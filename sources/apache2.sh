#!/bin/bash

# VMInstaller.sh - APACHE2
# VERSION: V1.06
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

clear
echo -e " "
echo -e " ${CC}SERVEUR WEB: APACHE2${CE} "
echo -e " "

# APACHE2
DOING="Installation de apache2 [apt install apache2]"
inform
apt install -y apache2 &>>/var/log/VMInstaller-output.log
check

DOING="Changement des permissions [chmod 755]"
inform
chmod 755 -R /var/www &>>/var/log/VMInstaller-output.log
adduser root vboxsf &>>/var/log/VMInstaller-output.log
adduser www-data vboxsf &>>/var/log/VMInstaller-output.log
check


# PHP
source "${DIR}/sources/php.sh"

APT_PACKAGES="${PHPVER} libapache2-mod-${PHPVER} ${PHPVER}-cli ${PHPVER}-common ${PHPVER}-mbstring ${PHPVER}-gd ${PHPVER}-intl ${PHPVER}-xml ${PHPVER}-mysql ${PHPVER}-zip"
for i in $APT_PACKAGES; do
	DOING="Installation des paquets [apt install ${i}]"
	inform
	apt install -y ${i} &>>/var/log/VMInstaller-output.log
	check
done


# CONFIGURATION
mkdir /etc/apache2/ssl &>>/var/log/VMInstaller-output.log
cd /etc/apache2/ssl/ &>>/var/log/VMInstaller-output.log

DOING="Génération de clé [openssl genrsa]"
inform
openssl genrsa -out key.pem 4096 &>>/var/log/VMInstaller-output.log
check

DOING="Génération de certificat TLS [openssl req]"
inform
openssl req -new -x509 -sha512 -days 3650 -key key.pem -out cert.pem -subj "/C=FR/ST=France/L=Saint-Etienne/O=BTS-SIO/OU=SLAM1/CN=localhost" &>>/var/log/VMInstaller-output.log
check

DOING="Création de la configuration [mv]"
inform
if [[ -f /etc/apache2/sites-available/website.conf ]]; then
	CONFIRM=false
	while [[ $CONFIRMM != "O" && $CONFIRM != "o" && $CONFIRM != "N" && $CONFIRM != "n" ]]; do
		echo -e " "
		read -p " website.conf existe déjà. Voulez-vous l'ecraser ? [O/N]: " CONFIRM
	done
else
	CONFIRM="O"
fi

if [[ $CONFIRM == "O" ]]; then
	cp -f "${DIR}/conf/apache2.conf" "/etc/apache2/sites-available/website.conf"  &>>/var/log/VMInstaller-output.log
fi
check

DOING="Désactivation du site par défaut [a2dissite]"
inform
a2dissite 000-default &>>/var/log/VMInstaller-output.log
check

DOING="Suppression du dossier par défaut [rm]"
inform
rm -rf /var/www/html &>>/var/log/VMInstaller-output.log
check

DOING="Activation de la configuration [a2ensite]"
inform
a2ensite website &>>/var/log/VMInstaller-output.log
check

DOING="Activation des modules 1/2 [a2enmod ssl]"
inform
a2enmod ssl &>>/var/log/VMInstaller-output.log
check

DOING="Activation des modules 2/2 [a2enmod headers]"
inform
a2enmod headers  &>>/var/log/VMInstaller-output.log
check

DOING="Redémarrage d'APACHE [service apache2 restart]"
inform
service apache2 restart  &>>/var/log/VMInstaller-output.log
check