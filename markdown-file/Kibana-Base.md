# kibana 知识

## 基础知识

- 官网文档：<https://www.elastic.co/guide/en/kibana/current/getting-started.html>

### 安装 Kibana

- CentOS 7.4
- 至少需要 500M 内存
- 官网文档：<https://www.elastic.co/guide/en/kibana/current/install.html>
- 官网文档 CentOS：<https://www.elastic.co/guide/en/kibana/current/rpm.html>
- 添加 KEY：`rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch`
- 添加源：`vim /etc/yum.repos.d/kibana.repo`

```
[kibana-6.x]
name=Kibana repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```

- 开始安装：`yum install -y kibana`，预计文件有 200M 左右，国内网络安装可能会很慢，慢慢等
	- 安装完后会多了一个：kibana 用户和组
- 启动和停止软件（默认是不启动的）：
	- 启动：`systemctl start kibana.service`
	- 状态：`systemctl status kibana.service`
	- 停止：`systemctl stop kibana.service`
	- 重新启动：`systemctl restart kibana.service`
- 安装完成后，增加系统自启动：
	- `/bin/systemctl daemon-reload`
	- `/bin/systemctl enable kibana.service`

#### RPM 安装后的一些配置位置说明

- 官网文档 CentOS：<https://www.elastic.co/guide/en/kibana/current/rpm.html>
- 配置文件的参数说明：<https://www.elastic.co/guide/en/kibana/6.5/settings.html>
- kibana 安装后位置：`/usr/share/kibana`
- kibana 的配置文件：`/etc/kibana/kibana.yml`
- Log 位置：`/var/log/kibana/`
- 数据位置：`/var/lib/kibana`
- 插件位置：`/usr/share/kibana/plugins`


#### 配置

- 编辑配置文件：`vim /etc/kibana/kibana.yml`
- 默认只能 localhost 访问，修改成支持外网访问

```
打开这个注释：#server.host: "localhost"
改为：server.host: "0.0.0.0"
```

- 然后你可以访问：`http://192.168.0.105:5601`，可以看到 kibana 的相关界面。
	- 1. Create index pattern
		- 如果你 Elasticsearch 新创建了索引，kibana 是不会自动帮你匹配到的，所以要匹配新索引，这一步都要走
	- 2. Discover | 右上角筛选时间区间
		- 这一步非常重要，里面的 filter，图表等都是基于此时间区间的
- 在 logstash 安装这一步，如果你刚刚有按着我说的去做一个 elasticsearch 索引，那你此时不会看到这样的提示：`Unable to fetch mapping. Do you have indices matching the pattern?`
	- 此时你可以直接点击 `create` 统计 `logstash-*` 格式的索引结果，看到相关内容
	- 如果你知道你的索引名称的规则，比如我现在要统计 Tomcat 的相关索引，我的索引名称是：`tomcat-log-*`，则我输入这个，点击：create 即可。


## 资料

- <>
- <>