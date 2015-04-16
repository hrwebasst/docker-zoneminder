#!/bin/bash
### In mysqld.sh (make sure this file is chmod +x):
# `/sbin/setuser mysql` runs the given command as the user `mysql`.
# If you omit that part, the command will be run as root.
exec 2>&1
exec /sbin/setuser mysql /usr/bin/mysqld_safe >>/var/log/mysqld.log 