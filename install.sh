#!/bin/bash


if [ -d "/etc/systemd/system" ]; then
  echo "|-------------------|"
  echo "|***** INSTALL *****|"
  echo "|-------------------|"

  systemctl stop giteaHook.service
  cp ./service/giteaHook.service /etc/systemd/system/giteaHook.service &&
  systemctl daemon-reload &&
  systemctl enable giteaHook &&
  systemctl start giteaHook &&

  echo "|------------|"
  echo "|*** DONE ***|"
  echo "|------------|"
  
  echo "|--------------|"
  echo "|** GOODLUCK **|"
  echo "|--------------|"

  journalctl -u giteaHook -f

else
  echo "/etc/systemd/system directory does not exist. Please check!"
fi
