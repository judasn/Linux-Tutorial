# WordPress 安装和配置（初稿）


## 更新系统

```
yum clean all
yum -y update
```

```
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
```

- 访问：<http://193.112.221.201>

```
mysql 5.6
sudo rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
yum install mysql mysql-server mysql-libs mysql-server

mysql 5.7
wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
yum localinstall -y mysql57-community-release-el7-8.noarch.rpm
yum install mysql-community-server

systemctl enable mysqld.service
systemctl restart  mysqld.service

默认 mysql 5.7 安装完有一个随机密码生成，位置在：/var/log/mysqld.log，里面有这样一句话：
A temporary password is generated for root@localhost: 随机密码

不用随机密码，我们可以设置密码
systemctl stop mysqld.service
/usr/sbin/mysqld --skip-grant-tables --user=mysql

在启动一个终端：mysql -u root mysql

UPDATE user SET authentication_string=PASSWORD('新密码') where USER='root';FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO '数据库用户名'@'%' IDENTIFIED BY '数据库用户名的密码' WITH GRANT OPTION;

systemctl restart  mysqld.service

试一下：mysql -h localhost -u root -p，然后输入密码，输入：select 1;

如果报：You must reset your password using ALTER USER statement before executing this statement

set password = password('新密码');

```

```
yum install php php-mysql php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc

vim /var/www/html/info.php

<?php
phpinfo();
?>
```

- <http://193.112.221.201/info.php>


rm -rf /var/www/html/info.php

https://cn.wordpress.org/

```
cd /var/www/html/
wget https://cn.wordpress.org/wordpress-4.9.4-zh_CN.zip
unzip wordpress-4.9.4-zh_CN.zip
mv wordpress-4.9.4-zh_CN.zip /opt

chown -R apache:apache /var/www/html
chmod -R 775 /var/www/html/wordpress

创建数据库：wordpress
```

- <http://193.112.221.201/wordpress/wp-admin/setup-config.php>

## 资料

- <https://blog.csdn.net/qq_35723367/article/details/79544001>
- <https://zhuanlan.zhihu.com/p/36744507>
