# Samba 介绍


## Samba 安装

- 查看是否已安装：
 - CentOS：`rpm -qa | grep samba`
 - Ubuntu：`dpkg -l | grep samba`

- 安装：
 - CentOS 6：`yum install samba samba-client samba-common`
 - Ubuntu：`sudo apt-get install -y samba samba-client`

## Samba 服务器配置文件常用参数

- 配置文件介绍（记得先备份 `cp /etc/samba/smb.conf /etc/samba/smb.conf.backup`）：`sudo vim /etc/samba/smb.conf`
 - 该配置解释：
    - 在 [global] 区域
       - workgroup = WORKGROUP #WORKGROUP表示Windows默认的工作组名称，一般共享给windows是设置为WORKGROUP，此字段不重要，无需与 Windows 的域保持一致
       - security = user #ubuntu下配置文件默认没有这句,这个是自己填上去的。表示指定samba的安全等级，安全等级分别有四种：share（其他人不需要账号密码即可访问共享目录）、user（检查账号密码）、server（表示检查密码由另外一台服务器负责）、domain（指定Windows域控制服务器来验证用户的账号和密码）
       注: samba 4 不再支持 security = share (查看版本 smbd --version)
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
          # (不一定要 777 权限，只要登录 samba 的用户是这个目录的用户即可，那么在 Windows 中的文件创建和写入都等同于 linux 的等价账户)
          browseable = yes
          writable = yes
          public = no
          read only = no
          guest ok = no # samba 4 拥有的
          create mask = 0646
          force create mode = 0646
          directory mask = 0747
          force directory mode = 0747
        ```

 - 一份成功的 samba 4 配置
 ```
 [global]
        workgroup = WORKGROUP
        passdb backend = tdbsam
        printing = cups
        printcap name = cups
        printcap cache time = 750
        cups options = raw
        map to guest = Bad User
        include = /etc/samba/dhcp.conf
        logon path = \\%L\profiles\.msprofile
        logon home = \\%L\%U\.9xprofile
        logon drive = P:
        max connections = 0
        deadtime = 0
        max log size = 500
[share1]
        path = /home/<your path>
        browsable =yes
        writable = yes
        read only = no
        guest ok=no     
        create mask = 0646
        force create mode = 0646
        directory mask = 0747
        force directory mode = 0747
 ```
- 启动服务（CentOS 6）：
 - `sudo service samba restart`
 - `service smb restart` # 启动 samba
- 启动服务（CentOS 7）：
 - `systemctl start smb.service`    # 启动 samba
 - `systemctl enable smb.service`    # 激活
 - `systemctl status smb.service`    # 查询 samba 状态（启动 samba 前后可以用查询验证）
- 启动服务（Ubuntu 16.04.3 -- ljoaquin提供）：
 - `sudo service smbd restart`


## Samba 登录及验证

- 在 Windows 连接 Samba 之前，可在本地（linux）使用命令验证

  `smbclient –L //localhost/<your samba share label>  -U <your samba user>`
  接下来输入的 password 来自于 `pdbedit -a user1` 命令为该用户设置的密码，不一定是 linux 用户密码
  <your samba share label> 来自 `/etc/samba/smb.conf` 文件中的标签，如上面的例子中有 `//localhost/myshare2`

  提示如下面，表示 Samba 服务启动成功
  ```
  Domain=[xxx1] OS=[Windows 6.1] Server=[Samba 4.6.2]

        Sharename       Type      Comment
        ---------       ----      -------
        share1          Disk
        IPC$            IPC       IPC Service (Samba 4.6.2)
  Domain=[xxx1] OS=[Windows 6.1] Server=[Samba 4.6.2]

        Server               Comment
        ---------            -------

        Workgroup            Master
        ---------            -------
        xxx2                xxx1
        WORKGROUP            xxx3

  ```
- Windows 登录
  打开资源管理器 -> 映射网络驱动器 -> 文件夹 填写上述 `smbclient –L` 命令后面加的路径 -> 
  弹出用户名密码对话框 -> 登录成功


## Samba 登录失败 

- linux 防火墙

- Windows 用户密码都正确，错误提示‘未知的用户名和密码。’
  regedit 打开注册表，删除键值 HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa 中的 LMCompatibilityLevel，无需重启计算机

## Samba 资料

- <http://www.lvtao.net/linux/555.html> 
- <https://www.centos.bz/2011/07/centos5-install-samba-windows-linux-fileshare/> 
- <https://wsgzao.github.io/post/samba/> 
- <http://linux.vbird.org/linux_server/0370samba.php> 
- <https://www.liberiangeek.net/2014/07/create-configure-samba-shares-centos-7/>
- <https://superuser.com/questions/1125438/windows-10-password-error-with-samba-share>
- <https://github.com/SeanXP/README.md/tree/master/samba>
- <http://www.apelearn.com/bbs/study/23.htm>
