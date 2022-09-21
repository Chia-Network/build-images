FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        apt-utils \
        software-properties-common  && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
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
        python3.9 \
        python3.9-venv \
        libpython3.9-dev \
        sudo \
        vim \
        wget \
        zlib1g-dev && \
    # Sets up some useful symlinks \
    python3.9 -m ensurepip && \
    ln -sf "$(which python3.9)" /usr/bin/python && \
    ln -sf "$(which python3.9)" /usr/bin/python3 && \
    ln -sf "$(which pip3.9)" /usr/bin/pip && \
    ln -sf "$(which pip3.9)" /usr/bin/pip3 && \
    pip3 install --no-cache-dir py3createtorrent && \
    rm -rf /var/lib/apt/lists/*

# Add nodejs
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Newer version of CMAKE
RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz && \
    echo "33fd10a8ec687a4d0d5b42473f10459bb92b3ae7def2b745dc10b192760869f3  cmake-3.23.1.tar.gz" > cmake-3.23.1-sha256.txt && \
    sha256sum -c cmake-3.23.1-sha256.txt || (echo "Invalid hash for cmake-3.23.1.tar.gz"; exit 1) && \
    tar -xzvf cmake-3.23.1.tar.gz && \
    cd cmake-3.23.1 && \
    ./bootstrap --parallel=$(nproc --all) -- -DCMAKE_USE_OPENSSL=OFF && \
    make -j $(nproc --all) && \
    make install && \
    rm -rf cmake-3.23.1*

# Add GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y
