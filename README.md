# gitea_CICD

<div align="center"><img src="https://upload.wikimedia.org/wikipedia/commons/d/d9/Node.js_logo.svg" alt="NodeJS" width="300"></div>

### 1) Clone project to your server

```sh
  git clone https://gitea.nswteam.net/joseph/gitea_CICD.git
```

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

  ```sh
      cp service/giteaService.conf service_run/giteaService.conf
  ```

### 5) Fill in environment variables (\*)

root@root#
  ```sh
      service_run/giteaService.conf
  ```
### 6) Run file "install.sh" to install service

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
