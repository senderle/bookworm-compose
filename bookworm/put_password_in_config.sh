#!/bin/sh

echo "[client]" > ~/.my.cnf
echo "user=root" >> ~/.my.cnf
echo "password=$MYSQL_ROOT_PASSWORD" >> ~/.my.cnf
echo "host=mariadb" >> ~/.my.cnf
