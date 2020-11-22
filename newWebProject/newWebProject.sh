read -p "Enter your project name (no spaces): " PROJECT

PROJECT_PATH="${HOME}/Documents/workspace/web/projects/${PROJECT}"
WORDPRESS_TO_THEME="wp-content/themes"

# PROCESS 
# mkdir -p for all dir's in path
mkdir ${PROJECT_PATH}

git clone https://github.com/WordPress/WordPress.git ${PROJECT_PATH}
cd ${PROJECT_PATH}/${WORDPRESS_TO_THEME}

git clone https://github.com/dan-frank/swd_theme ${PROJECT}
cd ${PROJECT_PATH}/${WORDPRESS_TO_THEME}/${PROJECT}

npm i

echo "The ${PROJECT} project has been initiated!"
