#!/bin/bash

# VMInstaller.sh - PHP
# VERSION: V1.06
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

DOING="Téléchargement de la clé APT SURY [wget]"
inform
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &>>/var/log/VMInstaller-output.log
check

DOING="Ajout du dépot SURY [sh]"
inform
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' &>>/var/log/VMInstaller-output.log
check

DOING="Mise à jour du système [apt update]"
inform
apt update &>>/var/log/VMInstaller-output.log
check


