## DOCUMENTATION
### RUN
#`docker compose up -d`
#> This runs the container
#`docker compose down`
#> This stops the container
#`docker compose down --volumes`
#> This stops the container and removes docker files

read -p "Enter your project name (no spaces): " PROJECT

PATH_PROJECT="${HOME}/Documents/Projects/wordpress/${PROJECT}"
PATH_WP="wp-content"
PATH_WP_THEME="${PATH_WP}/themes"
PATH_WP_PLUGINS="${PATH_WP}/plugins"
PATH_SCRIPT="${HOME}/Documents/Projects/scripts/new-docker-wordpress"

mkdir ${PATH_PROJECT}
cd ${PATH_PROJECT}

read -d '' DOCKER_YAML << EOF
version: '3'

services:
  db:
    image: mysql/mysql-server:8.0.23
    restart: unless-stopped
    environment:
      MYSQL_ROOT_USERNAME: root
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: ${PROJECT}_db
      MYSQL_USER: ${PROJECT}
      MYSQL_PASSWORD: root
    volumes:
      - ./db_data:/var/lib/mysql
    networks:
      - ${PROJECT}_wpsite
  phpmyadmin:
    depends_on:
      - db
    image: phpmyadmin/phpmyadmin
    restart: unless-stopped
    ports:
      - '8080:80'
    environment:
      PMA_HOST: db
      MYSQL_ROOT_PASSWORD: root
    networks:
      - ${PROJECT}_wpsite
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    restart: unless-stopped
    ports:
      - '8000:80'
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: ${PROJECT}_db
      WORDPRESS_DB_USER: ${PROJECT}
      WORDPRESS_DB_PASSWORD: root
    volumes:
      - "./files:/var/www/html"
    networks:
      - ${PROJECT}_wpsite
networks:
  ${PROJECT}_wpsite:
volumes:
  files:
  db_data:
EOF
echo "$DOCKER_YAML" > docker-compose.yml
docker-compose up -d

git clone https://github.com/dan-frank/${PROJECT} ${PATH_PROJECT}/files/${PATH_WP_THEME}/${PROJECT}
cd ${PATH_PROJECT}/files/${PATH_WP_THEME}/${PROJECT}
npm i
npm rebuild node-sass
npm rebuild rimraf
npm rebuild mkdirp
npm run init

rm -rf ${PATH_PROJECT}/files/${PATH_WP_PLUGINS}/akismet
rm ${PATH_PROJECT}/files/${PATH_WP_PLUGINS}/hello.php
cp -R ${PATH_SCRIPT}/plugins/ ${PATH_PROJECT}/files/${PATH_WP_PLUGINS}/

open http://localhost:8000/wp-admin/install.php

echo "The ${PROJECT} project has been initiated at:"
echo "${PATH_PROJECT}"

