#!/bin/bash

# Ce script sera appelé pour installer les dépôts.
# Vous pouvez ajouter vos commandes ici.

echo "Installation des dépôts..."

apt-get install wget gpg -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg 
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg 
rm -f microsoft.gpg

apt install apt-transport-https -y

apt update


echo "Terminé."