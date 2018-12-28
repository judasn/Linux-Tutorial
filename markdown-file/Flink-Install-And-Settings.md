# Flink 安装和配置

## 介绍

- 2018-11-30 发布最新：1.7.0 版本
- 官网：<https://flink.apache.org/>
- 官网 Github：<https://github.com/apache/flink>

## 本地模式安装

- CentOS 7.4
- IP 地址：`192.168.0.105`
- 官网指导：<https://ci.apache.org/projects/flink/flink-docs-release-1.7/tutorials/local_setup.html>
- 必须 JDK 8.x
- 下载：<http://flink.apache.org/downloads.html>
	- 选择 Binaries 类型
	- 如果没有 Hadoop 环境，只是本地开发，选择：Apache 1.7.0 Flink only
	- Scala 2.11 和 Scala 2.12 都可以，但是我因为后面要用到 kafka，kafka 推荐 Scala 2.11，所以我这里也选择同样。
	- 最终我选择了：Apache 1.7.0 Flink only Scala 2.11，共：240M
- 解压：`tar zxf flink-*.tgz`
- 进入根目录：`cd flink-1.7.0`，完整路径：`cd /usr/local/flink-1.7.0`
- 改下目录名方便后面书写：`mv /usr/local/flink-1.7.0 /usr/local/flink`
- 启动：`cd /usr/local/flink && ./bin/start-cluster.sh`
- 停止：`cd /usr/local/flink && ./bin/stop-cluster.sh`
- 查看日志：`tail -300f log/flink-*-standalonesession-*.log`
- 浏览器访问 WEB 管理：`http://192.168.0.105:8081`

## yarn 启动

