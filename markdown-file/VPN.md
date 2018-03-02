# VPN（Virtual Private Network）介绍

## VPN 介绍

VPN 分类有很多，这里主要讲 PPTPD 和 L2TPD、OpenVPN

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
 - 修改配置信息该值改为 1：
    - `net.ipv4.ip_forward=1` # 默认是注释掉的，要取消注释，也有出现是没有注释，但是默认是0：`net.ipv4.ip_forward=0`
 - 刷新配置：`sudo sysctl -p`
- 设置 iptables 转发：
 - 追加 iptables 规则：`sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`
 - 设置默认启动使用该规则：`sudo vim /etc/rc.local`
    - 在配置文件中添加：`iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`
- 添加登录账号（记得先备份）：`sudo vim /etc/ppp/chap-secrets`
 - 在文件尾巴添加如下配置信息：
    - `mytest1 pptpd 123456 *` #该格式分别表示：登录名、登录协议、密码、该连接上的客户端用什么 IP（* 表示随机一个 IP）
- 重启服务：`sudo service pptpd restart`
- Windows 连接 VPN 方法：<http://www.cnblogs.com/yuzeren48/p/4123879.html>

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

``` bash 
ipsec saref = yes           
require chap = yes   
refuse pap = yes   
require authentication = yes  
ppp debug = yes  
length bit = yes
ip range = 192.168.1.10-192.168.1.200              #这是客户端连接本机的IP端限制
local ip = 172.31.201.255        #这是本机服务器端的内网 IP
pppoptfile = /etc/ppp/options.xl2tpd        #指定本机的 PPP 配置文件地址，如果你的 PPP 配置文件地址不是这里那就改下
```

- 编辑 PPP 配置文件介绍（记得先备份）：`sudo vim /etc/ppp/options.xl2tpd` (如果没有这个文件自己创建)
 - 在文件尾巴添加如下配置信息：

``` bash
refuse-mschap-v2           
refuse-mschap           
ms-dns 8.8.8.8           #配置DNS，如果是境外服务器最好改为google的，国内的看情况
ms-dns 8.8.4.4           #配置DNS，如果是境外服务器最好改为google的，国内的看情况
asyncmap 0           
auth           
lock           
hide-password           
local           
name l2tpd           
proxyarp           
lcp-echo-interval 30           
lcp-echo-failure 4           
refuse           
refuse           
refuse   
```

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
- Windows 连接 VPN 方法：<http://www.cnblogs.com/yuzeren48/p/4123879.html>

## OpenVPN 安装

- 主要软件版本信息：
 - OpenVPN：2.3.11-1.el6
 - EasyRsa：2.2.2-1.el6
