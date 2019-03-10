#!/bin/sh
echo "ENVIRONMENT is $ENVIRONMENT"
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf
nginx -g daemon off;