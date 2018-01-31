#!/bin/bash

# VMInstaller.sh - Nginx
# VERSION: V1.09
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

clear
echo -e " "
echo -e " ${CC}SERVEUR WEB: NGINX${CE} "
echo -e " "

# NGINX
DOING="Installation de NGINX [apt install nginx]"
inform
apt install -y nginx &>>/var/log/VMInstaller-output.log
check

DOING="Changement des permissions [chmod 755]"
inform
chmod 755 -R /var/www &>>/var/log/VMInstaller-output.log
if [[ $VBOXGA == "O" || $VBOXGA == "o" ]]; then
	adduser root vboxsf &>>/var/log/VMInstaller-output.log
	adduser www-data vboxsf &>>/var/log/VMInstaller-output.log
fi
check


# PHP
source "${DIR}/sources/php.sh"

APT_PACKAGES="${PHPVER}-fpm ${PHPVER}-cli ${PHPVER}-common ${PHPVER}-mbstring ${PHPVER}-gd ${PHPVER}-intl ${PHPVER}-xml ${PHPVER}-mysql ${PHPVER}-zip"
for i in $APT_PACKAGES; do
	DOING="Installation des paquets [apt install ${i}]"
	inform
	apt install -y ${i} &>>/var/log/VMInstaller-output.log
	check
done


# CONFIGURATION
mkdir /etc/nginx/ssl &>>/var/log/VMInstaller-output.log
cd /etc/nginx/ssl/ &>>/var/log/VMInstaller-output.log

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
if [[ -f /etc/nginx/conf.d/website.conf ]]; then
	CONFIRM=false
	while [[ $CONFIRMM != "O" && $CONFIRM != "o" && $CONFIRM != "N" && $CONFIRM != "n" ]]; do
		echo -e " "
		read -p " webiste.conf existe déjà. Voulez-vous l'ecraser ? [O/N]: " CONFIRM
	done
else
	CONFIRM="O"
fi

if [[ $CONFIRM == "O" ]]; then
	cp -f "${DIR}/conf/nginx.conf" "/etc/nginx/conf.d/website.conf"  &>>/var/log/VMInstaller-output.log
fi
check

DOING="Configuration de NGINX [sed]"
inform
if [[ $CONFIRM == "O" ]]; then
	sed -i "s/PHPVER./\/${PHPVER}-/" /etc/nginx/conf.d/website.conf &>>/var/log/VMInstaller-output.log
fi
check

DOING="Désactivation du site par défaut [rm]"
inform
rm -f /etc/nginx/sites-enabled/default &>>/var/log/VMInstaller-output.log
check

DOING="Redémarrage de NGINX [service nginx restart]"
inform
service nginx restart &>>/var/log/VMInstaller-output.log
check
