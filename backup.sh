#!/bin/bash

#Backup mysql
mysqldump -u ${DB_USER:-zmuser} -p ${DB_PW:-zmpass} -h ${DB_HOST:-localhost} ${DB_NAME:-zm} > /var/backups/alldb_backup.sql

#Backup important file ... of the configuration ...
cp  /etc/hosts  /var/backups/

