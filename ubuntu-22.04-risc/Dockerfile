FROM ubuntu:focal as base

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y tree build-essential cmake curl wget git make pkg-config libgmp-dev libboost-dev libssl-dev zlib1g zlib1g-dev libreadline-dev libffi-dev && \
    rm -rf /var/lib/apt/lists/*

FROM base as ld

RUN curl -L -O https://ftpmirror.gnu.org/gnu/binutils/binutils-2.38.tar.gz && \
    tar -xvzf binutils-2.38.tar.gz && \
    cd binutils-2.38 && \
    ./configure --enable-ld --disable-gas --disable-gmp --disable-gold --disable-gprof --prefix=/opt/ld && \
    make && \
    make install && \
    tree /opt && \
    /opt/ld/bin/ld --version

FROM base as sqlite

RUN curl -L -O https://sqlite.org/2022/sqlite-autoconf-3400100.tar.gz && \
    tar -xvzf sqlite-autoconf-3400100.tar.gz && \
    cd sqlite-autoconf-3400100 && \
    CFLAGS="-DSQLITE_MAX_VARIABLE_NUMBER=500000" ./configure --prefix=/opt/sqlite3 && \
    make && \
    make install && \
    tree /opt && \
    /opt/sqlite3/bin/sqlite3 -version

FROM base as final

COPY --from=ld /opt/ld /usr

COPY --from=sqlite /opt/sqlite3 /opt/sqlite3

RUN tree /opt && \
    ld --version && \
    /opt/sqlite3/bin/sqlite3 -version

ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

RUN curl https://pyenv.run | bash

ARG PYTHON_CONFIGURE_OPTS="--enable-shared"

# for 3.8 - 3.10
ARG LDFLAGS="-L/opt/sqlite3/lib -lsqlite3"
ARG CPPFLAGS=-I/opt/sqlite3/include

RUN pyenv install 3.8
#RUN pyenv install 3.9
#RUN pyenv install 3.10

# for 3.11+
#ARG LIBSQLITE3_LIBS=-L/opt/sqlite3/lib -lsqlite3
#ARG LIBSQLITE3_CFLAGS=-I/opt/sqlite3/include
#ARG PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} LIBSQLITE3_LIBS='-L/opt/sqlite3/lib -lsqlite3'"
#ARG PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} LIBSQLITE3_CFLAGS=-I/opt/sqlite3/include"

ARG PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS} PKG_CONFIG_PATH=/opt/sqlite3/lib/pkgconfig"

RUN tree /opt
ARG PKG_CONFIG_PATH=/opt/sqlite3/lib/pkgconfig
RUN pkg-config sqlite3 --cflags
RUN pkg-config sqlite3 --libs

RUN pyenv install 3.11
#RUN pyenv install 3.12

RUN pyenv global 3.11 3.8

ENV LD_LIBRARY_PATH="/opt/sqlite3/lib"

RUN ldd $(python3.8 -c 'import _sqlite3; print(_sqlite3.__file__)')
#RUN ldd $(python3.9 -c 'import _sqlite3; print(_sqlite3.__file__)')
#RUN ldd $(python3.10 -c 'import _sqlite3; print(_sqlite3.__file__)')
RUN ldd $(python3.11 -c 'import _sqlite3; print(_sqlite3.__file__)')
#RUN ldd $(python3.12 -c 'import _sqlite3; print(_sqlite3.__file__)')

ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_BACKTRACE=1

#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
#    cargo install sccache
