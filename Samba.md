# Samba 介绍


## Samba 安装

- 查看是否已安装：
 - CentOS：`rpm -qa | grep samba`
 - Ubuntu：`dpkg -l | grep samba`

- 安装：
 - CentOS 6：`XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`
 - Ubuntu：`sudo apt-get install -y samba samba-client`

## Samba 服务器配置文件常用参数

- 配置文件介绍（记得先备份）：`sudo vim /etc/samba/smb.conf`
 - 该配置解释：
    - 在 [globle] 区域
       - workgroup = WORKGROUP #WORKGROUP表示Windows默认的工作组名称，一般共享给windows是设置为WORKGROUP
       - security = user #ubuntu下配置文件默认没有这句,这个是自己填上去的。表示指定samba的安全等级，安全等级分别有四种：share（其他人不需要账号密码即可访问共享目录）、user（检查账号密码）、server（表示检查密码由另外一台服务器负责）、domain（指定Windows域控制服务器来验证用户的账号和密码）
    - 在新区域区域
        - 当 security = share 使用下面这段，这段自己添加的，其中myshare这个名字表示其他机子访问该分享地址时用：file://该服务机IP/myshare
        ```
        [myshare]
          comment = share all
          path = /opt/mysamba #分享的目录，其中这个目录需要chmod 777 /opt/mysamba权限
          browseable = yes
          writable = yes
          public =yes
        ```
        - 当 security = user 使用下面这段，这段自己添加的，其中 myshare2 这个名字表示其他机子访问该分享地址时用：file://该服务机IP/myshare2
        - 可以返回的账号必须是系统已经存在的账号。先给系统添加账号：`useradd user1`，再用samba的设置添加账号：`pdbedit -a user1`，会让你设立该samba账号密码。列出账号：`pdbedit -L`
        ```
        [myshare2]
          comment = share for users
          path = /opt/mysamba2  #分享的目录，其中这个目录需要chmod 777 /opt/mysamba权限
          browseable = yes
          writable = yes
          public = no
        ```
- 启动服务：
 - `sudo service samba restart`

## Samba 资料

- <http://www.lvtao.net/linux/555.html> 
- <https://www.centos.bz/2011/07/centos5-install-samba-windows-linux-fileshare/> 
- <https://wsgzao.github.io/post/samba/> 
- <http://linux.vbird.org/linux_server/0370samba.php> 
