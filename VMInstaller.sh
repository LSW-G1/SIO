#!/bin/bash

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

# VARS
DOING=""
PHPVER="php7.2"
IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)

## FUNCTIONS
function log
{
	echo -e "$(date '+%d/%m/%Y %H:%M:%S') - [$1] - ${2}" >> /var/log/VMInstaller.log
}

function inform
{
	echo -ne " \r ${CC}[..]${CE} - ${DOING} "
}

function check
{
	if [[ $? -eq 0 ]]; then
		echo -e " \r ${CL}${CG}[OK]${CE} - ${DOING}"

		# LOGING
		log "OK" "${DOING}"
	else
		echo -e " \r ${CL}${CR}[FAILED]${CE} - ${DOING} "
		echo -e " "

		# LOGING
		log "FAILED" "${DOING}"
		exit 1
	fi
}




# ***
# * WELCOME
# ***

clear
echo -e " "
echo -e " Bienvenue"
echo -e " Ce script permet l'installation et la configuration automatique de"
echo -e " certains paquets utilisés lors de la formation BTS Service Informatique "
echo -e " aux Organisations"
echo -e " Il ne devrait être utilisé que sur ${CB}une Machine Virtuelle (VM) VirtualBox${CE}"
echo -e " "
echo -e " Au cours de l'installation, ce script nécessitera votre intervention "
echo -e " afin de mettre en place vos préférences, ainsi que d'installer "
echo -e " correctement tous les paquets "
echo -e " Il a cependant été pensé pour être le plus simple possible "
echo -e " "
echo -e " Ce script a été développé par ${CB}TARTIERE Kevin${CE} "
echo -e " En cas de difficulté(s), n'hésitez pas à envoyer un E-Mail avec vos logs "
echo -e " Les logs se trouvent ici :"
echo -e " - ${CB}/var/log/VMInstaller.log${CE} - log minimaliste"
echo -e " - ${CB}/var/log/VMInstaller-output.log${CE} - log contenant les sorties des commandes "
echo -e " "

# Removing previous log files
if [[ -f /var/log/VMInstaller-output.log ]]; then
	rm -f /var/log/VMInstaller-output.log &> /dev/null
fi

if [[ -f /var/log/VMInstaller.log ]]; then
	rm -f /var/log/VMInstaller.log &> /dev/null
fi

# Checking root access
DOING="Accès superutilisateur"
if [[ "$EUID" -ne 0 ]]; then
	echo -e " ${CR}[FAILED]${CE} - ${DOING}"
	echo -e " Veuillez lancer le script avec les autorisations ${CB}root${CE} "
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
	echo -e " ${CG}Lancement du script...${CE}"
	echo -e " "

	log "OK" "${DOING}"
else
	echo -e " ${CR}Arrêt du script...${CE}"
	echo -e " "

	log "FAILED" "${DOING}"
	exit 1
fi

# Timeout
ping -c 3 localhost &>/dev/null





# ***
# * SYSTEM UPDATES AND DEPENDENCIES
# ***

clear
echo -e " "
echo -e " Le script va maintenant mettre à jour votre système"
echo -e " et installer quelques dépendances qui seront nécessaires"
echo -e " prochainement "
echo -e " "

# Updating repository
DOING="Mise à jour du système [REPOSITORY]"
inform
apt update &>> /var/log/VMInstaller-output.log
check

# Updating packages and system
DOING="Mise à jour du système [PACKAGES] "
inform
apt full-upgrade -y &>> /var/log/VMInstaller-output.log
check

# Removing unused packages
DOING="Mise à jour du système [REMOVE UNUSED PACKAGES]"
inform
apt autoremove -y &>> /var/log/VMInstaller-output.log
check

# Removing old packages
DOING="Mise à jour du système [REMOVE OLD VERSION]"
inform
apt autoclean -y &>> /var/log/VMInstaller-output.log
check

# Installing dependencies
DOING="Installation des dépendances"
inform
apt install make gcc dkms linux-source linux-headers-$(uname -r) apt-transport-https lsb-release ca-certificates openssh-server -y &>> /var/log/VMInstaller-output.log
check

# Timeout
ping -c 3 localhost &>/dev/null





# ***
# * GUEST ADDTIONS
# ***

clear
echo -e " "
echo -e " Le script va maintenant vérifier les Additions Invité "
echo -e " "

