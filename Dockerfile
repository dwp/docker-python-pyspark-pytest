FROM python:3.6-alpine as base

# Stage 1 - build/retrieve all our dependencies
FROM base as builder

RUN mkdir /install
WORKDIR /install

# 1.1 - install Python dependencies
COPY requirements.txt /
RUN apk --update --no-cache add gcc musl-dev libffi-dev openssl-dev
RUN pip install --no-cache-dir --prefix /install --no-warn-script-location -r /requirements.txt
# moto doesn't install flask, but needs it for the standalone server
RUN pip install --no-cache-dir --prefix /install --no-warn-script-location flask

# 1.2 - Install Java (Spark) dependencies
COPY pom.xml /
RUN apk --update --no-cache add maven openjdk8
RUN mvn install -f /pom.xml

# Stage 2 - build the final image
FROM base
# install Bash for PyTest, and Java for PySpark
RUN apk --update --no-cache add bash openjdk8-jre-base
# install the Python libraries built in stage 1
COPY --from=builder /install /usr/local
# install the Java libraries built in stage 1
RUN mkdir /root/.m2
COPY --from=builder /root/.m2 /root/.m2
# set JAVA_HOME, required by PySpark
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