- 安装方式跟上面一样，但是必须保证有 hadoop、yarn 集群
- 控制台启动：`cd /usr/local/flink && ./bin/yarn-session.sh -n 2 -jm 1024 -tm 1024`
- 守护进程启动：`cd /usr/local/flink && ./bin/yarn-session.sh -n 2 -jm 1024 -tm 1024 -d`
- 有可能会报：`The Flink Yarn cluster has failed`，可能是资源不够
- YARN 参数配置可以参考：[点击我](https://sustcoder.github.io/2018/09/27/YARN%20%E5%86%85%E5%AD%98%E5%8F%82%E6%95%B0%E8%AF%A6%E8%A7%A3/)

## Demo

- 运行程序解压包下也有一些 jar demo：`cd /usr/local/flink/examples`
- 官网：<https://ci.apache.org/projects/flink/flink-docs-release-1.7/examples/>
- DataStream API：<https://ci.apache.org/projects/flink/flink-docs-release-1.7/dev/datastream_api.html>
- DataSet API：<https://ci.apache.org/projects/flink/flink-docs-release-1.7/dev/batch/>
- 访问该脚本可以得到如下内容：<https://flink.apache.org/q/quickstart.sh>

```
mvn archetype:generate								\
  -DarchetypeGroupId=org.apache.flink				\
  -DarchetypeArtifactId=flink-quickstart-java		\
  -DarchetypeVersion=${1:-1.7.0}							\
  -DgroupId=org.myorg.quickstart					\
  -DartifactId=$PACKAGE								\
  -Dversion=0.1										\
  -Dpackage=org.myorg.quickstart					\
  -DinteractiveMode=false
```

- 可以自己在本地执行该 mvn 命令，用 Maven 骨架快速创建一个 WordCount 项目
- 注意，这里必须使用这个仓库（最好用穿越软件）：`https://repository.apache.org/content/repositories/snapshots`
- 该骨架的所有版本：<https://search.maven.org/search?q=g:org.apache.flink AND a:flink-quickstart-java&core=gav>
	- 根据实验，目前 1.7.0 和 1.6.x 都是没有 WordCount demo 代码的。但是 1.3.x 是有的。

## 运行

- 可以直接在 IntelliJ IDEA 上 run
- 也可以交给服务器上 flink 执行，也有两种方式：
	- 把 jar 自己上传 Flink 服务器运行：`cd /usr/local/flink && ./bin/flink run -c com.youmeek.WordCount /opt/flink-simple-demo-1.0-SNAPSHOT.jar`
	- 也可以通过 WEB UI 上传 jar：<http://192.168.0.105:8081/#/submit>
		- 有一个 `Add New` 按钮可以上传 jar 包，然后填写 Class 路径：`com.youmeek.WordCount`
		- `parallelism` 表示并行度，填写数字，一般并行度设置为集群 CPU 核数总和的 2-3 倍（如果是单机模式不需要设置并行度）

## 安装 ncat 方便发送数据包

- 环境：CentOS 7.4
- 官网下载：<https://nmap.org/download.html>，找到 rpm 包
- 当前时间（201803）最新版本下载：`wget https://nmap.org/dist/ncat-7.60-1.x86_64.rpm`
- 当前时间（201812）最新版本下载：`wget https://nmap.org/dist/ncat-7.70-1.x86_64.rpm`
- 安装：`sudo rpm -i ncat-7.60-1.x86_64.rpm`
- ln 下：`sudo ln -s /usr/bin/ncat /usr/bin/nc`
- 检验：`nc --version`
- 启动监听 9011 端口：`nc -lk 9011`，然后你可以输入内容，Flink demo 看是否有收到

-------------------------------------------------------------------


## Flink 核心概念

- 四个基石：Checkpoint、State、Time、Window
- 解决 exactly-once 的问题
- 实现了 watermark 的机制，解决了基于事件时间处理时的数据乱序和数据迟到的问题
- 状态管理
- 提供了一套开箱即用的窗口操作，包括滚动窗口、滑动窗口、会话窗口
- 我想说的，都被这篇文章说了：
	- <http://shiyanjun.cn/archives/1508.html>
	- <http://wuchong.me/blog/2018/11/09/flink-tech-evolution-introduction/>
- 这里补充点其他的


```
Client 用来提交任务给 JobManager，JobManager 分发任务给 TaskManager 去执行，然后 TaskManager 会心跳的汇报任务状态
在 Flink 集群中，计算资源被定义为 Task Slot
每个 TaskManager 会拥有一个或多个 Slots

JobManager 会以 Slot 为单位调度 Task。
对 Flink 的 JobManager 来说，其调度的是一个 Pipeline 的 Task，而不是一个点。
在 Flink 中其也是一个被整体调度的 Pipeline Task。在 TaskManager 中，根据其所拥有的 Slot 个数，同时会拥有多个 Pipeline


Task Slot
在架构概览中我们介绍了 TaskManager 是一个 JVM 进程，并会以独立的线程来执行一个task或多个subtask。为了控制一个 TaskManager 能接受多少个 task，Flink 提出了 Task Slot 的概念。

Flink 中的计算资源通过 Task Slot 来定义。每个 task slot 代表了 TaskManager 的一个固定大小的资源子集。例如，一个拥有3个slot的 TaskManager，会将其管理的内存平均分成三分分给各个 slot。将资源 slot 化意味着来自不同job的task不会为了内存而竞争，而是每个task都拥有一定数量的内存储备。需要注意的是，这里不会涉及到CPU的隔离，slot目前仅仅用来隔离task的内存。
通过调整 task slot 的数量，用户可以定义task之间是如何相互隔离的。每个 TaskManager 有一个slot，也就意味着每个task运行在独立的 JVM 中。每个 TaskManager 有多个slot的话，也就是说多个task运行在同一个JVM中。而在同一个JVM进程中的task，可以共享TCP连接（基于多路复用）和心跳消息，可以减少数据的网络传输。也能共享一些数据结构，一定程度上减少了每个task的消耗。

每一个 TaskManager 会拥有一个或多个的 task slot，每个 slot 都能跑由多个连续 task 组成的一个 pipeline，比如 MapFunction 的第n个并行实例和 ReduceFunction 的第n个并行实例可以组成一个 pipeline。

source（Streaming 进来）
Transformations（Streaming 处理）
sink（Streaming 出去）

Flink程序与生俱来的就是并行和分布式的。Streams被分割成stream patition, Operators被被分割成operator subtasks。这些subtasks在不同的机器（容器）上的不同的线程中运行，彼此独立，互不干扰。 一个操作的operator subtask的数目，被称为parallelism（并行度）。一个stream的并行度，总是等于生成它的（operator）操作的并行度。一个Flink程序中，不同的operator可能具有不同的并行度。
```

-------------------------------------------------------------------


#### 为了容错的 Checkpoint 机制

- 这几篇文章写得很好：
	- [Flink 增量式checkpoint 介绍](https://my.oschina.net/u/992559/blog/2873828)
	- [A Deep Dive into Rescalable State in Apache Flink](https://flink.apache.org/features/2017/07/04/flink-rescalable-state.html)
	- [Flink 小贴士 (5): Savepoint 和 Checkpoint 的 3 个不同点](http://wuchong.me/blog/2018/11/25/flink-tips-differences-between-savepoints-and-checkpoints/)
	- [Flink 小贴士 (2)：Flink 如何管理 Kafka 消费位点](http://wuchong.me/blog/2018/11/04/how-apache-flink-manages-kafka-consumer-offsets/)
- Checkpoint 允许 Flink 恢复流中的状态和位置，使应用程序具有与无故障执行相同的语义
- Checkpoint 是 Flink 用来从故障中恢复的机制，快照下了整个应用程序的状态，当然也包括输入源读取到的位点。如果发生故障，Flink 将通过从 Checkpoint 加载应用程序状态并从恢复的读取位点继续应用程序的处理，就像什么事情都没发生一样。


```
一个checkpoint是Flink的一致性快照，它包括：

程序当前的状态
输入流的位置
Flink通过一个可配置的时间，周期性的生成checkpoint，将它写入到存储中，例如S3或者HDFS。写入到存储的过程是异步的，意味着Flink程序在checkpoint运行的同时还可以处理数据。

在机器或者程序遇到错误重启的时候，Flink程序会使用最新的checkpoint进行恢复。Flink会恢复程序的状态，将输入流回滚到checkpoint保存的位置，然后重新开始运行。这意味着Flink可以像没有发生错误一样计算结果。

检查点（Checkpoint）是使 Apache Flink 能从故障恢复的一种内部机制。检查点是 Flink 应用状态的一个一致性副本，包括了输入的读取位点。在发生故障时，Flink 通过从检查点加载应用程序状态来恢复，并从恢复的读取位点继续处理，就好像什么事情都没发生一样。你可以把检查点想象成电脑游戏的存档一样。如果你在游戏中发生了什么事情，你可以随时读档重来一次。
检查点使得 Apache Flink 具有容错能力，并确保了即时发生故障也能保证流应用程序的语义。检查点是以固定的间隔来触发的，该间隔可以在应用中配置。

```

- 默认情况下 checkpoint 是不启用的，为了启用 checkpoint，需要在 StreamExecutionEnvironment 中调用 enableCheckpointing(n) 方法, 其中 n 是 checkpoint 的间隔毫秒数。
- 这里有一个核心：用到 Facebook 的 RocksDB 数据库（可嵌入式的支持持久化的 key-value 存储系统）


-------------------------------------------------------------------

#### Exactly-Once

- 因为有了 Checkpoint，才有了 Exactly-Once
- [Apache Flink 端到端（end-to-end）Exactly-Once特性概览 （翻译）](https://my.oschina.net/u/992559/blog/1819948)
- 常见有这几种语义：

```
at most once : 至多一次。可能导致消息丢失。
at least once : 至少一次。可能导致消息重复。
exactly once ： 刚好一次。不丢失也不重复。
```


-------------------------------------------------------------------


#### Watermark

- [Flink 小贴士 (3): 轻松理解 Watermark](http://wuchong.me/blog/2018/11/18/flink-tips-watermarks-in-apache-flink-made-easy/)
- 了解事件时间的几个概念：event-time【消息产生的时间】, processing-time【消息处理时间】, ingestion-time【消息流入 flink 框架的时间】
- watermark 的作用，他们定义了何时不再等待更早的数据
- WaterMark 只在时间特性 EventTime 和 IngestionTime 起作用，并且 IngestionTime 的时间等同于消息的 ingestion 时间

-------------------------------------------------------------------

#### 窗口

- <http://wuchong.me/blog/2016/05/25/flink-internals-window-mechanism/>
- [Flink 原理与实现：Window 机制](http://wuchong.me/blog/2016/05/25/flink-internals-window-mechanism/)
- [Flink 原理与实现：Session Window](http://wuchong.me/blog/2016/06/06/flink-internals-session-window/)

##### 滚动窗口（Tumbling Windows）

- 滚动窗口有一个固定的大小，并且不会出现重叠

###### 滚动事件时间窗口

```
input
    .keyBy(<key selector>)
    .window(TumblingEventTimeWindows.of(Time.seconds(5)))
    .<windowed transformation>(<window function>);
```

- 每日偏移8小时的滚动事件时间窗口

```
input
    .keyBy(<key selector>)
    .window(TumblingEventTimeWindows.of(Time.days(1), Time.hours(-8)))
    .<windowed transformation>(<window function>);
```

###### 滚动处理时间窗口

```
input
    .keyBy(<key selector>)
    .window(TumblingProcessingTimeWindows.of(Time.seconds(5)))
    .<windowed transformation>(<window function>);
```

---------------------------------

##### 滑动窗口（Sliding Windows）

- 滑动窗口分配器将元素分配到固定长度的窗口中，与滚动窗口类似，窗口的大小由窗口大小参数来配置，另一个窗口滑动参数控制滑动窗口开始的频率。因此，滑动窗口如果滑动参数小于滚动参数的话，窗口是可以重叠的，在这种情况下元素会被分配到多个窗口中。
- 例如，你有10分钟的窗口和5分钟的滑动，那么每个窗口中5分钟的窗口里包含着上个10分钟产生的数据

###### 滑动事件时间窗口

```
input
    .keyBy(<key selector>)
    .window(SlidingEventTimeWindows.of(Time.seconds(10), Time.seconds(5)))
    .<windowed transformation>(<window function>);
```

###### 滑动处理时间窗口

```
input
    .keyBy(<key selector>)
    .window(SlidingProcessingTimeWindows.of(Time.seconds(10), Time.seconds(5)))
    .<windowed transformation>(<window function>);
```

- 偏移8小时的滑动处理时间窗口

```
input
    .keyBy(<key selector>)
    .window(SlidingProcessingTimeWindows.of(Time.hours(12), Time.hours(1), Time.hours(-8)))
    .<windowed transformation>(<window function>);
```

---------------------------------

##### 计数窗口（Count Window）

- 根据元素个数对数据流进行分组的

###### 翻滚计数窗口

- 当我们想要每 100 个用户购买行为事件统计购买总数，那么每当窗口中填满 100 个元素了，就会对窗口进行计算，这种窗口我们称之为翻滚计数窗口（Tumbling Count Window）

```
input
    .keyBy(<key selector>)
    .countWindow(100)
    .<windowed transformation>(<window function>);
```

---------------------------------


##### 会话窗口（Session Windows）

- session 窗口分配器通过 session 活动来对元素进行分组，session 窗口跟滚动窗口和滑动窗口相比，不会有重叠和固定的开始时间和结束时间的情况。相反，当它在一个固定的时间周期内不再收到元素，即非活动间隔产生，那个这个窗口就会关闭。一个 session 窗口通过一个 session 间隔来配置，这个 session 间隔定义了非活跃周期的长度。当这个非活跃周期产生，那么当前的 session 将关闭并且后续的元素将被分配到新的 session 窗口中去。

###### 事件时间会话窗口

```
input
    .keyBy(<key selector>)
    .window(EventTimeSessionWindows.withGap(Time.minutes(10)))
    .<windowed transformation>(<window function>);
```

###### 处理时间会话窗口

```
input
    .keyBy(<key selector>)
    .window(ProcessingTimeSessionWindows.withGap(Time.minutes(10)))
    .<windowed transformation>(<window function>);
```

---------------------------------

##### 全局窗口（Global Windows）

- 全局窗口分配器将所有具有相同 key 的元素分配到同一个全局窗口中，这个窗口模式仅适用于用户还需自定义触发器的情况。否则，由于全局窗口没有一个自然的结尾，无法执行元素的聚合，将不会有计算被执行。

```
input
    .keyBy(<key selector>)
    .window(GlobalWindows.create())
    .<windowed transformation>(<window function>);
```

-------------------------------------------------------------------


#### 生产环境准备

- [Flink 小贴士 (7): 4个步骤，让 Flink 应用达到生产状态](http://wuchong.me/blog/2018/12/03/flink-tips-4-steps-flink-application-production-ready/)

-------------------------------------------------------------------


#### 运行环境


- Flink 的部署
- Flink 有三种部署模式，分别是 Local、Standalone Cluster 和 Yarn Cluster。
- 对于 Local 模式来说，JobManager 和 TaskManager 会公用一个 JVM 来完成 Workload。
- 如果要验证一个简单的应用，Local 模式是最方便的。实际应用中大多使用 Standalone 或者 Yarn Cluster

-------------------------------------------------------------------

#### Flink 的 HA

-------------------------------------------------------------------

#### Monitoring REST API

https://ci.apache.org/projects/flink/flink-docs-stable/monitoring/rest_api.html#monitoring-rest-api

-------------------------------------------------------------------

#### 主要核心 API

- 官网 API 文档：<https://ci.apache.org/projects/flink/flink-docs-release-1.7/>
- DataStream API -- Stream Processing
- DataSet API -- Batch Processing
- Kafka source
	- Kafka Connectors
- Elasticsearch sink

-------------------------------------------------------------------

#### Table & SQL API（关系型 API）

Table API：为Java&Scala SDK提供类似于LINQ（语言集成查询）模式的API（自0.9.0版本开始）
SQL API：支持标准SQL（自1.1.0版本开始）


关系型API作为一个统一的API层，既能够做到在Batch模式的表上进行可终止地查询并生成有限的结果集，同时也能做到在Streaming模式的表上持续地运行并生产结果流，并且在两种模式的表上的查询具有相同的语法跟语义。这其中最重要的概念是Table，Table与DataSet、DataStream紧密结合，DataSet和DataStream都可以很容易地转换成Table，同样转换回来也很方便。

关系型API架构在基础的DataStream、DataSet API之上，其整体层次关系如下图所示：

![table-sql-level](http://7xkaaz.com1.z0.glb.clouddn.com/table-sql-level.png)

-------------------------------------------------------------------


## 资料

- [新一代大数据处理引擎 Apache Flink](https://www.ibm.com/developerworks/cn/opensource/os-cn-apache-flink/index.html)
- [Flink-关系型API简介](http://vinoyang.com/2017/07/06/flink-relation-api-introduction/)
- [Flink学习笔记(4):基本概念](https://www.jianshu.com/p/0cd1db4282be)
- [Apache Flink：特性、概念、组件栈、架构及原理分析](http://shiyanjun.cn/archives/1508.html)
- [Flink 原理与实现：理解 Flink 中的计算资源](http://wuchong.me/blog/2016/05/09/flink-internals-understanding-execution-resources/)
- [Flink实战教程](https://liguohua-bigdata.gitbooks.io/simple-flink/content/)

