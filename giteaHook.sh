#!/bin/bash

#URL project
project="/home/Log_service"

#URL folder FE
fe_path="manage-view/"

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
      send "joseph.le@apactech.io\n"
      exp_continue
    }
    "Password for *" {
      sleep 2
      send "Maypjtkh0ng\r\r"
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
    cp -rf $project/$fe_path/build/* /var/www/html
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
