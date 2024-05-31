FROM registry.gitlab.com/cmmarslender/kubectl-helm:v3 as kubectl-helm
FROM hashicorp/packer:latest as packer
FROM hashicorp/terraform:latest as terraform
FROM alpine:latest

ENV PACKER_PLUGIN_PATH="/packer-plugins"
ENV PYENV_ROOT=/root/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

COPY --from=packer /bin/packer /bin/
COPY --from=terraform /bin/terraform /bin/
COPY --from=kubectl-helm /usr/local/bin/kubectl /bin/
RUN apk add --no-cache ansible aws-cli bash build-base bzip2-dev curl curl-dev git github-cli git go gpg gpg-agent jq libffi-dev make mysql-client netcat-openbsd openssh-client openssh-keygen openssl openssl-dev readline-dev rsync sudo sqlite-dev tar tk-dev wget xorriso xz-dev zlib-dev && \
    apk add --no-cache yq --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    pyenv install 3.11 && \
    pyenv global 3.11 && \
    pip install --upgrade pip && \
    pip install --no-cache-dir j2cli jmespath && \
    packer plugins install github.com/hashicorp/amazon && \
    packer plugins install github.com/hashicorp/ansible && \
    packer plugins install github.com/hashicorp/proxmox
