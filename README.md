# SSL on Docker with Nginx and Certbot
Basic boilerplate to create SSL certificates from letsencrypt for your host
with auto-renewal combining certbot and nginx in a docker-compose environment.

This repo is intended to be used with projects which use of docker-compose
and nginx.

Also, the following steps are expected to be executed in a machine with a 
public IP and a DNS mapping a domain name to it.

## Add this repository as a submodule in your repository's root
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
    HOST_NAME=<host-name>
    NDL_REPO_ROOT=<path-to-ssl-on-docker-repository-relative-to-mains-root>
    OWNER_EMAIL=<email>
    STAGING=1/0 (1 to test all configuration before creating real certificates)
    ```

3. Add nginx and certbot
   If not exists, add nginx and certbot services in your production docker-compose file, as appear in ssl-on-docker/docker-compose.yml.
   Make sure the volumes point to the right local folders, as in the ssl-on-docker, volume paths are relative to the ssl-on-docker root. To do that, add ./ssl-on-docker at the beginning of every volume map so paths are relative to main repo's root.
    ```
    ...
    nginx:
        ...
        environment:
            HOST_NAME: ${HOST_NAME}
            NDL_REPO_ROOT: ${NDL_REPO_ROOT}
        volumes:
            - ./ssl-on-docker/data/nginx:/etc/nginx/conf.d
            - ./ssl-on-docker/data/certbot/conf:/etc/letsencrypt
            - ./ssl-on-docker/data/certbot/www:/var/www/certbot
            - ./ssl-on-docker:/ssl-on-docker
        ...
    
    certbot:
        ...
        volumes:
            - ./ssl-on-docker/data/certbot/conf:/etc/letsencrypt
            - ./ssl-on-docker/data/certbot/www:/var/www/certbot
            - ./ssl-on-docker/data/certbot/logs:/var/log/letsencrypt
    ```

## Check if 80 port is open
 
1. Start http test environment on your host 
   ```
    docker-compose up -f <path-to-this-repo-root>/data/test-http/test.yml up
   ```

2. Wait until  you see something in output like:
    ```
    ...
    /docker-entrypoint.sh: Configuration complete; ready for start up
    ```

3. Go to a web browser and try to connect via http to your host:
    ```
    http://your-host-name
    ```

4. You will know if your 80 port is open or not at this point.

5. Stop docker test environment (CRTL+C) or with:
    ```
    docker-compose up -f <path-to-this-repo-root>/data/test-http/test.yml down
    ```

6. If not don't have 80 port open, or you don't know, check your DNS
settings and firewalls/networking rules. If you are using cloud hosting
services, you will most probably need to explicitly allow http/https
inbound connections to your host machine.   

## Generate certificates

1. Create .env file with following variables
    ```
    HOST_NAME=whatever.com
    OWNER_EMAIL=myemail@mydomain.com
    NDL_REPO_ROOT=<path-to-this-repo-root>
    STAGING=1/0  to set staging mode (1) or production (0)
    ```

2. Make init-letsencrypt.sh executable and run it from this repo root:
    ```
   chmod +x <path-to-this-repo-root>/init-letsencrypt.sh
   sudo <path-to-this-repo-root>/init-letsencrypt.sh
   ```

## Test https connection
1. Start https test environment on your host 
   ```
    docker-compose up -f <path-to-this-repo-root>/data/test-https/test.yml up
   ```
2. Go to a web browser and try to connect via http to your host:
    ```
    https://your-host-name
    ```
4. You will know if your 443 port is open and your SSL working.

## Configure your app

1. Create volume mapping in nginx and certbot services from your project's
 docker-compose pointing to this repo's directory as follows:

    ```
    nginx:
      image: nginx:latest
      command: "/bin/sh -c 'while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g \"daemon off;\"'"
      ports:
        - "80:80"
        - "443:443"
      volumes:
        - <your-project-nginx-conf-dir>:/etc/nginx/conf.d
        - <this-repo-root>/data/certbot/conf:/etc/letsencrypt
        - <this-repo-root>/data/certbot/www:/var/www/certbot
   
    certbot:
      image: certbot/certbot
      entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"
      volumes:
        - <this-repo-root>/data/certbot/conf:/etc/letsencrypt
        - <this-repo-root>/data/certbot/www:/var/www/certbot

    ```

2. In your project's nginx config file, add following directives, replacing
 every occurrence of <your-host-name>:
    ```
    server {
        listen 80;
        server_name <your-host-name>;

        ...

        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }
        location / {
            return 301 https://$host$request_uri;
        }
    }
    server {
        listen 443 ssl;
        server_name <your-host-name>;
    
        ssl_certificate /etc/letsencrypt/live/<your-host-name>/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/<your-host-name>/privkey.pem;
    
        include /etc/letsencrypt/options-ssl-nginx.conf;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
        
        ...    

    }
    ```

## Run your app
Run your project's docker-compose as usually.
