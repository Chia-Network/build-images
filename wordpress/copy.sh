#!/bin/sh

mkdir -p "$WEBROOT"

# Chown before copy, so we don't run into conflicts with the mounted configmaps and other read-only filesystems
chown -R "$USERID":"$GROUPID" /wordpress

cp -rf /wordpress/* "$WEBROOT/"

