## DOCUMENTATION
### RUN
#`docker-compose up -d`
#> This runs the container
#`docker-compose down`
#> This stops the container
#`docker-compose down --volumes`
#> This stops the container and removes files
### HELPFUL RESOURCES
#### Docker
#- https://www.youtube.com/watch?v=pYhLEV-sRpY
#-- https://gist.github.com/bradtraversy/faa8de544c62eef3f31de406982f1d42

read -p "Enter your project name (no spaces): " PROJECT

PATH_PROJECT="${HOME}/Documents/workspace/web/projects/${PROJECT}"
PATH_WP="wp-content"
PATH_WP_THEME="${PATH_WP}/themes"
PATH_WP_PLUGINS="${PATH_WP}/plugins"
PATH_SCRIPT="${HOME}/Documents/workspace/scripts/newWebProject"

mkdir ${PATH_PROJECT}
cd ${PATH_PROJECT}

read -d '' DOCKER_YAML << EOF
version: '3'

services:
  db:
    image: mysql:latest
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_USERNAME: root
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: ${PROJECT}_db
      MYSQL_USER: ${PROJECT}
      MYSQL_PASSWORD: root
    networks:
      - wpsite
  phpmyadmin:
    depends_on:
      - db
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
      - '8080:80'
    environment:
      PMA_HOST: db
      MYSQL_ROOT_PASSWORD: root
    networks:
      - wpsite
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - '8000:80'
    restart: always
    volumes: ['./:/var/www/html']
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: ${PROJECT}_db
      WORDPRESS_DB_USER: ${PROJECT}
      WORDPRESS_DB_PASSWORD: root
    networks:
      - wpsite
networks:
  wpsite:
volumes:
  db_data:
EOF
echo "$DOCKER_YAML" > docker-compose.yml
docker-compose up -d

git clone https://github.com/dan-frank/swd_theme ${PATH_PROJECT}/${PATH_WP_THEME}/${PROJECT}
cd ${PATH_PROJECT}/${PATH_WP_THEME}/${PROJECT}
npm i

rm -rf ${PATH_PROJECT}/${PATH_WP_PLUGINS}/akismet
rm ${PATH_PROJECT}/${PATH_WP_PLUGINS}/hello.php
cp -R ${PATH_SCRIPT}/plugins/ ${PATH_PROJECT}/${PATH_WP_PLUGINS}/

open http://localhost:8000/wp-admin/install.php

echo "The ${PROJECT} project has been initiated at:"
echo "${PATH_PROJECT}"
