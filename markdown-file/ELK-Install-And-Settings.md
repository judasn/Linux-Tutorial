# ELK（Elasticsearch、Logstash、Kibana）安装和配置

## 版本说明

- 本文包含了：Elasticsearch 2.4.X 和 Elasticsearch 5.2.X 和 Elasticsearch 5.5.X，请有针对性地选择。

## 教程说明


- 官网：<https://www.elastic.co/>
- 官网总文档：<https://www.elastic.co/guide/index.html>
- 官网最终指南：<https://www.elastic.co/guide/en/elasticsearch/guide/current/administration.html#administration>
- 官网对各个系统的支持列表：<https://www.elastic.co/support/matrix>
- 5.2 版本有一个设置的新特性必须了解，测试建议我们用 CentOS 7：<https://www.elastic.co/guide/en/elasticsearch/reference/5.x/breaking-changes-5.2.html#_system_call_bootstrap_check>
- Elasticsearch 开源分布式搜索引擎，它的特点有：分布式，零配置，自动发现，索引自动分片，索引副本机制，restful 风格接口，多数据源，自动搜索负载等。
- Logstash 日志进行收集、分析，并将其存储供以后使用（如，搜索）
- kibana 为 Logstash 和 ElasticSearch 提供的日志分析友好的 Web 界面，可以帮助您汇总、分析和搜索重要数据日志。


### Elasticsearch 部署

- 请看 Elasticsearch 专题文：[Elasticsearch 相关知识](Elasticsearch-Base.md)


### logstash

- 请看 logstash 专题文：[logstash 相关知识](Logstash-Base.md)

### 安装 Kibana

- 选择一台机子安装即可，我选择：192.168.1.127 这台
- 切换到存放目录：`cd /usr/program/elk`
- 解压：`tar zxvf kibana-4.6.1-linux-x86_64.tar.gz`
- 修改配置文件：`vim /usr/program/elk/kibana-4.6.1-linux-x86_64/config/kibana.yml`，打开下面注释并配置：

``` nginx
server.port: 5601                                  #端口
server.host: "192.168.1.127"                        #访问ip地址
elasticsearch.url: "http://192.168.1.127:9200"      #连接elastic               
kibana.index: ".kibana"                            #在elastic中添加.kibana索引
```

- 记得先切换到 elasticsearch 用户下，然后先启动 elasticsearch。先确保 elasticsearch 集群是启动的。
- 再切换到 root 用户下，启动 kibana
- 带控制台的启动（比较慢）：`/usr/program/elk/kibana-4.6.1-linux-x86_64/bin/kibana`
- 守护进程方式启动：`/usr/program/elk/kibana-4.6.1-linux-x86_64/bin/kibana -d`
- 守护进程方式停止：`ps -ef|grep kibana`，只能通过 kill pid 来结束
- 然后你可以访问：`http://192.168.1.127:5601`，可以看到 kibana 的相关界面。
- 在 logstash 安装这一步，如果你刚刚有按着我说的去做一个 elasticsearch 索引，那你此时不会看到这样的提示：`Unable to fetch mapping. Do you have indices matching the pattern?`
	- 此时你可以直接点击 `create` 统计 `logstash-*` 格式的索引结果，看到相关内容
	- 如果你知道你的索引名称的规则，比如我现在要统计 Tomcat 的相关索引，我的索引名称是：`tomcat-log-*`，则我输入这个，点击：create 即可。
- kibana 的高级用法请看我单独的一篇文章：[kibana 相关知识](Kibana-Base.md)


## 资料

- <http://www.centoscn.com/CentosServer/test/2017/0304/8575.html>
- <https://blog.yourtion.com/install-x-pack-for-elasticsearch-and-kibana.html>
- <http://www.voidcn.com/blog/987146971/article/p-6290041.html>
- <http://www.web520.cn/archives/31077>
- <>
- <>
