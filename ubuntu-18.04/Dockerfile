FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        apt-utils \
        awscli \
        build-essential \
        curl \
        dialog \
        jq \
        software-properties-common \
        vim \
        wget \
        zlib1g-dev && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    add-apt-repository ppa:git-core/ppa && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        fakeroot \
        git \
        python3.8 \
        python3.8-venv \
        libpython3.8-dev \
        python3.8-distutils && \
    python3.8 -m ensurepip && \
    python3.8 -m pip install --no-cache-dir py3createtorrent && \
    rm -rf /var/lib/apt/lists/*

# Add nodejs
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs
