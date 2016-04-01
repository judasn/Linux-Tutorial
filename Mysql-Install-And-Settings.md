# Mysql 安装和配置


## Mysql 安装

- Mysql 安装
    - 官网：<http://www.mysql.com/>
    - 官网下载：<http://dev.mysql.com/downloads/mysql/>
    - 官网 5.5 下载：<http://dev.mysql.com/downloads/mysql/5.5.html#downloads>
    - 官网 5.6 下载：<http://dev.mysql.com/downloads/mysql/5.6.html#downloads>
    - 官网 5.7 下载：<http://dev.mysql.com/downloads/mysql/5.7.html#downloads>
    - 官网帮助中心：<http://dev.mysql.com/doc/refman/5.6/en/source-installation.html>
    - 此时（20160210） Mysql 5.5 最新版本为：**5.5.48**
    - 此时（20160210） Mysql 5.6 最新版本为：**5.6.29**
    - 此时（20160210） Mysql 5.7 最新版本为：**5.7.11**
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - Mysql 5.6 下载：`wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.29.tar.gz` （大小：31 M）
    - Mysql 5.7 下载：`wget http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.11.tar.gz` （大小：47 M）
    - 我们这次安装以 5.6 为实例
        - 解压压缩包：`tar zxvf mysql-5.6.29.tar.gz`
        - 移到解压包：`mv mysql-5.6.29/ /usr/program/`
        - 安装依赖包、编译包：`yum install -y make gcc-c++ cmake bison-devel  ncurses-devel`
        - 进入解压目录：`cd /usr/program/mysql-5.6.29/`
        - 生成安装目录：`mkdir -p /usr/program/mysql/data`
        - 生成配置：`sudo cmake -DCMAKE_INSTALL_PREFIX=/usr/program/mysql -DMYSQL_DATADIR=/usr/program/mysql/data -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1`
            - 更多参数说明可以查看：<http://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html>
        - 编译：`sudo make`，这个过程比较漫长，一般都在 30 分钟左右，具体还得看机子配置，如果最后结果有 error，建议删除整个 mysql 目录后重新解压一个出来继续处理
        - 安装：`sudo make install`
        - 配置开机启动：
            - `sudo cp /usr/program/mysql-5.6.29/support-files/mysql.server  /etc/init.d/mysql`
            - `sudo chmod 755 /etc/init.d/mysql`
            - `sudo chkconfig mysql on`
        - 初始化数据库：`sudo /usr/program/mysql/scripts/mysql_install_db --basedir=/usr/program/mysql --datadir=/usr/program/mysql/data --skip-name-resolve --user=mysql`
        - 复制一份配置文件： `sudo cp /usr/program/mysql-5.6.29/support-files/my-default.cnf /etc/my.cnf`
        - 删除安装的目录：`rm -rf /usr/program/mysql-5.6.29/`
        - 添加组和用户及安装目录权限
            - `sudo groupadd mysql` #添加组
            - `sudo useradd -g mysql mysql -s /bin/false` #创建用户mysql并加入到mysql组，不允许mysql用户直接登录系统
            - `sudo chown -R mysql:mysql /usr/program/mysql/data` #设置MySQL数据库目录权限
        - 启动 Mysql 服务器：`service mysql start`
        - 查看是否已经启动了：`ps aux | grep mysql`
        - 常用命令软连接，才可以在终端直接使用：mysql 和 mysqladmin 命令
            - `sudo ln -s /usr/program/mysql/bin/mysql /usr/bin`
            - `sudo ln -s /usr/program/mysql/bin/mysqladmin /usr/bin`

## 资料

- <http://www.cnblogs.com/xiongpq/p/3384681.html>