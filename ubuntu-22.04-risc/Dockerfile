FROM riscv64/ubuntu:focal as base

# ENV PYENV_ROOT=/root/.pyenv
# ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential cmake curl git make libgmp-dev libboost-dev libssl-dev zlib1g zlib1g-dev libreadline-dev libffi-dev && \
    echo delete this line when uncommenting below
#     curl https://pyenv.run | bash && \
#     PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.8 && \
#     PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.9 && \
#     PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.10 && \
#     PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.11 && \
#     PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.12 && \
#     pyenv global 3.12 && \
#     rm -rf /var/lib/apt/lists/*

# ENV PATH="/root/.cargo/bin:${PATH}"
# ENV RUST_BACKTRACE=1

# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.72.1

FROM base as ld

RUN curl -L -O https://ftpmirror.gnu.org/gnu/binutils/binutils-2.38.tar.gz && \
    tar -xvzf binutils-2.38.tar.gz && \
    cd binutils-2.38 && \
    ./configure --disable-gmp --enable-ld --disable-gold --disable-gas --prefix=/ld/usr && \
    make && \
    make install

FROM base as final

COPY --from=ld /ld/usr /
