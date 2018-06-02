# WordPress 安装和配置

## 环境

- 腾讯云
- CentOS 7.4
- 1C + 1G（最低配置）
- IP：193.112.211.201
	- 推荐按此文章进行安装的时候可以把该 IP 替换成你的，方便直接复制

## 更新系统可更新软件

```
yum clean all
yum -y update
```

## 安装 Apache

```
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
```

- 访问（如果出现 Apache 欢迎页面即表示成功）：<http://193.112.211.201>


## 安装 MySQL

#### MySQL 5.6（尽可能不用旧版本）

```
sudo rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
yum install mysql mysql-server mysql-libs mysql-server
```

#### MySQL 5.7（推荐）

```
wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
yum localinstall -y mysql57-community-release-el7-8.noarch.rpm
yum install mysql-community-server

systemctl enable mysqld.service
systemctl restart  mysqld.service
```

#### MySQL 5.7 配置


- 默认 MySQL 5.7 安装完有一个随机密码生成，位置在：`/var/log/mysqld.log`，里面有这样一句话：`A temporary password is generated for root@localhost: 随机密码`
- 如果初次要连上去需要填写该密码
- 我们也可以选择重置密码：
	- `systemctl stop mysqld.service`
	- `/usr/sbin/mysqld --skip-grant-tables --user=mysql`
- 在启动一个终端：`mysql -u root mysql`
	- `UPDATE user SET authentication_string=PASSWORD('新密码') where USER='root';FLUSH PRIVILEGES;` 
	- `GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '上一步的新密码' WITH GRANT OPTION;`
	- `systemctl restart  mysqld.service`
- 试一下：`mysql -h localhost -u root -p` 然后输入密码，在 MySQL 终端输入：`select 1;`
- 如果报：`You must reset your password using ALTER USER statement before executing this statement`，解决办法：

```
set global validate_password_policy=0; #密码强度设为最低等级
set global validate_password_length=6; #密码允许最小长度为6
set password = password('新密码');
FLUSH PRIVILEGES;
```

- YUM 安装的 MySQL 默认配置文件在：`vim /etc/my.cnf`，默认有如下信息，会自己配置的可以改下。

```
# For advice on how to change settings please see                                                                                                                                         
# http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html
 
[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
 
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
 
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```


## 安装 PHP

- 安装命令：`yum install php php-mysql php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc`
- 测试 PHP 安装结果，新建文件：`vim /var/www/html/info.php`

```
<?php
phpinfo();
?>
```

- 浏览器访问（出现 PHP 环境信息表示安装成功）：<http://193.112.211.201/info.php>
- 测试后删除刚刚文件：`rm -rf /var/www/html/info.php`

## 安装 WordPress

- 寻找官网最新版本下载地址（201806 是 4.9.4）：<https://cn.wordpress.org/>

```
cd /var/www/html/

wget https://cn.wordpress.org/wordpress-4.9.4-zh_CN.zip

unzip wordpress-4.9.4-zh_CN.zip

rm -rf wordpress-4.9.4-zh_CN.zip

cd /var/www/html/wordpress && mv * ../

chmod -R 777 /var/www/html/
```

## 创建数据库

- SQL 语句：`CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`

## WordPress 在线配置引导

- 浏览器访问：<http://193.112.211.201/wp-admin/setup-config.php>

## DNS 解析

- 我是托管到 DNSPOD，重新指向到新 IP 地址即可

## 资料

- <https://blog.csdn.net/qq_35723367/article/details/79544001>
- <https://zhuanlan.zhihu.com/p/36744507>
