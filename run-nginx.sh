#!/bin/bash

# Create environments from .env if exists.
if [ -f .env ]
then
  set -o allexport
  source .env
  set +o allexport
fi

# Replace envs in nginx config template
export DOLLAR='$' && envsubst < ${NDL_REPO_ROOT}/nginx.conf.template >
/etc/nginx/app.conf && nginx -g "daemon off;"

#Run nginx
