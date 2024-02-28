FROM riscv64/ubuntu:focal as base

ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential cmake curl wget git make libgmp-dev libboost-dev libssl-dev zlib1g zlib1g-dev libreadline-dev libffi-dev && \
    rm -rf /var/lib/apt/lists/*

# Compile newer version of sqlite3 \
RUN cd ~ && \
    wget -q https://sqlite.org/2022/sqlite-autoconf-3400100.tar.gz && \
    tar -xzf sqlite-autoconf-3400100.tar.gz && \
    cd sqlite-autoconf-3400100 && \
    CFLAGS="-DSQLITE_MAX_VARIABLE_NUMBER=500000" ./configure --prefix=/usr && \
    make && \
    make install && \
    cd ~ && \
    rm -rf ~/sqlite-autoconf*

RUN curl https://pyenv.run | bash && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.8 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.9 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.10 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.11 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.12 && \
    pyenv global 3.12

ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_BACKTRACE=1

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

FROM base as ld

RUN curl -L -O https://ftpmirror.gnu.org/gnu/binutils/binutils-2.38.tar.gz && \
    tar -xvzf binutils-2.38.tar.gz && \
    cd binutils-2.38 && \
    ./configure --enable-ld --disable-gas --disable-gmp --disable-gold --disable-gprof --prefix=/ld/usr && \
    make && \
    make install && \
    ls -la /ld/usr/bin && \
    ld --version

FROM base as final

COPY --from=ld /ld/usr /usr
RUN ls -la /usr/bin && \
    ld --version
