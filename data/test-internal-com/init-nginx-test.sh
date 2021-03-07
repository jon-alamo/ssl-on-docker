#!/bin/bash

# Replace envs in nginx config template
export DOLLAR='$'
envsubst < /repo/data/test-internal-com/nginx.conf.https.test.template > /etc/nginx/conf.d/app.conf

#Run nginx
nginx -g "daemon off;"
