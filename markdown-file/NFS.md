# NFS（Network FileSystem）介绍



## NFS 安装

- 查看是否已安装：
 - CentOS：`rpm -qa | grep nfs-*`
 - Ubuntu：`dpkg -l | grep nfs-*`

- 安装：
 - CentOS 5：`sudo yum install -y nfs-utils portmap`
 - CentOS 6：`sudo yum install -y nfs-utils rpcbind`
 - Ubuntu：`sudo apt-get install -y nfs-common nfs-kernel-server`

## NFS 服务器配置文件常用参数

- 配置文件介绍（记得先备份）：`sudo vim /etc/exports`
 - 默认配置文件里面是没啥内容的，我们需要自己加上配置内容，一行表示共享一个目录。为了方便使用，共享的目录最好将权限设置为 777（`chmod 777 folderName`）。
 - 假设在配置文件里面加上：`/opt/mytest 192.168.0.0/55(rw,sync,all_squash,anonuid=501,anongid=501,no_subtree_check)`
 - 该配置解释：
    - /opt/mytest 表示我们要共享的目录
    - 192.168.0.0/55 表示内网中这个网段区间的IP是可以进行访问的，如果要任意网段都可以访问，可以用 `*` 号表示
    - (rw,sync,all_squash,anonuid=501,anongid=501,no_subtree_check) 表示权限
        - rw：是可读写（ro是只读）
        - sync：同步模式，表示内存中的数据时时刻刻写入磁盘（async：非同步模式，内存中数据定期存入磁盘）
        - all_squash：表示不管使用NFS的用户是谁，其身份都会被限定为一个指定的普通用户身份。（no_root_squash：其他客户端主机的root用户对该目录有至高权限控制。root_squash：表示其他客户端主机的root用户对该目录有普通用户权限控制）
        - anonuid/anongid：要和root_squash或all_squash选项一同使用，表示指定使用NFS的用户被限定后的uid和gid，前提是本图片服务器的/etc/passwd中存在这一的uid和gid
        - no_subtree_check：不检查父目录的权限

- 启动服务：
 - `/etc/init.d/rpcbind restart`
 - `/etc/init.d/nfs-kernel-server restart`

## NFS 客户端访问

- 客户端要访问服务端的共享目录需要对其共享的目录进行挂载，在挂载之前先检查下：`showmount -e 192.168.1.25`（这个 IP 是 NFS 的服务器端 IP）
 - 如果显示：/opt/mytest 相关信息表示成功了。
- 现在开始对其进行挂载：`mount -t nfs 192.168.1.25:/opt/mytest/ /mytest/`
 - 在客户端机器上输入命令：`df -h` 可以看到多了一个 mytest 分区。然后我们可以再创建一个软链接，把软链接放在 war 包的目录下，这样上传的图片都会跑到另外一台服务器上了。软链接相关内容请自行搜索。

## NFS 资料

- <http://wiki.jikexueyuan.com/project/linux/nfs.html> 
- <http://www.jb51.net/os/RedHat/77993.html> 
- <http://www.cnblogs.com/Charles-Zhang-Blog/archive/2013/02/05/2892879.html> 
- <http://www.linuxidc.com/Linux/2013-08/89154.htm> 
- <http://www.centoscn.com/image-text/config/2015/0111/4475.html> 
