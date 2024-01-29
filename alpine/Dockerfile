FROM alpine:3.16.2
WORKDIR /root

# Set environment variables for rust and pyenv
ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_BACKTRACE=1

RUN sh -c "echo https://mirrors.edge.kernel.org/alpine/v3.16.2/community >> /etc/apk/repositories"
RUN apk add bash git curl python3 openssl openssl-dev perl linux-headers make gcc musl-dev patch patchelf
# Additional pyenv dependencies
RUN apk add --no-cache build-base libffi-dev bzip2-dev zlib-dev xz-dev readline-dev sqlite-dev tk-dev

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf -o rustup https://sh.rustup.rs
RUN sh ./rustup -y

# Build a copy of openssl - needed for the rust-openssl crate
COPY build-openssl.sh .
RUN sh ./build-openssl.sh

RUN curl https://pyenv.run | bash && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.8 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.9 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.10 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.11 && \
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install --skip-existing 3.12
