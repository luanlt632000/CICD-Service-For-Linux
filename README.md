# gitea_CICD



1) Clone project to your server
	git clone https://gitea.nswteam.net/joseph/gitea_CICD.git

2) Access the folder you just cloned
	root@root#cd <path>/gitea_CICD

3) Check the directory path
	root@root# pwd
		output: <path>/gitea_CICD

4) Fill in environment variables
	root@root# nano service/giteaService
		- GIT_USERNAME: Username of the git account.
		- GIT_PASSWORD: Password of the git account.
		- PROJECT_PATH: Root path of your project.
		- FE_PROJECT_PATH: Path of the front-end folder.
		- BE_PROJECT_PATH: Path of the back-end folder.
		- FE_ROOT_FOLDER: Path of folder front-end public.

5) Run file "install.sh" to install service
	root@root# ./install.sh

 


** Note: ** 

- Project gitea_CICD should be placed at the same folder level as your project

	..
	|
	|__your project
	|
	|__gitea_CICD project
	|
	|__ . . .


- Depending on the technology your project uses, the "gitea_CICD/service/giteaHook.sh" file will be custom configured to match the technology.








**____ Joseph ____ **
