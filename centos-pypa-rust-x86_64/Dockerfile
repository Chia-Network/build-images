FROM quay.io/pypa/manylinux_2_28_x86_64

WORKDIR /usr/src/app

# Download rustup and checksum
RUN curl https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init.sha256 | awk '{print $1 " rustup-init"}' > checksum.txt && \
    curl -O https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init

# Check sha256sum -- fails if rustup-init binary doesn't match sha256 checksum
RUN cat checksum.txt && \
    sha256sum -c checksum.txt

# Install rust with rustup-init
RUN chmod +x rustup-init && \
    ./rustup-init -y && \
    rm rustup-init checksum.txt

# Set environment variables
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_BACKTRACE=1

# Verify installation
RUN rustc --version && cargo --version

# Start command
CMD ["cargo", "run"]
