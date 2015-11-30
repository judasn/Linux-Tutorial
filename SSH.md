<h1 id="ubuntu0">SSH（Secure Shell）介绍</h1>

------

*   [Ubuntu 介绍](#linux0)
    *   [Ubuntu 安装和分区](#linux1)
    *   [网络配置](#linux2)
    *   [常用系统设置](#linux3)
    *   [修改源](#linux4)
    *   [安装软件基础](#linux4)
    *   [安装常用组件](#linux4)
    *   [安装常用生活软件](#linux4)
    *   [安装常用开发软件](#linux4)
    *   [Ubuntu 其他资料](#linux4)

------

------------------------------------------------------------------------------------------

<h2 id="ubuntu1">SSH 安装</h2>

- 安装：`sudo apt-get -y install openssh-server openssh-client`

<h2 id="ubuntu1">SSH 配置文件常用参数</h2>

- 配置文件介绍：`sudo vim /etc/ssh/sshd_config`
 - Port 22 #默认指定 22 端口，可以自己修改
 - Protocol 2,1 #指定了 SSH 协议版本，目前 SSH 只有两个版本 2 和 1
 - PasswordAuthentication yes #是否开启密码验证，因为 SSH 也可以设置秘钥类授权登录的方式，如果用这种方式我们可以考虑关掉密码登录的方式。
 - PermitEmptyPasswords no #是否允许密码为空，与上面参数配合用。
 
<h2 id="ubuntu1">SSH 允许 root 账户登录</h2>

- 配置文件介绍：`sudo vim /etc/ssh/sshd_config`
 - 允许 root 账号登录
    - 注释掉：`PermitRootLogin without-password`
    - 新增一行：`PermitRootLogin yes`
    
<h2 id="ubuntu1">SSH 密钥登录</h2>

- 生成秘钥和公钥文件
 - 命令：ssh-keygen，默认生成这些文件是在/root/.ssh/id_rsa，询问你是否需要口令密码，直接回车即可，没必要再用口令了。
 - 命令：cd /root/.ssh，可以看到有两个文件：id_rsa(私钥)和id_rsa.pub(公钥)
 - 在.ssh目录下创建SSH认证文件，命令：touch authorized_keys
 - 将公钥内容写到SSH认证文件里面，命令：cat id_rsa.pub >> authorized_keys
 - 修改SSH认证文件权限，命令：
   -chmod 700 /root/.ssh
   -chmod 600 authorized_keys

现在SSH客户端可以去拿着SSH服务器端上的id_rsa，然后客户端指定秘钥文件地址即可，这个一般由于你使用的客户端决定的。

命令：sudo service ssh restart
命令：sudo ifconfig，查看自己的网卡，在以太网的网卡上看到自己的IP
SSH服务默认启动
命令：sudo sysv-rc-conf ssh on


<h2 id="ubuntu1">SSH 资料</h2>

- http://www.jikexueyuan.com/course/861_1.html?ss=1 
 

