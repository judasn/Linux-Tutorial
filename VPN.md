# VPN（Virtual Private Network）介绍

## VPN 介绍

VPN 分类有很多，这里主要讲 PPTPD 和 L2TPD

## PPTPD 安装

- 查看是否已安装：
 - CentOS：`rpm -qa | grep pptpd`
 - Ubuntu：`dpkg -l | grep pptpd`

- 先安装依赖包：
 - CentOS 6：`sudo yum -y install ppp`
 - Ubuntu：`sudo apt-get install -y ppp`

- 安装：
 - CentOS 6：`sudo yum -y install pptpd`
 - Ubuntu：`sudo apt-get install -y pptpd`

## PPTPD 服务配置

- 注意：PPTPD 默认端口是 1723，所以防火墙要取消对其限制，查看 1723 端口是否开启：`sudo netstat -apnl | grep 1723`
- 编辑 PPTPD 配置文件介绍（记得先备份）：`sudo vim /etc/pptpd.conf`
 - 修改配置信息：
    - `option /etc/ppp/options.pptpd`  #配置文件中有一行这样的参数，如果没有自己添加上去，正常默认是有的。同时也有可能是这样的一句话：`option /etc/ppp/pptpd-options`，具体你自己看下你的配置文件里面是什么内容。
    - `logwtmp`  #默认这个是没有被注释的，这里要进行注释
    - `localip 172.31.0.1`  #本机服务器的内网IP地址，建议你的内网IP一般不要用常见网段，默认这个被注释，取消注释
    - `remoteip 192.168.0.10-200`   #客户端的IP地址范围，默认这个被注释，取消注释
- 编辑 PPP 配置文件介绍（记得先备份）：`sudo vim /etc/ppp/options.pptpd` 或是 `sudo vim /etc/ppp/pptpd-options`
 - 在文件尾巴添加如下配置信息（默认配置文件应该有，只是被注释了）：
    - `ms-dns 8.8.8.8`           #配置DNS，如果是境外服务器最好改为google的，国内的看情况
    - `ms-dns 8.8.4.4`           #配置DNS，如果是境外服务器最好改为google的，国内的看情况
- 开启系统转发（记得先备份）：`sudo vim /etc/sysctl.conf`
 - 修改配置信息：
    - `net.ipv4.ip_forward=1` #默认是注释掉的，要取消注释，也有出现是没有注释，但是默认是这样的：`net.ipv4.ip_forward=0`
 - 刷新配置：`sudo sysctl -p`
- 设置 iptables 转发：
 - 追加 iptables 规则：`sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`
 - 设置默认启动使用该规则：`sudo vim /etc/rc.local`
    - 在配置文件中添加：`iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`
- 添加登录账号（记得先备份）：`sudo vim /etc/ppp/chap-secrets`
 - 在文件尾巴添加如下配置信息：
    - `mytest1 pptpd 123456 *` #该格式分别表示：登录名、登录协议、密码、该连接上的客户端用什么 IP（* 表示随机一个 IP）
- 重启服务：`sudo service pptpd restart`

## L2TPD 安装

- 查看是否已安装：
 - CentOS：`rpm -qa | grep xl2tpd`
 - Ubuntu：`dpkg -l | grep xl2tpd`

- 安装：
 - CentOS 6：`XXXXXXXXXXXXXXXXXXXXXXXX`
 - Ubuntu：`sudo apt-get install -y xl2tpd ppp openswan`

## L2TPD 服务配置

- 注意：L2TPD 默认端口是 1701，所以防火墙要取消对其限制，查看 1701 端口是否开启：`sudo netstat -apnl | grep 1701`
- 编辑 Openswan 配置文件介绍（记得先备份）：`sudo vim /etc/ipsec.conf`
 - left=172.31.201.255  #其中这里的IP地址改为本机的内网IP，文件中有两处，都进行修改
- 编辑 IPsec-based 配置文件介绍（记得先备份）：`sudo vim /etc/ipsec.secrets`
 - 172.31.201.255 %any:    PSK"adc123456"  #在文件最后一行补充：（格式是：本机内网IP，后面是配置密钥。密钥不配置也可以但是建议配上去）
- 编辑 L2TPD 配置文件介绍（记得先备份）：`sudo vim /etc/xl2tpd/xl2tpd.conf`
 - 修改配置信息：
    - ipsec saref = yes           
    - require chap = yes   
    - refuse pap = yes   
    - require authentication = yes  
    - ppp debug = yes  
    - length bit = yes
    - ip range = 192.168.1.10-192.168.1.200              #这是客户端连接本机的IP端限制
    - local ip = 172.31.201.255        #这是本机服务器端的内网 IP
    - pppoptfile = /etc/ppp/options.xl2tpd        #指定本机的 PPP 配置文件地址，如果你的 PPP 配置文件地址不是这里那就改下
- 编辑 PPP 配置文件介绍（记得先备份）：`sudo vim /etc/ppp/options.xl2tpd` (如果没有这个文件自己创建)
 - 在文件尾巴添加如下配置信息：
    - refuse-mschap-v2           
    - refuse-mschap           
    - ms-dns 8.8.8.8           #配置DNS，如果是境外服务器最好改为google的，国内的看情况
    - ms-dns 8.8.4.4           #配置DNS，如果是境外服务器最好改为google的，国内的看情况
    - asyncmap 0           
    - auth           
    - lock           
    - hide-password           
    - local           
    - name l2tpd           
    - proxyarp           
    - lcp-echo-interval 30           
    - lcp-echo-failure 4           
    - refuse           
    - refuse           
    - refuse   
- 在终端输入命令：sudo sh -c 'for each in /proc/sys/net/ipv4/conf/* do echo 0 > $each/accept_redirects echo 0 > $each/send_redirects done'
- 开启系统转发（记得先备份）：`sudo vim /etc/sysctl.conf`
 - 修改配置信息：
    - net.ipv4.ip_forward=1 #默认是注释掉的，要取消注释
 - 刷新配置：`sudo sysctl -p`
- 设置 iptables 转发：
 - 追加 iptables 规则：`sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`
 - 设置默认启动使用该规则：`sudo vim /etc/rc.local`
    - 在配置文件中添加：iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
- 添加登录账号（记得先备份）：`sudo vim /etc/ppp/chap-secrets`
 - 在文件尾巴添加如下配置信息：
    - mytest1 l2tpd 123456 * #该格式分别表示：登录名、登录协议、密码、该连接上的客户端用什么 IP（* 表示随机一个 IP）
- 重启服务：`sudo service l2tpd restart`


## VPN 资料

- <http://www.jikexueyuan.com/course/1692_2.html?ss=1>
- <http://gnailuy.com/linux/2011/07/04/pptp-vpn/>
- [Freeradius 服务（用于账号认证管理的工具，可以扩展到VPN的账号管理）](http://www.jikexueyuan.com/course/1692_4.html?ss=2)
