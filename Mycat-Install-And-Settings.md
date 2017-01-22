# Mycat 安装和配置

## 前提

- 局域网中有一台 IP：192.168.1.111 已经安装好了一个 MySQL 5.6

## 部署的环境

- 系统：CentOS 6.7
- 系统 IP：192.168.1.112
- JDK：jdk-8u72-linux-x64.tar.gz
- Mycat：Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz

## Mycat 安装

- 官网（页头有一个 PDF 要记得下载，这本资料写得很好）：<http://mycat.io/>
- 官网下载（官网下载地址很乱，如果哪天右边这个地址不行了，到官网加群问下吧）：<http://dl.mycat.io/>
- 项目 Github：<https://github.com/MyCATApache/Mycat-Server>
- 此时（20170122） 最新稳定版本为：**1.6**，下载下来的文件名称：**Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz**
- 安装前的准备：
	- 这台机子必须装有 JDK，并且配置好 JAVA_HOME。JDK 的安装看：<https://github.com/judasn/Linux-Tutorial/blob/master/JDK-Install.md>
- 开始安装：
	- 给 Mycat 创建专属系统用户，并设置密码：
	- `useradd mycat`
	- `passwd mycat`，进入设置密码，我习惯测试的时候密码为：123456
	- 假设 Mycat 安装包的完整路径是：**/opt/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz**
		- 解压：`cd /opt ; tar -zxvf Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz`
		- 移动解压的目录到官方建议的目录下：`mv /opt/mycat /usr/local/`
	- 设置 Mycat 的环境变量
		- `vim /etc/profile`，添加如下内容：
``` nginx
export MYCAT_HOME=/usr/local/mycat
export PATH=$PATH:$MYCAT_HOME/bin
```
	- 刷新配置：`source /etc/profile`
	- 到这里就安装好了，但是先不启动，需要先去配置相应的配置文件。
	
## Mycat 配置

- 使用 Mycat 这几个配置文件必定会改动到。这一个文件所代表的含义几句话说不了，还请你自己看下官网的文档。
	- `rule.xml`，设置分片规则。
	- `server.xml`，主要用于配置系统变量、用户管理、用户权限等。
	- `schema.xml`，用于设置 Mycat 的逻辑库、表、数据节点、dataHost 等内容，分库分表、读写分离等等都是在这里进行配置的
		- 其中特别注意的是分片节点的配置，如下，其中 db1,db2,db3 是需要我们自己在 IP 为：192.168.1.111 这台机子上人工创建这三个空白数据库。
``` nginx
	<dataNode name="dn1" dataHost="localhost1" database="db1" />
    <dataNode name="dn2" dataHost="localhost1" database="db2" />
    <dataNode name="dn3" dataHost="localhost1" database="db3" />
```
- 假设你上面的配置文件都配置好了：
	- 开放 8066 端口
		- 如果只是临时测试，可以临时关掉防火墙：`service iptables stop`
		- 不然就添加防火墙规则：
	        - 添加规则：`sudo iptables -I INPUT -p tcp -m tcp --dport 8066 -j ACCEPT`
	        - 保存规则：`sudo service iptables save`
	        - 重启 iptables：`sudo service iptables restart`
- 启动/停止/重启
	- 启动有两种，一种是后台启动，启动后看不到任何信息。一种是控制台启动，启动后进入 Mycat 的控制台界面，显示当前 Mycat 的活动信息，按 Ctrl + C 停止控制台的时候 Mycat 也跟着停止。
	- 进入 Mycat 目录：`cd /usr/local/mycat/bin`
	- 后台启动：`./mycat start`，看到日志可以这样看：`tail -f /usr/local/mycat/logs/mycat.log`
	- 控制台启动：`./mycat console`
	- 重启：`./mycat restart`
	- 停止：`./mycat stop`
- 连接 Mycat
	- 连接 Mycat 的过程跟连接普通的 MySQL 表面上是没啥区别的，使用的命令都是一个样。但是需要注意的是，很容易出问题。对连接客户端有各种意外，目前我做了总结：
	- 连接命令：`mysql -h192.168.1.112 -uroot -p -P8066`，然后输入 mycat 的 root 用户密码（在上面介绍的 server.xml 中配置的）
	- **不建议** 的连接方式：
		- SQLyog 软件，我这边是报：*find no Route:select * from `youmeek_nav`.`nav_url` limit 0, 1000*
		- Windows 系统下使用 cmd 去连接，我这边是报：*ERROR 1105 (HY000): Unknown character set: 'gbk'*
		- MySQL-Front 软件，没用过，但是别人说是有兼容性问题
	- **建议** 的连接方式：
		- Navicat for mysql 软件
		- Linux 下的 MySQL 客户端命令行
