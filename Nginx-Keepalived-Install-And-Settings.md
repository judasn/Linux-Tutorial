# Nginx + Keepalived 高可用


## 说明

- 高可用 HA（High Availability），简单讲就是：我某个应用挂了，自动有另外应用起来接着扛着，致使整个服务对外来看是没有中断过的。这里的重点就是不中断，致使公司整个业务能不断进行中，把影响减到最小，赚得更多。
- 因为要不中断，所以我们就需要用到了 Keepalived。Keepalived 一般不会单独使用，基本都是跟负载均衡软件（LVS、HAProxy、Nginx）一起工作来达到集群的高可用效果。
- Keepalived 有双主、主备方案
- 常用词：
	- 心跳：Master 会主动给 Backup 发送心跳检测包以及对外的网络功能，而 Backup 负责接收 Master 的心跳检测包，随时准备接管主机。为什么叫心跳不知道，但是挺形象的，心跳同步。
	- 选举：Keepalived 配置的时候可以指定各台主机优先级，Master 挂了，各台 Backup 要选举出一个新的 Master。
- Keepalived
	- 官网：<http://www.keepalived.org/>
	- 官网下载：<http://www.keepalived.org/download.html>
	- 官网文档：<http://www.keepalived.org/documentation.html>


## 搭建

- 软件版本：
	- Nginx：**1.8.1**
	- Keepalived：**1.2.20**
	- JDK：**8u72**
	- Tomcat：**8.0.32**
- 部署环境：
	- 虚拟 IP（VIP）：192.168.1.50
	- 第一台主机：Nginx 1 + Keepalived 1 == 192.168.1.120（Master）
	- 第二台主机：Nginx 2 + Keepalived 2 == 192.168.1.121（Backup）
	- 第三台主机：Tomcat 1 == 192.168.1.122（Web 1）
	- 第四台主机：Tomcat 2 == 192.168.1.123（Web 2）
- 所有机子进行时间校准：[NTP（Network Time Protocol）介绍](NTP.md)
- 第三、第四台主机部署：
	- JDK 的安装：[JDK 安装](JDK-Install.md)
	- Tomcat 的安装：[Tomcat 安装和配置、优化](Tomcat-Install-And-Settings.md)
- 第一台主机部署（第二台主机也是按着这样完全配置）：
	- Nginx 的安装：[Nginx 安装和配置](Nginx-Install-And-Settings.md)
	- 添加虚拟 IP：
		- 复制一个网卡信息：`sudo cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0:0`
		- 编辑配置文件：`sudo vim /etc/sysconfig/network-scripts/ifcfg-eth0:0`
		- 修改内容为如下信息：
		``` nginx
		DEVICE=eth0:0    >>> 这个需要修改
        TYPE=Ethernet
        UUID=8ddbb256-caab-4ddf-8e9a-6527b4ac5a26
        ONBOOT=yes 
        NM_CONTROLLED=yes
        BOOTPROTO=none
        IPADDR=192.168.1.50    >>> 这个需要修改
        PREFIX=24  
        GATEWAY=192.168.1.1
        DNS1=101.226.4.6
        DEFROUTE=yes
        IPV4_FAILURE_FATAL=yes
        IPV6INIT=no
        NAME="System eth0:0"    >>> 这个需要修改
        HWADDR=00:0c:29:f4:17:db
        LAST_CONNECT=1460213205
		```
		- 重启网卡服务：`service network restart`
		- 如果你要绑定更多虚拟 IP，则多复制几个网卡配置出来，命名如下：ifcfg-eth0:0，ifcfg-eth0:1，ifcfg-eth0:2 ......
	- Keepalived 开始安装
		- 安装依赖：`sudo yum install -y gcc openssl-devel popt-devel`
		- 解压包：`cd /opt/setups/ ; tar zxvf keepalived-1.2.20.tar.gz`
		- 编译：`cd /opt/setups/keepalived-1.2.20 ; ./configure --prefix=/usr/program/keepalived`
		- 编译安装：`make && make install`
	- Keepalived 设置随机启动
		- 复制配置文件到启动脚本目录：`cp /usr/program/keepalived/etc/rc.d/init.d/keepalived /etc/init.d/keepalived`
		- 增加权限：`chmod +x /etc/init.d/keepalived`
		- 编辑配置文件：`vim /etc/init.d/keepalived`
		``` nginx
		把 15 行的：. /etc/sysconfig/keepalived，改为：
		. /usr/program/keepalived/etc/sysconfig/keepalived（注意：前面有一个点和空格需要注意）
		```
		- 添加环境变量：`vim /etc/profile`
		``` nginx
		# Keepalived 配置
		KEEPALIVED_HOME=/usr/program/keepalived
        PATH=$PATH:$KEEPALIVED_HOME/sbin
        export KEEPALIVED_HOME
        export PATH
		```
		- 刷新环境变量：`source /etc/profile`
		- 检测环境变量：`keepalived -v`
		- `ln -s /usr/program/keepalived/sbin/keepalived /usr/sbin/`
		- `vim /usr/program/keepalived/etc/sysconfig/keepalived`
		``` nginx
		把 14 行的：KEEPALIVED_OPTIONS="-D"，改为：
        KEEPALIVED_OPTIONS="-D -f /usr/program/keepalived/etc/keepalived/keepalived.conf"
		```
		- 启动服务：`service keepalived start`
		- 加入随机启动：`chkconfig keepalived on`
- 第一台主机配置：
	- 健康监测脚本：``
	- Keepalived 配置文件编辑：``
	- ``
	- ``
	- ``
	- ``
	- ``
	- ``
	- ``
- 第二台主机配置：


### 高可用测试

- 模拟 Keepalived 挂掉
	- 关闭 Master 主机的 Keepalived，查看 Master 和 Backup 两台主机的对应日志：`cat /var/log/messages`
	- 重新开启 Master 主机的 Keepalived，查看 Master 和 Backup 两台主机的对应日志：`cat /var/log/messages`
- 模拟 Nginx 挂掉
	- 关闭 Master 主机的 Nginx，查看 Master 和 Backup 两台主机的对应日志：`cat /var/log/messages`
	- 重新开启 Master 主机的 Nginx，查看 Master 和 Backup 两台主机的对应日志：`cat /var/log/messages`
- 完善脚本，增加 Nginx 挂掉后自动重启脚本



## 资料

- <http://xutaibao.blog.51cto.com/7482722/1669123>
- <https://m.oschina.net/blog/301710>
- <http://blog.csdn.net/u010028869/article/details/50612571>
- <>
- <>
- <>
- <>
- <>

