# docker-python-pyspark-pytest
Docker python/3.6-alpine image with pyspark and pytest.

# How to build

1. Run `docker build .`

# How to build when behind an SSL/TLS MITM Proxy
1. Copy your MITM's CA cert to ./ca-cert.pem
1. Run `docker build -f Dockerfile.local .`
