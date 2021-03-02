# nginx-docker-letsencrypt
Basic boilerplate to combine let's encrypt with nginx in a docker environment


## how-to

1. Create .env file with host name
    ```
    echo "NGINX_HOST=whatever.com" > .env
    ```
2. Make init-letsencrypt.sh executable and run it:
    ```
   chmod +x init-letsencrypt.sh
   sudo ./init-letsencrypt.sh
   ```

3. Run with docker-compose production file
    ```
    docker-compose -f docker-compose-production.yaml up
    ```
