# SSH（Secure Shell）介绍



## SSH 安装

- 查看是否已安装：
 - CentOS：`rpm -qa | grep openssh`
 - Ubuntu：`dpkg -l | grep openssh`

- 安装：
 - CentOS 6：`sudo yum install -y openssh-server openssh-clients`
 - Ubuntu：`sudo apt-get install -y openssh-server openssh-client`

## SSH 配置文件常用参数

- 配置文件介绍（记得先备份）：`sudo vim /etc/ssh/sshd_config`
 - Port 22 #默认指定 22 端口，可以自己修改
 - Protocol 2,1 #指定了 SSH 协议版本，目前 SSH 只有两个版本 2 和 1
 - PasswordAuthentication yes #是否开启密码验证，因为 SSH 也可以设置秘钥类授权登录的方式，如果用这种方式我们可以考虑关掉密码登录的方式。
 - PermitEmptyPasswords no #是否允许密码为空，与上面参数配合用。
 
## SSH 允许 root 账户登录

- 编辑配置文件（记得先备份）：`sudo vim /etc/ssh/sshd_config`
 - 允许 root 账号登录
    - 注释掉：`PermitRootLogin without-password`
    - 新增一行：`PermitRootLogin yes`
    
## SSH 密钥登录

- 生成秘钥和公钥文件，命令：`sudo ssh-keygen`，在交互提示中连续按三次回车，如果看得懂交互的表达，那就根据你自己需求来。默认生成密钥和公钥文件是在：/root/.ssh。
- 进入生成目录：`cd /root/.ssh`，可以看到有两个文件：id_rsa (私钥) 和 id_rsa.pub (公钥)
- 在 .ssh 目录下创建 SSH 认证文件，命令：`touch /root/.ssh/authorized_keys`
- 将公钥内容写到SSH认证文件里面，命令：`cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys`
- 修改SSH认证文件权限，命令：
   - `sudo chmod 700 /root/.ssh`
   - `sudo chmod 600 /root/.ssh/authorized_keys`
- 重启服务：`sudo service ssh restart`
- 设置 SSH 服务默认启动：`sudo sysv-rc-conf ssh on`

现在 SSH 客户端可以去拿着 SSH 服务器端上的 id_rsa，在客户端指定秘钥文件地址即可，这个一般由于你使用的客户端决定的，我这里推荐的是 Xshell 软件。

## SSH 资料

- <http://www.jikexueyuan.com/course/861_1.html?ss=1> 
