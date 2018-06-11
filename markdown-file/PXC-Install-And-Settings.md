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
- 创建需要挂载的目录：`mkdir -p /data/docker/pxc/node1 /data/docker/pxc/node2 /data/docker/pxc/node3`
- 赋权：`chmod 777 -R /data/docker/pxc`
- 创建 Docker 网段：`docker network create --subnet=172.18.0.0/24 pxc-net`
- 启动镜像：

```
# 初次初始化比较慢，给个 2 分钟左右吧
docker run -d -p 3307:3306 -v /data/docker/pxc/node1:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=gitnavi123456 -e CLUSTER_NAME=pxc-cluster -e XTRABACKUP_PASSWORD=gitnavi123456 --privileged --name=pxc-node-1 --net=pxc-net --ip 172.18.0.2 percona/percona-xtradb-cluster
```

- 使用 SQLyog 测试是否可以连上去，可以才能继续创建其他节点。
	- 连接地址是宿主机 IP，端口是：3307

```
docker run -d -p 3308:3306 -v /data/docker/pxc/node2:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=gitnavi123456 -e CLUSTER_NAME=pxc-cluster -e XTRABACKUP_PASSWORD=gitnavi123456 -e CLUSTER_JOIN=pxc-node-1 --privileged --name=pxc-node-2 --net=pxc-net --ip 172.18.0.3 percona/percona-xtradb-cluster

docker run -d -p 3309:3306 -v /data/docker/pxc/node3:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=gitnavi123456 -e CLUSTER_NAME=pxc-cluster -e XTRABACKUP_PASSWORD=gitnavi123456 -e CLUSTER_JOIN=pxc-node-1 --privileged --name=pxc-node-3 --net=pxc-net --ip 172.18.0.4 percona/percona-xtradb-cluster
```

- 测试集群
	- 用 SQLyog 连上 3 个节点，随便找一个节点创建库，其他几个节点会同时产生库。以此类推，创建表、插入数据，然后查看其他库情况。


## 资料

- <https://blog.csdn.net/leshami/article/details/72173732>
