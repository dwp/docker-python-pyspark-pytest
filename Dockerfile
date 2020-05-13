ARG BUILD_TYPE=standard

# Get python 3.6 and install build dependencies
FROM python:3.6-alpine AS base
RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache bash \
	&& apk add --no-cache --virtual build-deps build-base \
	&& apk add --no-cache openjdk8-jre
WORKDIR /tmp
COPY ./requirements.txt /tmp

# Install custom CA certs & pip config
FROM base as local-preinstall
WORKDIR /tmp
COPY ./ca-cert.pem /tmp
RUN mkdir -v -p ~/.pip
COPY ./pip.conf /root/.pip

# Skip custom CA certs & pip config for standard builds
FROM base as standard-preinstall
RUN echo "Skipping custom SSL pip configuration"

# Install Python packages
FROM ${BUILD_TYPE}-preinstall as install
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
	&& apk del build-deps
