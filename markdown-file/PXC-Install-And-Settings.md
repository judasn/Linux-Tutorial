# Percona XtraDB Cluster（PXC）安装和配置

## PXC 主要特点

- 主要特点：强一致性（比较适合比较注重事务的场景）
	- 采用同步复制，事务在所有节点中要嘛是同时提交成功，要嘛不提交，让写入失败
	- 所以，整个集群的写入吞吐量是由最弱的节点限制，如果有一个节点变配置较差，整体质量就是差的
- 数据同步是双向的，任何节点是从，也是主，都可以进行写入
- 一般推荐至少 3 个节点

## 官网资料

- 官网介绍：<https://www.percona.com/software/mysql-database/percona-xtradb-cluster>
- 官网下载：<https://www.percona.com/downloads/Percona-XtraDB-Cluster-LATEST/>

## Docker 方式安装

- Docker 官方仓库：<https://hub.docker.com/r/percona/percona-xtradb-cluster/>
- 下载镜像：`docker pull percona/percona-xtradb-cluster`
- 创建需要挂载的目录：`mkdir -p /data/docker/pxc/node1/mysql /data/docker/pxc/node2/mysql /data/docker/pxc/node3/mysql`
- 创建需要挂载的目录：`mkdir -p /data/docker/pxc/node1/backup`
- 赋权：`chmod 777 -R /data/docker/pxc`
- 创建 Docker 网段：`docker network create --subnet=172.18.0.0/24 pxc-net`
- 启动镜像：

```
# 初次初始化比较慢，给个 2 分钟左右吧，同时这个节点也用来做全量备份
docker run -d -p 3307:3306 -v /data/docker/pxc/node1/mysql:/var/lib/mysql -v /data/docker/pxc/node1/backup:/data/backup -e MYSQL_ROOT_PASSWORD=gitnavi123456 -e CLUSTER_NAME=pxc-cluster -e XTRABACKUP_PASSWORD=gitnavi123456 --privileged --name=pxc-node-1 --net=pxc-net --ip 172.18.0.2 percona/percona-xtradb-cluster
```

- 使用 SQLyog 测试是否可以连上去，可以才能继续创建其他节点。
	- 连接地址是宿主机 IP，端口是：3307

```
docker run -d -p 3308:3306 -v /data/docker/pxc/node2/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=gitnavi123456 -e CLUSTER_NAME=pxc-cluster -e XTRABACKUP_PASSWORD=gitnavi123456 -e CLUSTER_JOIN=pxc-node-1 --privileged --name=pxc-node-2 --net=pxc-net --ip 172.18.0.3 percona/percona-xtradb-cluster

docker run -d -p 3309:3306 -v /data/docker/pxc/node3/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=gitnavi123456 -e CLUSTER_NAME=pxc-cluster -e XTRABACKUP_PASSWORD=gitnavi123456 -e CLUSTER_JOIN=pxc-node-1 --privileged --name=pxc-node-3 --net=pxc-net --ip 172.18.0.4 percona/percona-xtradb-cluster
```

- 测试集群
	- 用 SQLyog 连上 3 个节点，随便找一个节点创建库，其他几个节点会同时产生库。以此类推，创建表、插入数据，然后查看其他库情况。

## 负载均衡

- 因为 PXC 是同步是双向的，都支持读写，所以就可以考虑使用负载均衡实现流量分发
- 使用使用 HAProxy（支持 HTTP 协议、TCP/IP 协议，并且支持虚拟化，可以直接用 Docker 安装）
- 创建需要挂载的目录：`mkdir -p /data/docker/haproxy/conf`
- 赋权：`chmod 777 -R /data/docker/haproxy`
- 创建一个用于 MySQL 心跳检测的用户：
	- 连上 PXC 任意一个数据库：`CREATE USER 'haproxy'@'%' IDENTIFIED BY '';`
- 创建配置文件：`vim /data/docker/haproxy/conf/haproxy.cfg`

