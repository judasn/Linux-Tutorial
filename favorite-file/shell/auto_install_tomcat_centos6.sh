#!/bin/sh

echo "判断常见的文件夹是否存在"

if [ ! -d "/opt/setups" ]; then
	mkdir /opt/setups
fi

if [ ! -d "/usr/program" ]; then
	mkdir /usr/program
fi

echo "下载 Tomcat"

cd /opt/setups
wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.0.47/bin/apache-tomcat-8.0.47.tar.gz

if [ ! -f "/opt/setups/apache-tomcat-8.0.47.tar.gz" ]; then
	echo "Tomcat 下载失败，结束脚本"
	exit 1
fi

echo "Tomcat 下载成功，开始解压 Tomcat"
tar -zxf apache-tomcat-8.0.47.tar.gz

if [ ! -d "/opt/setups/apache-tomcat-8.0.47" ]; then
	echo "Tomcat 解压失败，结束脚本"
	exit 1
fi

echo "Tomcat 解压包移到 /usr/program/ 目录下"
mv apache-tomcat-8.0.47/ /usr/program/
mv /usr/program/apache-tomcat-8.0.47/ /usr/program/tomcat8/

echo "防火墙放行 8080 端口"
iptables -I INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
service iptables save
service iptables restart

echo "运行 Tomcat"
sh /usr/program/tomcat8/bin/startup.sh ; tail -200f /usr/program/tomcat8/logs/catalina.out