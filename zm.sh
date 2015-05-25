#!/bin/bash
### In zm.sh (make sure this file is chmod +x):
# `/sbin/setuser xxxx` runs the given command as the user `xxxx`.
# If you omit that part, the command will be run as root.

umount /dev/shm
mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${MEM:-2048M} tmpfs /dev/shm

sleep 10s

/etc/init.d/zoneminder start  >>/var/log/zm.log 2>&1
