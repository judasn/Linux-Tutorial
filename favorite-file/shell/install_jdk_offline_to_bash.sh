#!/bin/sh

echo "判断常见的文件夹是否存在"

if [ ! -d "/opt/setups" ]; then
	mkdir /opt/setups
fi

echo "判断 JDK 压缩包是否存在"

if [ ! -f "/opt/setups/jdk-8u151-linux-x64.tar.gz" ]; then
	echo "JDK 压缩包不存在"
	exit 1
fi

echo "开始解压 JDK"
cd /opt/setups ; tar -zxf jdk-8u151-linux-x64.tar.gz

if [ ! -d "/opt/setups/jdk1.8.0_151" ]; then
	echo "JDK 解压失败，结束脚本"
	exit 1
fi

echo "JDK 解压包移到 /usr/local/ 目录下"
mv jdk1.8.0_151/ /usr/local/

echo "JDK 写入系统变量到 bash_profile"

cat << EOF >> ~/.bash_profile

# JDK
JAVA_HOME=/usr/local/jdk1.8.0_151
JRE_HOME=\$JAVA_HOME/jre
PATH=\$PATH:\$JAVA_HOME/bin
CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export JAVA_HOME
export JRE_HOME
export PATH
export CLASSPATH
EOF


echo "JDK 设置完成，需要你手动设置：source ~/.bash_profile"