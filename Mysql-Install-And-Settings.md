# MySQL 安装和配置


## MySQL 安装

- 假设当前用户为：root
- Mysql 安装
    - 官网：<http://www.mysql.com/>
    - 官网下载：<http://dev.mysql.com/downloads/mysql/>
    - 官网 5.5 下载：<http://dev.mysql.com/downloads/mysql/5.5.html#downloads>
    - 官网 5.6 下载：<http://dev.mysql.com/downloads/mysql/5.6.html#downloads>
    - 官网 5.7 下载：<http://dev.mysql.com/downloads/mysql/5.7.html#downloads>
    - 官网帮助中心：<http://dev.mysql.com/doc/refman/5.6/en/source-installation.html>
    - 此时（20160210） Mysql 5.5 最新版本为：**5.5.48**
    - 此时（20170130） Mysql 5.6 最新版本为：**5.6.35**
    - 此时（20160210） Mysql 5.7 最新版本为：**5.7.11**
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - Mysql 5.6 下载：`wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.35.tar.gz` （大小：31 M）
    - Mysql 5.7 下载：`wget http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.11.tar.gz` （大小：47 M）
    - 我们这次安装以 5.6 为实例
        - 进入下载目录：`cd /opt/setups`
        - 解压压缩包：`tar zxvf mysql-5.6.35.tar.gz`
        - 移到解压包：`mv /opt/setups/mysql-5.6.35 /usr/program/`
        - 安装依赖包、编译包：`yum install -y make gcc-c++ cmake bison-devel  ncurses-devel`
        - 进入解压目录：`cd /usr/program/mysql-5.6.35/`
        - 生成安装目录：`mkdir -p /usr/program/mysql/data`
        - 生成配置（使用 InnoDB）：`cmake -DCMAKE_INSTALL_PREFIX=/usr/program/mysql -DMYSQL_DATADIR=/usr/program/mysql/data -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1`
            - 更多参数说明可以查看：<http://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html>
        - 编译：`make`，这个过程比较漫长，一般都在 30 分钟左右，具体还得看机子配置，如果最后结果有 error，建议删除整个 mysql 目录后重新解压一个出来继续处理
        - 安装：`make install`
        - 配置开机启动：
            - `cp /usr/program/mysql-5.6.35/support-files/mysql.server  /etc/init.d/mysql`
            - `chmod 755 /etc/init.d/mysql`
            - `chkconfig mysql on`
        - 复制一份配置文件： `cp /usr/program/mysql-5.6.35/support-files/my-default.cnf /etc/my.cnf`
        - 删除安装的目录：`rm -rf /usr/program/mysql-5.6.35/`
        - 添加组和用户及安装目录权限
            - `groupadd mysql` #添加组
            - `useradd -g mysql mysql -s /bin/false` #创建用户mysql并加入到mysql组，不允许mysql用户直接登录系统
            - `chown -R mysql:mysql /usr/program/mysql/data` #设置MySQL数据库目录权限
        - 初始化数据库：`/usr/program/mysql/scripts/mysql_install_db --basedir=/usr/program/mysql --datadir=/usr/program/mysql/data --skip-name-resolve --user=mysql`
		- 开放防火墙端口：
			- `iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT`
			- `service iptables save`
			- `service iptables restart`
		- 禁用 selinux
			- 编辑配置文件：`vim /etc/selinux/config`
			- 把 `SELINUX=enforcing` 改为 `SELINUX=disabled`
        - 常用命令软连接，才可以在终端直接使用：mysql 和 mysqladmin 命令
            - `ln -s /usr/program/mysql/bin/mysql /usr/bin`
            - `ln -s /usr/program/mysql/bin/mysqladmin /usr/bin`
            - `ln -s /usr/program/mysql/bin/mysqldump /usr/bin`
            - `ln -s /usr/program/mysql/bin/mysqlslap /usr/bin`


## MySQL 配置

- 官网配置参数解释：<http://dev.mysql.com/doc/refman/5.6/en/mysqld-option-tables.html>
- 找一下当前系统中有多少个 my.cnf 文件：`find / -name "my.cnf"`，我查到的结果：

``` nginx
/etc/my.cnf
/usr/program/mysql/my.cnf
/usr/program/mysql/mysql-test/suite/ndb/my.cnf
/usr/program/mysql/mysql-test/suite/ndb_big/my.cnf
.............
/usr/program/mysql/mysql-test/suite/ndb_rpl/my.cnf
```


