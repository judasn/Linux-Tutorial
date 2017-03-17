# Logstash 知识

## 基础知识

- 基于 ruby 写的
- 官网文档：<https://www.elastic.co/guide/en/logstash/5.2/first-event.html>
- 如果是通过网络来收集，并不需要所有机子都装，但是如果是要通过读取文件来收集，那文件所在的那个机子就的安装
- 配置文件的写法格式：<https://www.elastic.co/guide/en/logstash/5.2/configuration-file-structure.html>


## 配置文件中的 Filter 讲解

- grok 比较耗 CPU 能少用就尽量少用
- 主要讲解 grok 这个插件，官网资料：<https://www.elastic.co/guide/en/logstash/5.2/plugins-filters-grok.html>
- 官网给我们整理的 120 个正则表达式变量：<https://github.com/logstash-plugins/logstash-patterns-core/tree/master/patterns>
	- 内置的变量格式为，eg：`%{IP}`
	- 而这个格式 `%{IP:client}` 表示把日志中匹配 IP 格式的内容存储到 ES 中的 client 域（字段）中，这样 ES 界面就有单独字段查看，方便。
- 安装完 logstash 本地也是有这些文件的，路径：`/usr/program/elk/logstash-2.4.1/vendor/bundle/jruby/1.9/gems/logstash-patterns-core-2.0.5/patterns`
- 官网简单的日志讲解：
- **新建** 配置文件：`vim /usr/program/elk/logstash-2.4.1/config/filter-grok-test.conf`：

``` nginx
input {
	stdin {
	
	}
}

filter {
	grok {
		match => { "message" => "%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}" }
	}
}

output {
	elasticsearch { 
		hosts => ["192.168.1.127:9200"]
		index => "filter-grok-test"
	}
}
```

- 启动 Logstash 并加载该配置文件：`/usr/program/elk/logstash-2.4.1/bin/logstash -f /usr/program/elk/logstash-2.4.1/config/filter-grok-test.conf`
	- 然后我们在交互界面中分别输入下面内容：
		- `55.3.244.1 GET /index.html 15824 0.043`
		- `125.4.234.22 GET /GitNavi.html 124 0.13`
	- 然后你开始关注 elasticsearch 集群的索引变化。

## 配置文件中的 multiline 多行内容收集插件讲解

- 配置的格式如下：
- 在 file 中的：`codec => multiline`

``` nginx
input {
	file {
		path => ["/usr/program/tomcat8/logs/logbackOutFile.log.*.log"]
		type => "tomcat-log"
		start_position => "beginning"
		codec => multiline {
		    pattern => "^\["
		    negate => true
		    what => "previous"
		}
	}
}

output {
	if [type] == "tomcat-log" {
		elasticsearch { 
			hosts => ["192.168.1.127:9200"]
			index => "tomcat-log-%{+YYYY.MM.dd}"
		}
	}
}
```


## 案例

### 测试模式

#### 自己写正则表达式，匹配后输出到控制台先看下：

- 新建目录（如果存在就不用）：`mkdir -p /usr/program/elk/logstash-2.4.1/config`
- **新建** 配置文件：`vim /usr/program/elk/logstash-2.4.1/config/regexp-test.conf`：

``` nginx
input {
	stdin {
		codec => multiline {
			pattern => "^\["
			negate => true
			what => "previous"
		}
	}
}

output {
	stdout { 
		codec => "rubydebug"
	}
}
```

- 启动 Logstash 并加载该配置文件：`/usr/program/elk/logstash-2.4.1/bin/logstash -f /usr/program/elk/logstash-2.4.1/config/regexp-test.conf`


#### 读取文件，输出到控制台先看下：

- 新建目录（如果存在就不用）：`mkdir -p /usr/program/elk/logstash-2.4.1/config`
- **新建** 配置文件：`vim /usr/program/elk/logstash-2.4.1/config/file-test.conf`：

``` nginx
input {
	file {
		path => ["/var/log/nginx/access.log"]
		type => "nginx-access-log"
		start_position => "beginning"
	}
}

output {
	stdout { 
		codec => "rubydebug"
	}
}
```

- 启动 Logstash 并加载该配置文件：`/usr/program/elk/logstash-2.4.1/bin/logstash -f /usr/program/elk/logstash-2.4.1/config/regexp-test.conf`


### Nginx 日志收集

- 机子：192.168.1.121
	- Nginx 日志位置：
		- `/var/log/nginx/access.log`
		- `/var/log/nginx/error.log`
- 安装 Logstash 过程请看：[ELK 日志收集系统安装和配置](ELK-Install-And-Settings.md)
- 新建目录（如果存在就不用）：`mkdir -p /usr/program/elk/logstash-2.4.1/config`
- **新建** 配置文件：`vim /usr/program/elk/logstash-2.4.1/config/nginx.conf`：

