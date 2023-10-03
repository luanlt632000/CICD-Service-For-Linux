#!/bin/bash

#File chua bien moi truong
source /home/joseph/abc/gitea_CICD/service/giteaService

#URL project
project=$PROJECT_PATH

#URL folder FE
fe_path=$(basename "$FE_PROJECT_PATH")

#URL folder BE
be_path=$BE_PROJECT_PATH

#URL other folder
#other="..."

#Username git
username=$GIT_USERNAME

#Password git
password=$GIT_PASSWORD

#Git branch
branch=$GIT_BRANCH

cd $project

result=$(expect -c "
  set timeout 10
  spawn git pull origin \$branch
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

    cd $be_path &&
    npm install 
    sleep 10

echo "|------------|"
echo "|*** DONE ***|"
echo "|------------|"
