# Rap 安装和配置


## 本机环境

- 系统：CentOS 6.7 64 位
- MySQL 5.6
- JDK 1.8
- Tomcat 8
- Redis 3.0.7
- Rap 0.14.1


## Rap 说明


- 官网：<https://github.com/thx/RAP>
- 在线版：<http://rap.taobao.org/>
- 官网 Wiki：<https://github.com/thx/RAP/wiki/home_cn>
- 官网部署手册：<https://github.com/thx/RAP/wiki/deploy_manual_cn>
- 用户手册：<https://github.com/thx/RAP/wiki/user_manual_cn>


## 下载

- 官网下载：<https://github.com/thx/RAP/releases>
- 当前最新版本：**0.14.1**
- 下载 war 部署包：<https://github.com/thx/RAP/releases>


## 安装 MySQL、JDK、Tomcat、Redis

- [MySQL 安装和配置](Mysql-Install-And-Settings.md)
- [JDK 安装](JDK-Install.md)
- [Tomcat 安装和配置、优化](Tomcat-Install-And-Settings.md)
- [Redis 安装和配置](Redis-Install-And-Settings.md)


## 安装 Rap

- 创建数据库，并创建权限用户

``` sql
CREATE DATABASE `rap_db` CHARACTER SET utf8;
CREATE USER 'rap'@'%' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON rap_db.* TO 'rap'@'%';
FLUSH PRIVILEGES;
```

- 把 RAP-0.14.1-SNAPSHOT.war 移动到 tomcat 的 webapp 目录下，删除其他多余的文件夹
- 解压：`unzip -x RAP-0.14.1-SNAPSHOT.war -d ROOT`
- 初始化数据库：`mysql -u rap -p rap_db < /usr/program/tomcat8/webapps/ROOT/WEB-INF/classes/database/initialize.sql`
- 修改连接数据库的配置信息：`vim /usr/program/tomcat8/webapps/ROOT/WEB-INF/classes/config.properties `
- 停掉防火墙：`service iptables stop`
- 启动 Redis：`/usr/local/bin/redis-server /etc/redis.conf`
- 启动 Tomcat：`sh /usr/program/tomcat8/bin/startup.sh ; tail -200f /usr/program/tomcat8/logs/catalina.out`