```
global
	#工作目录
	chroot /usr/local/etc/haproxy
	#日志文件，使用rsyslog服务中local5日志设备（/var/log/local5），等级info
	log 127.0.0.1 local5 info
	#守护进程运行
	daemon

defaults
	log 	global
	mode	http
	#日志格式
	option 	httplog
	#日志中不记录负载均衡的心跳检测记录
	option 	dontlognull
	#连接超时（毫秒）
	timeout connect 5000
	#客户端超时（毫秒）
	timeout client  50000
	#服务器超时（毫秒）
	timeout server  50000

#监控界面	
listen  admin_stats
	#监控界面的访问的IP和端口
	bind  0.0.0.0:8118
	#访问协议
	mode        http
	# URI 相对地址（访问 haproxy 监控地址：http://192.168.0.105:8118/dbs）
	stats uri   /dbs
	#统计报告格式
	stats realm     Global\ statistics
	#登陆帐户信息（登录名 admin，密码：gitnavi123456）
	stats auth  admin:gitnavi123456
#数据库负载均衡
listen  proxy-mysql
	#访问的IP和端口
	bind  0.0.0.0:3316
	#网络协议
	mode  tcp
	#负载均衡算法（轮询算法）
	#轮询算法：roundrobin
	#权重算法：static-rr
	#最少连接算法：leastconn
	#请求源IP算法：source 
	balance  roundrobin
	#日志格式
	option  tcplog
	#在 MySQL 中创建一个没有权限的 haproxy 用户，密码为空。Haproxy 使用这个账户对MySQL数据库心跳检测
	option  mysql-check user haproxy
	#这里填写的端口是 docker 容器的端口，而不是宿主机端口
	server  MySQL_1 172.18.0.2:3306 check weight 1 maxconn 2000
	server  MySQL_2 172.18.0.3:3306 check weight 1 maxconn 2000
	server  MySQL_3 172.18.0.4:3306 check weight 1 maxconn 2000
	#使用keepalive检测死链
	option  tcpka
```

- 官网 Docker 镜像：<https://hub.docker.com/_/haproxy/>
- 运行容器：`docker run -it -d -p 4001:8118 -p 4002:3316 -v /data/docker/haproxy/conf:/usr/local/etc/haproxy --name pxc-haproxy-1 --privileged --net=pxc-net haproxy -f /usr/local/etc/haproxy/haproxy.cfg`
- 浏览器访问：<http://192.168.0.105:4001/dbs>
	- 输入：`admin`
	- 输入：`gitnavi123456`
	- 可以看到 HAProxy 监控界面
- SQLyog 连接
	- IP：`192.168.0.105`
	- 端口：`4002`
	- 用户：`root`
	- 密码：`gitnavi123456`
	- 然后在上面创建对应的数据，如果所有节点都有对应的数据，则表示部署成功

## XtraBackup 热备份

- XtraBackup 备份过程不锁表
- XtraBackup 备份过程不会打断正在执行的事务
- XtraBackup 备份资料经过压缩，磁盘空间占用低

#### 全量备份

- 容器内安装 XtraBackup，并执行备份语句

```
apt-get update
apt-get install -y percona-xtrabackup-24

# 全量备份，备份到 docker 容器的 /data 目录下：
innobackupex --user=root --password=gitnavi123456 /data/backup/full/201806
```

#### 还原全量备份


- PXC 还原数据的时候，必须解散集群，删除掉只剩下一个节点，同时删除节点中的数据
    - 进入容器：`rm -rf /var/lib/mysql/*`
- 回滚备份时没有提交的事务：`innobackupex --user=root --password=gitnavi123456 --apply-back /data/backup/full/2018-04-15_05-09-07/`
- 还原数据：`innobackupex --user=root --password=gitnavi123456 --copy-back  /data/backup/full/2018-04-15_05-09-07/`


#### 增量备份（未整理）


## 资料

- <https://blog.csdn.net/leshami/article/details/72173732>
- <https://zhangge.net/5125.html>
- <https://blog.csdn.net/u012758088/article/details/78643704>
- <https://coding.imooc.com/class/219.html>
- <>
- <>
- <>
