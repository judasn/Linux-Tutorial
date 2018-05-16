# Kafka 安装和配置

## 消息系统的好处

- 解耦（各个业务系统各自为政，有各自新需求，各自系统自行修改，只通过消息来通信）
- 大系统层面的扩展性（不用改旧业务系统代码，增加新系统，接收新消息）
- 异步通信（一个消息，多个业务系统来消费。某些场景可以堆积到一定程度再去消费）
- 缓冲（解耦某些需要长时间处理业务）


## Kafka 介绍

> A distributed streaming platform

- 官网：<https://kafka.apache.org/>
- Github：<https://github.com/apache/kafka>
	- 主要是由 Java 和 Scala 开发
- 官网下载：<https://kafka.apache.org/downloads>
- 当前最新稳定版本（201803）：**1.0.1**
- 官网 quickstart：<https://kafka.apache.org/quickstart>
- 运行的机子不要小于 2G 内存
- Kafka 流行的主要原因：
	- 支持常见的发布订阅功能
	- 分布式
	- 高吞吐量（听说：普通单机也支持每秒 100000 条消息的传输）
	- 磁盘数据持久化，消费者 down 后，重新 up 的时候可以继续接收前面未接收到的消息
	- 支持流数据处理，常见于大数据
- 核心概念：
	- Producer：生产者（业务系统），负责发布消息到 broker
	- Consumer：消费者（业务系统），向 broker 读取消息的客户端
	- Broker：可以理解为：存放消息的管道（kafka 软件节点本身）
	- Topic：可以理解为：消息主题、消息标签、消息通道、消息队列（物理上不同 Topic 的消息分开存储，根据 Partition 参数决定一个 Topic 的消息保存于一个或多个 broker 上。作为使用者，不用关心 Topic 实际物理存储地方。）
	- Partition：是物理上的概念，每个 Topic 包含一个或多个 Partition。一般有几个 Broker，填写分区最好是等于大于节点值。分区目的主要是数据分片，解决水平扩展、高吞吐量。当 Producer 生产消息的时候，消息会被算法计算后分配到对应的分区，Consumer 读取的时候算法也会帮我们找到消息所在分区，这是内部实现的，应用层面不用管。
	- Replication-factor：副本。假设有 3 个 Broker 的情况下，当副本为 3 的时候每个 Partition 会在每个 Broker 都会存有一份，目的主要是容错。
		- 其中有一个 Leader。
	- Consumer Group：每个 Consumer 属于一个特定的 Consumer Group（可为每个 Consumer 指定 group name，若不指定 group name 则属于默认的 group）一般一个业务系统集群指定同一个一个 group id，然后一个业务系统集群只能一个节点来消费同一个消息。
		- Consumer Group 信息存储在 zookeeper 中，需要通过 zookeeper 的客户端来查看和设置
		- 如果某 Consumer Group 中 consumer 数量少于 partition 数量，则至少有一个 consumer 会消费多个 partition 的数据
		- 如果 consumer 的数量与 partition 数量相同，则正好一个 consumer 消费一个 partition 的数据
		- 如果 consumer 的数量多于 partition 的数量时，会有部分 consumer 无法消费该 topic 下任何一条消息。
		- 具体实验可以看这篇文章：[Kafka深度解析](http://www.jasongj.com/2015/01/02/Kafka%E6%B7%B1%E5%BA%A6%E8%A7%A3%E6%9E%90/)
	- Record：消息数据本身，由一个 key、value、timestamp 组成
- 业界常用的 docker 镜像：
	- [wurstmeister/kafka-docker（不断更新，优先）](https://github.com/wurstmeister/kafka-docker/)
	- Spring 项目选用依赖包的时候，对于版本之间的关系可以看这里：<http://projects.spring.io/spring-kafka/>
		- 目前（201803） 
		- spring boot 2.0 以上基础框架版本，kafka 版本 1.0.x，推荐使用：spring-kafka 2.1.4.RELEASE
		- spring boot 2.0 以下基础框架版本，kafka 版本 0.11.0.x, 1.0.x，推荐使用：spring-kafka 1.3.3.RELEASE
- 官网 quickstart 指导：<https://kafka.apache.org/quickstart>
- 常用命令：
	- wurstmeister/kafka-docker 容器中 kafka home：`cd /opt/kafka`
	- 假设我的 zookeeper 地址：`10.135.157.34:2181`，如果你有多个节点用逗号隔开
	- 列出所有 topic：`bin/kafka-topics.sh --list --zookeeper 10.135.157.34:2181`
	- 创建 topic：`bin/kafka-topics.sh --create --topic kafka-test-topic-1 --partitions 3 --replication-factor 1 --zookeeper 10.135.157.34:2181`
		- 创建名为 kafka-test-topic-1 的 topic，3个分区分别存放数据，数据备份总共 2 份
	- 查看特定 topic 的详情：`bin/kafka-topics.sh --describe --topic kafka-test-topic-1 --zookeeper 10.135.157.34:2181`
	- 删除 topic：`bin/kafka-topics.sh --delete --topic kafka-test-topic-1 --zookeeper 10.135.157.34:2181`
	- 更多命令可以看：<http://orchome.com/454>
- 假设 topic 详情的返回信息如下：
	- `PartitionCount:6`：分区为 6 个
	- `ReplicationFactor:3`：副本为 3 个
	- `Partition: 0 Leader: 3`：Partition 下标为 0 的主节点是 broker.id=3
		- 当 Leader down 掉之后，其他节点会选举中一个新 Leader
	- `Replicas: 3,1,2`：在 `Partition: 0` 下共有 3 个副本，broker.id 分别为 3,1,2
	- `Isr: 3,1,2`：在 `Partition: 0` 下目前存活的 broker.id 分别为 3,1,2

```
Topic:kafka-all    PartitionCount:6    ReplicationFactor:3    Configs:
    Topic: kafka-all    Partition: 0    Leader: 3    Replicas: 3,1,2    Isr: 3,1,2
    Topic: kafka-all    Partition: 1    Leader: 1    Replicas: 1,2,3    Isr: 1,2,3
    Topic: kafka-all    Partition: 2    Leader: 2    Replicas: 2,3,1    Isr: 2,3,1
    Topic: kafka-all    Partition: 3    Leader: 3    Replicas: 3,2,1    Isr: 3,2,1
    Topic: kafka-all    Partition: 4    Leader: 1    Replicas: 1,3,2    Isr: 1,3,2
    Topic: kafka-all    Partition: 5    Leader: 2    Replicas: 2,1,3    Isr: 2,1,3
```


----------------------------------------------------------------------------------------------


## Docker 单个实例部署（1.0.1）

- 目前 latest 用的时候 kafka 1.0.1，要指定版本可以去作者 [github](https://github.com/wurstmeister/kafka-docker) 看下 tag 目录，切换不同 tag，然后看下 Dockerfile 里面的 kafka 版本号
- 我的服务器外网 ip：`182.61.19.177`，hostname 为：`instance-3v0pbt5d`
- 在我的开发机上上配置 host：

```
182.61.19.177 instance-3v0pbt5d
```

- 部署 kafka：
- 目前 latest 用的时候 kafka 1.0.1，要指定版本可以去作者 [github](https://github.com/wurstmeister/kafka-docker) 看下 tag 目录，切换不同 tag，然后看下 Dockerfile 里面的 kafka 版本号
- 新建文件：`vim docker-compose.yml`
- 这里的 kafka 对外网暴露端口是 9094，内网端口是 9092

```
version: '3.2'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: wurstmeister/kafka:latest
    ports:
      - target: 9094
        published: 9094
        protocol: tcp
        mode: host
    environment:
      HOSTNAME_COMMAND: "docker info | grep ^Name: | cut -d' ' -f 2"
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT
      KAFKA_ADVERTISED_PROTOCOL_NAME: OUTSIDE
      KAFKA_ADVERTISED_PORT: 9094
      KAFKA_PROTOCOL_NAME: INSIDE
      KAFKA_PORT: 9092
      KAFKA_LOG_DIRS: /data/docker/kafka/logs
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: 'true'
      KAFKA_LOG_RETENTION_HOURS: 168
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /data/docker/kafka/logs:/data/docker/kafka/logs
```

- 测试：
	- 进入 kafka 容器：`docker exec -it kafkadocker_kafka_1 /bin/bash`
	- 根据官网 Dockerfile 说明，kafka home 应该是：`cd /opt/kafka`
	- 创建 topic 命令：`bin/kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic my-topic-test`
	- 查看 topic 命令：`bin/kafka-topics.sh --list --zookeeper zookeeper:2181`
	- 删除 topic：`bin/kafka-topics.sh --delete --topic my-topic-test --zookeeper zookeeper:2181`
	- 给 topic 发送消息命令：`bin/kafka-console-producer.sh --broker-list localhost:9092 --topic my-topic-test`，然后在出现交互输入框的时候输入你要发送的内容
	- 再开一个终端，进入 kafka 容器，接受消息：`bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic-test --from-beginning`
		- 其中 `--from-beginning` 参数表示在启动该客户端的时候接受前面 kafka 的所有记录。不加这个参数，则旧数据不会收到，生产者新生产的消息才会接收到。
	- 此时发送的终端输入一个内容回车，接受消息的终端就可以收到。

----------------------------------------------------------------------------------------------


## Docker 多机多实例部署（外网无法访问）

- 三台机子：
	- 内网 ip：`172.24.165.129`，外网 ip：`47.91.22.116`
	- 内网 ip：`172.24.165.130`，外网 ip：`47.91.22.124`
	- 内网 ip：`172.24.165.131`，外网 ip：`47.74.6.138`
- 修改三台机子 hostname：
	- 节点 1：`hostnamectl --static set-hostname youmeekhost1`
	- 节点 2：`hostnamectl --static set-hostname youmeekhost2`
	- 节点 3：`hostnamectl --static set-hostname youmeekhost3`
- 三台机子的 hosts 都修改为如下内容：`vim /etc/hosts`

```
172.24.165.129 youmeekhost1
172.24.165.130 youmeekhost2
172.24.165.131 youmeekhost3
```

- 开发机设置 hosts：

```
47.91.22.116 youmeekhost1
47.91.22.124 youmeekhost2
47.74.6.138 youmeekhost3
```


#### Zookeeper 集群

- 节点 1：

```
docker run -d --name=zookeeper1 --net=host --restart=always \
-v /data/docker/zookeeper/data:/data \
-v /data/docker/zookeeper/log:/datalog \
-v /etc/hosts:/etc/hosts \
-e ZOO_MY_ID=1 \
-e "ZOO_SERVERS=server.1=youmeekhost1:2888:3888 server.2=youmeekhost2:2888:3888 server.3=youmeekhost3:2888:3888" \
zookeeper:latest
```


- 节点 2：

```
docker run -d --name=zookeeper2 --net=host --restart=always \
-v /data/docker/zookeeper/data:/data \
-v /data/docker/zookeeper/log:/datalog \
-v /etc/hosts:/etc/hosts \
-e ZOO_MY_ID=2 \
-e "ZOO_SERVERS=server.1=youmeekhost1:2888:3888 server.2=youmeekhost2:2888:3888 server.3=youmeekhost3:2888:3888" \
zookeeper:latest
```


- 节点 3：

```
docker run -d --name=zookeeper3 --net=host --restart=always \
-v /data/docker/zookeeper/data:/data \
-v /data/docker/zookeeper/log:/datalog \
-v /etc/hosts:/etc/hosts \
-e ZOO_MY_ID=3 \
-e "ZOO_SERVERS=server.1=youmeekhost1:2888:3888 server.2=youmeekhost2:2888:3888 server.3=youmeekhost3:2888:3888" \
zookeeper:latest
```



#### 先安装 nc 再来校验 zookeeper 集群情况

- 环境：CentOS 7.4
- 官网下载：<https://nmap.org/download.html>，找到 rpm 包
- 当前时间（201803）最新版本下载：`wget https://nmap.org/dist/ncat-7.60-1.x86_64.rpm`
- 安装并 ln：`sudo rpm -i ncat-7.60-1.x86_64.rpm && ln -s /usr/bin/ncat /usr/bin/nc`
- 检验：`nc --version`

#### zookeeper 集群测试

- 节点 1 执行命令：`echo stat | nc youmeekhost1 2181`，能得到如下信息：

```
Zookeeper version: 3.4.11-37e277162d567b55a07d1755f0b31c32e93c01a0, built on 11/01/2017 18:06 GMT
Clients:
 /172.31.154.16:35336[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 1
Sent: 0
Connections: 1
Outstanding: 0
Zxid: 0x0
Mode: follower
Node count: 4
```

- 节点 2 执行命令：`echo stat | nc youmeekhost2 2181`，能得到如下信息：

```
Zookeeper version: 3.4.11-37e277162d567b55a07d1755f0b31c32e93c01a0, built on 11/01/2017 18:06 GMT
Clients:
 /172.31.154.17:55236[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 1
Sent: 0
Connections: 1
Outstanding: 0
Zxid: 0x100000000
Mode: leader
Node count: 4
```

- 节点 3 执行命令：`echo stat | nc youmeekhost3 2181`，能得到如下信息：

```
Zookeeper version: 3.4.11-37e277162d567b55a07d1755f0b31c32e93c01a0, built on 11/01/2017 18:06 GMT
Clients:
 /172.31.65.88:41840[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 1
Sent: 0
Connections: 1
Outstanding: 0
Zxid: 0x100000000
Mode: follower
Node count: 4
```

##### Kafka 集群

- 节点 1 执行：

```
docker run -d --net=host --name=kafka1 \
--restart=always \
--env KAFKA_BROKER_ID=1 \
--env KAFKA_ZOOKEEPER_CONNECT=youmeekhost1:2181,youmeekhost2:2181,youmeekhost3:2181 \
--env KAFKA_LOG_DIRS=/data/docker/kafka/logs \
--env HOSTNAME_COMMAND="docker info | grep ^Name: | cut -d' ' -f 2" \
--env KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT \
--env KAFKA_ADVERTISED_PROTOCOL_NAME=OUTSIDE \
--env KAFKA_ADVERTISED_PORT=9094 \
--env KAFKA_PROTOCOL_NAME=INSIDE \
--env KAFKA_PORT=9092 \
--env KAFKA_AUTO_CREATE_TOPICS_ENABLE=true \
--env KAFKA_LOG_RETENTION_HOURS=168 \
--env KAFKA_HEAP_OPTS="-Xmx1G -Xms1G" \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /etc/localtime:/etc/localtime \
-v /data/docker/kafka/logs:/data/docker/kafka/logs \
-v /etc/hosts:/etc/hosts \
wurstmeister/kafka:latest
```

- 节点 2 执行：

```
docker run -d --net=host --name=kafka2 \
--restart=always \
--env KAFKA_BROKER_ID=2 \
--env KAFKA_ZOOKEEPER_CONNECT=youmeekhost1:2181,youmeekhost2:2181,youmeekhost3:2181 \
--env KAFKA_LOG_DIRS=/data/docker/kafka/logs \
--env HOSTNAME_COMMAND="docker info | grep ^Name: | cut -d' ' -f 2" \
--env KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT \
--env KAFKA_ADVERTISED_PROTOCOL_NAME=OUTSIDE \
--env KAFKA_ADVERTISED_PORT=9094 \
--env KAFKA_PROTOCOL_NAME=INSIDE \
--env KAFKA_PORT=9092 \
--env KAFKA_AUTO_CREATE_TOPICS_ENABLE=true \
--env KAFKA_LOG_RETENTION_HOURS=168 \
--env KAFKA_HEAP_OPTS="-Xmx1G -Xms1G" \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /etc/localtime:/etc/localtime \
-v /data/docker/kafka/logs:/data/docker/kafka/logs \
-v /etc/hosts:/etc/hosts \
wurstmeister/kafka:latest
```

- 节点 3 执行：

```
docker run -d --net=host --name=kafka3 \
--restart=always \
--env KAFKA_BROKER_ID=3 \
--env KAFKA_ZOOKEEPER_CONNECT=youmeekhost1:2181,youmeekhost2:2181,youmeekhost3:2181 \
--env KAFKA_LOG_DIRS=/data/docker/kafka/logs \
--env HOSTNAME_COMMAND="docker info | grep ^Name: | cut -d' ' -f 2" \
--env KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT \
--env KAFKA_ADVERTISED_PROTOCOL_NAME=OUTSIDE \
--env KAFKA_ADVERTISED_PORT=9094 \
--env KAFKA_PROTOCOL_NAME=INSIDE \
--env KAFKA_PORT=9092 \
--env KAFKA_AUTO_CREATE_TOPICS_ENABLE=true \
--env KAFKA_LOG_RETENTION_HOURS=168 \
--env KAFKA_HEAP_OPTS="-Xmx1G -Xms1G" \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /etc/localtime:/etc/localtime \
-v /data/docker/kafka/logs:/data/docker/kafka/logs \
-v /etc/hosts:/etc/hosts \
wurstmeister/kafka:latest
```

#### Kafka 集群测试

- 在 kafka1 上测试：
	- 进入 kafka1 容器：`docker exec -it kafka1 /bin/bash`
	- 根据官网 Dockerfile 说明，kafka home 应该是：`cd /opt/kafka`
	- 创建 topic 命令：`bin/kafka-topics.sh --create --zookeeper youmeekhost1:2181,youmeekhost2:2181,youmeekhost3:2181 --replication-factor 3 --partitions 3 --topic my-topic-test`
	- 查看 topic 命令：`bin/kafka-topics.sh --list --zookeeper youmeekhost1:2181,youmeekhost2:2181,youmeekhost3:2181`
	- 给 topic 发送消息命令：`bin/kafka-console-producer.sh --broker-list youmeekhost1:9092 --topic my-topic-test`，然后在出现交互输入框的时候输入你要发送的内容
- 在 kafka2 上测试：
	- 进入 kafka2 容器：`docker exec -it kafka2 /bin/bash`
	- 接受消息：`cd /opt/kafka && bin/kafka-console-consumer.sh --bootstrap-server youmeekhost2:9092 --topic my-topic-test --from-beginning`
- 在 kafka3 上测试：
	- 进入 kafka3 容器：`docker exec -it kafka3 /bin/bash`
	- 接受消息：`cd /opt/kafka && bin/kafka-console-consumer.sh --bootstrap-server youmeekhost3:9092 --topic my-topic-test --from-beginning`
- 如果 kafka1 输入的消息，kafka2 和 kafka3 能收到，则表示已经成功。



#### 部署 kafka-manager（未能访问成功）

- 节点 1：`docker run -d --name=kafka-manager1 --restart=always -p 9000:9000 -e ZK_HOSTS="youmeekhost1:2181,youmeekhost2:2181,youmeekhost3:2181" sheepkiller/kafka-manager:latest`

----------------------------------------------------------------------------------------------

## Kafka 1.0.1 源码安装

- 一台机子：CentOS 7.4，根据文章最开头，已经修改了 hosts
- 确保本机安装有 JDK8（JDK 版本不能随便挑选）
- 先用上面的 docker 方式部署一个 zookeeper，我这里的 zookeeper IP 地址为：`172.16.0.2`
	- **如果该 zookeeper 前面已经用过了，最好重新删除，重新 run，因为 zookeeper 上保留的旧的 topic 配置**
- 官网下载：<https://kafka.apache.org/downloads>
- 当前（201803）最新版本为：**1.0.1，同时推荐 Scala 版本为 2.11**，这里要特别注意：kafka_2.11-1.0.1.tgz 中的 2.11 指的是 Scala 版本
	- 找到：`Binary downloads` 下面的链接
	- 下载：`wget http://mirrors.shu.edu.cn/apache/kafka/1.0.1/kafka_2.11-1.0.1.tgz`
- 解压：`tar zxvf kafka_2.11-1.0.1.tgz`，假设当前目录为：`/usr/local/kafka_2.11-1.0.1`
- 为了方便，修改目录名字：`mv /usr/local/kafka_2.11-1.0.1 /usr/local/kafka`
- 创建 log 输出目录：`mkdir -p /data/kafka/logs`
- 修改 kafka-server 的配置文件：`vim /usr/local/kafka/config/server.properties`
- 找到下面两个参数内容，修改成如下：

```
# 唯一ID（kafka 集群环境下，该值必须唯一，默认从 0 开始），和 zookeeper 的配置文件中的 myid 类似道理（单节点多 broker 的情况下该参数必改）
broker.id=1
# 监听地址（单节点多 broker 的情况下该参数必改）
listeners=PLAINTEXT://0.0.0.0:9092
# 向 Zookeeper 注册的地址。这里可以直接填写外网IP地址，但是不建议这样做，而是通过配置 hosts 的方式来设置。不然填写外网 IP 地址会导致所有流量都走外网（单节点多 broker 的情况下该参数必改）
advertised.listeners=PLAINTEXT://youmeekhost:9092
# 日志数据目录，可以通过逗号来指定多个目录（单节点多 broker 的情况下该参数必改）
log.dirs=/data/kafka/logs
# 创建新 topic 的时候默认 1 个分区。需要特别注意的是：已经创建好的 topic 的 partition 的个数只可以被增加，不能被减少。
# 如果对消息有高吞吐量的要求，可以增加分区数来分摊压力
num.partitions=1
# 允许删除topic
delete.topic.enable=false
# 允许自动创建topic（默认是 true）
auto.create.topics.enable=false
# 磁盘IO不足的时候，可以适当调大该值 ( 当内存足够时 )
#log.flush.interval.messages=10000
#log.flush.interval.ms=1000
# kafka 数据保留时间 默认 168 小时 == 7 天
log.retention.hours=168
# zookeeper，存储了 broker 的元信息
zookeeper.connect=youmeekhost:2181

# 其余都使用默认配置，但是顺便解释下：
# borker 进行网络处理的线程数
num.network.threads=3

# borker 进行 I/O 处理的线程数
num.io.threads=8

# 发送缓冲区 buffer 大小，数据不是一下子就发送的，先回存储到缓冲区了到达一定的大小后在发送，能提高性能
socket.send.buffer.bytes=102400

# 接收缓冲区大小，当数据到达一定大小后在序列化到磁盘
socket.receive.buffer.bytes=102400

# 这个参数是向 kafka 请求消息或者向 kafka 发送消息的请请求的最大数，这个值不能超过 java 的堆栈大小
socket.request.max.bytes=104857600
```

- 启动 kafka 服务（必须制定配置文件）：`cd /usr/local/kafka && bin/kafka-server-start.sh config/server.properties`
	- 后台方式运行 kafka 服务：`cd /usr/local/kafka && bin/kafka-server-start.sh -daemon config/server.properties`
	- 停止 kafka 服务：`cd /usr/local/kafka && bin/kafka-server-stop.sh`
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

## kafka 1.0.1 默认配置文件内容

```
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# see kafka.server.KafkaConfig for additional details and defaults

############################# Server Basics #############################

# The id of the broker. This must be set to a unique integer for each broker.
broker.id=0

############################# Socket Server Settings #############################

# The address the socket server listens on. It will get the value returned from 
# java.net.InetAddress.getCanonicalHostName() if not configured.
#   FORMAT:
#     listeners = listener_name://host_name:port
#   EXAMPLE:
#     listeners = PLAINTEXT://your.host.name:9092
#listeners=PLAINTEXT://:9092

# Hostname and port the broker will advertise to producers and consumers. If not set, 
# it uses the value for "listeners" if configured.  Otherwise, it will use the value
# returned from java.net.InetAddress.getCanonicalHostName().
#advertised.listeners=PLAINTEXT://your.host.name:9092

# Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
#listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL

# The number of threads that the server uses for receiving requests from the network and sending responses to the network
num.network.threads=3

# The number of threads that the server uses for processing requests, which may include disk I/O
num.io.threads=8

# The send buffer (SO_SNDBUF) used by the socket server
socket.send.buffer.bytes=102400

# The receive buffer (SO_RCVBUF) used by the socket server
socket.receive.buffer.bytes=102400

# The maximum size of a request that the socket server will accept (protection against OOM)
socket.request.max.bytes=104857600


############################# Log Basics #############################

# A comma seperated list of directories under which to store log files
log.dirs=/tmp/kafka-logs

# The default number of log partitions per topic. More partitions allow greater
# parallelism for consumption, but this will also result in more files across
# the brokers.
num.partitions=1

# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
# This value is recommended to be increased for installations with data dirs located in RAID array.
num.recovery.threads.per.data.dir=1

############################# Internal Topic Settings  #############################
# The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
# For anything other than development testing, a value greater than 1 is recommended for to ensure availability such as 3.
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

############################# Log Flush Policy #############################

# Messages are immediately written to the filesystem but by default we only fsync() to sync
# the OS cache lazily. The following configurations control the flush of data to disk.
# There are a few important trade-offs here:
#    1. Durability: Unflushed data may be lost if you are not using replication.
#    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
#    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to exceessive seeks.
# The settings below allow one to configure the flush policy to flush data after a period of time or
# every N messages (or both). This can be done globally and overridden on a per-topic basis.

# The number of messages to accept before forcing a flush of data to disk
#log.flush.interval.messages=10000

# The maximum amount of time a message can sit in a log before we force a flush
#log.flush.interval.ms=1000

############################# Log Retention Policy #############################

# The following configurations control the disposal of log segments. The policy can
# be set to delete segments after a period of time, or after a given size has accumulated.
# A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
# from the end of the log.

# The minimum age of a log file to be eligible for deletion due to age
log.retention.hours=168

# A size-based retention policy for logs. Segments are pruned from the log unless the remaining
# segments drop below log.retention.bytes. Functions independently of log.retention.hours.
#log.retention.bytes=1073741824

# The maximum size of a log segment file. When this size is reached a new log segment will be created.
log.segment.bytes=1073741824

# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
log.retention.check.interval.ms=300000

############################# Zookeeper #############################

# Zookeeper connection string (see zookeeper docs for details).
# This is a comma separated host:port pairs, each corresponding to a zk
# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# You can also append an optional chroot string to the urls to specify the
# root directory for all kafka znodes.
zookeeper.connect=localhost:2181

# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=6000


############################# Group Coordinator Settings #############################

# The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
# The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
# The default value for this is 3 seconds.
# We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
# However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
group.initial.rebalance.delay.ms=0
```


----------------------------------------------------------------------------------------------


## 其他资料

- [管理Kafka的Consumer-Group信息](http://lsr1991.github.io/2016/01/03/kafka-consumer-group-management/)
- [Kafka--Consumer消费者](http://blog.xiaoxiaomo.com/2016/05/14/Kafka-Consumer%E6%B6%88%E8%B4%B9%E8%80%85/)
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
- <http://www.cnblogs.com/huxi2b/p/7929690.html>
- <http://blog.csdn.net/HG_Harvey/article/details/79198496>
- <http://blog.csdn.net/vtopqx/article/details/78638996>
- <http://www.weduoo.com/archives/2047>
- <https://blog.52itstyle.com/archives/2358/>

