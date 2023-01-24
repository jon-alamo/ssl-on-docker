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
   If not exits, create .env file on the ssl-on-docker repository's directory and add the following variables:
    ```
    DOMAIN_ARGS=-d sub1.yourdomain.com -d sub2.yourdomain.com -d yourdomain.com
    STAGING_ARG=--staging (or leave blank)
    EMAIL_ARG=<your email>
    NETWORK_NAME=<main project network name>
    ```    

3.  Create certificates for the first time
    ```
    docker-compose -f ssl-on-docker/docker-compose.init.yml up
    ```

4. Prepare nginx configuration
   Create nginx configuration file called app.conf under nginx directory in your main project's root.
5. Ensure that the following lines are present in the nginx configuration file:
    ```
    ssl_certificate /etc/letsencrypt/live/<yourdomain.com>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<yourdomain.com>/privkey.pem;
    ```


## Run your app
Run your project's docker-compose as usually.
