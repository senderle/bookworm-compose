#!/bin/bash

mkdir -p /etc/bookworm

# ALways overwrite the admin settings.
echo "[client]" > /etc/bookworm/admin.cnf
echo "user=root" >> /etc/bookworm/admin.cnf
echo "password=$MYSQL_ROOT_PASSWORD" >> /etc/bookworm/admin.cnf
echo "host=mariadb" >> /etc/bookworm/admin.cnf
echo "clienthostname=" >> /etc/bookworm/admin.cnf

# The client password should only be generated once.
if [ ! -f "/etc/bookworm/client.cnf" ]; then
  RAND=$(openssl rand -base64 20)
  echo "[client]" > /etc/bookworm/client.cnf
  echo "user=bookworm" >> /etc/bookworm/client.cnf
  echo "password=$RAND" >> /etc/bookworm/client.cnf
  echo "host=mariadb" >> /etc/bookworm/client.cnf
  echo "clienthostname=" >> /etc/bookworm/client.cnf
fi
