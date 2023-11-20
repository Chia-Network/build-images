FROM alpine:latest

RUN apk add mysql-client aws-cli

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
