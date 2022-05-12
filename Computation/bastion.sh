#!/bin/bash
yum update -y
sudo yum -y install https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm
sudo amazon-linux-extras install epel -y
sudo yum -y install mysql-community-server
sudo systemctl enable --now mysqld
sudo yum -y install git
mkdir /dbScripts
git clone ${github_rep} /dbScripts

mysql --host=dentist-prueba-id.c4etmjaey4hy.us-east-1.rds.amazonaws.com --user=root --password=dentist_db mydentistprueba < aws-project-random-files/dentistDBCreation.sql
mysql --host=dentist-prueba-id.c4etmjaey4hy.us-east-1.rds.amazonaws.com --user=root --password=dentist_db mydentistprueba < aws-project-random-files/dentistDBInsert.sql