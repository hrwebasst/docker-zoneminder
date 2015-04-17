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

if [ -v DB_HOST ]; then
	sed -i -e 's/^ZM_DB_HOST=localhost/ZM_DB_HOST='"$DB_HOST"'/' /etc/zm/zm.conf
 	sed -i -e 's/^ZM_DB_NAME=zm/ZM_DB_NAME='"$DB_NAME"'/' /etc/zm/zm.conf
 	sed -i -e 's/^ZM_DB_USER=zmuser/ZM_DB_USER='"$DB_USER"'/' /etc/zm/zm.conf
 	sed -i -e 's/^ZM_DB_PASS=zmpass/ZM_DB_PASS='"$DB_PW"'/' /etc/zm/zm.conf
        echo '[client]' > /root/.my.cnf
 	echo "password=${DB_PW}" >> /root/.my.cnf
#        if ! mysql -u $DB_USER -h $DB_HOST -e "use ${DB_NAME}"; then
#        mysql -u $DB_USER -h $DB_HOST $DB_NAME < /usr/share/zoneminder/db/zm_create.sql
#        fi

	count='select count(*) from information_schema.tables where table_type = "BASE TABLE" and table_schema = "${DB_NAME}"'
	mysql -h $DB_HOST -u $DB_USER $DB_NAME -e "$count" > /var/lib/mysql/mysql_status.txt 
	stat=`cat /var/lib/mysql/mysql_status.txt | tail -1`
	rm -rf /var/lib/mysql/mysql_status.txt
	if [ "$stat" = "0" ]; then
	mysql -u $DB_USER -h $DB_HOST $DB_NAME < /usr/share/zoneminder/db/zm_create.sql
	fi


fi

#tail -f /var/log/mysqld.log /var/log/zm.log /var/log/apache2.log
