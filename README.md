# SSL on Docker with Nginx and Certbot
Basic boilerplate to create SSL certificates from letsencrypt for your host
with auto-renewal combining certbot and nginx in a docker-compose environment.

This repo is intended to be used with projects which use of docker-compose
and nginx.

Also, the following steps are expected to be executed in a machine with a 
public IP and a DNS mapping a domain name to it.

## Clone this repository into your repository's root
1. From repository's root
    ```
    git submodule add git@github.com:jon-alamo/ssl-on-docker.git
    git add .gitmodules
    git commit -m "Added ssl-on-docker repostiory as submodule" .gitmodules
    git push
    ```
2. Create env vars
   If not exits, create .env file on the main repository's root and add the following variables:
    ```
    HOST_NAME=*.domainname.com
    STAGING=--staging (or leave blank)
    EMAIL=
    COMPOSE_PROJECT_NAME=
    NETWORK_NAME=    
   ```
3.  Create certificates for the first time
    ```
    docker-compose -f ssl-on-docker/docker-compose.init.yml up
    ```


## Run your app
Run your project's docker-compose as usually.
