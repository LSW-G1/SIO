#!/bin/bash

# VMInstaller.sh - MariaDB
# VERSION: V1.11
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

clear
echo -e " "
echo -e " ${CC}BASE DE DONNÉES: MARIADB${CE}"
echo -e " "
echo -e " MariaDB est un système de gestion de base de données équivalent à MySQL"
echo -e " "

DOING="Ajout de la clé APT 0xF1656F24C74CD1D8 [apt-key]"
inform
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 &>>/var/log/VMInstaller-output.log
check

# gpg is being mean to me, always showing a message :c
clear
echo -e " "
echo -e " ${CC}BASE DE DONNÉES: MARIADB${CE}"
echo -e " "
echo -e " MariaDB est un système de gestion de base de données équivalent à MySQL"
echo -e " "

DOING="Ajout de la clé APT 0xF1656F24C74CD1D8 [apt-key]"
inform
check

DOING="Ajout du dépot mariadb.mirrors.ovh.net [add-apt-repository]"
inform
sh -c 'echo "deb [arch=amd64,i386,ppc64el] http://mariadb.mirrors.ovh.net/MariaDB/repo/10.3/debian stretch main" > /etc/apt/sources.list.d/mariadb.list' &>>/var/log/VMInstaller-output.log
check

DOING="Mise à jours des dépots [apt update]"
inform
apt update -y &>>/var/log/VMInstaller-output.log
check

DOING="Installation de MariaDB [apt install mariadb-server]"
inform
apt install mariadb-server -y &>>/var/log/VMInstaller-output.log
check

DOING="Configuration de MariaDB [mysql]"
inform
mysql -e "UPDATE mysql.user SET Password = PASSWORD('root') WHERE User = 'root'" &>>/var/log/VMInstaller-output.log
mysql -e "DROP USER ''@'localhost'" &>>/var/log/VMInstaller-output.log
mysql -e "DROP USER ''@'$(hostname)'" &>>/var/log/VMInstaller-output.log
mysql -e "DROP DATABASE test" &>>/var/log/VMInstaller-output.log
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION" &>>/var/log/VMInstaller-output.log
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION" &>>/var/log/VMInstaller-output.log
mysql -e "FLUSH PRIVILEGES" &>>/var/log/VMInstaller-output.log

# Allow external connection
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf &>>/var/log/VMInstaller-output.log

# my.cnf
echo -e "[client]" > ~/.my.cnf
echo -e "user=root" >> ~/.my.cnf
echo -e "password=root" >> ~/.my.cnf
check

DOING="Redémarrage du service MySQL [service mysql restart]"
inform
service mysql restart &>>/var/log/VMInstaller-output.log
check
