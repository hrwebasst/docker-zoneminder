#!/bin/bash

  DEBIAN_FRONTEND=noninteractive apt-get install -y -q zoneminder
  
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

 #to clear some data before saving this layer ...a docker image
 rm -R /var/www/html
 rm /etc/apache2/sites-enabled/000-default.conf
 apt-get clean
 rm -rf /tmp/* /var/tmp/*
 rm -rf /var/lib/apt/lists/*


sleep 10s
