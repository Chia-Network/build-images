#!/bin/bash

ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/x86_64-linux-musl/asm
ln -s /usr/include/asm-generic /usr/include/x86_64-linux-musl/asm-generic
ln -s /usr/include/linux /usr/include/x86_64-linux-musl/linux

mkdir /musl

wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1w.tar.gz
tar zxvf OpenSSL_1_1_1w.tar.gz 
cd openssl-OpenSSL_1_1_1w/

CC="/usr/bin/x86_64-alpine-linux-musl-gcc -static" ./Configure no-shared no-async --prefix=/musl --openssldir=/musl/ssl linux-x86_64
make depend
make -j$(nproc)
make install
