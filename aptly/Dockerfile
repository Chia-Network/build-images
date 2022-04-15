FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y awscli curl git gpg jq wget && \
    wget -qO - https://www.aptly.info/pubkey.txt | apt-key add - && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y aptly && \
    rm -rf /var/lib/apt/lists/*
