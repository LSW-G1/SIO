#!/bin/bash

# VMInstaller.sh - Welcome
# VERSION: V1.09
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

clear
echo -e " "
echo -e " Bienvenue"
echo -e " Ce script permet l'installation et la configuration automatique de"
echo -e " certains paquets utilisés lors de la formation BTS Service Informatique "
echo -e " aux Organisations"
echo -e " Il ne devrait être utilisé que sur ${CM}une Machine Virtuelle (VM) VirtualBox${CE}"
echo -e " "
echo -e " Au cours de l'installation, ce script nécessitera votre intervention "
echo -e " afin de mettre en place vos préférences, ainsi que d'installer "
echo -e " correctement tous les paquets "
echo -e " Il a cependant été pensé pour être le plus simple possible "
echo -e " "
echo -e " Ce script a été développé par ${CM}TARTIERE Kevin${CE} "
echo -e " En cas de difficulté(s), n'hésitez pas à envoyer un E-Mail avec vos logs "
echo -e " Les logs se trouvent ici :"
echo -e " - ${CM}/var/log/VMInstaller.log${CE} - log minimaliste"
echo -e " - ${CM}/var/log/VMInstaller-output.log${CE} - log contenant les sorties des commandes "
echo -e " "

# Removing previous log files
if [[ -f /var/log/VMInstaller-output.log ]]; then
	rm -f /var/log/VMInstaller-output.log &>/dev/null
fi

if [[ -f /var/log/VMInstaller.log ]]; then
	rm -f /var/log/VMInstaller.log &>/dev/null
fi

source "${DIR}/sources/checking.sh"