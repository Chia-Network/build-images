#!/bin/sh

mkdir -p "$WEBROOT"
cp -rf /wordpress/* "$WEBROOT/"
chown -R "$USERID":"$GROUPID" "$WEBROOT"
