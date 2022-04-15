FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y aptly awscli curl git gpg jq && \
    rm -rf /var/lib/apt/lists/*
