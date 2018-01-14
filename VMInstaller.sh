#!/bin/bash

# VMInstaller.sh
# VERSION: V1.06
# AUTHOR: Kevin TARTIERE <ktartiere@gmail.com>

# Laucnh Directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${DIR}/sources/includes.sh"
source "${DIR}/sources/welcome.sh"

source "${DIR}/sources/packages.sh"
source "${DIR}/sources/vbox-ga.sh"
source "${DIR}/sources/mariadb.sh"
source "${DIR}/sources/webserver.sh"
source "${DIR}/sources/globalconfig.sh"

source "${DIR}/sources/informations.sh"