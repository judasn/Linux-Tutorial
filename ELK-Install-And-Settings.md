# ELK（Elasticsearch、Logstash、Kibana）安装和配置


## 本机环境

- 两台机子CPU 1 核，内存 4G
	- 192.168.1.126
	- 192.168.1.127
- 系统：CentOS 7.3 64 位
- 依赖环境：JDK 1.8，所在目录：`/usr/program/jdk1.8.0_121`


## 说明


- 官网：<https://www.elastic.co/>
- 官网总文档：<https://www.elastic.co/guide/index.html>
- 官网最终指南：<https://www.elastic.co/guide/en/elasticsearch/guide/current/administration.html#administration>
- 此时（201703）最新版本：**5.2**，但是我在使用过程中有很多坑，暂时又退回到 **2.X**
- 官网对各个系统的支持列表：<https://www.elastic.co/support/matrix>
- 5.2 版本有一个设置的新特性必须了解，测试建议我们用 CentOS 7：<https://www.elastic.co/guide/en/elasticsearch/reference/5.x/breaking-changes-5.2.html#_system_call_bootstrap_check>
- Elasticsearch 开源分布式搜索引擎，它的特点有：分布式，零配置，自动发现，索引自动分片，索引副本机制，restful 风格接口，多数据源，自动搜索负载等。
- Logstash 日志进行收集、分析，并将其存储供以后使用（如，搜索）
- kibana 为 Logstash 和 ElasticSearch 提供的日志分析友好的 Web 界面，可以帮助您汇总、分析和搜索重要数据日志。


## 2.4.X 

### 安装 elasticsearch 集群

### 下载

- 下载在我个人习惯的子自己创建的目录下：/usr/program/elk
- elasticsearch 2.4.1（26 M）：`wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-2.4.1.tar.gz`
- logstash 2.4.0（80 M）：`wget https://download.elastic.co/logstash/logstash/logstash-2.4.1.tar.gz`
- kibana 4.6.1（32 M）：`wget https://download.elastic.co/kibana/kibana/kibana-4.6.1-linux-x86_64.tar.gz`

### tar 解压安装

- **确保系统安装有 JDK**
- 官网文档：<https://www.elastic.co/guide/en/elasticsearch/reference/5.2/zip-targz.html>
- 添加日志存放目录、数据存放目录：`mkdir -p /opt/elasticsearch/data /opt/elasticsearch/log`
- 添加组和用户
	- 该版本不能使用 root 用户进行使用
	- `useradd elasticsearch -p 123456`，添加一个名为 elasticsearch 的用户，还有一个同名的组
- 解压下载的文件
	- `cd /usr/program/elk`
	- `tar zxvf elasticsearch-2.4.1.tar.gz`
- 赋权限：
	- `chown -R elasticsearch:elasticsearch /usr/program/elk /opt/elasticsearch`
- 我 tar 安装后一些路径说明：
	- home：`/usr/program/elk/elasticsearch-2.4.1`
	- bin：`/usr/program/elk/elasticsearch-2.4.1/bin`
	- 配置文件：`/usr/program/elk/elasticsearch-2.4.1/config/elasticsearch.yml`
	- plugins：`/usr/program/elk/elasticsearch-2.4.1/plugins`
	- script：`/usr/program/elk/elasticsearch-2.4.1/scripts`
	- data：`/opt/elasticsearch/data`
	- log：`/opt/elasticsearch/log/集群名称.log`
- 编辑配置文件：`vim /usr/program/elk/elasticsearch-2.4.1/config/elasticsearch.yml`，打开下面注释，并修改

``` nginx
cluster.name: gitnavi-cluster
node.name: gitnavi-node-1
path.data: /opt/elasticsearch/data
path.logs: /opt/elasticsearch/log
bootstrap.memory_lock: true
network.host: 0.0.0.0 # 也可以是本机 IP
http.port: 9200
discovery.zen.ping.multicast.enabled: false
discovery.zen.ping.unicast.hosts: ["192.168.1.127", "192.168.1.126"]  #这个为两台机子的 IP 地址
```

- 修改这个配置文件，不然无法锁内存：`vim /etc/security/limits.conf`
- 在文件最尾部增加下面内容：

``` nginx
# allow user 'elasticsearch' mlockall
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
* soft nofile 65536
* hard nofile 65536
```

