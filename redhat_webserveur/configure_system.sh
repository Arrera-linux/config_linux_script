#!/bin/bash

# Ce script sera appelé pour configurer le système.
# Vous pouvez ajouter vos commandes ici.

echo "Configuration du système..."

systemctl enable --now httpd

systemctl start mysqld

MYSQL_ROOT_PWD="SuperMdp2026sql!"

# 1. Définir le mot de passe root (si pas encore fait)
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PWD}';
FLUSH PRIVILEGES;
EOF

# 2. Supprimer utilisateurs anonymes
mysql -u root -p"${MYSQL_ROOT_PWD}" <<EOF
DELETE FROM mysql.user WHERE User='';
EOF

# 3. Désactiver l'accès root à distance
mysql -u root -p"${MYSQL_ROOT_PWD}" <<EOF
DELETE FROM mysql.user WHERE User='root' AND Host!='localhost';
EOF

# 4. Supprimer la base de test
mysql -u root -p"${MYSQL_ROOT_PWD}" <<EOF
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db LIKE 'test\\_%';
EOF

mysql -u root -p"${MYSQL_ROOT_PWD}" <<EOF
FLUSH PRIVILEGES;
EOF

systemctl enable mysqld

firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

chown -R $SUDO_USER:$SUDO_USER /var/www/html
chmod 755 /var/www/html
chcon -R -t httpd_sys_content_t /var/www/html

CONFIG_FILE="/etc/httpd/conf.d/phpMyAdmin.conf"

# Vérifier si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then
  echo "❌ S'il vous plaît, lancez ce script avec sudo ou en tant que root."
  exit 1
fi

# Vérifier si le fichier existe
if [ -f "$CONFIG_FILE" ]; then
    echo "✅ Fichier de configuration trouvé."

    # 1. Faire une sauvegarde du fichier original (au cas où)
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup_$(date +%F_%T)"
    echo "📦 Sauvegarde créée."

    # 2. Utiliser sed pour remplacer 'Require local' par 'Require all granted'
    # Cela autorise l'accès depuis n'importe quelle IP
    sed -i 's/Require local/Require all granted/g' "$CONFIG_FILE"
    echo "🔓 Restriction 'Require local' levée."

    # 3. Tester la configuration Apache pour éviter les crashs
    if apachectl configtest; then
        # 4. Redémarrer Apache pour appliquer les changements
        systemctl restart httpd
        echo "🚀 Service httpd redémarré avec succès."
        echo "👉 Vous devriez maintenant pouvoir accéder à phpMyAdmin."
    else
        echo "❌ Erreur de syntaxe Apache détectée. Le redémarrage a été annulé."
        # Restauration en cas d'erreur
        cp "$CONFIG_FILE.backup_*" "$CONFIG_FILE"
        echo "🔙 Configuration originale restaurée."
    fi

else
    echo "❌ Le fichier $CONFIG_FILE n'a pas été trouvé. Avez-vous bien installé phpMyAdmin ?"
fi

echo "Terminé."