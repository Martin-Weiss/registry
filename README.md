# registry

HINT: this is the first commit and push and not yet tested / work in progress

Scripts to create a registry with portus

1. adjust variables.txt in certificates

2. create certificates with executing scripts in certificates

3. adjust variables.txt in registry

4. start mysql.sh

5. create database with the correct user and password:

	podman exec -it mysql bash

	mysql -u root -p

	CREATE USER 'portus'@'%' IDENTIFIED BY '<password>';

	CREATE DATABASE <database_name>;

	GRANT ALL ON <database_name>.* TO 'portus'@'%';

	quit

	exit

6. start registty.sh

7. start portus.sh

8. start portus-background.sh

9. login to portus with the password in variables.txt

10. connect registry <fqdn>:5000 and use ssl

11. create admin user, create other users, teams, namespaces and push images

12. enjoy
