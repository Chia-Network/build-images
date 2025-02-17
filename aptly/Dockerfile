FROM golang:1 AS builder

RUN git clone --branch v1.6.0 https://github.com/aptly-dev/aptly.git && \
    cd aptly && \
    make build

FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y awscli curl git gpg jq wget && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/aptly/build/aptly /usr/bin/aptly