- 保留 **/etc/my.cnf** 和 **/usr/program/mysql/mysql-test/** 目录下配置文件，其他删除掉。
- 我整理的一个单机版配置说明（MySQL 5.6，适用于 1G 内存的服务器）：
	- [my.cnf](MySQL-Settings/MySQL-5.6/1G-Memory-Machine/my-for-comprehensive.cnf)

## 修改 root 账号密码

- 启动 Mysql 服务器：`service mysql start`
- 查看是否已经启动了：`ps aux | grep mysql`
- 默认安装情况下，root 的密码是空，所以为了方便我们可以设置一个密码，假设我设置为：123456
- 终端下执行：`mysql -uroot`
    - 现在进入了 mysql 命令行管理界面，输入：`SET PASSWORD = PASSWORD('123456');FLUSH PRIVILEGES;`
- 修改密码后，终端下执行：`mysql -uroot -p`
    - 根据提示，输入密码进度 mysql 命令行状态。
- 如果你在其他机子上连接该数据库机子报：**Access denied for user 'root'@'localhost' (using password: YES)**
	- 解决办法：
	- 在终端中执行：`service mysql stop`
	- 在终端中执行（前面添加的 Linux 用户 mysql 必须有存在）：`/usr/program/mysql/bin/mysqld --skip-grant-tables --user=mysql`
		- 此时 MySQL 服务会一直处于监听状态，你需要另起一个终端窗口来执行接下来的操作
		- 在终端中执行：`mysql -u root mysql`
		- 把密码改为：123456，进入 MySQL 命令后执行：`UPDATE user SET Password=PASSWORD('123456') where USER='root';FLUSH PRIVILEGES;`
		- 然后重启 MySQL 服务：`service mysql restart`

## 连接报错：Caused by: java.sql.SQLException: null,  message from server: "Host '192.168.1.133' is not allowed to connect to this MySQL server"

- 不允许除了 localhost 之外去连接，解决办法，进入 MySQL 命令行，输入下面内容：
- `GRANT ALL PRIVILEGES ON *.* TO '数据库用户名'@'%' IDENTIFIED BY '数据库用户名的密码' WITH GRANT OPTION;`

## MySQL 主从复制

### 环境说明和注意点

- 假设有两台服务器，一台做主，一台做从
    - MySQL 主信息：
        - IP：**12.168.1.113**
        - 端口：**3306**
    - MySQL 从信息：
        - IP：**12.168.1.115**
        - 端口：**3306**
- 注意点
	- 主 DB server 和从 DB server 数据库的版本一致
	- 主 DB server 和从 DB server 数据库数据一致
	- 主 DB server 开启二进制日志，主 DB server 和从 DB server 的 server-id 都必须唯一
- 优先操作：
    - **把主库的数据库复制到从库并导入**
    
### 主库机子操作

- 主库操作步骤
	- 创建一个目录：`mkdir -p /usr/program/mysql/data/mysql-bin`
	- 主 DB 开启二进制日志功能：`vim /etc/my.cnf`，
		- 添加一行：`log-bin = /usr/program/mysql/data/mysql-bin`
        - 指定同步的数据库，如果不指定则同步全部数据库，其中 ssm 是我的数据库名：`binlog-do-db=ssm`
    - 主库关掉慢查询记录，用 SQL 语句查看当前是否开启：`SHOW VARIABLES LIKE '%slow_query_log%';`，如果显示 OFF 则表示关闭，ON 表示开启
    - 重启主库 MySQL 服务
    - 进入 MySQL 命令行状态，执行 SQL 语句查询状态：`SHOW MASTER STATUS;`
        - 在显示的结果中，我们需要记录下 **File** 和 **Position** 值，等下从库配置有用。
    - 设置授权用户 slave01 使用 123456 密码登录主库，这里 @ 后的 IP 为从库机子的 IP 地址，如果从库的机子有多个，我们需要多个这个 SQL 语句。

    ``` SQL
    grant replication slave on *.* to 'slave01'@'192.168.1.135' identified by '123456';
    flush privileges;
    ```


### 从库机子操作


- 从库操作步骤
    - 从库开启慢查询记录，用 SQL 语句查看当前是否开启：`SHOW VARIABLES LIKE '%slow_query_log%';`，如果显示 OFF 则表示关闭，ON 表示开启。
	- 测试从库机子是否能连上主库机子：`mysql -h 192.168.1.105 -u slave01 -p`，必须要连上下面的操作才有意义。
		- 由于不能排除是不是系统防火墙的问题，所以建议连不上临时关掉防火墙：`service iptables stop`
		- 或是添加防火墙规则：
	        - 添加规则：`iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT`
	        - 保存规则：`service iptables save`
	        - 重启 iptables：`service iptables restart`
	- 修改配置文件：`vim /etc/my.cnf`，把 server-id 改为跟主库不一样
	- 在进入 MySQL 的命令行状态下，输入下面 SQL：

	``` SQL
	CHANGE MASTER TO
	master_host='192.168.1.113',
	master_user='slave01',
	master_password='123456',
	master_port=3306,
	master_log_file='mysql3306-bin.000006',>>>这个值复制刚刚让你记录的值
	master_log_pos=1120;>>>这个值复制刚刚让你记录的值
	```

- 执行该 SQL 语句，启动 slave 同步：`START SLAVE;`
- 执行该 SQL 语句，查看从库机子同步状态：`SHOW SLAVE STATUS;`
- 在查看结果中必须下面两个值都是 Yes 才表示配置成功：
    - `Slave_IO_Running:Yes`
        - 如果不是 Yes 也不是 No，而是 Connecting，那就表示从机连不上主库，需要你进一步排查连接问题。
    - `Slave_SQL_Running:Yes`
- 如果你的 Slave_IO_Running 是 No，一般如果你是在虚拟机上测试的话，从库的虚拟机是从主库的虚拟机上复制过来的，那一般都会这样的，因为两台的 MySQL 的 UUID 值一样。你可以检查从库下的错误日志：`cat /usr/program/mysql/data/mysql-error.log`
    - 如果里面提示 uuid 错误，你可以编辑从库的这个配置文件：`vim /usr/program/mysql/data/auto.cnf`，把配置文件中的：server-uuid 值随便改一下，保证和主库是不一样即可。





## 资料

- <http://www.cnblogs.com/xiongpq/p/3384681.html>