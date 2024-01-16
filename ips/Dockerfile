FROM hashicorp/packer:latest as packer
FROM hashicorp/terraform:latest as terraform
FROM alpine:latest

ENV PACKER_PLUGIN_PATH="/packer-plugins"

COPY --from=packer /bin/packer /bin/
COPY --from=terraform /bin/terraform /bin/
RUN apk add --no-cache ansible aws-cli bash curl curl-dev git github-cli go gpg gpg-agent jq make mysql-client netcat-openbsd openssh-client openssh-keygen python3 py3-pip py3-jmespath rsync sudo tar && \
    apk add --no-cache yq --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    pip install --break-system-packages j2cli && \
    packer plugins install github.com/hashicorp/amazon && \
    packer plugins install github.com/hashicorp/ansible
