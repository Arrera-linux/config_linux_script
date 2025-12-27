#!/bin/bash

# Ce script sera appelé pour configurer le système.
# Vous pouvez ajouter vos commandes ici.

echo "Configuration du système..."

systemctl enable --now httpd

systemctl start httpd
TEMP_PASS=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

mysql --connect-expired-password -u root -p"$TEMP_PASS" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'P@sswordTemporaireFort123!';
UNINSTALL COMPONENT 'file://component_validate_password';
ALTER USER 'root'@'localhost' IDENTIFIED BY '1';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
DELETE FROM mysql.user WHERE User='';
FLUSH PRIVILEGES;
EOF

systemctl enable --now mysqld

firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

chown -R $SUDO_USER:$SUDO_USER /var/www/html
chmod 755 /var/www/html
chcon -R -t httpd_sys_content_t /var/www/html 

echo "Terminé."