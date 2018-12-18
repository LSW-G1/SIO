#!/bin/bash

# VMInstaller.sh - Global Config
# VERSION: V1.11
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

clear
echo -e " "
echo -e " ${CC}DERNIÈRES ÉTAPES: CONFIGURATION${CE} "
echo -e " "

DOING="Autorisation de la connexion ROOT en SSH [sed]"
inform
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config &>>/var/log/VMInstaller-output.log
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config &>>/var/log/VMInstaller-output.log
service sshd restart &>>/var/log/VMInstaller-output.log
check

DOING="Téléchargement de composer [wget]"
inform
wget https://getcomposer.org/installer -O composer-setup.php &>>/var/log/VMInstaller-output.log
check

DOING="Installation de composer [php]"
inform
php composer-setup.php &>>/var/log/VMInstaller-output.log
check

rm composer-setup.php &>>/var/log/VMInstaller-output.log
chmod +x composer.phar &>>/var/log/VMInstaller-output.log
mv composer.phar /usr/local/bin/composer &>>/var/log/VMInstaller-output.log

DOING="Téléchargement d'adminer.php [wget]"
inform
cd /var/www/html &>>/var/log/VMInstaller-output.log
wget https://github.com/vrana/adminer/releases/download/v4.6.3/adminer-4.6.3-mysql.php -O adminer.php &>>/var/log/VMInstaller-output.log
check
