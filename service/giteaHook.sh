#!/bin/bash

#File chua bien moi truong
source /home/joseph/abc/gitea_CICD/service/giteaService

#URL project
project=$PROJECT_PATH

#URL folder FE
fe_path=$FE_PROJECT_PATH

#URL folder BE
#be_path="netmiko_Api/"

#URL other folder
#other="..."

cd $project

result=$(expect -c '
  set timeout 10
  spawn git pull
  expect {
    "Username for *" {
      send "$GIT_USERNAME\n"
      exp_continue
    }
    "Password for *" {
      sleep 2
      send "$GIT_PASSWORD\r\r"
      exp_continue
    }
    eof
  }
  catch wait result
  exit [lindex $result 3]
')

echo "$result"

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
    cp -rf $project/$fe_path/build/* $FE_ROOT_FOLDER
fi

echo "|----------------------|"
echo "|*** UPDATE LIBRARY ***|"
echo "|----------------------|"

    cd $project &&
    npm install 
    sleep 10

echo "|------------|"
echo "|*** DONE ***|"
echo "|------------|"
