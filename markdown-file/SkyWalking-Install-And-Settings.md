# SkyWalking 安装和配置


## OpenAPM 相关

- 目前市场工具一览：<https://openapm.io/landscape>
- 目前最活跃的标准：[OpenTracing](https://opentracing.io/)
- 现在比较活跃的应该是：
    - [Jaeger](https://www.jaegertracing.io/)
    - [SkyWalking](https://skywalking.apache.org/)


## 官网资料

- 当前时间：2019-05，最新版本：6.1
- 官网：<https://skywalking.apache.org/>
- 官网 Github：<https://github.com/apache/skywalking>
- 官网文档：<https://github.com/apache/skywalking/blob/master/docs/README.md>
- 官网下载：<http://skywalking.apache.org/downloads/>
    - 该网页显示：官网目前推荐的是通过源码构建出包，docker 镜像推荐
    - 源码构建方法：<https://github.com/apache/skywalking/blob/master/docs/en/guides/How-to-build.md>
- 这里简单抽取下核心内容：
- 至少需要 jdk8 + maven3
- 需要 Elasticsearch
    - Elasticsearch 和 SkyWalking 的所在服务器的时间必须一致
    - 看了下源码依赖的 Elasticsearch 依赖包，目前支持 5.x 和 6.x


## 支持收集的组件列表

- 国内常用的组件目前看来都支持了
- <https://github.com/apache/skywalking/blob/master/docs/en/setup/service-agent/java-agent/Supported-list.md>


## 基于 IntelliJ IDEA 直接运行、Debug

- 这里选择 IntelliJ IDEA 运行服务，方便我们 debug 了解 SkyWalking：<https://github.com/apache/skywalking/blob/master/docs/en/guides/How-to-build.md#setup-your-intellij-idea>

```
cd skywalking/

git submodule init

git submodule update

mvn clean package -DskipTests

因为需要设置 gRPC 的自动生成的代码目录，为源码目录，所以：
手工将下面提到的目录下的 grpc-java 和 java 目录设置为 IntelliJ IDEA 的源码目录（Sources Root）
/skywalking/apm-protocol/apm-network/target/generated-sources/protobuf
/skywalking/oap-server/server-core/target/generated-sources/protobuf
/skywalking/oap-server/server-receiver-plugin/receiver-proto/target/generated-sources/protobuf
/skywalking/oap-server/exporter/target/generated-sources/protobuf


手工将下面提到的目录下的 antlr4 目录设置为 IntelliJ IDEA 的源码目录（Sources Root）
/skywalking/oap-server/generate-tool-grammar/target/generated-sources

手工将下面提到的目录下的 oal 目录设置为 IntelliJ IDEA 的源码目录（Sources Root）
/skywalking/oap-server/generated-analysis/target/generated-sources

```

#### 启动 Server 项目

- 现在可以通过 IntelliJ IDEA 启动服务：
- 编辑 server 配置：`/skywalking/oap-server/server-starter/src/main/resources/application.yml`
    - 里面有关 Elasticsearch 连接信息的配置，你可以根据自己的情况进行配置。
- 启动类：`/skywalking/oap-server/server-starter/src/main/java/org/apache/skywalking/oap/server/starter/OAPServerStartUp.java`
    - 第一次启动会创建 540 个左右的 Elasticsearch 索引库，会花点时间。


#### 启动 UI 项目


- 现在启动 UI 项目，找到：`/skywalking/apm-webapp/src/main/java/org/apache/skywalking/apm/webapp/ApplicationStartUp.java`
- 访问 UI 地址：<http://127.0.0.1:8080>
    - 用户名：admin
    - 密码：admin


## Java Agent（探针）


#### IntelliJ IDEA 项目调试

- 前面构建服务的时候记得构建出 jar 包出来，这里要用到
- 自己的 Spring Boot 项目
- 引包：

```
<!--SkyWalking start-->
<!-- https://mvnrepository.com/artifact/org.apache.skywalking/apm-toolkit-trace -->
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-trace</artifactId>
    <version>6.1.0</version>
</dependency>
<!--SkyWalking end-->
```

- 常用注解：


```
@Trace
@ApiOperation(tags = {"用户系统管理->用户管理->用户列表"}, value = "查询所有用户列表", notes = "查询所有用户列表")
@RequestMapping(value = "/list", method = RequestMethod.GET)
@ResponseBody
public List<SysUser> list() {
    List<SysUser> sysUserList = sysUserService.findAll();
    ActiveSpan.tag("一共有数据：", sysUserList.size() + "条");
    log.info("当前 traceId={}", TraceContext.traceId());
    return sysUserList;
}

```

- 更多注解的使用：<https://github.com/apache/skywalking/blob/master/docs/en/setup/service-agent/java-agent/Application-toolkit-trace.md>

- 你的 demo 项目在 IntelliJ IDEA 启动的时候加上 VM 参数上设置：

```
-javaagent:/你自己的路径/skywalking-agent.jar -Dskywalking.agent.application_code=my_app_001 -Dskywalking.collector.backend_service=localhost:11800
```

- 默认 11800 是 gRPC 的接收接口
- 你自己构建出来的 jar 路径一般是：`/skywalking/apm-sniffer/apm-agent/target/skywalking-agent.jar`
- 然后请求你带有 Trace 的 Controller，然后去 UI 界面看统计情况

#### jar 包方式

- 你的 Spring Boot jar 包 run 之前加上 VM 参数：

```
java -javaagent:/你自己的路径/skywalking-agent.jar -Dskywalking.collector.backend_service=localhost:11800 -Dskywalking.agent.application_code=my_app_002 -jar my-project-1.0-SNAPSHOT.jar
```


#### Docker 方式

- Dockerfile

```
FROM openjdk:8-jre-alpine

LABEL maintainer="tanjian20150101@gmail.com"

ENV SW_APPLICATION_CODE=java-agent-demo \
	SW_COLLECTOR_SERVERS=localhost:11800

COPY skywalking-agent /apache-skywalking-apm-incubating/agent

COPY target/sky-demo-1.0-SNAPSHOT.jar /demo.jar

ENTRYPOINT java -javaagent:/apache-skywalking-apm-incubating/agent/skywalking-agent.jar -Dskywalking.collector.backend_service=${SW_COLLECTOR_SERVERS} \
-Dskywalking.agent.application_code=${SW_APPLICATION_CODE} -jar /demo.jar
```

- 构建镜像：

```
docker build -t hello-demo .
docker run -p 10101:10101 -e SW_APPLICATION_CODE=hello-world-demo-005 -e SW_COLLECTOR_SERVERS=127.10.0.2:11800 hello-demo
```



## 构建 jar 部署在服务器

- 如果想直接打包出 jar 部署与服务器，只需要这样：<https://github.com/apache/skywalking/blob/master/docs/en/guides/How-to-build.md#build-from-github>

```
cd skywalking/

git submodule init

git submodule update

mvn clean package -DskipTests
```

## 告警配置

- <https://skywalking.apache.org/zh/blog/2019-01-03-monitor-microservice.html>


## 资料

- <https://skywalking.apache.org/zh/blog/2018-12-21-SkyWalking-source-code-read.html>
- <https://github.com/JaredTan95/skywalking-tutorials>
- <https://www.bilibili.com/video/av40796154?from=search&seid=8779011383117018227>
- <https://skywalking.apache.org/zh/blog/2019-01-03-monitor-microservice.html>
- <>
- <>
- <>
- <>






