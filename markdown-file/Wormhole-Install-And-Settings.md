# Wormhole Flink 最佳实践

## 前置声明

- 需要对流计算的一些基础概念有基础了解，比如：Source、Sink、YARN、Kafka 等

-------------------------------------------------------------------

## 本文目标

- 统计 **滑动窗口** 下的流过的数据量（count）
- 业务数据格式：

```
{
   "id": 1,
   "name": "test",
   "phone": "18074546423",
   "city": "Beijing",
   "time": "2017-12-22 10:00:00"
}
```

-------------------------------------------------------------------

## 基础环境

- 参考官网：<https://edp963.github.io/wormhole/deployment.html>
- 4 台 8C32G 服务器 CentOS 7.5
    - **为了方便测试，服务器都已经关闭防火墙，并且对外开通所有端口**
    - **都做了免密登录**
    - hostname：`linux01`
    - hostname：`linux02`
    - hostname：`linux03`
    - hostname：`linux04`
    - hostname：`linux05`
    - Ansible 批量添加 hosts 请看：[点击我](Ansible-Install-And-Settings.md)
- 必须（版本请不要随便用，而是按照如下说明来）：
    - 一般情况下，我组件都是放在：`/usr/local`
    - JDK（所有服务器）：`1.8.0_181`
        - 批量添加 JDK 请看：[点击我](Ansible-Install-And-Settings.md)
    - Hadoop 集群（HDFS，YARN）（linux01、linux02、linux03）：`2.6.5`
        - 安装请看：[点击我](Hadoop-Install-And-Settings.md)
    - Zookeeper 单点（linux04）：`3.4.13`
        - 安装请看：[点击我](Zookeeper-Install.md)
    - Kafka 单点（linux04）：`0.10.2.2`
        - 安装请看：[点击我](Kafka-Install-And-Settings.md)
    - MySQL 单点（linux04）：`5.7`
        - 安装请看：[点击我](Mysql-Install-And-Settings.md)
    - Spark 单点（linux05）：`2.2.0`
        - 安装请看：[点击我](Spark-Install-And-Settings.md)
    - Flink 单点（linux05）：`1.5.1`
        - 安装请看：[点击我](Flink-Install-And-Settings.md)
    - wormhole 单点（linux05）：`0.6.0-beta`，2018-12-06 版本
- 非必须：
    - Elasticsearch（支持版本 5.x）（非必须，若无则无法查看 wormhole 处理数据的吞吐和延时）
    - Grafana （支持版本 4.x）（非必须，若无则无法查看 wormhole 处理数据的吞吐和延时的图形化展示）

-------------------------------------------------------------------

## Wormhole 安装 + 配置

- 参考官网：<https://edp963.github.io/wormhole/deployment.html>
- 解压：`cd /usr/local && tar -xvf wormhole-0.6.0-beta.tar.gz`
- 修改配置文件：`vim /usr/local/wormhole-0.6.0-beta/conf/application.conf`

```

akka.http.server.request-timeout = 120s

wormholeServer {
  cluster.id = "" #optional global uuid
  host = "linux05"
  port = 8989
  ui.default.language = "Chinese"
  token.timeout = 1
  token.secret.key = "iytr174395lclkb?lgj~8u;[=L:ljg"
  admin.username = "admin"    #default admin user name
  admin.password = "admin"    #default admin user password
}

mysql = {
  driver = "slick.driver.MySQLDriver$"
  db = {
    driver = "com.mysql.jdbc.Driver"
    user = "root"
    password = "123456"
    url = "jdbc:mysql://linux04:3306/wormhole?useUnicode=true&characterEncoding=UTF-8&useSSL=false"
    numThreads = 4
    minConnections = 4
    maxConnections = 10
    connectionTimeout = 3000
  }
}

#ldap = {
#  enabled = false
#  user = ""
#  pwd = ""
#  url = ""
#  dc = ""
#  read.timeout = 3000
#  read.timeout = 5000
#  connect = {
#    timeout = 5000
#    pool = true
#  }
#}

spark = {
  wormholeServer.user = "root"   #WormholeServer linux user
  wormholeServer.ssh.port = 22       #ssh port, please set WormholeServer linux user can password-less login itself remote
  spark.home = "/usr/local/spark"
  yarn.queue.name = "default"        #WormholeServer submit spark streaming/job queue
  wormhole.hdfs.root.path = "hdfs://linux01/wormhole"   #WormholeServer hdfslog data default hdfs root path
  yarn.rm1.http.url = "linux01:8088"    #Yarn ActiveResourceManager address
  yarn.rm2.http.url = "linux01:8088"   #Yarn StandbyResourceManager address
}

flink = {
  home = "/usr/local/flink"
  yarn.queue.name = "default"
  feedback.state.count=100
  checkpoint.enable=false
  checkpoint.interval=60000
  stateBackend="hdfs://linux01/flink-checkpoints"
  feedback.interval=30
}

zookeeper = {
  connection.url = "linux04:2181"  #WormholeServer stream and flow interaction channel
  wormhole.root.path = "/wormhole"   #zookeeper
}

kafka = {
  brokers.url = "linux04:9092"
  zookeeper.url = "linux04:2181"
  topic.refactor = 1
  using.cluster.suffix = false #if true, _${cluster.id} will be concatenated to consumer.feedback.topic
  consumer = {
    feedback.topic = "wormhole_feedback"
    poll-interval = 20ms
    poll-timeout = 1s
    stop-timeout = 30s
    close-timeout = 20s
    commit-timeout = 70s
    wakeup-timeout = 60s
    max-wakeups = 10
    session.timeout.ms = 60000
    heartbeat.interval.ms = 50000
    max.poll.records = 1000
    request.timeout.ms = 80000
    max.partition.fetch.bytes = 10485760
  }
}

#kerberos = {
#  keyTab=""      #the keyTab will be used on yarn
#  spark.principal=""   #the principal of spark
#  spark.keyTab=""      #the keyTab of spark
#  server.config=""     #the path of krb5.conf
#  jaas.startShell.config="" #the path of jaas config file which should be used by start.sh
#  jaas.yarn.config=""     #the path of jaas config file which will be uploaded to yarn
#  server.enabled=false   #enable wormhole connect to Kerberized cluster
#}

# choose monitor method among ES、MYSQL
monitor ={
   database.type="MYSQL"
}

#Wormhole feedback data store, if doesn't want to config, you will not see wormhole processing delay and throughput
#if not set, please comment it

#elasticSearch.http = {
#  url = "http://localhost:9200"
#  user = ""
#  password = ""
#}

#display wormhole processing delay and throughput data, get admin user token from grafana
#garfana should set to be anonymous login, so you can access the dashboard through wormhole directly
#if not set, please comment it

#grafana = {
#  url = "http://localhost:3000"
#  admin.token = "jihefouglokoj"
#}

#delete feedback history data on time
maintenance = {
  mysql.feedback.remain.maxDays = 7
  elasticSearch.feedback.remain.maxDays = 7
}


#Dbus integration, support serveral DBus services, if not set, please comment it

#dbus = {
#  api = [
#    {
#      login = {
#        url = "http://localhost:8080/keeper/login"
#        email = ""
#        password = ""
#      }
#      synchronization.namespace.url = "http://localhost:8080/keeper/tables/riderSearch"
#    }
#  ]
#}
```

