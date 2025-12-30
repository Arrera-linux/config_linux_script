#!/bin/bash

# Ce script sera appelé pour installer les dépôts.
# Vous pouvez ajouter vos commandes ici.

echo "Installation des dépôts..."

dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-10.noarch.rpm -y

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null



echo "Terminé."