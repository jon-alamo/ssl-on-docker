#!/bin/bash

# Replace envs in nginx config template
export DOLLAR='$'
envsubst < /repo/nginx.conf.template > /etc/nginx/app.conf

#Run nginx
nginx -g "daemon off;"
