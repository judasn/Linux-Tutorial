#!/bin/sh

echo "判断常见的文件夹是否存在"

if [ ! -d "/opt/setups" ]; then
	mkdir /opt/setups
fi

echo "判断 Maven 压缩包是否存在"

if [ ! -f "/opt/setups/apache-maven-3.5.4-bin.tar.gz" ]; then
	echo "Maven 压缩包不存在"
	exit 1
fi

echo "开始解压 Maven"
cd /opt/setups ; tar -zxf apache-maven-3.5.4-bin.tar.gz

if [ ! -d "/opt/setups/apache-maven-3.5.4" ]; then
	echo "Maven 解压失败，结束脚本"
	exit 1
fi

echo "Maven 解压包移到 /usr/local/ 目录下"
mv apache-maven-3.5.4/ /usr/local/

echo "Maven 写入系统变量到 profile"

cat << EOF >> /etc/profile

# Maven
M3_HOME=/usr/local/apache-maven-3.5.4
MAVEN_HOME=/usr/local/apache-maven-3.5.4
PATH=\$PATH:\$M3_HOME/bin
MAVEN_OPTS="-Xms256m -Xmx356m"
export M3_HOME
export MAVEN_HOME
export PATH
export MAVEN_OPTS

EOF


echo "Maven 设置完成，需要你手动设置：source /etc/profile"