#!/bin/bash

  DEBIAN_FRONTEND=noninteractive apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y -q mysql-server zoneminder
  /usr/bin/mysqld_safe &
  sleep 10s

  mysqladmin -u root password mysqlpsswd
  mysqladmin -u root -pmysqlpsswd reload
  mysqladmin -u root -pmysqlpsswd create zm
  echo "grant select,insert,update,delete on zm.* to 'zmuser'@localhost identified by 'zmpass'; flush privileges; " | mysql -u root -pmysqlpsswd
  mysql -u root -pmysqlpsswd < /usr/share/zoneminder/db/zm_create.sql
  killall mysqld

 #to fix error relate to ip address of container apache2
 echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
 ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf
 
 #to fix problem with skin file
 sed -i '309d' /usr/share/zoneminder/skins/flat/js/skin.js
 sed -i '309d' /usr/share/zoneminder/skins/flat/js/skin.js
 sed -i '309d' /usr/share/zoneminder/skins/flat/js/skin.js
 sed -i '309d' /usr/share/zoneminder/skins/flat/js/skin.js
 
 #make apache use ssl
 sed -i -e '1i<VirtualHost *:443>\' /etc/zm/apache.conf
 sed -i '/443>/aSSLEngine on\nSSLCertificateFile \/etc\/apache2\/site.crt\nSSLCertificateKeyFile \/etc\/apache2\/site.key' /etc/zm/apache.conf
 sed -i -e "\$a<\/VirtualHost>" /etc/zm/apache.conf
 #allow for env vars
 sed -i -e"s/^ZM_DB_HOST=localhost/ZM_DB_HOST=\${DB_HOST:-localhost}/" /etc/zm/zm.conf
 sed -i -e"s/^ZM_DB_NAME=zm/ZM_DB_NAME=\${DB_NAME:-zm}/" /etc/zm/zm.conf
 sed -i -e"s/^ZM_DB_USER=zmuser/ZM_DB_USER=\${DB_USER:-zmuser}/" /etc/zm/zm.conf
 sed -i -e"s/^ZM_DB_PASS=zmpass/ZM_DB_PASS=\${DB_PW:-zmpass}/" /etc/zm/zm.conf
 
 #to clear some data before saving this layer ...a docker image
 rm -R /var/www/html
 rm /etc/apache2/sites-enabled/000-default.conf
 apt-get clean
 rm -rf /tmp/* /var/tmp/*
 rm -rf /var/lib/apt/lists/*


sleep 10s