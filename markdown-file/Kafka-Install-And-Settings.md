# Kafka 安装和配置

## 部署 Kafka 的核心要点

- Kafka 的部署什么都很简单，启动不会报错，但是有一个点很蛋疼，网络问题，而这个问题的核心点在于：hosts，所以如果你看到有些文章不写 IP，写 hosts 不用感觉奇怪，是有原因的，特别是 listeners 问题。
- 假设我 Kafka 和 Zookeeper 是部署在一台机子：
	- 内网 IP：`172.16.0.2`
	- 外网 IP：`182.61.19.178`
- 那我在服务器上 hosts 应该是这样的：`vim /etc/hosts`

```
172.16.0.2 youmeekhost
```

- 则在后面的部署环节，以及修改配置文件过程中都应该用该 hosts
- 而我本地的开发机 hosts 应该这样配置（重要）：

```
182.61.19.178 youmeekhost
```

----------------------------------------------------------------------------------------------


## Kafka 介绍

> A distributed streaming platform

- 官网：<https://kafka.apache.org/>
- 官网下载：<https://kafka.apache.org/downloads>
- 当前最新稳定版本（201803）：**1.0.1**
- 官网 quickstart：<https://kafka.apache.org/quickstart>
- 核心概念：
	- Producer：生产者（业务系统），负责发布消息到 broker
	- Consumer：消费者（业务系统），向 broker 读取消息的客户端
	- Broker：可以理解为：存放消息的管道（kafka）
	- Topic：可以理解为：消息主题、消息标签（物理上不同 Topic 的消息分开存储，逻辑上一个 Topic 的消息虽然保存于一个或多个 broker 上但用户只需指定消息的 Topic 即可生产或消费数据而不必关心数据存于何处）
    - Partition：Partition 是物理上的概念，每个Topic包含一个或多个Partition.
    - Consumer Group：每个 Consumer 属于一个特定的 Consumer Group（可为每个 Consumer 指定 group name，若不指定 group name 则属于默认的 group）一般一个集群指定一个 group
