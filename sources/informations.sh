#!/bin/bash

# VMInstaller.sh - Informations
# VERSION: V1.06
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

clear
echo -e " "
echo -e " L'installation est maintenant terminée "
echo -e " Il est conseillé de redémarrer votre machine virtuelle. "
echo -e " "
echo -e " ${CR}Veuillez noter ces informations:${CE} "
echo -e " ${CY} MySQL${CE} "
echo -e " ${CY} - username: root${CE} "
echo -e " ${CY} - password: root${CE} "
echo -e " "
echo -e " Votre machine dispose d'un serveur web servant à la fois:"
echo -e " Sur le port ${CM}80${CE} (${CM}http://${IP}/${CE})"
echo -e " Sur le port ${CM}443${CE} (${CM}https://${IP}/${CE})"
echo -e " Vous aurez une alete de sécurtié : le certificat n'est pas connu"
echo -e " Vous pouvez ignorer ce message."
echo -e " "
echo -e " Vous pouvez maintenant vous connecter à votre serveur"
echo -e " en SSH (${CM}ssh root@${IP}${CE}) ou via Putty."
echo -e " "
echo -e " L'adresse IP locale de votre machine est: ${CM}${IP}${CE}"
echo -e " "
