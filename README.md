# docker-python-pyspark-pytest
Docker python/3.6-alpine image with pyspark and pytest.

## How to build

1. Run `DOCKER_BUILDKIT=1 docker build -t repo/image_name .`

## How to build when behind an SSL/TLS MITM Proxy

1. Copy your MITM's CA cert to ./ca-cert.pem
1. Run `DOCKER_BUILDKIT=1 docker build --build-arg BUILD_TYPE=local -t repo/image_name .`