- 关闭 firewall
	- `systemctl stop firewalld.service` #停止firewall
	- `systemctl disable firewalld.service` #禁止firewall开机启动

- 切换到 elasticsearch 用户下：`su elasticsearch`
- 带控制台的启动（比较慢）：`/usr/program/elk/elasticsearch-2.4.1/bin/elasticsearch`
	- 控制台会输出类似这样的信息：

```
[2017-03-13 18:42:51,170][INFO ][node                     ] [gitnavi-node-1] version[2.4.1], pid[21156], build[c67dc32/2016-09-27T18:57:55Z]
[2017-03-13 18:42:51,177][INFO ][node                     ] [gitnavi-node-1] initializing ...
[2017-03-13 18:42:51,821][INFO ][plugins                  ] [gitnavi-node-1] modules [reindex, lang-expression, lang-groovy], plugins [head, kopf], sites [head, kopf]
[2017-03-13 18:42:51,852][INFO ][env                      ] [gitnavi-node-1] using [1] data paths, mounts [[/ (rootfs)]], net usable_space [12.4gb], net total_space [17.4gb], spins? [unknown], types [rootfs]
[2017-03-13 18:42:51,852][INFO ][env                      ] [gitnavi-node-1] heap size [1015.6mb], compressed ordinary object pointers [true]
[2017-03-13 18:42:54,094][INFO ][node                     ] [gitnavi-node-1] initialized
[2017-03-13 18:42:54,094][INFO ][node                     ] [gitnavi-node-1] starting ...
[2017-03-13 18:42:54,175][INFO ][transport                ] [gitnavi-node-1] publish_address {192.168.1.127:9300}, bound_addresses {[::]:9300}
[2017-03-13 18:42:54,178][INFO ][discovery                ] [gitnavi-node-1] gitnavi-cluster/-XywT60EScO-9lgzjfnsgg
[2017-03-13 18:42:57,344][INFO ][cluster.service          ] [gitnavi-node-1] new_master {gitnavi-node-1}{-XywT60EScO-9lgzjfnsgg}{192.168.1.127}{192.168.1.127:9300}, reason: zen-disco-join(elected_as_master, [0] joins received)
[2017-03-13 18:42:57,410][INFO ][gateway                  ] [gitnavi-node-1] recovered [0] indices into cluster_state
[2017-03-13 18:42:57,414][INFO ][http                     ] [gitnavi-node-1] publish_address {192.168.1.127:9200}, bound_addresses {[::]:9200}
[2017-03-13 18:42:57,414][INFO ][node                     ] [gitnavi-node-1] started
```

- 守护进程方式启动：`/usr/program/elk/elasticsearch-2.4.1/bin/elasticsearch -d`
- 守护进程方式停止：`ps -ef|grep elasticsearc`，只能通过 kill pid 来结束
- 访问：`http://192.168.1.127:9200/`，可以看到如下内容：

``` json
{
  "name" : "gitnavi-node-1",
  "cluster_name" : "gitnavi-cluster",
  "cluster_uuid" : "0b66dYpnTd-hh7x4Phfm1A",
  "version" : {
    "number" : "2.4.1",
    "build_hash" : "c67dc32e24162035d18d6fe1e952c4cbcbe79d16",
    "build_timestamp" : "2016-09-27T18:57:55Z",
    "build_snapshot" : false,
    "lucene_version" : "5.5.2"
  },
  "tagline" : "You Know, for Search"
}
```

- 插件（插件的迭代很容易跟不上官网的版本，所以请牢记关注插件官网的说明）
	- head，节点数据查看管理：<https://github.com/mobz/elasticsearch-head>
	- kopf，集群管理：<https://github.com/lmenezes/elasticsearch-kopf>
	- Bigdesk，监控查看CPU内存索引数据搜索情况http连接数：<https://github.com/hlstudio/bigdesk>
- 安装（过程比较慢）
	- head：`/usr/program/elk/elasticsearch-2.4.1/bin/plugin install mobz/elasticsearch-head`
		- 安装完的访问地址：`http://192.168.1.127:9200/_plugin/head`
    - kopf：`/usr/program/elk/elasticsearch-2.4.1/bin/plugin install lmenezes/elasticsearch-kopf`
		- 安装完的访问地址：`http://192.168.1.127:9200/_plugin/kopf`
    - Bigdesk：`/usr/program/elk/elasticsearch-2.4.1/bin/plugin install hlstudio/bigdesk`
		- 安装完的访问地址：`http://192.168.1.127:9200/_plugin/bigdesk`
	- 卸载：`/usr/share/elasticsearch/bin/elasticsearch-plugin remove 插件名称`

