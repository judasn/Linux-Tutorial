# Zookeeper 安装


## 需要环境

- JDK 安装

## 下载安装

- 官网：<https://zookeeper.apache.org/>
- 此时（201702）最新稳定版本：Release 3.4.9`
- 官网下载：<http://www.apache.org/dyn/closer.cgi/zookeeper/>
- 我这里以：`zookeeper-3.4.8.tar.gz` 为例
- 安装过程：
	- `mkdir -p /usr/program/zookeeper/data`
	- `cd /opt/setups`
	- `tar zxvf zookeeper-3.4.8.tar.gz`
	- `mv /opt/setups/zookeeper-3.4.8 /usr/program/zookeeper`
	- `cd /usr/program/zookeeper/zookeeper-3.4.8/conf`
    - `mv zoo_sample.cfg zoo.cfg`
	- `vim zoo.cfg`
- 将配置文件中的这个值：
	- 原值：`dataDir=/tmp/zookeeper`
	- 改为：`dataDir=/usr/program/zookeeper/data`
- 防火墙开放2181端口
	- `iptables -A INPUT -p tcp -m tcp --dport 2181 -j ACCEPT`
	- `service iptables save`
	- `service iptables restart`
- 启动 zookeeper：`sh /usr/program/zookeeper/zookeeper-3.4.8/bin/zkServer.sh start`
- 停止 zookeeper：`sh /usr/program/zookeeper/zookeeper-3.4.8/bin/zkServer.sh stop`
- 查看 zookeeper 状态：`sh /usr/program/zookeeper/zookeeper-3.4.8/bin/zkServer.sh status`
	- 如果是集群环境，下面几种角色
		- leader
		- follower

## 集群环境搭建

### 确定机子环境

- 集群环境最少节点是：3，且节点数必须是奇数，生产环境推荐是：5 个机子节点。
- 系统都是 CentOS 6
- 机子 1：192.168.1.121
- 机子 2：192.168.1.111
- 机子 3：192.168.1.112

### 配置

- 在三台机子上都做如上文的流程安装，再补充修改配置文件：`vim /usr/program/zookeeper/zookeeper-3.4.8/conf/zoo.cfg`
- 三台机子都增加下面内容：

``` nginx
server.1=192.168.1.121:2888:3888
server.2=192.168.1.111:2888:3888
server.3=192.168.1.112:2888:3888
```

- 在 机子 1 增加一个该文件：`vim /usr/program/zookeeper/data/myid`，文件内容填写：`1`
- 在 机子 2 增加一个该文件：`vim /usr/program/zookeeper/data/myid`，文件内容填写：`2`
- 在 机子 3 增加一个该文件：`vim /usr/program/zookeeper/data/myid`，文件内容填写：`3`
- 然后在三台机子上都启动 zookeeper：`sh /usr/program/zookeeper/zookeeper-3.4.8/bin/zkServer.sh start`
- 分别查看三台机子的状态：`sh /usr/program/zookeeper/zookeeper-3.4.8/bin/zkServer.sh status`，应该会得到类似这样的结果：

```
Using config: /usr/program/zookeeper/zookeeper-3.4.8/bin/../conf/zoo.cfg
Mode: follower 或者 Mode: leader
```