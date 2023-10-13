#!/bin/bash

if [ -d "/etc/systemd/system" ]; then
    echo "|---------------------------|"
    echo -e "|***** \e[33mINSTALL SERVICE\e[0m *****|"
    echo "|---------------------------|"
    
    pwd_install=$(pwd) &&
    escaped_pwd_install=$(printf '%s\n' "$pwd_install" | sed -e 's/[\/&]/\\&/g') &&
    echo ""
    echo "|------------------------------|"
    echo -e "|***** \e[33mUPDATE ENVIRONMENT\e[0m *****|"
    echo "|------------------------------|"
    echo ""
    
    find $pwd_install/service -type f -not -name "giteaService.conf" -exec cp {} $pwd_install/service_run \;

    sudo sed -i "s#ExecStart=.*#ExecStart=$escaped_pwd_install/service_run/giteaService.sh#" $pwd_install/service_run/giteaHook.service &&
    echo -e "* \e[32mExecStart\e[0m *" &&

    sudo sed -i "s#WorkingDirectory=.*#WorkingDirectory=$escaped_pwd_install/service_run#" $pwd_install/service_run/giteaHook.service &&
    echo -e "* \e[32mWorkingDirectory\e[0m *" &&

    sudo sed -i "s#EnvironmentFile=.*#EnvironmentFile=$escaped_pwd_install/service_run/giteaService.conf#" $pwd_install/service_run/giteaHook.service &&
    echo -e "* \e[32mEnvironmentFile\e[0m *" &&

    sudo sed -i "s#HOOK_PATH=.*#HOOK_PATH=$escaped_pwd_install#" $pwd_install/service_run/giteaService.conf &&
    echo -e "* \e[32mHOOK_PATH\e[0m *" &&

    sudo sed -i "s#source .*#source $escaped_pwd_install/service_run/giteaService.conf#" $pwd_install/service_run/giteaHook.sh &&
    echo -e "* \e[32mEXEC_FILE\e[0m *" &&
    echo ""

    sudo sed -i "s#source .*#source $escaped_pwd_install/service_run/giteaService.conf#" $pwd_install/service_run/giteaService.sh &&

    systemctl stop giteaHook.service
    
    input_file="$pwd_install/service_run/giteaService.conf" &&
    
    #Doc va xu ly tung dong
    while IFS= read -r line; do
        # Kiem tra xem dong c� chua "_PATH" kh�ng
        if [[ $line == *"_PATH"* && $line != "#"* && $line != *"_COMMAND"* ]]; then
            # Lay string sau dau "="
            path="${line#*=}"
            # Loai bo khoang trong trong duong dan
            path=$(echo "$path" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
            # Kiem tra duong dan ton tai
            if [ ! -e "$path" ]; then
                echo ""
                echo -e "\e[41mError: $path not exists.\e[0m"
                echo ""
                exit 1 # Dung chuong trinh
            else
                echo -e "\e[32mOK: $path exists\e[0m"
                sleep 1
            fi
        fi
    done <"$input_file" &&

    

    cp $pwd_install/service_run/giteaHook.service /etc/systemd/system/giteaHook.service &&
    echo "" &&
    echo -e "* \e[32mCopy service file\e[0m *" &&
    systemctl daemon-reload &&
    echo "" &&
    echo "|----------------------|" &&
    echo -e "|*** \e[33mENABLE SERVICE\e[0m ***|" &&
    echo "|----------------------|" &&
    echo "" &&
    systemctl enable giteaHook &&
    echo "|---------------------|" &&
    echo -e "|*** \e[33mSTART SERVICE\e[0m ***|" &&
    echo "|---------------------|" &&
    echo "" &&
    systemctl start giteaHook &&
    echo "|------------|" &&
    echo -e "|*** \e[33mDONE\e[0m ***|" &&
    echo "|------------|" &&
    echo "" &&
    sleep 1 &&
    echo "|--------------|" &&
    echo -e "|** \e[33mGOODLUCK\e[0m **|" &&
    echo "|--------------|" &&
    echo "" &&
    journalctl -u giteaHook -f
    
else
    echo "/etc/systemd/system directory does not exist. Please check!"
fi
