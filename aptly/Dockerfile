FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y aptly awscli curl git gpg jq wget && \
    rm -rf /var/lib/apt/lists/*
