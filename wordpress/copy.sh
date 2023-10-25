#!/bin/sh

mkdir -p $WEBROOT
cp -rf /wordpress/* $WEBROOT/
chown -R $UID:$GID $WEBROOT
