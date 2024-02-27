FROM riscv64/ubuntu:focal

ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

# Compile newer version of sqlite3 \
RUN wget -q https://sqlite.org/2022/sqlite-autoconf-3400100.tar.gz && \
    tar -xzf sqlite-autoconf-3400100.tar.gz && \
    cd sqlite-autoconf-3400100 && \
    CFLAGS="-DSQLITE_MAX_VARIABLE_NUMBER=500000" ./configure --prefix=/sqlite/usr && \
    make && \
    make install

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential cmake curl git make libgmp-dev libboost-dev libssl-dev zlib1g zlib1g-dev libreadline-dev libffi-dev && \
    curl https://pyenv.run | bash && \
    # PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.8 && \
    # PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.9 && \
    # PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.10 && \
    # PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.11 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.12 && \
    pyenv global 3.12 && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_BACKTRACE=1

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.72.1
