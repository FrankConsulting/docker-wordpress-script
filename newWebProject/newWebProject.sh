read -p "Enter your project name (no spaces): " PROJECT

PROJECT_PATH="${HOME}/Documents/workspace/web/projects/${PROJECT}"
WORDPRESS_TO_THEME="wp-content/themes"

# PROCESS 
open -j /Applications/MAMP/MAMP.app/

mkdir ${PROJECT_PATH}

git clone https://github.com/WordPress/WordPress.git ${PROJECT_PATH}
cd ${PROJECT_PATH}/${WORDPRESS_TO_THEME}

git clone https://github.com/dan-frank/swd_theme ${PROJECT}
cd ${PROJECT_PATH}/${WORDPRESS_TO_THEME}/${PROJECT}

npm i

cd /Applications/MAMP/bin && ./start.sh
cd /Applications/MAMP/bin && ./stop.sh

echo "CREATE DATABASE ${PROJECT};"  | /Applications/MAMP/Library/bin/mysql --host=localhost -uroot -proot

open http://localhost:8887/${PROJECT}/

echo "The ${PROJECT} project has been initiated!"
