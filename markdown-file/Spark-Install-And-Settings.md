# Spark 安装和配置

## 介绍

- 2018-12 发布最新：2.4.0 版本
- 官网：<https://spark.apache.org/>
- 官网文档：<https://spark.apache.org/documentation.html>
- 官网下载：<https://spark.apache.org/downloads.html>
- 官网 Github：<https://github.com/apache/spark>

## 本地模式安装

- CentOS 7.4
- IP 地址：`192.168.0.105`
- 必须 JDK 8.x
- 已经安装了 hadoop-2.6.5 集群（**这个细节注意**）
- 因为个人原因，我这里 Hadoop 还是 2.6.5 版本，Spark 要用的是 2.2.0
- Spark 2.2.0 官网文档：<https://spark.apache.org/docs/2.2.0/>
	- 192M，下载速度有点慢
	- `cd /usr/local && wget https://archive.apache.org/dist/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.6.tgz`
- 解压：`tar zxvf spark-2.2.0-bin-hadoop2.6.tgz`
- 重命名：`mv /usr/local/spark-2.2.0-bin-hadoop2.6 /usr/local/spark`
- 增加环境变量：

```
vim /etc/profile

SPARK_HOME=/usr/local/spark
PATH=$PATH:${SPARK_HOME}/bin:${SPARK_HOME}/sbin
export SPARK_HOME
export PATH

source /etc/profile
```

- 修改配置：`cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh`
- 修改配置：`vim $SPARK_HOME/conf/spark-env.sh`
- 假设我的 hadoop 路径是：/usr/local/hadoop-2.6.5，则最尾巴增加：

```
export HADOOP_CONF_DIR=/usr/local/hadoop-2.6.5/etc/hadoop
```

- 因为要交给 YARN 作业，所以到这里就好了。


## 资料

- <https://cloud.tencent.com/developer/article/1010903>