``` nginx
input {
	file {
		path => ["/var/log/nginx/access.log"]
		type => "nginx-access-log"
		start_position => "beginning"
	}
	
	file {
		path => ["/var/log/nginx/error.log"]
		type => "nginx-error-log"
		start_position => "beginning"
	}
}

output {
	if [type] == "nginx-access-log" {
		elasticsearch { 
			hosts => ["192.168.1.127:9200"]
			index => "nginx-access-log"
		}
	}
	
	if [type] == "nginx-error-log" {
		elasticsearch { 
			hosts => ["192.168.1.127:9200"]
			index => "nginx-error-log"
		}
	}
}
```

- 启动 Logstash 并加载该配置文件：`/usr/program/elk/logstash-2.4.1/bin/logstash -f /usr/program/elk/logstash-2.4.1/config/nginx.conf`
- 然后你开始访问 nginx，再关注 elasticsearch 集群的索引变化，如果有新增索引那就表示可以了。

#### 进一步优化：把 nginx 的日志输出格式改为 json

- 配置 nginx 访问日志的输出格式：`vim /usr/local/nginx/conf/nginx.conf`

``` nginx
user root;
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;
    
    log_format json '{"@timestamp":"$time_iso8601",'
                     '"host":"$server_addr",'
                     '"clientip":"$remote_addr",'
                     '"size":$body_bytes_sent,'
                     '"responsetime":$request_time,'
                     '"upstreamtime":"$upstream_response_time",'
                     '"upstreamhost":"$upstream_addr",'
                     '"http_host":"$host",'
                     '"url":"$uri",'
                     '"xff":"$http_x_forwarded_for",'
                     '"referer":"$http_referer",'
                     '"agent":"$http_user_agent",'
                     '"status":"$status"}';
	#全局日志
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    server {
        listen       80;
        server_name  localhost;
		
		# 针对服务的日志输出
		access_log /var/log/nginx/access-json.log json;

        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
```

- 修改 Logstash 的收集
- **编辑** 配置文件：`vim /usr/program/elk/logstash-2.4.1/config/nginx.conf`：

``` nginx
input {
	file {
		path => ["/var/log/nginx/access-json.log"]
		codec => json
		type => "nginx-access-json-log"
		start_position => "beginning"
	}

}

output {
	if [type] == "nginx-access-json-log" {
		elasticsearch { 
			hosts => ["192.168.1.127:9200"]
			index => "nginx-access-json-log"
		}
	}
}
```

- 启动 Logstash 并加载该配置文件：`/usr/program/elk/logstash-2.4.1/bin/logstash -f /usr/program/elk/logstash-2.4.1/config/nginx.conf`
- 然后你开始访问 nginx，再关注 elasticsearch 集群的索引变化，如果有新增索引那就表示可以了。


### Tomcat 日志收集

- 机子：192.168.1.121
	- Tomcat 日志位置：`/usr/program/tomcat8/logs`
- 安装 Logstash 过程请看：[ELK 日志收集系统安装和配置](ELK-Install-And-Settings.md)
- 新建目录（如果存在就不用）：`mkdir -p /usr/program/elk/logstash-2.4.1/config`
- **新建** 配置文件：`vim /usr/program/elk/logstash-2.4.1/config/tomcat.conf`：

``` nginx
input {
	file {
		path => ["/usr/program/tomcat8/logs/logbackOutFile.log.*.log"]
		type => "tomcat-log"
		start_position => "beginning"
		codec => multiline {
		    pattern => "^\["
		    negate => true
		    what => "previous"
		}
	}
}

output {
	if [type] == "tomcat-log" {
		elasticsearch { 
			hosts => ["192.168.1.127:9200"]
			index => "tomcat-log-%{+YYYY.MM.dd}"
		}
	}
}
```

- 启动 Logstash 并加载该配置文件：`/usr/program/elk/logstash-2.4.1/bin/logstash -f /usr/program/elk/logstash-2.4.1/config/tomcat.conf`
- 然后你开始访问 nginx，再关注 elasticsearch 集群的索引变化，如果有新增索引那就表示可以了。


### MySQL 慢 SQL 日志收集

- 其他的细节都跟上面一样不多说了，配置文件这里需要用到 grok 进行正则的拆分
- 这里有资料，我觉得别人已经说得很好了（Google 关键字：`grok mysql slow`）：
	- <http://soft.dog/2016/01/30/logstash-mysql-slow-log/>
	- <https://kibana.logstash.es/content/logstash/examples/mysql-slow.html>
	- <https://leejo.github.io/2013/11/21/parsing_mysql_slow_query_log_with_logstash/>
	- <https://www.phase2technology.com/blog/adding-mysql-slow-query-logs-to-logstash/>
	- <https://discuss.elastic.co/t/grok-filter-for-mysql-slow-logs-produces-grokparsefailure-but-passes-tests/55799>

```
"(?m)^#\s+User@Host:\s+%{USER:user}\[[^\]]+\]\s+@\s+%{USER:clienthost}\s+\[(?:%{IP:clientip})?\]\s+Id:\s+%{NUMBER:id:int}\n#\s+Schema:\s+%{USER:schema}\s+Last_errno:\s+%{NUMBER:lasterrorno:int}\s+Killed:\s+%{NUMBER:killedno:int}\n#\s+Query_time:\s+%{NUMBER:query_time:float}\s+Lock_time:\s+%{NUMBER:lock_time:float}\s+Rows_sent:\s+%{NUMBER:rows_sent:int}\s+Rows_examined:\s+%{NUMBER:rows_examined:int}\s+Rows_affected:\s+%{NUMBER:rows_affected:int}\n#\s+Bytes_sent:\s+%{NUMBER:bytes_sent:int}\n\s*(?:use\s+%{USER:usedatabase};\s*\n)?SET\s+timestamp=%{NUMBER:timestamp};\n\s*(?<query>(?<action>\w+)\b.*)\s*(?:\n#\s+Time)?.*$"
```

