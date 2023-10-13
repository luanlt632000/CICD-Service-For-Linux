# gitea_CICD

<div align="center"><img src="https://upload.wikimedia.org/wikipedia/commons/d/d9/Node.js_logo.svg" alt="NodeJS" width="300"></div>

### 1) Clone project to your server

```sh
  git clone https://<USERNAME>:<PASSWORD>@gitea.nswteam.net/joseph/gitea_CICD.git
```
- Get username:
<div><img src="https://i.ibb.co/pLR2BjH/image.png" alt="getUsername" width="300"></div>

### 2) Access the folder you just cloned

root@root#
  ```sh
      cd gitea_CICD
  ```

### 3) Check the directory path

root@root#
  ```sh
      pwd
  ```
- output: <path>/gitea_CICD

### 4) Create folder service_run

root@root#

  ```sh
      mkdir service_run
  ```
Copy environment file 
  ```sh
      cp service/giteaService.conf service_run/giteaService.conf
  ```

### 5) Fill in environment variables (\*)

root@root#
  ```sh
      nano service_run/giteaService.conf
  ```
### 6) Add Nginx configuration
- Open the Nginx configuration file.

- Add thr following configuration content.

  ```
      location /git/ {
      #index index.html;
      proxy_pass http://<IP-address>:<PORT>;
      proxy_http_version 1.1;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Server $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "Upgrade";
      proxy_pass_request_headers on;
      proxy_max_temp_file_size 0;
      proxy_connect_timeout 900;
      proxy_send_timeout 900;
      proxy_read_timeout 900;
      proxy_buffer_size 128k;
      proxy_buffers 4 256k;
      proxy_busy_buffers_size 256k;
      proxy_temp_file_write_size 256k;
      }
  ```

- Change "IP-address" and "PORT". The "PORT" corresponds to the "PORT_SERVICE" of the "service_run/giteaService.conf" file.

### 7) Run file "install.sh" to install service

root@root#
  ```sh
      ./install.sh
  ```

<div align="center"><img src="https://i.ibb.co/VJHhb3y/install-Service.png" alt="install server" width="600"></div>

#### ** Note: **

- Project gitea_CICD should be placed at the same folder level as your project

  ```
      ├── your_project
      └── gitea_CICD project
  ```

- Depending on the technology your project uses, the "gitea_CICD/service/giteaHook.sh" file will be custom configured to match the technology.

<div align="center"><h4><i>**____ Joseph Le____ **</i></h4></div>
