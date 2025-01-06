#!/bin/bash

ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/x86_64-linux-musl/asm
ln -s /usr/include/asm-generic /usr/include/x86_64-linux-musl/asm-generic
ln -s /usr/include/linux /usr/include/x86_64-linux-musl/linux

mkdir /musl

wget https://github.com/openssl/openssl/releases/download/openssl-3.0.15/openssl-3.0.15.tar.gz
tar zxvf openssl-3.0.15.tar.gz 
cd openssl-3.0.15/ || exit

CC="/usr/bin/x86_64-alpine-linux-musl-gcc -static" ./Configure no-shared no-async --prefix=/musl --openssldir=/musl/ssl linux-x86_64
make depend
make -j"$(nproc)"
make install
