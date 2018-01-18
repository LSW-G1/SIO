#!/bin/bash

# VMInstaller.sh - MariaDB
# VERSION: V1.08
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

clear
echo -e " "
echo -e " ${CC}BASE DE DONNÉES: MARIADB${CE}"
echo -e " "
echo -e " MariaDB est un système de gestion de base de données équivalent à MySQL"
echo -e " "

DOING="Installation de MariaDB [apt install mariadb-server]"
inform
apt install mariadb-server -y &>>/var/log/VMInstaller-output.log
check

DOING="Configuration de MariaDB [mysql]"
inform
mysql -proot -e "UPDATE mysql.user SET Password = PASSWORD('root') WHERE User = 'root'" &>>/var/log/VMInstaller-output.log
mysql -proot -e "DROP USER ''@'localhost'" &>>/var/log/VMInstaller-output.log
mysql -proot -e "DROP USER ''@'$(hostname)'" &>>/var/log/VMInstaller-output.log
mysql -proot -e "DROP DATABASE test" &>>/var/log/VMInstaller-output.log
mysql -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION" &>>/var/log/VMInstaller-output.log
mysql -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION" &>>/var/log/VMInstaller-output.log
mysql -proot -e "FLUSH PRIVILEGES" &>>/var/log/VMInstaller-output.log

# Allow external connection
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf &>>/var/log/VMInstaller-output.log
check

DOING="Redémarrage du service MySQL [service mysql restart]"
inform
service mysql restart &>>/var/log/VMInstaller-output.log
check
