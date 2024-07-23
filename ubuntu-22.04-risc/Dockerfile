FROM ubuntu:focal as base

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y tree build-essential cmake curl wget git make pkg-config libgmp-dev libboost-dev libssl-dev zlib1g zlib1g-dev libreadline-dev libffi-dev && \
    rm -rf /var/lib/apt/lists/*

#FROM base as ld
#
#RUN curl -L -O https://ftpmirror.gnu.org/gnu/binutils/binutils-2.38.tar.gz && \
#    tar -xvzf binutils-2.38.tar.gz && \
#    cd binutils-2.38 && \
#    ./configure --enable-ld --disable-gas --disable-gmp --disable-gold --disable-gprof --prefix=/ld/usr && \
#    make && \
#    make install && \
#    ls -la /ld/usr/bin && \
#    ld --version

FROM base as sqlite

RUN wget -q https://sqlite.org/2022/sqlite-autoconf-3400100.tar.gz && \
    tar -xzf sqlite-autoconf-3400100.tar.gz && \
    cd sqlite-autoconf-3400100 && \
    CFLAGS="-DSQLITE_MAX_VARIABLE_NUMBER=500000" ./configure --prefix=/opt/sqlite3 && \
    make && \
    make install && \
    tree /opt/sqlite3 && \
    ls -la /opt/sqlite3/bin && \
    /opt/sqlite3/bin/sqlite3 -version

FROM base as final

#COPY --from=ld /ld/usr /usr

COPY --from=sqlite /opt/sqlite3 /opt/sqlite3

RUN ls -la /usr/bin && \
    ld --version && \
    tree /opt/sqlite3 && \
    /opt/sqlite3/bin/sqlite3 -version

ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

RUN curl https://pyenv.run | bash && \
    export PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} --enable-shared" && \
    export PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} SQLITE3_LIBS='-L/opt/sqlite3/lib -lsqlite3'" && \
    ls -la /opt/sqlite3/lib && \
    export PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} SQLITE3_CFLAGS='-I/opt/sqlite3/include'" && \
    ls -la /opt/sqlite3/include && \
    pyenv install --skip-existing 3.8 && \
    pyenv install --skip-existing 3.9 && \
    pyenv install --skip-existing 3.10 && \
    pyenv install --skip-existing 3.11 && \
    pyenv install --skip-existing 3.12 && \
    pyenv global 3.12

ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_BACKTRACE=1

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    cargo install sccache
