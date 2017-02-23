#!/bin/sh

echo "安装 nginx"

cd /opt/setups

yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel

mkdir -p /usr/local/nginx /var/log/nginx /var/temp/nginx /var/lock/nginx

tar zxvf nginx-1.10.2.tar.gz

cd nginx-1.10.2/

./configure --prefix=/usr/local/nginx --pid-path=/var/local/nginx/nginx.pid --lock-path=/var/lock/nginx/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-http_gzip_static_module --http-client-body-temp-path=/var/temp/nginx/client --http-proxy-temp-path=/var/temp/nginx/proxy --http-fastcgi-temp-path=/var/temp/nginx/fastcgi --http-uwsgi-temp-path=/var/temp/nginx/uwsgi --http-scgi-temp-path=/var/temp/nginx/scgi 

make

make install

iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT

service iptables save

service iptables restart

echo "完成安装 nginx，把端口加到防火墙中"
