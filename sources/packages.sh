#!/bin/bash

# VMInstaller.sh - Packages System
# VERSION: V1.06
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

clear
echo -e " "
echo -e " ${CC}GESTION DES PAQUETS${CE} "
echo -e " "
echo -e " Le script va maintenant mettre à jours votre système et "
echo -e " installer quelques dépendances qui seront nécessaires prochainement"
echo -e " "

# UPDATE COMMANDS
APT_COMMANDS="update full-upgrade autoremove autoclean"
for i in $APT_COMMANDS; do
	DOING="Mise à jour du système [apt ${i}]"
	inform
	apt ${i} -y &>>/var/log/VMInstaller-output.log
	check
done

# INSTALLATION COMMANDS
APT_PACKAGES="make gcc dkms linux-source linux-headers-$(uname -r) apt-transport-https lsb-release ca-certificates openssh-server git"
for i in $APT_PACKAGES; do
	DOING="Installation des paquets [apt install ${i}]"
	inform
	apt install -y ${i} &>>/var/log/VMInstaller-output.log
	check
done