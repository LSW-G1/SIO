#!/bin/bash

# VMInstaller.sh - Includes
# VERSION: V1.06
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

# Colors
CR="\033[1;31m"
CG="\033[1;32m"
CY="\033[1;33m"
CB="\033[1;34m"
CM="\033[1;35m"
CC="\033[1;36m"
CE="\033[0m"

# Clear Line
CL="\033[2K"

# VARIABLES
DOING=""
PHPVER="php7.2"
IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)


# FUNCTION: Informs the user about the current operation
function inform
{
	echo -ne " \r ${CL}${CC}[..]${CE} - ${DOING}"
}

function success
{
	echo -e " \r ${CL}${CG}[OK]${CE} - ${DOING}"
	log "OK" "${DOING}"
}

function failure
{
	echo -e " \r ${CL}${CR}[FAILED]${CE} - ${DOING}"
	log "FAIL" "${DOING}"
}

function log
{
	echo -e "$(date '+%d/%m/%Y %H:%M:%S') - [$1] - ${2}" >> /var/log/VMInstaller.log
}

# FUNCTION: Checks the error code
function check
{
	if [[ $? -eq 0 ]]; then
		success
	else
		if [[ $1 == "VirtualBox" ]]; then
			echo -e " \r ${CL}${CM}[ATTENTION]${CE} - ${DOING}"
			echo -e " "
			echo -e " S'il s'agit de la ${CM}première installation${CE} "
			echo -e " - ${CY}Arrêtez le script${CE} "
			echo -e " - ${CY}Vérifiez les logs [/var/log/VMinstaller-output.log]${CE} "
			echo -e " "
			echo -e " S'il s'agit d'une ${CM}mise à jours${CE} ou ${CM}d'une réinstallation${CE} "
			echo -e " - ${CY}Continuez le script${CE} "
			echo -e " - ${CY}Redémarrez votre Machine Virtuelle${CE} "
			echo -e " "

			waitUserInput
		else
			failure
			echo -e " "
			exit 1
		fi
	fi
}

# FUNCTION: Waits for the user's input
function waitUserInput
{
	read -p " Appuyez sur entrer pour continuer... "
	echo -e " "
}