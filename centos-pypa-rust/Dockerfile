FROM quay.io/pypa/manylinux2014_x86_64

WORKDIR /usr/src/app

# download the rustup-init binary and checksum file
ADD https://static.rust-lang.org/rustup/dist/aarch64-unknown-linux-musl/rustup-init rustup-init
ADD https://static.rust-lang.org/rustup/dist/aarch64-unknown-linux-musl/rustup-init.sha256 rustup-init.sha256

# validate the checksum of the rustup-init binary
RUN if [[ $(curl https://static.rust-lang.org/rustup/dist/aarch64-unknown-linux-musl/rustup-init.sha256 | awk '{print $1}') = $(curl -s https://static.rust-lang.org/rustup/dist/aarch64-unknown-linux-musl/rustup-init | sha256sum | awk '{print $1}'
) ]]; then chmod +x rustup-init; else echo "Checksums did not match"; fi

# run the rustup-init script to install Rust
RUN ./rustup-init -y

CMD ["rustc", "--version"]
