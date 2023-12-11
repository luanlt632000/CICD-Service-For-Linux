#!/bin/bash

#File chua bien moi truong
source /home/joseph/tr2/gitea_CICD/service_run/giteaService.conf

check="false"

#URL project
project=$PROJECT_PATH

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

result=$(git pull origin $GIT_BRANCH) &&
if [ $? -ne 0 ]; then
    echo "Pull failed. Please check!"
    error_message=$(git pull origin $GIT_BRANCH 2>&1)
    echo "Error: $error_message"
else
    echo "Pull success!"
    echo "" &&
    echo "--> git pull origin $GIT_BRANCH" &&
    echo "" &&
    echo "$result" &&
    output=$(echo "$result" | grep "|" | awk -F "|" '{gsub(/ /, "", $1); print $1}') &&
    while IFS= read -r line; do
      if [[ $line != "" && $(find "$project" | grep "$line" | grep -q "$FE_PROJECT_PATH"; echo $?) -eq 0 ]]; then
        echo "$line ton tai" &&
        check="true"
      else
        echo "$line ko ton tai"
      fi
    done <<< "$output"
    
#    process_ids=$(ps aux | grep "$FE_PROJECT_PATH" | grep "build" | grep -v grep | awk '{print $2}') &&
#    
#    if [ -n "$process_ids" ]; then
#    
#      echo "Kill process build on $FE_PROJECT_PATH..."
#    
#      for process_id in $process_ids; do
#        kill "$process_id"
#      done
#    
#    fi
#    
#    process_sh_ids=$(ps aux | grep "service_run/giteaHook.sh" | grep -v grep | awk '{print $2}') &&
#    
#    if [ -n "$process_sh_ids" ]; then
#    
#      echo "Kill process build on process_sh_ids..."
#    
#      for process_sh_id in $process_sh_ids; do
#        kill "$process_sh_id"
#      done
#    
#    fi
    
    if [[ $check == "true" ]]; then
      echo "|--------------------------------------------------------|"
      echo "|***** THERE ARE CHANGES INSIDE FOLDER $FE_PROJECT_PATH *****|"
      echo "|--------------------------------------------------------|"
  
      echo "|---------------|"
      echo "|*** INSTALL ***|"
      echo "|---------------|"
  
      cd $FE_PROJECT_PATH &&
        npm install -f
  
      echo "|-------------|"
      echo "|*** BUILD ***|"
      echo "|-------------|"
  
      npm run build &&
        cp -rf $FE_PROJECT_PATH/build/* $FE_ROOT_FOLDER_PATH
fi
    
    echo "|----------------------|"
    echo "|*** UPDATE LIBRARY ***|"
    echo "|----------------------|"
    
    input_file="$HOOK_PATH/service_run/giteaService.conf" &&
    
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
fi

