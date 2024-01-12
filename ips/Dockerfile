FROM hashicorp/packer:latest as packer
FROM hashicorp/terraform:latest as terraform
FROM alpine:latest

COPY --from=packer /bin/packer /bin/
COPY --from=terraform /bin/terraform /bin/
RUN apk add --no-cache ansible aws-cli bash curl curl-dev git github-cli go gpg gpg-agent jinja2-cli jq mysql-client netcat-openbsd openssh-client openssh-keygen py3-jmespath rsync sudo tar && \
    apk add --no-cache yq --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    ln -s $(which jinja2) $(dirname $(which jinja2))/j2
