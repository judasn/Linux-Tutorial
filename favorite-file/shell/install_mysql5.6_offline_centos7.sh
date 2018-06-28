#!/bin/sh

echo "安装 mysql 开始"

echo "判断常见的文件夹是否存在"

if [ ! -d "/opt/setups" ]; then
	mkdir /opt/setups
fi

echo "判断 JDK 压缩包是否存在"

if [ ! -f "/opt/setups/mysql-5.6.35.tar.gz" ]; then
	echo "mysql 压缩包不存在"
	exit 1
fi

cd /opt/setups

tar zxvf mysql-5.6.35.tar.gz

mv /opt/setups/mysql-5.6.35 /usr/local/

yum install -y make gcc-c++ cmake bison-devel ncurses-devel autoconf 

cd /usr/local/mysql-5.6.35/

mkdir -p /usr/local/mysql/data

cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/usr/local/mysql/data -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1

make

make install

cp /usr/local/mysql-5.6.35/support-files/mysql.server /etc/init.d/mysql

chmod 755 /etc/init.d/mysql

chkconfig mysql on

cp /usr/local/mysql-5.6.35/support-files/my-default.cnf /etc/my.cnf

rm -rf /usr/local/mysql-5.6.35/

groupadd mysql

useradd -g mysql mysql -s /bin/false

chown -R mysql:mysql /usr/local/mysql/data

/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --skip-name-resolve --user=mysql

ln -s /usr/local/mysql/bin/mysql /usr/bin

ln -s /usr/local/mysql/bin/mysqladmin /usr/bin

ln -s /usr/local/mysql/bin/mysqldump /usr/bin

ln -s /usr/local/mysql/bin/mysqlslap /usr/bin

echo "防火墙放行 3306 端口"
systemctl restart firewalld.service
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload
systemctl stop firewalld.service

echo "安装 mysql 结束，现在需要手动设置防火墙和禁用 selinux."