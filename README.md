# registry

HINT: this is the first commit and push and not yet tested / work in progress

Scripts to create a registry with portus and 389-ds

This is prepared for podman on SLES 15 SP2 so podman needs to be installed..
Scripts are for /data/certificates, /data/389-ds and /data/registry - so place them there or adjust.

1. adjust variables.txt in certificates

2. create certificates with executing scripts in certificates

3. adjust variables in 389-ds

4. start 389-ds.sh

5. adjust variables.txt in registry

6. start mysql.sh

7. create database with the correct user and password:

	podman exec -it mysql bash

	mysql -u root -p

	CREATE USER 'portus'@'%' IDENTIFIED BY '<password>';

	CREATE DATABASE <database_name>;

	GRANT ALL ON <database_name>.* TO 'portus'@'%';

	quit

	exit

8. start registry.sh

9. start portus.sh

10. start portus-background.sh

11. login to portus with the password in variables.txt

12. connect registry <fqdn>:5000 and use ssl

13. create admin user, create other users, teams, namespaces and push images

14. enjoy
