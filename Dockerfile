### 1. Get python 3.6

FROM python:3.6-alpine

WORKDIR /tmp
COPY ./requirements.txt /tmp
COPY ./pom.xml /tmp/pom.xml

### 2. Get required packages via the package manager
RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache bash \
	&& apk add build-base \
	&& apk add maven
#	&& apk add --no-cache openjdk8-jre

RUN { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION 8u252
ENV JAVA_ALPINE_VERSION 8.252.09-r0
RUN set -x \
    && apk add --update \
    && apk add --no-cache \
            openjdk8="$JAVA_ALPINE_VERSION" \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ] \
### 3. To resolve issues installing cryptography python module run below commands
	&& apk add py-cryptography \
	&& apk add gcc musl-dev libffi-dev openssl-dev python3-dev \
	&& pip install cryptography -vvv --no-binary=cryptography \
	&& pip install flask \
### 4 Get pypandoc, pyspark and pytest from pip
	&& pip install --trusted-host=pypi.python.org --trusted-host=pypi.org --trusted-host=files.pythonhosted.org --no-cache-dir -r /tmp/requirements.txt \
### 5 Running below command to get runtime dependencies for pyspark
    && mvn install && rm -rf target

