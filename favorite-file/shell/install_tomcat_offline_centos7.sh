#!/bin/sh

echo "判断常见的文件夹是否存在"

if [ ! -d "/opt/setups" ]; then
	mkdir /opt/setups
fi


echo "判断 tomcat 压缩包是否存在"

if [ ! -f "/opt/setups/apache-tomcat-8.0.46.tar.gz" ]; then
	echo "JDK 压缩包不存在"
	exit 1
fi


cd /opt/setups

echo "开始解压 Tomcat"

tar -zxf apache-tomcat-8.0.46.tar.gz

if [ ! -d "/opt/setups/apache-tomcat-8.0.46" ]; then
	echo "Tomcat 解压失败，结束脚本"
	exit 1
fi

echo "Tomcat 解压包移到 /usr/local/ 目录下"
mv apache-tomcat-8.0.46/ /usr/local/
mv /usr/local/apache-tomcat-8.0.46/ /usr/local/tomcat8/

echo "防火墙放行 8080 端口"
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

echo "运行 Tomcat"
sh /usr/local/tomcat8/bin/startup.sh ; tail -200f /usr/local/tomcat8/logs/catalina.out