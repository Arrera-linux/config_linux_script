#!/bin/bash

# Ce script sera appelé pour installer les dépôts.
# Vous pouvez ajouter vos commandes ici.

echo "Installation des dépôts..."

dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm -y

echo "Terminé."