### 构建 elasticsearch 集群

- 另外一台机子也同样这样安装，但是有几个地方有差别：
	- 特别注意：集群的关键点是配置文件中的：cluster.name，这个一样就表示在一个集群中
	- 配置文件：`/usr/program/elk/elasticsearch-2.4.1/config/elasticsearch.yml`
	    - node 名称改为不一样的，比如我这边改为 2：node.name: gitnavi-node-2 
	- 插件不用安装，有一台机子安装即可
	- 先启动装有 head 的机子，然后再启动另外一台，这样好辨别

### logstash

- logstash 基于 ruby，也需要 JDK 环境
- 如果是通过网络来收集，并不需要所有机子都装，但是如果是要通过读取文件来收集，那文件所在的那个机子就的安装 logstash
- 安装：
	- 切换到存放目录：`cd /usr/program/elk`
	- 解压：`tar zxvf logstash-2.4.1.tar.gz`
- 切换到 root 用户下，启动 logstash
- 带控制台的启动（比较慢）进行最简单的 hello world 测试：`/usr/program/elk/logstash-2.4.1/bin/logstash -e 'input { stdin { } } output { stdout { codec => rubydebug} }'`
	-  启动后显示如下内容：
	
	``` nginx
	Settings: Default pipeline workers: 1
	Pipeline main started
	```
	
	- 然后此时的光标是为可输入状态，我们输入：hello world 回车，然后应该会得到这样的结果：
	
	``` json
	{
	       "message" => "hello world",
	      "@version" => "1",
	    "@timestamp" => "2017-03-14T06:56:44.690Z",
	          "host" => "youmeeklocalhost"
	}
	```

- 现在进一步加深，把控制台输入的内容放在 elasticsearch 索引中
- 记得先切换到 elasticsearch 用户下，然后先启动 elasticsearch。先确保 elasticsearch 集群是启动的。
- 带控制台的启动（比较慢）：`/usr/program/elk/logstash-2.4.1/bin/logstash -e 'input { stdin { } } output { elasticsearch { hosts => ["192.168.1.127:9200"] } }'`
	-  启动后显示如下内容：
	
	``` nginx
	Settings: Default pipeline workers: 1
	Pipeline main started
	```
	
	- 然后此时的光标是为可输入状态，我们输入任意内容回车，然后访问 elasticsearch 的 head 插件控制台：`http://192.168.1.127:9200/_plugin/head/`
	- 然后你可以看到有一个类似这样的名称格式的索引：`logstash-2017.03.14`，这一步必须有，等下 kibana 会用到这个索引
- logstash 的高级用法请看我单独的一篇文章：[logstash 相关知识](Logstash-Base.md)

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


//==================================================================================================================================================================

## 5.2 安装（未完成）

### RPM 安装

- 官网总的安装文档：<https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html>

### 安装 Elasticsearch

- 确保安装有 JDK
- 官网文档：<https://www.elastic.co/guide/en/elasticsearch/reference/5.2/install-elasticsearch.html>
- 创建 repo 文件：`vim /etc/yum.repos.d/elasticsearch.repo`，文件内容如下：

``` ini
[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```

- 引入 key：`rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch`
- 开始安装：`yum install -y elasticsearch`
- 如果网络慢下载不了，那可以手动安装：
	- 下载：`wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.2.rpm`
	- 安装：`rpm --install elasticsearch-5.2.2.rpm`
- 添加自启动：`systemctl enable elasticsearch.service`
- 因为我的 JDK 是解压版本，不是 yum 安装的，所以这里要配置 JDK 路径：`vim /etc/sysconfig/elasticsearch`
	- 找到 JAVA_HOME，打开注释，写上你的 JDK 路径即可
