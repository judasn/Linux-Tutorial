# Kafka 安装和配置

## Kafka 介绍

> A distributed streaming platform

- 官网：<https://kafka.apache.org/>
- 官网下载：<https://kafka.apache.org/downloads>
- 当前最新稳定版本（201803）：**1.0.1**
- 官网 quickstart：<https://kafka.apache.org/quickstart>
- 核心概念：
	- producer：生产者
	- consumer：消费者
	- broker：可以理解为：存放消息的管道（kafka）
	- topic：可以理解为：消息主题、消息标签
- 业界常用的 docker 镜像：
	- [wurstmeister/kafka-docker（不断更新，优先）](https://github.com/wurstmeister/kafka-docker/)
		- 运行的机子不要小于 2G 内存
		- 修改 docker-compose.yml 中参数 KAFKA_ADVERTISED_HOST_NAME，改为你宿主机的 IP 地址
		- 先启动 zookeeper：`docker-compose up -d`
		- 添加 kafka 节点：`docker-compose scale kafka=3`
		- 停止容器：`docker-compose stop`
	- [spotify/docker-kafka](https://github.com/spotify/docker-kafka)


## 资料

- <http://www.ituring.com.cn/article/499268>
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