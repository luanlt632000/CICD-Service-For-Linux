# gitea_CICD
[NodeJS]: https://upload.wikimedia.org/wikipedia/commons/d/d9/Node.js_logo.svg
![NodeJS][NodeJS]
### 1) Clone project to your server
  ```sh
    git clone https://gitea.nswteam.net/joseph/gitea_CICD.git
  ```
### 2) Access the folder you just cloned
* root@root#
    ```sh
        cd gitea_CICD
    ```
### 3) Check the directory path
* root@root#
    ```sh
        pwd
    ```
* output: <path>/gitea_CICD

### 4) Fill in environment variables (*)
* root@root#
    ```sh
        nano service/giteaService
    ```
	* GIT_USERNAME: Username of the git account.
	* GIT_PASSWORD: Password of the git account.
	* GIT_BRANCH: The git branch is needed for the server.
	* EMAIL_ADDRESS: Your email address.
	* SEND_EMAIL: Turn on/off email sending feature.
	* PROJECT_PATH: Root path of your project.
	* FE_PROJECT_PATH: Path of the front-end folder.
	* BE_PROJECT_PATH: Path of the back-end folder.
	* FE_ROOT_FOLDER: Path of folder front-end public.

### 5) Run file "install.sh" to install service
* root@root#
     ```sh
        ./install.sh
    ```

![install](https://ibb.co/rFbLqvP)
#### ** Note: ** 

- Project gitea_CICD should be placed at the same folder level as your project
    ```
        ├── your_project
        └── gitea_CICD project
    ```

- Depending on the technology your project uses, the "gitea_CICD/service/giteaHook.sh" file will be custom configured to match the technology.

 **____ Joseph ____ **

