#!/bin/bash

# Replace envs in nginx config template
export DOLLAR='$'
envsubst < /repo/data/test-https/nginx.conf.https.test.template > /etc/nginx/conf.d/app.conf

#Run nginx
nginx -g "daemon off;"
