#!/bin/sh

echo "判断常见的文件夹是否存在"

if [ ! -d "/opt/setups" ]; then
	mkdir /opt/setups
fi

if [ ! -d "/usr/program" ]; then
	mkdir /usr/program
fi

echo "下载 JDK"

cd /opt/setups
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz

if [ ! -f "/opt/setups/jdk-8u144-linux-x64.tar.gz" ]; then
	echo "JDK 下载失败，结束脚本"
	exit 1
fi

echo "JDK 下载成功，开始解压 JDK"
tar -zxf jdk-8u144-linux-x64.tar.gz

if [ ! -d "/opt/setups/jdk1.8.0_144" ]; then
	echo "JDK 解压失败，结束脚本"
	exit 1
fi

echo "JDK 解压包移到 /usr/program/ 目录下"
mv jdk1.8.0_144/ /usr/program/

echo "JDK 写入系统变量到 zshrc"

echo 'JAVA_HOME=/usr/program/jdk1.8.0_144' >> ~/.zshrc  
echo 'JRE_HOME=$JAVA_HOME/jre' >> ~/.zshrc  
echo 'PATH=$PATH:$JAVA_HOME/bin' >> ~/.zshrc  
echo 'CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> ~/.zshrc  
echo 'export JAVA_HOME' >> ~/.zshrc  
echo 'export JRE_HOME' >> ~/.zshrc  
echo 'export PATH' >> ~/.zshrc  
echo 'export CLASSPATH' >> ~/.zshrc  

echo "JDK 设置完成，需要你手动设置：source ~/.zshrc"