while [[ $CDROM != true ]]; do
	DOING="Recherche de l'image CD des Additions Invité"
	inform

	blkid /dev/sr0  &>> /var/log/VMInstaller-output.log
	if [[ $? -eq 0 ]]; then
		CDROM=true
	else
		CDROM=false

		clear
		echo -e " "
		echo -e " ${CC}Veuillez insérer le CD des Additions Invité${CE}"
		echo -e " ${CC}Allez dans ${CY}Périphériques${CE}"
		echo -e " ${CC}Puis cliquez sur ${CY}Insérer l'image CD des Additions Invité${CE}"
		echo -e " "

		read -p " Appuyez sur une touche pour continuer... "
		echo -e " "
	fi
done

check

# Timeout
ping -c 3 localhost &>/dev/null

clear
echo -e " "
echo -e " Le script va maintenant installer les Additions Invité "
echo -e " "

# Mount the disc
DOING="Montage du disque virtuel"
inform
mount /media/cdrom &>> /var/log/VMInstaller-output.log
check

DOING="Installation des Additions Invité"
inform
sh /media/cdrom/VBoxLinuxAdditions.run &>> /var/log/VMInstaller-output.log
check

# Timeout
ping -c 3 localhost &>/dev/null





# ***
# * FOLDER SHARING
# ***

while [[ $SHARING != "O" ]]; do
	clear
	echo -e " "
	echo -e " Le script va maintenant rechercher le dossier partagé "
	echo -e " "

	DOING="Recherche du dossier partagé"
	inform

	VBoxControl guestproperty set /VirtualBox/GuestAdd/SharedFolders/MountDir /var/www &>> /var/log/VMInstaller-output.log
	VBoxService &>> /var/log/VMInstaller-output.log

	# Timeout
	ping -c 2 localhost &>/dev/null

	SHARING_PATH=$(find /var/www/ -type d -name "sf_*")

	if [[ ! -z  "${SHARING_PATH}" ]]; then
		echo -e " \r ${CL}${CG}[OK]${CE} - ${DOING}"

		SHARING="O"
		log "SHARING" "${SHARING_PATH}"
	else
		clear
		echo -e " "
		echo -e " Le système de partage permet de synchroniser un dossier entre le système "
		echo -e " hôte (votre système), et le système invité (la VM) "
		echo -e " "
		echo -e " Ainsi, toute action effectuée depuis votre PC sur ce dossier sera "
		echo -e " immédiatement transmit à la machine virtuelle et inversement "
		echo -e " "
		echo -e " ${CB}Vous devez créer un dossier sur votre ordinateur qui contiendra${CE}"
		echo -e " ${CB}les éléments partagés entre celui-ci et la VM.${CE}"
		echo -e " "
		echo -e " ${CC}Allez dans Machine, puis Paramètres"
		echo -e " ${CC}Allez dans l'onglet Dossiers partagés"
		echo -e " ${CC}Sélectionner le dossier à partager"
		echo -e " ${CC}Cochez les cases ${CY}'Montage automatique'${CE} et ${CY}'Configuration permanente'${CE}"
		echo -e " "

		echo -e " \r ${CL}${CR}[FAILED]${CE} - ${DOING}"
		echo -e " "

		log "FAILED" "${DOING}"

		# Ask to continue
		read -p " Appuyez sur une touche pour réessayer.. "

		SHARING="N"
	fi
done

# Timeout
ping -c 2 localhost &>/dev/null





# ***
# * MARIADB [root/root]
# ***


clear
echo -e " "
echo -e " Système de gestion de base de données"
echo -e " Nous allons à présent installer le paquet mariadb-server"
echo -e " Il s'agit d'une version libre de MySQL "
echo -e " "

DOING="Installation de MariaDB"
inform
apt install mariadb-server -y &>> /var/log/VMInstaller-output.log
check

DOING="Configuration de MariaDB"
inform

mysql -e "UPDATE mysql.user SET Password = PASSWORD('root') WHERE User = 'root'" &>> /var/log/VMInstaller-output.log
mysql -e "DROP USER ''@'localhost'" &>> /var/log/VMInstaller-output.log
mysql -e "DROP USER ''@'$(hostname)'" &>> /var/log/VMInstaller-output.log
mysql -e "DROP DATABASE test" &>> /var/log/VMInstaller-output.log
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root'"; &>> /var/log/VMInstaller-output.log
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root'"; &>> /var/log/VMInstaller-output.log
mysql -e "FLUSH PRIVILEGES" &>> /var/log/VMInstaller-output.log

# Allow external connection
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf &>> /var/log/VMInstaller-output.log
check

DOING="Redémarrage du service MySQL"
inform
service mysql restart
check

# Timeout
ping -c 3 localhost &>/dev/null





