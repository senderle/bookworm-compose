#!/bin/bash

mkdir -p /etc/bookworm

# ALways overwrite the admin settings.
echo "[client]" > /etc/bookworm/admin.cnf
echo "user=root" >> /etc/bookworm/admin.cnf
echo "password=`cat $MYSQL_ROOT_PASSWORD_FILE`" >> /etc/bookworm/admin.cnf
echo "host=mariadb" >> /etc/bookworm/admin.cnf
echo "clienthostname=" >> /etc/bookworm/admin.cnf

# The client password should only be generated once.
if [ ! -f "/etc/bookworm/client.cnf" ]; then
  echo "[client]" > /etc/bookworm/client.cnf
  echo "user=bookworm" >> /etc/bookworm/client.cnf
  echo "password=`cat $MYSQL_PASSWORD_FILE`" >> /etc/bookworm/client.cnf
  echo "host=mariadb" >> /etc/bookworm/client.cnf
  echo "clienthostname=" >> /etc/bookworm/client.cnf
fi
