#!/bin/bash

# daloRADIUS - RADIUS Web Platform
# Copyright (C) 2007 - Liran Tal <liran@enginx.com> All Rights Reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#
# Authors:        Filippo Lauria <filippo.lauria@iit.cnr.it>
#


# Set default values for variables
ENABLE_COLORS=true
# Function to print an OK message in green
print_green() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print a KO message in red
print_red() {
    echo -e "${RED}$1${NC}"
}

# Function to print a warning message in yellow
print_yellow() {
    echo -e "${YELLOW}$1${NC}"
}

# Function to print an info message in blue
print_blue() {
    echo -e "${BLUE}$1${NC}"
}

print_spinner() {
    PID=$1
    
    i=1
    sp="/-\|"
    echo -n ' '
    while [ -d /proc/$PID ]; do
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.1
    done
    printf "\b"
}



key_install() {
    echo -n "[+] Gpg key... "
    apt --no-install-recommends install ca-certificates curl gnupg -y >/dev/null 2>&1 & print_spinner $!
    apt --no-install-recommends install -m 0755 -d /etc/apt/keyrings >/dev/null 2>&1 & print_spinner $!
    if [ $? -ne 0 ]; then
        print_red "KO"
        echo "[!] Failed to install Gpg key. Aborting." >&2
        exit 1
    fi
    print_green "OK"
}

# Function to install MariaDB
curl_install() {
    echo -n "[+] Download docker... "
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc >/dev/null 2>&1 & print_spinner $!
    sudo chmod a+r /etc/apt/keyrings/docker.asc >/dev/null 2>&1 & print_spinner $!
    if [ $? -ne 0 ]; then
        print_red "KO"
        echo "[!] Failed to download Docker. Aborting." >&2
        exit 1
    fi
    print_green "OK"
}


# Function to install freeRADIUS
repo_install() {
    echo -n "[+] Add repo... "
    echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null 2>&1 & print_spinner $!
    if [ $? -ne 0 ]; then
        print_red "KO"
        echo "[!] Failed to add repo. Aborting." >&2
        exit 1
    fi
    print_green "OK"
}

# Function to install daloRADIUS and required packages
update_dep() {
    echo -n "[+] Updating dependencies... "
    sudo apt update >/dev/null 2>&1 & print_spinner $!
    if [ $? -ne 0 ]; then
        print_red "KO"
        print_red "[!] Failed to update dependencies. Aborting." >&2
        exit 1
    fi
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y >/dev/null 2>&1 & print_spinner $!
    print_green "OK"
}



# Function to install daloRADIUS and required packages
down_docker() {
    echo -n "[+] Descargando docker.. "
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >/dev/null 2>&1 & print_spinner $!
    if [ $? -ne 0 ]; then
        print_red "KO"
        print_red "[!] Failed to down docker. Aborting." >&2
        exit 1
    fi
    sudo chmod +x /usr/local/bin/docker-compose >/dev/null 2>&1 & print_spinner $!
    print_green "OK"
}

# Function to install daloRADIUS and required packages

# Main function calling other functions in the correct order
main() {
    key_install
    curl_install
    repo_install
    update_dep
    down_docker

}


# Define color codes
if $ENABLE_COLORS; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    GREEN=''
    RED=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Call the main function to start the installation process
main
