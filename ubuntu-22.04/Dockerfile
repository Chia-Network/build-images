# So we can copy yq into our container later
FROM mikefarah/yq:4 AS yq

FROM ubuntu:22.04

ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/lib"

ARG PYTHON_VERSION
ARG SQLITE_VERSION
ENV EXPECTED_SQLITE_VERSION=$SQLITE_VERSION

COPY --from=yq /usr/bin/yq /usr/bin/yq

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        apt-utils \
        gpg \
        gpg-agent \
        software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        awscli \
        build-essential \
        ca-certificates \
        curl \
        dialog \
        fakeroot \
        g++-12 \
        g++-13 \
        git \
        jq \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncursesw5-dev \
        libreadline-dev \
        libssl-dev \
        libxml2-dev \
        libxmlsec1-dev \
        lsb-release \
        sudo \
        time \
        tk-dev \
        vim \
        wget \
        xz-utils \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# electron-builder does not work for arm64 as of Aug 16, 2022.
# this is a "temporary" fix.  for three plus years.
# https://github.com/jordansissel/fpm/issues/1801#issuecomment-919877499
# located here for https://github.com/Chia-Network/chia-blockchain/pull/20037
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        ruby \
        ruby-dev && \
    rm -rf /var/lib/apt/lists/* && \
    sudo gem install fpm && \
    gem cleanup && \
    rm -rf $(gem environment cachedir)/*.gem && \
    find $(gem environment gemdir) -name "*.c" -delete && \
    find $(gem environment gemdir) -name "*.o" -delete

# Compile newer version of sqlite3 \
RUN cd ~ && \
    SQLITE_NUM=$(echo "$SQLITE_VERSION" | awk -F. '{printf "%d%02d%02d00", $1, $2, $3}') && \
    wget -q "https://sqlite.org/2022/sqlite-autoconf-${SQLITE_NUM}.tar.gz" && \
    tar -xzf "sqlite-autoconf-${SQLITE_NUM}.tar.gz" && \
    cd "sqlite-autoconf-${SQLITE_NUM}" && \
    CFLAGS="-DSQLITE_MAX_VARIABLE_NUMBER=500000" ./configure --prefix=/usr && \
    make && \
    make install && \
    cd ~ && \
    rm -rf ~/sqlite-autoconf*

# Set up pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    pyenv install $PYTHON_VERSION && \
    pyenv global $PYTHON_VERSION && \
    pip install --upgrade pip && \
    pip install --no-cache-dir py3createtorrent && \
    python3 -c 'import sys, sqlite3, os; sys.exit(sqlite3.sqlite_version != os.environ["EXPECTED_SQLITE_VERSION"])'

# Add nodejs
ENV NODE_MAJOR=18
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Newer version of CMAKE
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && \
    apt-get install cmake -y && \
    rm -rf /var/lib/apt/lists/*

# Add GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y \
    && rm -rf /var/lib/apt/lists/*
