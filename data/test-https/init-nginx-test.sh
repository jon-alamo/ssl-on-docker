#!/bin/bash

# Replace envs in nginx config template
export DOLLAR='$'
envsubst < ../../nginx.conf.template > /etc/nginx/app.conf

#Run nginx
nginx -g "daemon off;"