- 业界常用的 docker 镜像：
	- [wurstmeister/kafka-docker（不断更新，优先）](https://github.com/wurstmeister/kafka-docker/)
		- 这个示例，部署是成功了，开发环境没法调通，暂时无解。
		- 运行的机子不要小于 2G 内存
		- clone 项目：`git clone https://github.com/wurstmeister/kafka-docker.git`
		- 修改 `vim docker-compose.yml` 中参数 KAFKA_ADVERTISED_HOST_NAME，改为你 /etc/hosts 下的配置
		- 先启动 zookeeper（首次时间较慢）：`docker-compose up -d`
		- 再添加 kafka 节点：`docker-compose scale kafka=3`
		- 停止容器：`docker-compose stop`
		- 进入容器：`docker exec -it 54f /bin/bash`
	- Spring 项目选用依赖包的时候，对于版本之间的关系可以看这里：<http://projects.spring.io/spring-kafka/>
		- 目前（201803） 
		- spring boot 2.0 以上基础框架版本，kafka 版本 1.0.x，推荐使用：spring-kafka 2.1.4.RELEASE
		- spring boot 2.0 以下基础框架版本，kafka 版本 0.11.0.x, 1.0.x，推荐使用：spring-kafka 1.3.3.RELEASE
- 官网 quickstart 指导：<https://kafka.apache.org/quickstart>
- 常用命令：
	- 容器中 kafka home：`cd /opt/kafka`
	- 我的 zookeeper 地址：`10.135.157.34:2181`，如果你有多个节点用逗号隔开
	- 列出所有 topic：`bin/kafka-topics.sh --list --zookeeper 10.135.157.34:2181`
	- 创建 topic：`bin/kafka-topics.sh --create --topic kafka-test-topic-1 --partitions 3 --replication-factor 1 --zookeeper 10.135.157.34:2181`
		- 创建名为 kafka-test-topic-1 的 topic，3个分区分别存放数据，数据备份总共 2 份
	- 查看特定 topic 的详情：`bin/kafka-topics.sh --describe --topic kafka-test-topic-1 --zookeeper 10.135.157.34:2181`
	- 删除 topic：`bin/kafka-topics.sh --delete --topic kafka-test-topic-1 --zookeeper 10.135.157.34:2181`
	- 更多命令可以看：<http://orchome.com/454>

----------------------------------------------------------------------------------------------


## Docker 单个实例部署

- 我的宿主机 ip：`172.16.0.2`，下面会用到
- 部署 zookeeper：`docker run -d --name one-zookeeper -p 2181:2181 -v /etc/localtime:/etc/localtime zookeeper:3.4`
- 部署 kafka：
	- 目前 latest 用的时候 kafka 1.0.1，要指定版本可以去作者 [github](https://github.com/wurstmeister/kafka-docker) 看下 tag 目录，切换不同 tag，然后看下 Dockerfile 里面的 kafka 版本号

```
docker run -d --name one-kafka -p 9092:9092 \
--link one-zookeeper \
--env KAFKA_ZOOKEEPER_CONNECT=one-zookeeper:2181 \
--env KAFKA_ADVERTISED_HOST_NAME=172.16.0.2 \
--env KAFKA_ADVERTISED_PORT=9092 \
-v /etc/localtime:/etc/localtime \
wurstmeister/kafka:latest
```

- 测试：
	- 进入 kafka 容器：`docker exec -it one-kafka /bin/bash`
	- 根据官网 Dockerfile 说明，kafka home 应该是：`cd /opt/kafka`
	- 创建 topic 命令：`bin/kafka-topics.sh --create --zookeeper one-zookeeper:2181 --replication-factor 1 --partitions 1 --topic my-topic-test`
	- 查看 topic 命令：`bin/kafka-topics.sh --list --zookeeper one-zookeeper:2181`
	- 删除 topic：`bin/kafka-topics.sh --delete --topic my-topic-test --zookeeper one-zookeeper:2181`
	- 给 topic 发送消息命令：`bin/kafka-console-producer.sh --broker-list localhost:9092 --topic my-topic-test`，然后在出现交互输入框的时候输入你要发送的内容
	- 再开一个终端，进入 kafka 容器，接受消息：`bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic-test --from-beginning`
	- 此时发送的终端输入一个内容回车，接受消息的终端就可以收到。

----------------------------------------------------------------------------------------------


## Docker 多机多实例部署

- 三台机子：
	- 内网 ip：
	- 内网 ip：
	- 内网 ip：
- 三台机子的 hosts 修改为：`vim /etc/hosts`

```
172.16.0.2 youmeekhost1
172.16.0.2 youmeekhost2
172.16.0.2 youmeekhost3
```

#### 各个节点部署 zookeeper：

- 节点 1：

```
docker run -d \
-v /data/docker/zookeeper/data:/data \
-v /data/docker/zookeeper/log:/datalog \
-e ZOO_MY_ID=1 \
-e "ZOO_SERVERS=server.1=youmeekhost1:2888:3888 server.2=youmeekhost2:2888:3888 server.3=youmeekhost3:2888:3888" \
--name=zookeeper1 --net=host --restart=always zookeeper:3.4
```


- 节点 2：

```
docker run -d \
-v /data/docker/zookeeper/data:/data \
-v /data/docker/zookeeper/log:/datalog \
-e ZOO_MY_ID=2 \
-e "ZOO_SERVERS=server.1=youmeekhost1:2888:3888 server.2=youmeekhost2:2888:3888 server.3=youmeekhost3:2888:3888" \
--name=zookeeper2 --net=host --restart=always zookeeper:3.4
```


- 节点 3：

```
docker run -d \
-v /data/docker/zookeeper/data:/data \
-v /data/docker/zookeeper/log:/datalog \
-e ZOO_MY_ID=3 \
-e "ZOO_SERVERS=server.1=youmeekhost1:2888:3888 server.2=youmeekhost2:2888:3888 server.3=youmeekhost3:2888:3888" \
--name=zookeeper3 --net=host --restart=always zookeeper:3.4
```

#### 先安装 nc 再来校验 zookeeper 集群情况

- 环境：CentOS 7.4
- 官网下载：<https://nmap.org/download.html>，找到 rpm 包
- 当前时间（201803）最新版本下载：`wget https://nmap.org/dist/ncat-7.60-1.x86_64.rpm`
- 安装：`sudo rpm -i ncat-7.60-1.x86_64.rpm`
- ln 下：`sudo ln -s /usr/bin/ncat /usr/bin/nc`
- 检验：`nc --version`

#### zookeeper 测试

- 各节点执行命令：`echo stat | nc youmeekhost1 2181`，能得到如下信息：

```
Zookeeper version: 3.4.11-37e277162d567b55a07d1755f0b31c32e93c01a0, built on 11/01/2017 18:06 GMT
Clients:
 /172.21.0.1:33344[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 1
Sent: 0
Connections: 1
Outstanding: 0
Zxid: 0x500000000
Mode: leader
Node count: 4
```


#### 部署 Kafka

- 节点 1 执行：

```
docker run -d --name kafka1 -p 9092:9092 \
--link zookeeper1 \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper1:2181 \
--env KAFKA_ADVERTISED_HOST_NAME=youmeekhost1 \
--env KAFKA_ADVERTISED_PORT=9092 \
-v /etc/localtime:/etc/localtime \
wurstmeister/kafka:latest
```

- 节点 2 执行：

```
docker run -d --name kafka2 -p 9092:9092 \
--link zookeeper2 \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper2:2181 \
--env KAFKA_ADVERTISED_HOST_NAME=youmeekhost1 \
--env KAFKA_ADVERTISED_PORT=9092 \
-v /etc/localtime:/etc/localtime \
wurstmeister/kafka:latest
```

- 节点 3 执行：

```
docker run -d --name kafka3 -p 9092:9092 \
--link zookeeper3 \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper3:2181 \
--env KAFKA_ADVERTISED_HOST_NAME=youmeekhost1 \
--env KAFKA_ADVERTISED_PORT=9092 \
-v /etc/localtime:/etc/localtime \
wurstmeister/kafka:latest
```

----------------------------------------------------------------------------------------------

#### Docker 单实例 kafka

- 目前 latest 用的时候 kafka 1.0.1，要指定版本可以去作者 [github](https://github.com/wurstmeister/kafka-docker) 看下 tag 目录，切换不同 tag，然后看下 Dockerfile 里面的 kafka 版本号

```
docker run -d --name one-kafka -p 9092:9092 \
--link one-zookeeper \
--env KAFKA_ZOOKEEPER_CONNECT=one-zookeeper:2181 \
--env KAFKA_ADVERTISED_HOST_NAME=172.16.0.2 \
--env KAFKA_ADVERTISED_PORT=9092 \
-v /etc/localtime:/etc/localtime \
wurstmeister/kafka:latest
```

- 测试：
	- 进入 kafka 容器：`docker exec -it one-kafka /bin/bash`
	- 根据官网 Dockerfile 说明，kafka home 应该是：`cd /opt/kafka`
	- 创建 topic 命令：`bin/kafka-topics.sh --create --zookeeper one-zookeeper:2181 --replication-factor 1 --partitions 1 --topic my-topic-test`
	- 查看 topic 命令：`bin/kafka-topics.sh --list --zookeeper one-zookeeper:2181`
	- 删除 topic：`bin/kafka-topics.sh --delete --topic my-topic-test --zookeeper one-zookeeper:2181`
	- 给 topic 发送消息命令：`bin/kafka-console-producer.sh --broker-list localhost:9092 --topic my-topic-test`，然后在出现交互输入框的时候输入你要发送的内容
	- 再开一个终端，进入 kafka 容器，接受消息：`bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic-test --from-beginning`
	- 此时发送的终端输入一个内容回车，接受消息的终端就可以收到。

----------------------------------------------------------------------------------------------

## Kafka 1.0.1 源码安装

- 一台机子：CentOS 7.4，根据文章最开头，已经修改了 hosts
- 确保本机安装有 JDK8
- 先用上面的 docker 方式部署一个 zookeeper，我这里的 zookeeper IP 地址为：`172.16.0.2`
	- **如果该 zookeeper 前面已经用过了，最好重新删除，重新 run，因为 zookeeper 上保留的旧的 topic 配置**
- 官网下载：<https://kafka.apache.org/downloads>
- 当前（201803）最新版本为：**1.0.1，同时推荐 Scala 版本为 2.11**
	- 找到：`Binary downloads` 下面的链接
	- 下载：`wget http://mirrors.shu.edu.cn/apache/kafka/1.0.1/kafka_2.11-1.0.1.tgz`
- 解压：`tar zxvf kafka_2.11-1.0.1.tgz`，假设当前目录为：`/usr/local/kafka_2.11-1.0.1`
- 为了方便，修改目录名字：`mv /usr/local/kafka_2.11-1.0.1 /usr/local/kafka`
- 创建 log 输出目录：`mkdir -p /data/kafka/logs`
- 修改 kafka-server 的配置文件：`vim /usr/local/kafka/config/server.properties`
- 找到下面两个参数内容，修改成如下：

```
# 唯一ID（kafka 集群环境下，该值必须唯一）
broker.id=1
# 监听地址
listeners=PLAINTEXT://0.0.0.0:9092
# 向 Zookeeper 注册的地址。这里可以直接填写外网IP地址，但是不建议这样做，而是通过配置 hosts 的方式来设置。不然填写外网 IP 地址会导致所有流量都走外网
advertised.listeners=PLAINTEXT://youmeekhost:9092
# 数据目录
log.dirs=/data/kafka/logs
# 允许删除topic
delete.topic.enable=true
# 允许自动创建topic
auto.create.topics.enable=true
# 磁盘IO不足的时候，可以适当调大该值 ( 当内存足够时 )
#log.flush.interval.messages=10000
#log.flush.interval.ms=1000
# kafka 数据保留时间 默认 168 小时 == 7 天
log.retention.hours=168
# zookeeper
zookeeper.connect=youmeekhost:2181

# 其余都使用默认配置

```

- 启动 kafka 服务：`cd /usr/local/kafka && bin/kafka-server-start.sh config/server.properties`
- 再开一个终端测试：
	- 进入目录：`cd /usr/local/kafka`
	- 创建 topic 命令：`bin/kafka-topics.sh --create --zookeeper youmeekhost:2181 --replication-factor 1 --partitions 1 --topic my-topic-test`
	- 查看 topic 命令：`bin/kafka-topics.sh --list --zookeeper youmeekhost:2181`
	- 删除 topic：`bin/kafka-topics.sh --delete --topic my-topic-test --zookeeper youmeekhost:2181`
	- 给 topic 发送消息命令：`bin/kafka-console-producer.sh --broker-list youmeekhost:9092 --topic my-topic-test`，然后在出现交互输入框的时候输入你要发送的内容
	- 再开一个终端，进入 kafka 容器，接受消息：`bin/kafka-console-consumer.sh --bootstrap-server youmeekhost:9092 --topic my-topic-test --from-beginning`
	- 此时发送的终端输入一个内容回车，接受消息的终端就可以收到。
- Spring Boot 依赖：

```xml
<dependency>
	<groupId>org.springframework.kafka</groupId>
	<artifactId>spring-kafka</artifactId>
	<version>1.3.3.RELEASE</version>
</dependency>

<dependency>
	<groupId>org.apache.kafka</groupId>
	<artifactId>kafka-clients</artifactId>
	<version>1.0.1</version>
</dependency>

<dependency>
	<groupId>org.apache.kafka</groupId>
	<artifactId>kafka-streams</artifactId>
	<version>1.0.1</version>
</dependency>
```

----------------------------------------------------------------------------------------------


## 资料

- <http://www.ituring.com.cn/article/499268>
- <http://orchome.com/kafka/index>
- <https://www.jianshu.com/p/263164fdcac7>
- <https://www.cnblogs.com/wangxiaoqiangs/p/7831990.html>
- <http://www.bijishequ.com/detail/536308>
- <http://lanxinglan.cn/2017/10/18/%E5%9C%A8Docker%E7%8E%AF%E5%A2%83%E4%B8%8B%E9%83%A8%E7%BD%B2Kafka/>
- <https://www.cnblogs.com/ding2016/p/8282907.html>
- <http://blog.csdn.net/fuyuwei2015/article/details/73379055>
- <https://segmentfault.com/a/1190000012990954>
- <http://www.54tianzhisheng.cn/2018/01/04/Kafka/>
- <https://renwole.com/archives/442>
- <http://www.bijishequ.com/detail/542646?p=85>
- <http://blog.csdn.net/zhbr_f1/article/details/73732299>
- <http://wangzs.leanote.com/post/kafka-manager%E5%AE%89%E8%A3%85>
- <https://cloud.tencent.com/developer/article/1013313>
- <http://blog.csdn.net/boling_cavalry/article/details/78309050>
- <https://www.jianshu.com/p/d77149efa59f>
- <http://www.bijishequ.com/detail/536308>
- <http://blog.51cto.com/13323775/2063420>
- <http://lanxinglan.cn/2017/10/18/%E5%9C%A8Docker%E7%8E%AF%E5%A2%83%E4%B8%8B%E9%83%A8%E7%BD%B2Kafka/>
- <http://www.cnblogs.com/huxi2b/p/6592862.html>
- <http://www.cnblogs.com/huxi2b/p/7929690.html>
- <http://blog.csdn.net/HG_Harvey/article/details/79198496>
- <http://blog.csdn.net/vtopqx/article/details/78638996>
- <http://www.weduoo.com/archives/2047>
- <http://www.jishurensheng.com/461884086.html>
- <https://blog.52itstyle.com/archives/2358/>