# HELPFUL RESOURCES
# Docker
# - https://upcloud.com/community/tutorials/wordpress-with-docker/
# - https://docs.docker.com/config/containers/container-networking/

read -p "Enter your project name (no spaces): " PROJECT

PATH_PROJECT="${HOME}/Documents/workspace/web/projects/${PROJECT}"
PATH_WP="html/wp-content"
PATH_WP_THEME="${PATH_WP}/themes"
PATH_WP_PLUGINS="${PATH_WP}/plugins"
PATH_SCRIPT="${HOME}/Documents/workspace/scripts/newWebProject"

mkdir ${PATH_PROJECT}
cd ${PATH_PROJECT}

docker run -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=wordpress --name ${PROJECT}_db -v "$PWD/database":/var/lib/mysql -d mariadb:latest
docker run -e WORDPRESS_DB_PASSWORD=root --name ${PROJECT} --link ${PROJECT}_db:mysql -p 127.0.0.1:8080:80 -v "$PWD/html":/var/www/html -d wordpress

git clone https://github.com/dan-frank/swd_theme ${PATH_PROJECT}/${PATH_WP_THEME}/${PROJECT}
cd ${PATH_PROJECT}/${PATH_WP_THEME}/${PROJECT}

npm i

rm -rf ${PATH_PROJECT}/${PATH_WP_THEME}/${PROJECT}/.git

# copy ${PATH_SCRIPT}/plugins/* ${PATH_PROJECT}/${PATH_WP_PLUGINS}/*

open http://localhost:8080/wp-admin/install.php

echo "The ${PROJECT} project has been initiated at:"
echo "${PATH_PROJECT}"