### Logstash 不直接写到 ES 先写到 Redis 再写到 ES

- 官网 Redis 插件使用说明：<https://www.elastic.co/guide/en/logstash/2.4/plugins-inputs-redis.html>

#### 一台 Logstash 把数据写到 Redis

- Redis 机器 IP：192.168.1.125
- Logstash 机器 IP：192.168.1.121
- Logstash 机器 **新建** 配置文件：`vim /usr/program/elk/logstash-2.4.1/config/redis-test.conf`：

``` nginx
input {
	stdin {
		
	}
}

output {
	redis {
		host => "192.168.1.125"
		port => "6379"
		db => "2"
		data_type => "list"
		key => "gitnavi-logstash-info"
	}
}
```

- 启动 Logstash 并加载该配置文件：`/usr/program/elk/logstash-2.4.1/bin/logstash -f /usr/program/elk/logstash-2.4.1/config/redis-test.conf`
	- 然后我们在交互界面中分别输入下面内容：
	- `hello` 回车
	- `world` 回车
- 进入 Redis 机器上的数据：
	- 进入 redis 交互端：`redis-cli`
	- 查询 db2：`select 2`
	- 查询 db2 下的所有内容：`keys *`，可以看到有一个："gitnavi-logstash-info"
	- 查询该 list 类型的数据：`LRANGE gitnavi-logstash-info 0 1`，正常可以得到这样的数据

``` json
1) "{\"message\":\"hello\",\"@version\":\"1\",\"@timestamp\":\"2017-03-15T15:23:35.064Z\",\"host\":\"youmeekhost\"}"
2) "{\"message\":\"world\",\"@version\":\"1\",\"@timestamp\":\"2017-03-15T15:23:37.245Z\",\"host\":\"youmeekhost\"}"
```

#### 一台 Logstash 把数据从 Redis 读取出来写到 ES

- Redis 机器 IP：192.168.1.125
- Logstash 机器 IP：192.168.1.125
- Logstash 机器 **新建** 配置文件：`vim /usr/program/elk/logstash-2.4.1/config/redis-test.conf`：

``` nginx
input {
	redis {
		type => "redis-log"
		host => "192.168.1.125"
		port => "6379"
		db => "2"
		data_type => "list"
		key => "gitnavi-logstash-info"
	}
}

output {
	if [type] == "redis-log" {
		elasticsearch {
	        hosts => ["192.168.1.127:9200"]
	        index => "redis-log"
	    }
    }
}
```

- 启动 Logstash 并加载该配置文件：`/usr/program/elk/logstash-2.4.1/bin/logstash -f /usr/program/elk/logstash-2.4.1/config/redis-test.conf`
- 然后现在在 Logstash 机器 IP：192.168.1.121 上继续输入一些内容，看下 ES 集群是否有对应的索引创建。

### Logstash 不直接写到 ES 先写到 MQ 再写到 ES

- 官网 RabbitMQ 插件使用说明：<https://www.elastic.co/guide/en/logstash/2.4/plugins-inputs-rabbitmq.html>

#### 一台 Logstash 把数据写到 rabbitMQ

``` nginx
input {
	file {
		path => "/usr/local/tomcat/logs/tomcat_json.log"
		codec => "json"
		type => "tomcat"
	}
}

output {
	rabbitmq { 
		host => "RabbitMQ_server"
		port => "5672"
		vhost => "elk"
		exchange => "elk_exchange"
		exchange_type => "direct"
		key => "elk_key"
		user => "liang"
		password => "liang123"
	}
	stdout { 
		codec => rubydebug 
	}
}
```

#### 一台 Logstash 把数据从 rabbitMQ 读取出来写到 ES （还未测试）


``` nginx
input {
	rabbitmq {
		host => "127.0.0.1"
		subscription_retry_interval_seconds => "5"
		vhost => "elk"
		exchange => "elk_exchange"
		queue => "elk_queue"
		durable => "true"
		key => "elk_key"
		user => "liang"
		password => "liang123"
	}
}

output {

	if [type] == "nginx" {
		elasticsearch {
			hosts => "192.168.1.127:9200"
			user => "logstash"
			password => "123456"
			index => "nginx-%{+YYYY.MM.dd}"
		}
	}
	
	if [type] == "tomcat" {
		elasticsearch {
			hosts => "192.168.1.127:9200"
			user => "logstash"
			password => "123456"
			index => "tomcat-%{+YYYY.MM.dd}"
		}
	}

	stdout { 
		codec => rubydebug 
	}
}
```



## 资料

- <https://liang178.github.io/2016/08/11/elk+rabbitmq/>
- <>