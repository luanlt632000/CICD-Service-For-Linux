#!/bin/bash

#File chua bien moi truong
source /home/gitea_CICD/service_temp/giteaService.conf

#URL project
project=$PROJECT_PATH

#URL folder FE
fe_path=$(basename "$FE_PROJECT_PATH")

#URL folder BE
be_path=$BE_PROCESS_PATH

#Username git
username=$GIT_USERNAME

#Password git
password=$GIT_PASSWORD

#Git branch
branch=$GIT_BRANCH

cd $project

function run_commands() {
  local name_path_folder="$1"
  local command_name=$(echo "${name_path_folder}_COMMAND")
  #echo $command_name &&
  # Tìm command line
  command_line=$(grep "$command_name" "$input_file") &&
    command="${command_line#*=}" &&
    echo "" &&
    echo "$command" &&
    echo "" &&
    cd $path &&
    echo -e $(eval "$command")
    echo ""
}

result=$(expect -c "
  set timeout 10
  spawn git pull origin $GIT_BRANCH
  expect {
    \"Username for *\" {
      send \"$username\r\"
      exp_continue
    }
    \"Password for *\" {
      sleep 2
      send \"$password\r\r\"
      exp_continue
    }
    eof
  }
  catch wait result
  exit [lindex \$result 3]
") &&
  echo "$result" &&
  if [[ $result == *$fe_path* ]]; then
    echo "|--------------------------------------------------------|"
    echo "|***** THERE ARE CHANGES INSIDE FOLDER $fe_path *****|"
    echo "|--------------------------------------------------------|"

    echo "|---------------|"
    echo "|*** INSTALL ***|"
    echo "|---------------|"

    cd $project/$fe_path &&
      npm install

    echo "|-------------|"
    echo "|*** BUILD ***|"
    echo "|-------------|"

    npm run build &&
      cp -rf $project/$fe_path/build/* $FE_ROOT_FOLDER_PATH
  fi

echo "|----------------------|"
echo "|*** UPDATE LIBRARY ***|"
echo "|----------------------|"

input_file="$HOOK_PATH/service_temp/giteaService.conf" &&

  # Doc va xu ly tung dong
  while IFS= read -r line; do
    # Kiem tra xem dong có chua "_PATH" không
    if [[ $line == *"_PROCESS_PATH"* && $line != "#"* && $line != *"_COMMAND"* ]]; then
      IFS="=" read -r variable value <<<"$line"
      variable=$(echo "$variable" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
      path=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

      # Loai bo khoang trong trong duong dan
      path=$(echo "$path" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
      # Kiem tra duong dan ton tai
      if [ ! -e "$path" ]; then
        echo ""
        echo -e "\e[41mError: $path not exists.\e[0m"
        echo ""
        exit 1 # Dung chuong trinh
      else
        echo -e "\e[32mProcessing in\e[0m: $path"
        run_commands "$variable"
      fi
    fi
  done <"$input_file" &&
echo "|------------|"
echo "|*** DONE ***|"
echo "|------------|"
