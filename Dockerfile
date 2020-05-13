### 1. Get python 3.6
FROM python:3.6-alpine AS base

FROM base as standard

WORKDIR /tmp
COPY ./requirements.txt /tmp

### 2. Get required packages via the package manager
RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache bash \
	&& apk add build-base \
	&& apk add --no-cache openjdk8-jre \
	### 3 Get pypandoc, pyspark and pytest from pip
	&& pip install --trusted-host=pypi.python.org --trusted-host=pypi.org --trusted-host=files.pythonhosted.org --no-cache-dir -r /tmp/requirements.txt

FROM base AS local

WORKDIR /tmp
COPY ./requirements.txt /tmp
COPY ./ca-cert.pem /tmp
RUN mkdir -v -p ~/.pip
COPY ./pip.conf /root/.pip
RUN rm -rf ~/.cache/pip

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache bash \
	&& apk add build-base \
	&& apk add --no-cache openjdk8-jre \
	&& pip install --trusted-host=pypi.python.org --trusted-host=pypi.org --trusted-host=files.pythonhosted.org --no-cache-dir -r /tmp/requirements.txt \
	&& apk del build-deps