# ***
# * WEBSERVER CHOICE
# ***

clear
echo -e " "
echo -e " Vous devez maintenant faire le choix de votre serveur web "
echo -e " Le script ne supporte que 2 options : "
echo -e " - ${CY} 1) NGINX${CE} "
echo -e " - ${CY} 2) APACHE${CE} "
echo -e " "

DOING="Choix du serveur web"
while [[ $WEBSERVER != "1" && $WEBSERVER != "2" ]]; do
	read -p " Quel serveur choisissez-vous ? [1/2]: " WEBSERVER
done

echo -e " "
log "CHOICE" "${WEBSERVER}"





# ***
# * WEBSERVER INSTALLATION
# ***

case $WEBSERVER in
	1)
		DOING="Installation de Nginx"
		inform
		apt install nginx -y &>> /var/log/VMInstaller-output.log
		check
		;;
	2)
		DOING="Installation d'Apache2"
		inform
		apt install apache2 -y &>> /var/log/VMInstaller-output.log
		check
		;;
esac

DOING="Changement des permissions"
inform
chmod 755 -R /var/www &>> /var/log/VMInstaller-output.log
adduser root vboxsf &>> /var/log/VMInstaller-output.log
adduser www-data vboxsf &>> /var/log/VMInstaller-output.log
check

# Timeout
ping -c 3 localhost &>/dev/null




# ***
# * PHP PREPARATION
# ***

DOING="Téléchargement de la clé APT SURY"
inform
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &>> /var/log/VMInstaller-output.log
check

DOING="Ajout du dépot SURY"
inform
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' &>> /var/log/VMInstaller-output.log
check

DOING="Mise à jour du système [REPOSITORY]"
inform
apt update &>> /var/log/VMInstaller-output.log
check

# Timeout
ping -c 3 localhost &>/dev/null





# ***
# * PHP INSTALLATION
# ***

case $WEBSERVER in
	1)
		DOING="Installation de ${PHPVER}-FPM"
		inform
		apt install ${PHPVER}-fpm ${PHPVER}-cli ${PHPVER}-common ${PHPVER}-mbstring ${PHPVER}-gd ${PHPVER}-intl ${PHPVER}-xml ${PHPVER}-mysql ${PHPVER}-zip -y &>> /var/log/VMInstaller-output.log
		check
		;;
	2)
		DOING="Installation de ${PHPVER}"
		inform
		apt install ${PHPVER} libapache2-mod-${PHPVER} ${PHPVER}-cli ${PHPVER}-common ${PHPVER}-mbstring ${PHPVER}-gd ${PHPVER}-intl ${PHPVER}-xml ${PHPVER}-mysql ${PHPVER}-zip -y &>> /var/log/VMInstaller-output.log
		check
		;;
esac

# Timeout
ping -c 3 localhost &>/dev/null






# ***
# * WEBSERVER CONFIGURATION
# ***

clear
echo -e " "
echo -e " Le script va maintenant configurer votre serveur web"
echo -e " "

