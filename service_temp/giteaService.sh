#!/bin/bash

# Đường dẫn tới tệp index.js
indexjs_path=$HOOK_PATH/index.js
project_path=$HOOK_PATH 

# Kiểm tra xem Node.js đã cài đặt chưa
if ! command -v node &> /dev/null; then
  echo -e "\e[31mNode.js is not installed.\e[0m"
  echo -e "\e[32mInstall Node.js...\e[0m"
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&
  sudo apt-get install nodejs -y && 
  node -v
else
  echo -e "\e[32mNodejs is installed!\e[0m" &&
  node -v
fi

# Kiểm tra xem npm đã cài đặt chưa
if ! command -v npm &> /dev/null; then
  echo -e "\e[31mnpm is not installed. Install npm...\e[0m"
  sudo apt-get install npm -y
else
  echo -e "\e[32mnpm is installed!\e[0m" &&
  npm -v
fi

# Kiểm tra xem tệp index.js có tồn tại không
if [ -f "$indexjs_path" ]; then
  echo "Run file $indexjs_path..."
  cd "$project_path" &&
  npm install &&
  node "$indexjs_path"
else
  echo -e "\e[31mFile $indexjs_path not exists\e[0m"
fi
