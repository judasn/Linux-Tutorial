#!/bin/sh

echo "安装开始"

yum install -y gcc-c++ tcl

cd /opt/setups

tar zxvf redis-3.2.8.tar.gz

mv redis-3.2.8/ /usr/program/

cd /usr/program/redis-3.2.8

make

make install

cp /usr/program/redis-3.2.8/redis.conf /etc/

sed -i 's/daemonize no/daemonize yes/g' /etc/redis.conf

echo "/usr/local/bin/redis-server /etc/redis.conf" >> /etc/rc.local

iptables -I INPUT -p tcp -m tcp --dport 6379 -j ACCEPT

service iptables save

service iptables restart

rm -rf /usr/program/redis-3.2.8

echo "安装结束"