- 检查系统环境是否支持：`cat /dev/net/tun`，如果出现：`cat: /dev/net/tun: File descriptor in bad state`，则表示支持。如果现实的是：`cat: /dev/net/tun: No such device `，则不支持
- 需要先安装 EPEL 源，具体可以看这篇文章：[CentOS 源设置](https://github.com/judasn/Linux-Tutorial/blob/master/centos-settings/CentOS-Extra-Packages.md)
- 安装：
 - 安装依赖包：
    - `yum install -y gcc make rpm-build autoconf.noarch openssl openssl-devel lzo lzo-devel pam pam-devel automake pkgconfig`
 - 安装 OpenVPN：
    - `yum install -y openvpn easy-rsa`

## OpenVPN 服务配置

### 禁用 selinux

- 编辑配置文件：`vim /etc/selinux/config`
- 把 `SELINUX=enforcing` 改为 `SELINUX=disabled`

### 生成OpenVPN需要的服务器、客户端证书

- 使用 easy-rsa 的脚本产生证书

- 修改vars文件
 - `cd /usr/share/easy-rsa/2.0`，后面关于证书的操作都是在这个目录下
 - `vim vars`
    - 需要修改的内容主要有下面这些信息（在文件 64 行）：注册信息，比如公司地址、公司名称、部门名称等。
     - `export KEY_COUNTRY="CN"`
     - `export KEY_PROVINCE="GuangDong"`
     - `export KEY_CITY="GuangZhou"`
     - `export KEY_ORG="YouMeekOrganization"`
     - `export KEY_EMAIL="admin@youmeek.com"`
     - `export KEY_OU="YouMeekOrganizationalUnit"`

- 初始化环境变量
 - `source vars`
 
- 清除keys目录下所有与证书相关的文件，下面步骤生成的证书和密钥都在 /usr/share/easy-rsa/2.0/keys 目录里
 - `./clean-all`
 
- 生成根证书 ca.crt 和根密钥 ca.key（会有好几个提示，你都不需要输入什么内容，一路按回车即可，除非你懂原理）
 - `./build-ca`
 
- 为服务端生成证书和密钥（也会有好几个提示，你都不需要输入什么内容，一路按回车即可，直到提示需要输入y/n时，输入y再按回车继续走）
 - 其中：server，这个名字别改，照着来，等下那些就可以直接使用。
 - `./build-key-server server`
 
- 每一个登陆的VPN客户端需要有一个证书，每个证书在同一时刻只能供一个客户端连接，下面语句是建立2份demo，你可以只输入第一个即可。
- 为客户端生成证书和密钥（一路按回车，直到提示需要输入y/n时，输入y再按回车，一共两次）
 - 其中：client1，这个名字别改，照着来，等下那些就可以直接使用，除非你会。
 - `./build-key client1`
 - `./build-key client2`
 
- 创建迪菲·赫尔曼密钥，会在 keys 目录里面生成dh2048.pem文件（生成过程比较慢，在此期间不要去中断它，我这边花的时间是：2分钟）
 - `./build-dh`
 
### 设置OpenVPN服务端配置文件

- 复制一份服务器端配置文件模板server.conf到/etc/openvpn/
- 其中，我这边现在的版本是：2.3.11，所以我这边是填这个，你的不一定就跟我一样，所以你先到 doc 目录下，看下你具体是哪个版本，改下下面这句命令即可。
 - `cp /usr/share/doc/openvpn-2.3.11/sample/sample-config-files/server.conf /etc/openvpn/`

- 编辑 server.conf，把下面的内容替换到已有的文件中，记得去掉后面的注释，我这样写只是为了方便解释对应的内容含义：
    - `vim /etc/openvpn/server.conf`

``` bash
port 1194 # 端口一般我们不改
proto udp # 默认使用udp，如果使用HTTP Proxy，改成tcp，必须使用tcp协议，还需要注意的是：需要与客户端配置保持一致，等下客户端配置会说道
dev tun
ca /usr/share/easy-rsa/2.0/keys/ca.crt # 这一行默认值为：ca ca.crt
cert /usr/share/easy-rsa/2.0/keys/server.crt # 这一行默认值为：cert server.crt
key /usr/share/easy-rsa/2.0/keys/server.key  # 这一行默认值为：key server.key
dh /usr/share/easy-rsa/2.0/keys/dh2048.pem  # 这一行默认值为：dh dh2048.pem
server 10.192.170.0 255.255.255.0  # 给客户的分配的局域网IP段，默认虚拟局域网网段，不要和实际的局域网冲突即可，这个10.192.170.0跟下面还有一个地方配置也有关联，需要注意
ifconfig-pool-persist ipp.txt # 启用了ipp.txt作为客户端和virtual IP的对应表，以方便客户端重新连接可以获得同样的IP；
keepalive 10 120
comp-lzo
persist-key
persist-tun
status openvpn-status.log  # OpenVPN的状态日志，默认为/etc/openvpn/openvpn-status.log
log openvpn.log # OpenVPN的运行日志，默认为/etc/openvpn/openvpn.log 
log-append openvpn.log
verb 3

push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DOMAIN-SEARCH ap-northeast-1.compute.internal"
push "dhcp-option DOMAIN-SEARCH ec2.drawbrid.ge"
```



### 配置内核和防火墙，开启nat功能，启动服务

- 开启路由转发功能
    - `sed -i '/net.ipv4.ip_forward/s/0/1/' /etc/sysctl.conf`
    - 刷新配置：`sudo sysctl -p`

辨别你的 VPS 是属于那种虚拟方式，主流有：Xen KVM OpenVZ，方法：
- `sudo yum install -y virt-what`，virt-what是一个判断当前环境所使用的虚拟技术的脚本，常见的虚拟技术基本上都能正常识别出来
    - `sudo virt-what`，我这边 Vultr 输出的结果是：KVM

- 配置防火墙
    - `iptables -A INPUT -p udp --dport 1194 -j ACCEPT`
    - `iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT`

- 设置IP转发，若你的 VPS 虚拟方案是：Xen 或 KVM的请输入：（eth0要根据具体的网卡标示来，可以通过ifconfig查看），其中：10.192.170.0/16 表示客户端连接上去后从这个区间中分配给客户端的IP地址
    - `iptables -t nat -A POSTROUTING -s 10.192.170.0/16 -o eth0 -j MASQUERADE`

- 若你的 VPS 虚拟方案是：OpenVZ 的请输入：（45.32.90.22是你VPS的IP）
    - `iptables -t nat -A POSTROUTING -s 10.192.170.0/16 -j SNAT --to-source 45.32.90.22`
- 保存防火墙配置
    - `service iptables save`
    - `service iptables restart`

 
### 启动openvpn并设置为开机启动

- `service openvpn start`
- `chkconfig openvpn on`


### OpenVPN客户端配置

下载 Windows 客户端：
https://openvpn.net/index.php/download/community-downloads.html

Mac 用户下载这个 tunnelblick（该地址需要开穿越）：
http://code.google.com/p/tunnelblick/

- 从服务器上下载证书文件到本地：
    - `/usr/share/easy-rsa/2.0/keys/ca.crt`
    - `/usr/share/easy-rsa/2.0/keys/client1.crt`
    - `/usr/share/easy-rsa/2.0/keys/client1.key`

到你本地的电脑上（window电脑在安装好OpenVPN软件后可以把如上证书拷贝到如下文件夹里：C:\Program Files\OpenVPN\config ）

从服务器找到这个文件：/usr/share/doc/openvpn-2.3.11/sample/sample-windows/sample.ovpn，下载到本地电脑这个目录下：C:\Program Files\OpenVPN\config
然后把这个文件改名字为：client1.ovpn 文件内如如下, 其他不用改只要把SERVER-IP 改成你服务器的 IP  

``` bash
client        #这个client不是自定义名称 不能更改
dev tun       #要与前面server.conf中的配置一致。
proto udp              #要与前面server.conf中的配置一致。
remote 45.32.90.22 1194    #将45.32.90.22替换为你VPS的IP，端口也与前面的server.conf中配置一致。
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt              #具体名称以刚下载的为准
cert client1.crt              #具体名称以刚下载的为准
key client1.key              #具体名称以刚下载的为准
comp-lzo
verb 3
```

- 打开 OpenVPN 客户端，连接试试看。

## VPN 资料

- <http://www.jikexueyuan.com/course/1692_2.html?ss=1>
- <http://gnailuy.com/linux/2011/07/04/pptp-vpn/>
- <http://www.centoscn.com/CentosServer/test/2014/1120/4153.html>
- <https://linux.cn/article-3706-1.html>
- <http://www.bkjia.com/yjs/1041400.html>
- <http://blog.liujason.com/1663.html>
- <http://shit.name/openvpn-on-centos/>
- <http://kunsland.github.io/blogs/2015/03/22/vps-openvpn/>
- <http://neolee.com/web/centos-openvz-vps-configuration-openvpn/>
- [Freeradius 服务（用于账号认证管理的工具，可以扩展到VPN的账号管理）](http://www.jikexueyuan.com/course/1692_4.html?ss=2)
