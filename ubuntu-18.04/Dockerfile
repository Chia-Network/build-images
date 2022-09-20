FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        apt-utils \
        software-properties-common  && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    add-apt-repository ppa:git-core/ppa && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        awscli \
        build-essential \
        curl \
        dialog \
        fakeroot \
        git \
        jq \
        python3.8 \
        python3.8-venv \
        libpython3.8-dev \
        python3.8-distutils \
        sudo \
        vim \
        wget \
        zlib1g-dev && \
    # Sets up some useful symlinks \
    python3.8 -m ensurepip && \
    ln -sf "$(which python3.8)" /usr/bin/python && \
    ln -sf "$(which python3.8)" /usr/bin/python3 && \
    ln -sf "$(which pip3.8)" /usr/bin/pip && \
    ln -sf "$(which pip3.8)" /usr/bin/pip3 && \
    pip3 install --no-cache-dir py3createtorrent && \
    rm -rf /var/lib/apt/lists/*

# Add nodejs
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Add GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y