- 初始化数据库：
    - 创建表：`create database wormhole character set utf8;`
- 初始化表结构脚本路径：<https://github.com/edp963/wormhole/blob/master/rider/conf/wormhole.sql>
    - 该脚本存在一个问题：初始化脚本和补丁脚本混在一起，所以直接复制执行会有报错，但是报错的部分是不影响
    - 我是直接把基础 sql 和补丁 sql 分开执行，方便判断。
- 部署完成，浏览器访问：<http://linux01:8989>

-------------------------------------------------------------------

## 创建用户

- **参考官网，必须先了解下**：<https://edp963.github.io/wormhole/quick-start.html>
- 必须创建用户，后面才能进入 Project 里面创建 Stream / Flow
- 创建的用户类型必须是：`user`


-------------------------------------------------------------------

## 创建 Source 需要涉及的概念 

#### 创建 Instance

- Instance 用于绑定各个组件的所在服务连接
- 一般我们都会选择 Kafka 作为 source，后面的基础也是基于 Kafka 作为 Source 的场景
- 假设填写实例名：`source_kafka`

#### 创建 Database

- 各个组件的具体数据库、Topic 等信息
- 假设填写 topic：`source`


#### 创建 Namespace

- wormhole 抽象出来的概念
- 用于数据分类
- 假设填写 Tables：`ums_extension   id`
- 配置 schema，记得配置上 ums_ts

```
{
   "id": 1,
   "name": "test",
   "phone": "18074546423",
   "city": "Beijing",
   "time": "2017-12-22 10:00:00"
}
```


-------------------------------------------------------------------

## 创建 Sink 需要涉及的概念 

#### 创建 Instance

- 假设填写实例名：`sink_mysql`

#### 创建 Database

- 假设填写 Database Name：`sink`
- config 参数：`useUnicode=true&characterEncoding=UTF-8&useSSL=false&rewriteBatchedStatements=true`

#### 创建 Namespace

- 假设填写 Tables: `user  id`


-------------------------------------------------------------------

## 创建 Project

- 项目标识：`demo`

-------------------------------------------------------------------


## Flink Stream

- Stream 是在 Project 内容页下才能创建
- 一个 Stream 可以有多个 Flow
- 并且是 Project 下面的用户才能创建，admin 用户没有权限
- 要删除 Project 必须先进入 Project 内容页删除所有 Stream 之后 admin 才能删除 Project
- 新建 Stream
    - Stream type 类型选择：`Flink`
    - 假设填写 Name：`wormhole_stream_test`

## Flink Flow（流式作业）

- Flow 是在 Project 内容页下才能创建
- 并且是 Project 下面的用户才能创建，admin 用户没有权限
- Flow 会关联 source 和 sink
- 要删除 Project 必须先进入 Project 内容页删除所有 Stream 之后 admin 才能删除 Project
- 基于 Stream 新建 Flow
    - Pipeline
    - Transformation
        - <https://edp963.github.io/wormhole/user-guide.html#cep>
        - NO_SKIP 滑动窗口
        - SKIP_PAST_LAST_EVENT 滚动窗口
        - KeyBy 分组字段
        - Output
            - Agg：将匹配的多条数据做聚合，生成一条数据输出,例：field1:avg,field2:max（目前支持 max/min/avg/sum）
            - Detail：将匹配的多条数据逐一输出
            - FilteredRow：按条件选择指定的一条数据输出，例：head/last/ field1:min/max
    - Confirmation
- 注意：Stream 处于 running 状态时，才可以启动 Flow


-------------------------------------------------------------------

## Kafka 发送测试数据

- `cd /usr/local/kafka/bin`
- `./kafka-console-producer.sh --broker-list linux01:9092 --topic source --property "parse.key=true" --property "key.separator=@@@"`
- 发送 UMS 流消息协议规范格式：

```
data_increment_data.kafka.source_kafka.source.ums_extension.*.*.*@@@{"id": 1, "name": "test", "phone":"18074546423", "city": "Beijing", "time": "2017-12-22 10:00:00"}
```