case $WEBSERVER in
	1)
		mkdir /etc/nginx/ssl
		cd /etc/nginx/ssl/

		DOING="Génération de clé"
		inform
		openssl genrsa -out key.pem 4096 &>> /var/log/VMInstaller-output.log
		check

		DOING="Génération de certificat TLS"
		inform
		openssl req -new -x509 -sha512 -days 3650 -key key.pem -out cert.pem -subj "/C=FR/ST=France/L=Saint-Etienne/O=BTS-SIO/OU=SLAM1/CN=localhost" &>> /var/log/VMInstaller-output.log
		check

		DOING="Configuration de NGINX"
		inform

		echo -e '''
server
{
	listen 80;
	server_name "";

	## SERVER CONFIG
	autoindex on;
	root /var/www;

	index index.php index.html;

	# MAIN PAGE
	location / {
		try_files $uri $uri/ /index.php?$query_string;
	}

	# PHP support
	location ~ \.php$ {
		try_files $uri =404;
		fastcgi_pass unix:/run/php/PHPVER-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include fastcgi_params;
	}
}

server {
	listen 443 ssl http2;
	server_name "";

	## Certificates
	ssl_certificate /etc/nginx/ssl/cert.pem;
	ssl_certificate_key /etc/nginx/ssl/key.pem;

	## Protocol
	ssl_protocols TLSv1.2;

	## Diffie-Hellman
	ssl_ecdh_curve sect571r1:secp521r1:brainpoolP512r1:secp384r1;

	## Ciphers
	ssl_ciphers EECDH+AESGCM:EECDH+AES:EECDH+CHACHA20;
	ssl_prefer_server_ciphers on;

	## TLS parameters
	ssl_session_cache shared:SSL:10m;
	ssl_session_timeout 5m;
	ssl_session_tickets off;

	## SERVER CONFIG
	autoindex on;
	index index.php index.html;

	root /var/www;

	# MAIN PAGE
	location / {
		try_files $uri $uri/ /index.php?$query_string;
	}

	# PHP support
	location ~ \.php$ {
		try_files $uri =404;
		fastcgi_pass unix:/run/php/PHPVER-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include fastcgi_params;
	}
}
		''' > /etc/nginx/conf.d/website.conf

		sed -i "s/PHPVER./\/${PHPVER}-/" /etc/nginx/conf.d/website.conf &>> /var/log/VMInstaller-output.log
		check

		DOING="Désactivation du site par défaut"
		inform
		rm /etc/nginx/sites-enabled/default
		check

		DOING="Redémarrage de NGINX"
		inform
		service nginx restart
		check
		;;
	2)
		mkdir /etc/apache2/ssl
		cd /etc/apache2/ssl/

		DOING="Génération de clé"
		inform
		openssl genrsa -out key.pem 4096 &>> /var/log/VMInstaller-output.log
		check

		DOING="Génération de certificat TLS"
		inform
		openssl req -new -x509 -sha512 -days 3650 -key key.pem -out cert.pem -subj "/C=FR/ST=France/L=Saint-Etienne/O=BTS-SIO/OU=SLAM1/CN=localhost" &>> /var/log/VMInstaller-output.log
		check

		DOING="Configuration d'APACHE"
		inform

		echo '''
<VirtualHost _default_:80>
	ServerAdmin admin@localhost.fr
	DocumentRoot /var/www

	<Directory />
		Options FollowSymLinks
		AllowOverride None
	</Directory>

	LogLevel warn
	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined
</VirtualHost>

<VirtualHost _default_:443>
	ServerAdmin admin@localhost.fr
	DocumentRoot /var/www

	<Directory />
		Options FollowSymLinks
		AllowOverride None
	</Directory>

	LogLevel warn
	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined

	# SSL CONFIG
	SSLEngine on
	SSLCertificateFile /etc/apache2/ssl/cert.pem
	SSLCertificateKeyFile /etc/apache2/ssl/key.pem

	SSLOpenSSLConfCmd ECDHParameters prime256v1
	SSLOpenSSLConfCmd Curves brainpoolP512r1:secp521r1:brainpoolP384r1:secp384r1:brainpoolP256r1:prime256v1
</VirtualHost>
		''' > /etc/apache2/sites-available/website.conf

		DOING="Désactivation du site par défaut"
		inform
		a2dissite 000-default &>> /var/log/VMInstaller-output.log
		check

		DOING="Activation de la configuration"
		inform
		a2ensite website &>> /var/log/VMInstaller-output.log
		check

		DOING="Activation des modules 1/2"
		inform
		a2enmod ssl &>> /var/log/VMInstaller-output.log
		check

		DOING="Activation des modules 2/2"
		inform
		a2enmod headers  &>> /var/log/VMInstaller-output.log
		check

		DOING="Redémarrage d'APACHE"
		inform
		service apache2 restart  &>> /var/log/VMInstaller-output.log
		check
		;;
esac

echo -e " "

# Timeout
ping -c 3 localhost &>/dev/null





# ***
# * OTHER CONFIG
# ***

clear
echo -e " "
echo -e " Le script va maintenant changer quelques configurations"
echo -e " "

DOING="Autorisation de la connexion ROOT en SSH"
inform
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config &>/var/log/VMInstaller-output.log
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config &>/var/log/VMInstaller-output.log
service sshd restart
check

# Timeout
ping -c 3 localhost &>/dev/null





# ***
# * END
# ***

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
echo -e " Sur le port ${CB}80${CE} (${CB}http://${IP}/${CE})"
echo -e " Sur le port ${CB}443${CE} (${CB}https://${IP}/${CE})"
echo -e " Vous aurez une alete de sécurtié : le certificat n'est pas connu"
echo -e " Vous pouvez ignorer ce message."
echo -e " "
echo -e " Vous pouvez maintenant vous connecter à votre serveur"
echo -e " en SSH (${CB}ssh root@${IP}${CE}) ou via Putty."
echo -e " L'adresse IP locale de votre machine est: ${CB}${IP}${CE}"
echo -e " "