- 修改配置：
	- 创建数据目录：`mkdir -p /opt/elasticsearch/data`
	- 给 ELK 系统用户授权：`chown -R elasticsearch:elasticsearch /opt/elasticsearch/data`
	- 修改配置：`vim /etc/elasticsearch/elasticsearch.yml`，打开下面这些内容的注释，并修改：
	
	``` nginx
	cluster.name: gitnavi-cluster
	node.name: gitnavi-node-1
	path.data: /opt/elasticsearch/data
	path.logs: /var/log/elasticsearch
	bootstrap.memory_lock: true
	network.host: 本机 IP 地址
	http.port: 9200
	discovery.zen.ping.multicast.enabled: false
    discovery.zen.ping.unicast.hosts: ["192.168.1.127", "192.168.1.126"]  #这个为两台机子的 IP 地址，ES 从2.0版本开始，默认的自动发现方式改为了单播(unicast)方式
	```

	- 修改这个配置文件，不然无法锁内存：`vim /etc/security/limits.conf`
	- 增加下面内容：
	
	``` nginx
	# allow user 'elasticsearch' mlockall
	elasticsearch soft memlock unlimited
	elasticsearch hard memlock unlimited
	* soft nofile 65536
	* hard nofile 65536
	```

- 修改：`vim /etc/sysctl.conf`，添加下面配置

``` ini
vm.max_map_count=655360
```

- 启动（比较慢，耐心点）：`systemctl start elasticsearch.service`
- 查看启动日志：`tail -500f /var/log/elasticsearch/节点名.log`
- 停止：`systemctl stop elasticsearch.service`
- rpm 安装后一些路径说明：
	- home：`/usr/share/elasticsearch`
	- bin：`/usr/share/elasticsearch/bin`
	- 配置文件：`/etc/elasticsearch/elasticsearch.yml`
	- 变量配置文件：`/etc/sysconfig/elasticsearch`
	- log：`/var/log/elasticsearch/集群名称.log`
	- plugins：`/usr/share/elasticsearch/plugins`
	- data：`/var/lib/elasticsearch`，只是我在上面改到 /opt 目录下了
	- script：`/etc/elasticsearch/scripts`

### 安装 X-Pack 或是其他插件

- X-Pack 是官网提供的管理增强工具，但是全部功能收费，有一个月使用，有部分功能免费。其他免费的插件。
	- licence 的用法可以看这篇文章：
		- <http://blog.csdn.net/abcd_d_/article/details/53178798>
		- <http://blog.csdn.net/AbnerSunYH/article/details/53436212>
		- 破解：<http://www.lofter.com/lpost/33be15_d4fd028>
	- 免费插件：
	- head - 节点数据查看管理：<https://github.com/mobz/elasticsearch-head>
	- kopf - 集群管理：<https://github.com/lmenezes/elasticsearch-kopf>
- 官网说明：<https://www.elastic.co/guide/en/x-pack/5.2/installing-xpack.html>
- 安装（过程比较慢）：`/usr/share/elasticsearch/bin/elasticsearch-plugin install x-pack`
- 如果线上安装速度太慢，那就离线安装：
	- 下载，我放在 /opt 目录下（119M）：`wget https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-5.2.2.zip`
	- 安装：`/usr/share/elasticsearch/bin/elasticsearch-plugin install file:///opt/x-pack-5.2.2.zip`
- 卸载：`/usr/share/elasticsearch/bin/elasticsearch-plugin remove x-pack`
- 安装后重启服务，重启后访问你会发现需要用户和密码，我们可以关掉这个，在 elasticsearch.yml 中添加：`xpack.security.enabled: false`
- 其他 5.2 资料：
	- <https://blog.yourtion.com/install-x-pack-for-elasticsearch-and-kibana.html>
	- <https://www.ko178.cn/?p=353>
	- <https://my.oschina.net/HeAlvin/blog/828639>
	- <http://www.jianshu.com/p/004765d2238b>
	- <http://www.cnblogs.com/delgyd/p/elk.html>
	- <http://www.itdadao.com/articles/c15a1135185p0.html>
	- <http://www.busyboy.cn/?p=920>
	- <http://nosmoking.blog.51cto.com/3263888/1897989>


## 资料

- <http://www.centoscn.com/CentosServer/test/2017/0304/8575.html>
- <https://blog.yourtion.com/install-x-pack-for-elasticsearch-and-kibana.html>
- <http://www.voidcn.com/blog/987146971/article/p-6290041.html>
- <http://www.web520.cn/archives/31077>
- <>
- <>