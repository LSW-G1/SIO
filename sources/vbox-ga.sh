#!/bin/bash

# VMInstaller.sh - VirtualBox Guest Additions
# VERSION: V1.06
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

CDROM=false
while [[ $CDROM != true ]]; do
	clear
	echo -e " "
	echo -e " ${CC}ADDTITIONS INVITÉS: VERIFICATIONS${CE} "
	echo -e " "
	echo -e " Les Additions Invités permettent d'accéder a des fonctionnalités "
	echo -e " supplémentaires tels que le partage de dossier que nous ajouterons "
	echo -e " plus tard."
	echo -e " "

	DOING="Vérification de la présence du CD [blkid]"
	inform
	blkid /dev/sr0 &>>/var/log/VMInstaller-output.log

	if [[ $? -eq 0 ]]; then
		# Something is in the CDROM slot
		DOING="Montage du CD [mount]"
		inform

		mount /media/cdrom &>>/var/log/VMInstaller-output.log

		if [[ -f /media/cdrom/VBoxLinuxAdditions.run ]]; then
			# Correct CDROM detected
			CDROM=true
			success
		else
			# Wrong CDROM detected
			failure
			CDROM=false
			umount /media/cdrom &>>/var/log/VMInstaller-output.log

			echo -e " "
			echo -e " Veuillez insérer le ${CM}CD des Additions Invités${CE} "
			echo -e " - ${CY}Allez dans Périphériques${CE} "
			echo -e " - ${CY}Cliquez sur Insérer l'image des Additions Invités${CE} "
			echo -e " "

			waitUserInput
		fi
	else
		# Nothing is in the CDROM slot
		failure
		CDROM=false

		echo -e " "
		echo -e " Veuillez insérer le ${CM}CD des Additions Invités${CE} "
		echo -e " - ${CY}Allez dans Périphériques${CE} "
		echo -e " - ${CY}Cliquez sur Insérer l'image des Additions Invités${CE} "
		echo -e " "

		waitUserInput
	fi
done

clear
echo -e " "
echo -e " ${CC}ADDTITIONS INVITÉS: INSTALLATION${CE} "
echo -e " "
echo -e " Les Additions Invités permettent d'accéder a des fonctionnalités "
echo -e " supplémentaires tel que le partage de dossier que nous ajouterons "
echo -e " plus tard."
echo -e " "

DOING="Installation des Additions Invités [sh]"
inform
sh /media/cdrom/VBoxLinuxAdditions.run force &>>/var/log/VMInstaller-output.log
check "VirtualBox"

SHARING=false
while [[ $SHARING != true ]]; do
	clear
	echo -e " "
	echo -e " ${CC}ADDTITIONS INVITÉS: PARTAGE DE DOSSIERS${CE} "
	echo -e " "
	echo -e " Les Additions Invités permettent d'accéder a des fonctionnalités "
	echo -e " supplémentaires tel que le partage de dossier. "
	echo -e " "

	DOING="Recherche du dossier partagé [VBoxControl]"
	inform

	mkdir -p /var/www/html/share &>>/var/log/VMInstaller-output.log
	# Old & Easy way. Thanks VirtualBox 5.2.12...
	# VBoxControl guestproperty set /VirtualBox/GuestAdd/SharedFolders/MountDir /var/www/html &>>/var/log/VMInstaller-output.log
	# VBoxService &>>/var/log/VMInstaller-output.log

	# Thanks https://unix.stackexchange.com/questions/353921/cutting-id-output?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
	UMASK=$(umask) &>>/var/log/VMInstaller-output.log
	GID=$(id | awk -F '[=()]' '{print $5}')
	UUID=$(id | awk -F '[=()]' '{print $2}')

	mount.vboxsf -o umask=${UMASK},gid=${GID},uid=${UUID} share /var/www/html/share &>>/var/log/VMInstaller-output.log
	if [[ $? -eq 0 ]]; then
		SHARING=true
		success

		echo -e "share /var/www/html/share vboxsf umask=${UMASK},gid=${GID},uid=${UUID}" &>> /etc/fstab
	else
		SHARING=false
		failure

		echo -e " "
		echo -e " Le système de partage de fichier permet de synchronisrer un "
		echo -e " dossier entre votre système hôte et la Machine Virtuelle "
		echo -e " "
		echo -e " Ainsi, toute modification effectuée depuis votre PC sur ce "
		echo -e " dossier sera immédiatement transmit à la machine virtuelle "
		echo -e " et inversement. "
		echo -e " "
		echo -e " ${CM}Vous devez créer un dossier sur votre ordinateur qui${CE} "
		echo -e " ${CM}contiendra les éléments partagés entre celui-ci et la VM${CE} "
		echo -e " "
		echo -e " - ${CY}Allez dans Machine, puis Paramètres${CE} "
		echo -e " - ${CY}Allez dans l'onglet Dossiers Partagés${CE} "
		echo -e " - ${CY}Sélectionner le dossier à partager${CE} "
		echo -e " - ${CY}Donnez lui le nom '${CM}share${CY}'${CE} "
		echo -e " - ${CY}Cochez la case ${CC}'Montage Automatique'${CE} "
		echo -e " - ${CY}Cochez la case ${CC}'Configuration Permanente'${CE} "
		echo -e " "

		waitUserInput
	fi
done