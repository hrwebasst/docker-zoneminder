#!/bin/bash

#Backup mysql
mysqldump -u $MYSQL_ENV_MYSQL_USER -p$MYSQL_ENV_MYSQL_PASSWORD -h $MYSQL_PORT_3306_TCP_ADDR $MYSQL_ENV_MYSQL_DATABASE > /var/backups/`date +\%Y-\%m-\%d-\%H.\%M`.sql



