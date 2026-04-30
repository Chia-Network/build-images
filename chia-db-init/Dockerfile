FROM alpine:latest

RUN apk add --no-cache aws-cli sqlite curl jq gzip

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
