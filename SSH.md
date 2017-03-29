# SSH（Secure Shell）介绍



## SSH 安装

- 查看是否已安装：
 - CentOS：`rpm -qa | grep openssh`
 - Ubuntu：`dpkg -l | grep openssh`

- 安装：
 - CentOS 6：`sudo yum install -y openssh-server openssh-clients`
 - Ubuntu：`sudo apt-get install -y openssh-server openssh-client`


## SSH 修改连接端口

- 配置文件介绍（记得先备份）：`sudo vim /etc/ssh/sshd_config`
- 打开这一行注释：Port 22
	- 自定义端口选择建议在万位的端口，如：10000-65535之间，假设这里我改为 60001
- 给新端口加到防火墙中：
    - 添加规则：`iptables -I INPUT -p tcp -m tcp --dport 60001 -j ACCEPT`
    - 保存规则：`service iptables save`
    - 重启 iptables：`service iptables restart`

## 设置超时

- ClientAliveInterval指定了服务器端向客户端请求消息的时间间隔, 默认是0，不发送。而ClientAliveInterval 300表示5分钟发送一次，然后客户端响应，这样就保持长连接了。
- ClientAliveCountMax，默认值3。ClientAliveCountMax表示服务器发出请求后客户端没有响应的次数达到一定值，就自动断开，正常情况下，客户端不会不响应。
- 正常我们可以设置为：
	- ClientAliveInterval 300
	- ClientAliveCountMax 3
	- 按上面的配置的话，300*3＝900秒＝15分钟，即15分钟客户端不响应时，ssh连接会自动退出。

## SSH 允许 root 账户登录

- 编辑配置文件（记得先备份）：`sudo vim /etc/ssh/sshd_config`
 - 允许 root 账号登录
    - 注释掉：`PermitRootLogin without-password`
    - 新增一行：`PermitRootLogin yes`

## SSH 不允许 root 账户登录

- 新增用户和把新增的用户改为跟 root 同等权限方法：[Bash.md]
- 编辑配置文件（记得先备份）：`sudo vim /etc/ssh/sshd_config`
    - 注释掉这一句（如果没有这一句则不管它）：`PermitRootLogin yes`

## SSH 密钥登录

- 生成秘钥和公钥文件，命令：`sudo ssh-keygen`，在交互提示中连续按三次回车，如果看得懂交互的表达，那就根据你自己需求来。默认生成密钥和公钥文件是在：/root/.ssh。
- 进入生成目录：`cd /root/.ssh`，可以看到有两个文件：id_rsa (私钥) 和 id_rsa.pub (公钥)
- 在 .ssh 目录下创建 SSH 认证文件，命令：`touch /root/.ssh/authorized_keys`
- 将公钥内容写到SSH认证文件里面，命令：`cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys`
- 修改SSH认证文件权限，命令：
   - `sudo chmod 700 /root/.ssh`
   - `sudo chmod 600 /root/.ssh/authorized_keys`
- 重启服务：`sudo service sshd restart`
- 设置 SSH 服务默认启动：`sudo sysv-rc-conf ssh on`
- 现在 SSH 客户端可以去拿着 SSH 服务器端上的 id_rsa，在客户端指定秘钥文件地址即可，这个一般由于你使用的客户端决定的，我这里推荐的是 Xshell 软件。

## 限制只有某一个IP才能远程登录服务器

- 在该配置文件：`vim /etc/hosts.deny`
	- 添加该内容：`sshd:ALL`
- 在该配置文件：`vim /etc/hosts.allow`
	- 添加该内容：`sshd:123.23.1.23`

## 限制某些用户可以 SSH 访问

- 在该配置文件：`vim /etc/ssh/sshd_config`
	- 添加该内容：`AllowUsers root userName1 userName2`

## 修改完配置都要记得重启服务

- 命令：`service sshd restart`

## 常用 SSH 连接终端

- Windows -- Xshell：<http://www.youmeek.com/ssh-terminal-emulator-recommend-xshell-and-xftp/>
- Mac -- ZOC：<http://xclient.info/s/zoc-terminal.html>

## SSH 资料

- <http://www.jikexueyuan.com/course/861_1.html?ss=1> 
- <http://www.361way.com/ssh-autologout/4679.html> 
- <http://www.osyunwei.com/archives/672.html> 
