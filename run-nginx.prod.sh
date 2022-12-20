#!/bin/bash

# Create environments from .env if exists.
if [ -f .env ]
then
  set -o allexport
  source .env
  set +o allexport
fi

# Replace envs in nginx config template
export DOLLAR='$'
envsubst < /nginx-conf/nginx.conf > /etc/nginx/app.conf

#Run nginx
nginx -g "daemon off;"
