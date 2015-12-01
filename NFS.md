<h1 id="ssh0">NFS（Network FileSystem）介绍</h1>

------

*   [SSH（Secure Shell）介绍](#ssh0)
    *   [SSH 安装](#ssh1)
    *   [SSH 配置文件常用参数](#ssh2)
    *   [SSH 允许 root 账户登录](#ssh3)
    *   [SSH 密钥登录](#ssh4)
    *   [SSH 资料](#ssh5)

------

<h2 id="ssh1">SSH 安装</h2>

- 安装：
 - CentOS：`yum install -y nfs-utils`
 - Ubuntu：`apt-get install nfs-common nfs-kernel-server`


<h2 id="ssh2">SSH 配置文件常用参数</h2>

- 配置文件介绍：`sudo vim /etc/exports`
 - 默认配置文件里面是没啥内容的，我们需要自己加上配置内容，一行表示共享一个目录。共享的目录为了方便使用，最好将权限设置为 777。
 - 加上：`/opt/mytest 192.168.0.0/55(rw,sync,all_squash,anonuid=501,anongid=501,no_subtree_check)`
 - 该配置解释：
    - /opt/mytest表示我们要共享的目录
    - 192.168.0.0/55表示内网中这个网段区间的IP是可以进行访问的，如果要任意网段都可以访问，可以用 `*` 号表示
    - (rw,sync,all_squash,anonuid=501,anongid=501)表示权限
    - rw：是可读写（ro是只读）
    - sync：同步模式，表示内存中的数据时时刻刻写入磁盘（async：非同步模式，内存中数据定期存入磁盘）
    - all_squash：表示不管使用NFS的用户是谁，其身份都会被限定为一个指定的普通用户身份。（no_root_squash：其他客户端主机的root用户对该目录有至高权限控制。root_squash：表示其他客户端主机的root用户对该目录有普通用户权限控制）
    - anonuid/anongid：要和root_squash或all_squash选项一同使用，表示指定使用NFS的用户被限定后的uid和gid，前提是本图片服务器的/etc/passwd中存在这一的uid和gid
    - no_subtree_check：不检查父目录的权限




启动：
/etc/init.d/rpcbind restart
/etc/init.d/nfs-kernel-server restart

客户端：
客户端需要挂载，在挂载之前先检查下：
showmount -e 192.168.1.25（这个IP是NFS的服务器端IP）
如果显示：/opt/mytest相关信息表示成功了。
现在挂载：mount -t nfs 192.168.1.25:/opt/mytest/ /mytest/
使用：df -h可以看到多了一个mytest分区。然后我们可以创建一个软链接，把软链接放在war包的目录下，这样上传的图片都会跑到另外一台服务器上了。








<h2 id="ssh5">SSH 资料</h2>

- http://www.jikexueyuan.com/course/861_1.html?ss=1 
 

