#!/bin/bash

# VMInstaller.sh - Webserver
# VERSION: V1.07
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

clear
echo -e " "
echo -e " ${CC}SERVEUR WEB: CHOIX${CE} "
echo -e " "
echo -e " Vous devez maintenant faire le choix de votre serveur web "
echo -e " Le script ne supporte que 2 options : "
echo -e " - ${CY} 1) NGINX${CE} "
echo -e " - ${CY} 2) APACHE${CE} "
echo -e " "
while [[ $WEBSERVER != "1" && $WEBSERVER != "2" ]]; do
	read -p " Quel serveur choisissez-vous ? [1/2]: " WEBSERVER
done
echo -e " "


case $WEBSERVER in
	1)
		source "${DIR}/sources/nginx.sh"
		;;
	2)
		source "${DIR}/sources/apache2.sh"
		;;
esac

mv /var/www/html/index.html /var/www/html/_index.html &>> /var/log/VMInstaller-output.log
cp ${DIR}/conf/phpinfo.php /var/www/html/ -rf &>> /var/log/VMInstaller-output.log