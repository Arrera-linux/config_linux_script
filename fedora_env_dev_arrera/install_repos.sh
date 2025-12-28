#!/bin/bash

# Ce script sera appelé pour installer les dépôts.
# Vous pouvez ajouter vos commandes ici.

echo "Installation des dépôts..."

sudo dnf install dnf-plugins-core fedora-workstation-repositories -y -q
sudo dnf install --nogpgcheck https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y -q
sudo dnf install --nogpgcheck https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y -q

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo sh -c 'echo -e "[antigravity-rpm]\nname=Antigravity RPM Repository\nbaseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm\nenabled=1\ngpgcheck=0" > /etc/yum.repos.d/antigravity.repo'
dnf install fedora-workstation-repositories -y 
dnf config-manager setopt google-chrome.enabled=1

dnf makecache -q

echo "Terminé."