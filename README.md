# nginx-docker-letsencrypt
Basic boilerplate to create SSL certificates from letsencrypt for your host
with auto-renewal combining certbot and nginx in a docker-compose environment.

This repo is intended to be used with projects which use of docker-compose
and nginx.

## how-to

1. Create .env file with following variables
    ```
    HOST_NAME=whatever.com
    OWNER_EMAIL=myemail@mydomain.com
    NDL_REPO_ROOT=path/to/this/repository/root/in/your/local/file/system
    ```

2. Make init-letsencrypt.sh executable and run it from this repo root:
    ```
   chmod +x init-letsencrypt.sh
   sudo ./init-letsencrypt.sh
   ```

3. Create volume mapping in nginx and certbot services from your project's
 docker-compose pointing to this repo's directory as follows:

    ```
    nginx:
      image: nginx:latest
      ports:
        - "80:80"
        - "443:443"
      volumes:
        - <your-project-nginx-conf-dir>:/etc/nginx/conf.d
        - <this-repo-root>/data/certbot/conf:/etc/letsencrypt
        - <this-repo-root>/data/certbot/www:/var/www/certbot
   
    certbot:
      image: certbot/certbot
      volumes:
        - <this-repo-root>/data/certbot/conf:/etc/letsencrypt
        - <this-repo-root>/data/certbot/www:/var/www/certbot

    ```

4. In your project's nginx config file, add following directives, replacing
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
5. Run your docker-compose as usually
