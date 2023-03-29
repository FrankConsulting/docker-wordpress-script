## DOCUMENTATION
### RUN
# `docker compose up -d`
# > This runs the container
#
# `docker compose down`
# > This stops the container
#
# `docker compose down --volumes`
# > This stops the container and removes docker files

read -p "Enter your project name (no spaces): " PROJECT

# -- Declare vars --
GIT_REPO_BASE="https://github.com/FrankConsulting"
PATH_SCRIPT="${HOME}/Documents/Projects/Scripts/docker-wordpress-script"
PATH_PROJECT="${HOME}/Documents/Projects/Wordpress/${PROJECT}"
PATH_WP_THEME="${PATH_PROJECT}/files/wp-content/themes/${PROJECT}"
PATH_WP_PLUGINS="${PATH_PROJECT}/files/wp-content/plugins"

# -- Setup project folders --
mkdir -p ${PATH_PROJECT}
cd ${PATH_PROJECT}

# -- Init `docker-compose` file
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
    image: wordpress:6.0-php8.1-apache
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

# -- Fetch WordPress theme
git clone ${GIT_REPO_BASE}/${PROJECT} ${PATH_WP_THEME}

# -- Set common plugins --
rm -rf ${PATH_WP_PLUGINS}/akismet
rm ${PATH_WP_PLUGINS}/hello.php
cp -R ${PATH_SCRIPT}/plugins/ ${PATH_WP_PLUGINS}/

# -- Display project --
open http://localhost:8000/wp-admin/install.php
echo "The ${PROJECT} project has been initiated at:"
echo "${PATH_PROJECT}"

# -- Call Nix dev shell --
cd ${PATH_WP_THEME}
nix develop

