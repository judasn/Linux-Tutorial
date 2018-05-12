#!/bin/sh


echo "安装 nginx"
echo "判断常见的文件夹是否存在"

if [ ! -d "/opt/setups" ]; then
	mkdir /opt/setups
fi

if [ ! -d "/usr/local/nginx" ]; then
	mkdir -p /usr/local/nginx
fi

if [ ! -d "/var/log/nginx" ]; then
	mkdir -p /var/log/nginx
fi

if [ ! -d "/var/temp/nginx" ]; then
	mkdir -p /var/temp/nginx
fi

if [ ! -d "/var/lock/nginx" ]; then
	mkdir -p /var/lock/nginx
fi

echo "下载 Nginx"

cd /opt/setups
wget https://nginx.org/download/nginx-1.12.2.tar.gz

if [ ! -f "/opt/setups/nginx-1.12.2.tar.gz" ]; then
	echo "Nginx 下载失败，结束脚本"
	exit 1
fi

echo "Nginx 下载成功，开始解压 Nginx"
tar -zxf nginx-1.12.2.tar.gz

if [ ! -d "/opt/setups/nginx-1.12.2" ]; then
	echo "Nginx 解压失败，结束脚本"
	exit 1
fi

echo "安装源码安装依赖"
yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel

echo "开始安装 Nginx"
cd nginx-1.12.2/

./configure --prefix=/usr/local/nginx --pid-path=/var/local/nginx/nginx.pid --lock-path=/var/lock/nginx/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-http_gzip_static_module --http-client-body-temp-path=/var/temp/nginx/client --http-proxy-temp-path=/var/temp/nginx/proxy --http-fastcgi-temp-path=/var/temp/nginx/fastcgi --http-uwsgi-temp-path=/var/temp/nginx/uwsgi --with-http_ssl_module --http-scgi-temp-path=/var/temp/nginx/scgi
make
make install

echo "防火墙放行 80 端口"
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload

echo "启动 Nginx"
/usr/local/nginx/sbin/nginx
