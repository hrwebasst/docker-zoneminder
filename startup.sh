#!/bin/bash


set -e

if [ -f /etc/configured ]; then
        echo 'already configured'
        #start external process that will wait for apache and mysql start to run one time
        /sbin/zm.sh &
else
        #configuration for zoneminder
        chown -R root:www-data /var/cache/zoneminder
        chmod -R 770 /var/cache/zoneminder

        #needed to fix problem with ubuntu ... and cron
        update-locale
        date > /etc/configured
        #start external process that will wait for apache and mysql start to run one time
        /sbin/zm.sh &
fi

if [ -v MYSQL_PORT_3306_TCP_ADDR ]; then
	sed -i -e 's/^ZM_DB_HOST=localhost/ZM_DB_HOST='"$MYSQL_PORT_3306_TCP_ADDR"'/' /etc/zm/zm.conf
 	sed -i -e 's/^ZM_DB_NAME=zm/ZM_DB_NAME='"$MYSQL_ENV_MYSQL_DATABASE"'/' /etc/zm/zm.conf
 	sed -i -e 's/^ZM_DB_USER=zmuser/ZM_DB_USER='"$MYSQL_ENV_MYSQL_USER"'/' /etc/zm/zm.conf
 	sed -i -e 's/^ZM_DB_PASS=zmpass/ZM_DB_PASS='"$MYSQL_ENV_MYSQL_PASSWORD"'/' /etc/zm/zm.conf
        echo '[client]' > /root/.my.cnf
 	echo "password=${MYSQL_ENV_MYSQL_ROOT_PASSWORD}" >> /root/.my.cnf

        fix_strict="SET @@global.sql_mode= ''"
	count='select count(*) from information_schema.tables where table_type = "BASE TABLE" and table_schema = "${MYSQL_ENV_MYSQL_DATABASE}"'
	mysql -h $MYSQL_PORT_3306_TCP_ADDR -u $MYSQL_ENV_MYSQL_USER $MYSQL_ENV_MYSQL_DATABASE -e "$count" > /mysql_status.txt 
	stat=`cat /mysql_status.txt | tail -1`
	rm -rf /var/lib/mysql/mysql_status.txt
	if [ "$stat" = "0" ]; then
        mysql -u root -h $MYSQL_PORT_3306_TCP_ADDR $MYSQL_ENV_MYSQL_DATABASE -e "$fix_strict"
	mysql -u $MYSQL_ENV_MYSQL_USER -h $MYSQL_PORT_3306_TCP_ADDR $MYSQL_ENV_MYSQL_DATABASE < /usr/share/zoneminder/db/zm_create.sql
	fi


fi

#tail -f /var/log/mysqld.log /var/log/zm.log /var/log/apache2.log
