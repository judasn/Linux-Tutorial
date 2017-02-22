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