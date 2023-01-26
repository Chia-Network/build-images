FROM golang:1 as builder

RUN git clone --branch v1.5.0 https://github.com/aptly-dev/aptly.git && \
    cd aptly && \
    make modules install

FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y awscli curl git gpg jq wget && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/aptly /usr/bin/aptly
