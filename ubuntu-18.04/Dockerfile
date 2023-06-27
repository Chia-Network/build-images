FROM ubuntu:18.04

ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        apt-utils \
        software-properties-common && \
    add-apt-repository ppa:git-core/ppa -y && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        awscli \
        build-essential \
        curl \
        dialog \
        fakeroot \
        g++-9 \
        g++-10 \
        git \
        jq \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncursesw5-dev \
        libreadline-dev \
        libssl-dev \
        libsqlite3-dev \
        libxml2-dev \
        libxmlsec1-dev \
        sudo \
        tk-dev \
        vim \
        wget \
        xz-utils \
        zlib1g-dev && \
    # Set up pyenv \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    pyenv install 3.8 && \
    pyenv global 3.8 && \
    pip install --upgrade pip && \
    pip install --no-cache-dir py3createtorrent && \
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
