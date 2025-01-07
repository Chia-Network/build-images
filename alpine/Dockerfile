FROM alpine:3.21
WORKDIR /root

# Set environment variables for rust and pyenv
ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_BACKTRACE=1

RUN apk add bash git curl python3 openssl openssl-dev perl linux-headers make gcc musl-dev patch patchelf py3-pip
# Additional pyenv dependencies
RUN apk add --no-cache build-base libffi-dev bzip2-dev zlib-dev xz-dev readline-dev sqlite-dev tk-dev

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf -o rustup https://sh.rustup.rs
RUN sh ./rustup -y

RUN curl https://pyenv.run | bash && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.8 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.9 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.10 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.11 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.12
