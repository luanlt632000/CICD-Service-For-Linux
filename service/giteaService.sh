#!/bin/bash

# Đường dẫn tới tệp index.js
indexjs_path=$INDEXJS_HOOK_PATH/index.js
project_path=$HOOK_PATH 

# Kiểm tra xem Node.js đã cài đặt chưa
if ! command -v node &> /dev/null; then
  echo "Node.js chưa được cài đặt. Đang cài đặt Node.js..."
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&
  sudo apt-get install nodejs -y && 
  node -v
else
  echo "Nodejs da duoc cai dat!" &&
  node -v
fi

# Kiểm tra xem npm đã cài đặt chưa
if ! command -v npm &> /dev/null; then
  echo "npm chưa được cài đặt. Đang cài đặt npm..."
  sudo apt-get install npm -y
else
  echo "npm da duoc cai dat!" &&
  npm -v
fi

# Kiểm tra xem tệp index.js có tồn tại không
if [ -f "$indexjs_path" ]; then
  echo "Chạy tệp $indexjs_path..."
  cd "$project_path" &&
  node "$indexjs_path"
else
  echo "Tệp $indexjs_path không ton tại."
fi
