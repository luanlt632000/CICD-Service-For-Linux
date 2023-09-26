#!/bin/bash


if [ -d "/etc/systemd/system" ]; then
  echo "|-------------------|"
  echo "|***** INSTALL *****|"
  echo "|-------------------|"
  
  pwd_install=$(pwd) &&
  escaped_pwd_install=$(printf '%s\n' "$pwd_install" | sed -e 's/[\/&]/\\&/g') &&
 
  echo "|------------------------------|"
  echo "|***** UPDATE ENVIRONMENT *****|"
  echo "|------------------------------|"
  
  
  sudo sed -i "s#ExecStart=.*#ExecStart=$escaped_pwd_install/service/giteaService.sh#" $pwd_install/service/giteaHook.service &&
  echo "* ExecStart *" &&
  sleep 3 && 

  sudo sed -i "s#WorkingDirectory=.*#WorkingDirectory=$escaped_pwd_install/service#" $pwd_install/service/giteaHook.service &&
  echo "* WorkingDirectory *" &&
  sleep 3 &&

  sudo sed -i "s#EnvironmentFile=.*#EnvironmentFile=$escaped_pwd_install/service/giteaService#" $pwd_install/service/giteaHook.service &&
  echo "* EnvironmentFile *" &&
  sleep 3 &&

  sudo sed -i "s#INDEXJS_HOOK_PATH=.*#INDEXJS_HOOK_PATH=$escaped_pwd_install#" $pwd_install/service/giteaService &&
  echo "* INDEXJS_HOOK_PATH *" &&
  sleep 3 &&

  sudo sed -i "s#HOOK_PATH=.*#HOOK_PATH=$escaped_pwd_install#" $pwd_install/service/giteaService &&
  echo "* HOOK_PATH *" &&
  sleep 3 &&

  systemctl stop giteaHook.service 
  
  cp $pwd_install/service/giteaHook.service /etc/systemd/system/giteaHook.service &&
  echo "* Copy service file *" &&
  
  systemctl daemon-reload &&
  
  echo "|--------------|" &&
  echo "|*** ENABLE ***|" &&
  echo "|--------------|" &&
  
  systemctl enable giteaHook &&
  
  echo "|-------------|" &&
  echo "|*** START ***|" &&
  echo "|-------------|" &&
  
  systemctl start giteaHook &&

  echo "|------------|" &&
  echo "|*** DONE ***|" &&
  echo "|------------|" &&
  
  echo "|--------------|" &&
  echo "|** GOODLUCK **|" &&
  echo "|--------------|" &&

  journalctl -u giteaHook -f

else
  echo "/etc/systemd/system directory does not exist. Please check!"
fi
