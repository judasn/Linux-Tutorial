#!/bin/sh

echo "安装 mysql 开始"
echo "必须准备两个文件：mysql-5.7.21.tar.gz 和 boost_1_59_0.tar.gz"
echo "mysql 5.7 依赖 boost，官网说明：https://dev.mysql.com/doc/mysql-sourcebuild-excerpt/5.7/en/source-installation.html"
echo "boost 下载地址（79M）：http://www.boost.org/users/history/version_1_59_0.html"

if [ ! -f "/opt/setups/mysql-5.7.21.tar.gz" ]; then
	echo "缺少 mysql-5.7.21.tar.gz 文件，结束脚本"
	exit 1
fi

if [ ! -f "/opt/setups/boost_1_59_0.tar.gz" ]; then
	echo "缺少 boost_1_59_0.tar.gz 文件，结束脚本"
	exit 1
fi

cd /opt/setups

tar zxvf mysql-5.7.21.tar.gz

mv /opt/setups/mysql-5.7.21 /usr/local/

tar zxvf boost_1_59_0.tar.gz

mv /opt/setups/boost_1_59_0 /usr/local/

yum install -y make gcc-c++ cmake bison-devel ncurses-devel

cd /usr/local/mysql-5.7.21/

mkdir -p /usr/local/mysql/data

cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/usr/local/mysql/data -DWITH_BOOST=/usr/local/boost_1_59_0 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1

make

make install

cp /usr/local/mysql-5.7.21/support-files/mysql.server /etc/init.d/mysql

chmod 755 /etc/init.d/mysql

chkconfig mysql on

echo "mysql 5.7 这个文件没了，需要自己创建一个"

cp /usr/local/mysql-5.7.21/support-files/my-default.cnf /etc/my.cnf

rm -rf /usr/local/mysql-5.7.21/

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