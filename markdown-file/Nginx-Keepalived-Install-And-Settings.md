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
- 部署环境（下文中以第几台来代表这些主机）：
	- 虚拟 IP（VIP）：192.168.1.50
	- 第一台主机：Nginx 1 + Keepalived 1 == 192.168.1.120（Master）
	- 第二台主机：Nginx 2 + Keepalived 2 == 192.168.1.121（Backup）
	- 第三台主机：Tomcat 1 == 192.168.1.122（Web 1）
	- 第四台主机：Tomcat 2 == 192.168.1.123（Web 2）
- 所有机子进行时间校准：[NTP（Network Time Protocol）介绍](NTP.md)
- 第三、第四台主机部署：
	- JDK 的安装：[JDK 安装](JDK-Install.md)
	- Tomcat 的安装：[Tomcat 安装和配置、优化](Tomcat-Install-And-Settings.md)
- 第一、二台主机部署（两台部署内容一样）：
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
	- Keepalived 设置服务和随机启动
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
		- 加入随机启动：`chkconfig keepalived on`
- 第一、二台主机配置（两台在 Keepalived 配置上稍微有不一样）：
	- 健康监测脚本（我个人放在：/opt/bash 目录下）：[nginx_check.sh](Keepalived-Settings/nginx_check.sh)
	- 健康监测脚本添加执行权限：`chmod 755 /opt/bash/nginx_check.sh`
	- 运行监测脚本，看下是否有问题：`sh /opt/bash/nginx_check.sh`，如果没有报错，则表示改脚本没有问题
		- 这个脚本很重要，如果脚本没法用，在启用 Keepalived 的时候可能会报：`Keepalived_vrrp[5684]: pid 5959 exited with status 1`
	- nginx 配置（两台一样配置）：
	
	``` nginx
	worker_processes  1;
    
    events {
        worker_connections  1024;
    }
    
    http {
        include       mime.types;
        default_type  application/octet-stream;
    
        sendfile        on;
        keepalive_timeout  65;
        
        # （重点）
        upstream tomcatCluster {
            server 192.168.1.122:8080 weight=1;
            server 192.168.1.123:8080 weight=1;
        }
        
        # （重点）
        server {
            listen       80;
            server_name  192.168.1.50;
    
            location / {
                proxy_pass   http://tomcatCluster;
                index  index.html index.htm;
            }
        }
    }
	```
	
	- Keepalived 配置文件编辑（第一、二台配置稍微不同，不同点具体看下面重点说明）
		- 编辑：`vim /usr/program/keepalived/etc/keepalived/keepalived.conf`
	
	``` nginx
	! Configuration File for keepalived
    
    # 全局配置
    global_defs {
    	# 邮箱通知配置，keepalived 在发生切换时需要发送 email 到的对象，一行一个
    	notification_email {
    		#acassen@firewall.loc
    		#failover@firewall.loc
    		#sysadmin@firewall.loc
    	}
    	# 指定发件人
    	#notification_email_from Alexandre.Cassen@firewall.loc
    	# 指定smtp服务器地址
    	#smtp_server 192.168.200.1
    	# 指定smtp连接超时时间，单位秒
    	#smtp_connect_timeout 30
    	
    	router_id LVS_DEVEL
    	vrrp_skip_check_adv_addr
    	vrrp_strict
    }
    
    # （重点）脚本监控实现
    vrrp_script check_nginx {
    	# 运行脚本
    	script "/opt/bash/nginx_check.sh"
    	# 时间间隔，2秒
    	interval 2
    	# 权重
    	weight 2
    }
    
    
    vrrp_instance VI_1 {
    	# （重点）Backup 机子这里是设置为：BACKUP
    	state MASTER
    	interface eth0
    	virtual_router_id 51
    	# （重点）Backup 机子要小于当前 Master 设置的 100，建议设置为 99
    	priority 100
    	# Master 与 Backup 负载均衡器之间同步检查的时间间隔，单位是秒
    	advert_int 1
    	authentication {
    		auth_type PASS
    		auth_pass 1111
    	}
    	
    	# （重点）配置虚拟 IP 地址，如果有多个则一行一个
    	virtual_ipaddress {
    		192.168.1.50
    	}
    	
    	# （重点）脚本监控调用
    	track_script {
    		check_nginx
    	}
    }
	```


### 启动各自服务

- 四台机子都停掉防火墙：`service iptables stop`
- 先启动两台 Tomcat：`sh /usr/program/tomcat8/bin/startup.sh ; tail -200f /usr/program/tomcat8/logs/catalina.out`
	- 检查两台 Tomcat 是否可以单独访问，最好给首页加上不同标识，好方便等下确认是否有负载
		- `http://192.168.1.122:8080`
		- `http://192.168.1.123:8080`
- 启动两台 Nginx 服务：`/usr/local/nginx/sbin/nginx`
- 启动两台 Keepalived 服务：`service keepalived start`
- 查看 Master 和 Backup 两台主机的对应日志：`tail -f /var/log/messages`


### 高可用测试

- 模拟 Keepalived 挂掉
	- 关闭 Master 主机的 Keepalived，查看 Master 和 Backup 两台主机的对应日志：`tail -f /var/log/messages`
		- 关闭服务：`service keepalived stop`
		- 如果第二台机接管了，则表示成功
	- 重新开启 Master 主机的 Keepalived，查看 Master 和 Backup 两台主机的对应日志：`tail -f /var/log/messages`
		- 重启服务：`service keepalived restart`
		- 如果第一台机重新接管了，则表示成功
- 模拟 Nginx 挂掉
	- 关闭 Master 主机的 Nginx，查看 Master 和 Backup 两台主机的对应日志：`tail -f /var/log/messages`
		- 关闭服务：`/usr/local/nginx/sbin/nginx -s stop`
		- 如果第二台机接管了，则表示成功
	- 重新开启 Master 主机的 Nginx，查看 Master 和 Backup 两台主机的对应日志：`tail -f /var/log/messages`
		- 重启 Nginx 服务：`/usr/local/nginx/sbin/nginx -s reload`
		- 重启 Keepalived 服务：`service keepalived restart`
		- 如果第一台机重新接管了，则表示成功
- 可以优化的地方，改为双主热备，监控脚本上带有自启动相关细节，后续再进行。
- 日志中常用的几句话解释：
	- `Entering to MASTER STATE`，变成 Master 状态
		- `Netlink reflector reports IP 192.168.1.50 added`，一般变为 Master 状态，都要重新加入虚拟 IP，一般叫法叫做：虚拟 IP 重新漂移到 Master 机子上
	- `Entering BACKUP STATE`，变成 Backup 状态
		- `Netlink reflector reports IP 192.168.1.50 removed`，一般变为 Backup 状态，都要移出虚拟 IP，一般叫法叫做：虚拟 IP 重新漂移到 Master 机子上
	- `VRRP_Script(check_nginx) succeeded`，监控脚本执行成功


## 资料

- <http://xutaibao.blog.51cto.com/7482722/1669123>
- <https://m.oschina.net/blog/301710>
- <http://blog.csdn.net/u010028869/article/details/50612571>
- <http://blog.csdn.net/wanglei_storage/article/details/51175418>