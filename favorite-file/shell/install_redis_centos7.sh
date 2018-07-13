#!/bin/sh

echo "安装 redis"
echo "判断常见的文件夹是否存在"

if [ ! -d "/opt/setups" ]; then
	mkdir /opt/setups
fi

echo "下载 redis"

cd /opt/setups
wget http://download.redis.io/releases/redis-4.0.6.tar.gz

if [ ! -f "/opt/setups/redis-4.0.6.tar.gz" ]; then
	echo "redis 下载失败，结束脚本"
	exit 1
fi

echo "reids 下载成功"


echo "安装开始"

yum install -y gcc-c++ tcl

cd /opt/setups

tar zxvf redis-4.0.6.tar.gz

if [ ! -d "/opt/setups/redis-4.0.6" ]; then
	echo "redis 解压失败，结束脚本"
	exit 1
fi

mv redis-4.0.6/ /usr/local/

cd /usr/local/redis-4.0.6

make

make install

cp /usr/local/redis-4.0.6/redis.conf /etc/

sed -i 's/daemonize no/daemonize yes/g' /etc/redis.conf

echo "/usr/local/bin/redis-server /etc/redis.conf" >> /etc/rc.local

echo "防火墙放行 6379 端口"
firewall-cmd --zone=public --add-port=6379/tcp --permanent
firewall-cmd --reload

rm -rf /usr/local/redis-4.0.6

echo "安装结束"
