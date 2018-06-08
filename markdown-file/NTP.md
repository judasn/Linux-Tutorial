## NTP（Network Time Protocol）介绍



## NTP 安装

- 查看是否已安装：
 - CentOS：`rpm -qa | grep ntp-*`
 - Ubuntu：`dpkg -l | grep ntp-*`

- 安装：
 - CentOS 6/7：`sudo yum install -y ntp`
 - Ubuntu：`sudo apt-get install -y ntp`

## 配置阿里云 NTP（推荐）

- 官网介绍：<https://help.aliyun.com/knowledge_detail/40583.html>
- 配置文件介绍（记得先备份）：`sudo vim /etc/ntp.conf`
- 注释掉以下默认的配置内容：

```
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst
```

- 新增配置：

``` nginx
ntp1.aliyun.com
ntp2.aliyun.com
ntp3.aliyun.com
ntp4.aliyun.com
ntp5.aliyun.com
ntp6.aliyun.com
ntp7.aliyun.com
```

- CentOS 6 
	- 重启 NTP 服务：`sudo service ntpd start`
	- 添加 NTP 自启动：`sudo chkconfig ntpd on`
- CentOS 7 
	- 重启 NTP 服务：`sudo systemctl start ntpd.service`
	- 添加 NTP 自启动：`sudo systemctl enable ntpd.service`


## NTP 服务器配置文件常用参数

- 世界上可以校对时间节点：<http://www.pool.ntp.org/zh> 
- 中国时间校对服务器节点：<http://www.pool.ntp.org/zone/cn> 
- 配置文件介绍（记得先备份）：`sudo vim /etc/ntp.conf`


![NTP 服务器配置文件常用参数](../images/NTP-a-1.jpg)

- 该配置解释：
- 标注 1 是默认内容，我们这里进行了注释。
- 标注 2 是新增内容，表示使用中国时间校对服务器节点地址。

``` nginx
server 0.cn.pool.ntp.org
server 1.cn.pool.ntp.org
server 2.cn.pool.ntp.org
server 3.cn.pool.ntp.org
```

- 我的配置如下
 ```
 driftfile  /var/lib/ntp/drift
pidfile    /var/run/ntpd.pid
logfile    /var/log/ntp.log


# Access Control Support
restrict    default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
restrict 127.0.0.1
restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap nopeer noquery
restrict 172.16.0.0 mask 255.240.0.0 nomodify notrap nopeer noquery
restrict 100.64.0.0 mask 255.192.0.0 nomodify notrap nopeer noquery
restrict 10.0.0.0 mask 255.0.0.0 nomodify notrap nopeer noquery


# local clock
server 127.127.1.0
fudge  127.127.1.0 stratum 10


restrict ntp1.aliyun.com nomodify notrap nopeer noquery
restrict ntp1.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp10.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp11.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp12.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp2.aliyun.com nomodify notrap nopeer noquery
restrict ntp2.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp3.aliyun.com nomodify notrap nopeer noquery
restrict ntp3.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp4.aliyun.com nomodify notrap nopeer noquery
restrict ntp4.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp5.aliyun.com nomodify notrap nopeer noquery
restrict ntp5.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp6.aliyun.com nomodify notrap nopeer noquery
restrict ntp6.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp7.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp8.cloud.aliyuncs.com nomodify notrap nopeer noquery
restrict ntp9.cloud.aliyuncs.com nomodify notrap nopeer noquery


server ntp1.aliyun.com iburst minpoll 4 maxpoll 10
server ntp1.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp10.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp11.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp12.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp2.aliyun.com iburst minpoll 4 maxpoll 10
server ntp2.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp3.aliyun.com iburst minpoll 4 maxpoll 10
server ntp3.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp4.aliyun.com iburst minpoll 4 maxpoll 10
server ntp4.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp5.aliyun.com iburst minpoll 4 maxpoll 10
server ntp5.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp6.aliyun.com iburst minpoll 4 maxpoll 10
server ntp6.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp7.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp8.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
server ntp9.cloud.aliyuncs.com iburst minpoll 4 maxpoll 10
```
- 启动服务：
 - `sudo service ntpd stop`（改配置后，先停再启动）
 - `sudo service ntpd start`
- 手动更新时间：
 - `sudo ntpdate ntp1.aliyun.com`

- 服务加到启动项
	- CentOS 系统：`sudo chkconfig ntpd on`
	- Ubuntu 系统
		- `sudo apt-get install -y sysv-rc-conf `
		- `sudo sysv-rc-conf ntpd on`

## NTP 资料

- <http://www.jikexueyuan.com/course/1710.html> 
- <http://www.pool.ntp.org/zh> 
- <http://blog.kissdata.com/2014/10/28/ubuntu-ntp.html> 
