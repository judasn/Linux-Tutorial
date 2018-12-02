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
- 进入根目录：`cd flink-1.7.0`
- 启动：`./bin/start-cluster.sh`
- 停止：`./bin/stop-cluster.sh`
- 查看日志：`tail -300f log/flink-*-standalonesession-*.log`
- 浏览器访问 WEB 管理：`http://192.168.0.105:8081`

## Demo

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



## 资料

- []()

