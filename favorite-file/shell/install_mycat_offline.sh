#!/bin/sh

echo "判断常见的文件夹是否存在"

if [ ! -d "/opt/setups" ]; then
	mkdir /opt/setups
fi

echo "判断是否有 JDK 环境"

if [ -z $JAVA_HOME ];then  
	echo "没有 JAVA_HOME 环境变量"
	exit 1
fi

echo "判断 /opt 目录下 mycat 压缩包是否存在"

if [ ! -f "/opt/setups/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz" ]; then
	echo "mycat 压缩包是否存在不存在"
	exit 1
fi

echo "解压压缩包"

cd /opt/setups ; tar -zxf Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz

echo "把解压后目录移到 /usr/local/ 目录下"
mv /opt/setups/mycat /usr/local/

echo "写入系统变量到 zshrc"

echo 'MYCAT_HOME=/usr/local/mycat' >> ~/.zshrc  
echo 'PATH=$PATH:$MYCAT_HOME/bin' >> ~/.zshrc  
echo 'export MYCAT_HOME' >> ~/.zshrc  
echo 'export PATH' >> ~/.zshrc
echo "mycat 设置完成，需要你手动设置：source ~/.zshrc"


