# 花生壳 安装


## CentOS 下过程

- 官网：<http://hsk.oray.com/> 
- 官网下载：<http://hsk.oray.com/download/#type=linux>
- 官网安装说明：<http://service.oray.com/question/1890.html>
- 软件包下载：`wget http://download.oray.com/peanuthull/linux/phddns-2.0.6.el6.x86_64.rpm`
- 安装：`sudo yum localinstall -y phddns-2.0.6.el6.x86_64.rpm`
- 配置：
    - 安装完毕后，在终端下运行：`phddns`
    - 第一步：：Enter server address(press ENTER use phddns60.oray.net)，这是提示您输入花生壳服务器的域名，如果网站上没有更新域名的公告说明，这一步直接回车即可，会使用默认的 phddns60.oray.net 域名。
    - 第二步：Enter your Oray account:这是提示您输入在花生壳官网注册的用户名，请根据实际情况输入。
    - 第三步：Password：这是提示您输入在花生壳官网注册的用户名所对应的密码，请根据实际情况输入。
    - 第四步：Network interface(s): 这是要配置您这台服务器的网络参数，花生壳（公网版）软件会自动检查，并输出您的网络情况。eth0部分可能和上面的不一样，是您的实际网络设置。如果您有两块网卡，eth0 和eth1 ,而您希望用eth1来绑定花生壳，请在这里输入 eth1 ，然后回车。如果您只有一块网卡，或者您希望使用 eth0来绑定花生壳，在这里直接回车即可。
    - 第五步：Log to use(default /var/log/phddns.log):这是提示您输入花生壳（公网版）软件日志的保存位置，请使用绝对路径指定日志文件名。如果直接回车，会使用 /var/log/phddns.log 来保存日志。
    - 第六步： Save to configuration file (/etc/phlinux.conf)?(yes/no/other): 这是提示您输入上述配置的保存文件名。如果输入yes 或直接回车，将会使用/etc/phlinux.conf 来作为配置的保存文件名。如果输入other ，将会提示您自行指定文件名，请使用绝对路径来指定这个配置文件名。如果输入no ,不对上述配置进行保存,下次重新使用花生壳（公网版）时,需要手动指定配置文件或再次通过交互模式进行设置.
    - 第六步执行完毕后，屏幕上会依次出现：defOnStatusChanged ok，DomainsRegistered，UserType，表示安装、配置完成了
- 启动服务：`/usr/bin/phddns -c /etc/phlinux.conf -d`
- 设置开机启动：`echo "/usr/bin/phddns -c /etc/phlinux.conf -d" >> /etc/rc.local`
- 查看进程：`ps -ef | grep phddns`
- 卸载：
    - `rpm -qa|grep phddns`
    - `sudo rpm -e phddns-2.0.6-1.el6.x86_64`


## 资料

 - <http://service.oray.com/question/1890.html>
 