#!/bin/bash

# VMInstaller.sh - Checking Root Access
# VERSION: V1.09
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

# Checking root access
DOING="Accès superutilisateur"
if [[ "$EUID" -ne 0 ]]; then
	echo -e " ${CR}[FAILED]${CE} - ${DOING}"
	echo -e " Veuillez lancer le script avec les autorisations ${CM}root${CE} "
	echo -e " "

	exit 1
else
	echo -e " ${CG}[OK]${CE} - ${DOING}"
	echo -e " "
fi

# Asking to continue
DOING="Confirmation de lancement"
while [[ $CONFIRM != "O" && $CONFIRM != "N" && $CONFIRM != "o" && $CONFIRM != "n" ]]; do
	read -p " Voulez-vous continuer ? [O/N]: " CONFIRM
done

if [[ $CONFIRM == "O" || $CONFIRM == "o" ]]; then
	log "INFO" "Local IP: ${IP}"
	log "INFO" "Linux version: $(uname -a)"
	log "INFO" "Debian version: $(cat /etc/debian_version)"

	log "OK" "${DOING}"
else
	echo -e " ${CR}Arrêt du script...${CE}"
	echo -e " "

	log "FAILED" "${DOING}"
	exit 1
fi

# Should we install VirtualBox - GA ?
DOING="Autorisation de l'installation des Additions Invités"
while [[ $VBOXGA != "O" && $VBOXGA != "N" && $VBOXGA != "o" && $VBOXGA != "n" ]]; do
	read -p " Voulez-vous installer les additions invités [VirtualBox Guest Additions]: " VBOXGA
done

if [[ $VBOXGA == "O" || $VBOXGA == "o" ]]; then
	echo -e " ${CG}Lancement du script...${CE}"
	echo -e " "

	log "INFO" "VboxGA install: true"
else
	log "INFO" "VboxGA install: false"
fi
