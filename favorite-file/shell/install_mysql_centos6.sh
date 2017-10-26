#!/bin/sh

echo "安装 mysql 开始"

cd /opt/setups

tar zxvf mysql-5.6.35.tar.gz

mv /opt/setups/mysql-5.6.35 /usr/program/

yum install -y make gcc-c++ cmake bison-devel ncurses-devel

cd /usr/program/mysql-5.6.35/

mkdir -p /usr/program/mysql/data

cmake -DCMAKE_INSTALL_PREFIX=/usr/program/mysql -DMYSQL_DATADIR=/usr/program/mysql/data -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1

make

make install

cp /usr/program/mysql-5.6.35/support-files/mysql.server /etc/init.d/mysql

chmod 755 /etc/init.d/mysql

chkconfig mysql on

cp /usr/program/mysql-5.6.35/support-files/my-default.cnf /etc/my.cnf

rm -rf /usr/program/mysql-5.6.35/

groupadd mysql

useradd -g mysql mysql -s /bin/false

chown -R mysql:mysql /usr/program/mysql/data

/usr/program/mysql/scripts/mysql_install_db --basedir=/usr/program/mysql --datadir=/usr/program/mysql/data --skip-name-resolve --user=mysql

ln -s /usr/program/mysql/bin/mysql /usr/bin

ln -s /usr/program/mysql/bin/mysqladmin /usr/bin

ln -s /usr/program/mysql/bin/mysqldump /usr/bin

ln -s /usr/program/mysql/bin/mysqlslap /usr/bin

iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT

service iptables save

service iptables restart

echo "安装 mysql 结束，现在需要手动设置防火墙和禁用 selinux."