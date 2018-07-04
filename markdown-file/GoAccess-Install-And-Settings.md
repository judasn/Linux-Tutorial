# GoAccess 安装和配置

## 官网资料

- 一般用于  Apache, Nginx 的 Log 分析
- 官网：<https://goaccess.io/>
- 官网下载（201807 最新版本 1.2）：<https://goaccess.io/download>
- 官网 Github：<https://github.com/allinurl/goaccess>
- 国内中文站：<https://goaccess.cc/>


## 安装（CentOS 7.4）

- 注意，如果是在 CentOS 6 下安装会碰到一些问题，可以参考：<https://www.jianshu.com/p/7cacc1d20588>

- 1. 安装依赖包

```
yum install -y ncurses-devel
wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz
tar -zxvf GeoIP.tar.gz
cd GeoIP-1.4.8/
./configure
make && make install
```

- 2. 安装 GoAccess

```
wget http://tar.goaccess.io/goaccess-1.2.tar.gz
tar -xzvf goaccess-1.2.tar.gz
cd goaccess-1.2/ 
./configure --enable-utf8 --enable-geoip=legacy
make && make install
```

## 配置

- 假设你 nginx 安装在：`/usr/local/nginx`
- 假设你 nginx 的 log 输出到：`/var/log/nginx`
- 修改 `vim /usr/local/nginx/conf/nginx.conf` 指定 nginx 的日志格式

```

http {
	charset  utf8;

	log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
	                '$status $body_bytes_sent "$http_referer" '
	                '"$http_user_agent" "$http_x_forwarded_for" "$request_time"';

	access_log /var/log/nginx/access.log main;
	error_log /var/log/nginx/error.log;
}
```

- 停止 nginx：`/usr/local/nginx/sbin/nginx -s stop`
- 备份旧的 nginx log 文件：`mv /var/log/nginx/access.log /var/log/nginx/access.log.20180702back`
- 启动 nginx：`/usr/local/nginx/sbin/nginx`
- 创建 GoAccess 配置文件：`vim /etc/goaccess_log_conf_nginx.conf` 

```
time-format %T
date-format %d/%b/%Y
log_format %h - %^ [%d:%t %^] "%r" %s %b "%R" "%u" "%^" %^ %^ %^ %T
```


## 使用

#### 在终端上展示数据

```
goaccess -a -d -f /var/log/nginx/access.log -p /etc/goaccess_log_conf_nginx.conf
```


#### 手动生成当前统计页面

```
goaccess -f /var/log/nginx/access.log -p /etc/goaccess_log_conf_nginx.conf -o /usr/local/nginx/report/index.html
```

- 更多参数用法：

```
时间分布图上：按小时展示数据：
goaccess -f /var/log/nginx/access.log -p /etc/goaccess_log_conf_nginx.conf -o /usr/local/nginx/report/index.html --ignore-crawlers --hour-spec=min


时间分布图上：按分钟展示数据：
goaccess -f /var/log/nginx/access.log -p /etc/goaccess_log_conf_nginx.conf -o /usr/local/nginx/report/index.html --ignore-crawlers --hour-spec=hour


不显示指定的面板
goaccess -f /var/log/nginx/access.log -p /etc/goaccess_log_conf_nginx.conf -o /usr/local/nginx/report/index.html --ignore-crawlers --hour-spec=min \
	--ignore-panel=VISITORS \
	--ignore-panel=REQUESTS \
	--ignore-panel=REQUESTS_STATIC \
	--ignore-panel=NOT_FOUND \
	--ignore-panel=HOSTS \
	--ignore-panel=OS \
	--ignore-panel=BROWSERS \
	--ignore-panel=VIRTUAL_HOSTS \
	--ignore-panel=REFERRERS \
	--ignore-panel=REFERRING_SITES \
	--ignore-panel=KEYPHRASES \
	--ignore-panel=STATUS_CODES \
	--ignore-panel=REMOTE_USER \
	--ignore-panel=GEO_LOCATION

我一般只留下几个面板（排除掉不想看的面板，因为使用 --enable-panel 参数无法达到这个目的）
goaccess -f /var/log/nginx/access.log -p /etc/goaccess_log_conf_nginx.conf -o /usr/local/nginx/report/index.html --ignore-crawlers --hour-spec=min \
	--ignore-panel=VISITORS \
	--ignore-panel=REQUESTS_STATIC \
	--ignore-panel=NOT_FOUND \
	--ignore-panel=OS \
	--ignore-panel=VIRTUAL_HOSTS \
	--ignore-panel=REFERRERS \
	--ignore-panel=KEYPHRASES \
	--ignore-panel=REMOTE_USER \
	--ignore-panel=GEO_LOCATION
```

#### 方便执行命令创建脚本

- `vim goaccess_report_by_min.sh`

```
goaccess -f /var/log/nginx/access.log -p /etc/goaccess_log_conf_nginx.conf -o /usr/local/nginx/report/index.html --ignore-crawlers --hour-spec=min \
	--ignore-panel=VISITORS \
	--ignore-panel=REQUESTS_STATIC \
	--ignore-panel=NOT_FOUND \
	--ignore-panel=OS \
	--ignore-panel=VIRTUAL_HOSTS \
	--ignore-panel=REFERRERS \
	--ignore-panel=KEYPHRASES \
	--ignore-panel=REMOTE_USER \
	--ignore-panel=GEO_LOCATION
```

- `vim goaccess_report_by_hour.sh`

```
goaccess -f /var/log/nginx/access.log -p /etc/goaccess_log_conf_nginx.conf -o /usr/local/nginx/report/index.html --ignore-crawlers --hour-spec=hour \
	--ignore-panel=VISITORS \
	--ignore-panel=REQUESTS_STATIC \
	--ignore-panel=NOT_FOUND \
	--ignore-panel=OS \
	--ignore-panel=VIRTUAL_HOSTS \
	--ignore-panel=REFERRERS \
	--ignore-panel=KEYPHRASES \
	--ignore-panel=REMOTE_USER \
	--ignore-panel=GEO_LOCATION
```

#### 实时生成统计页面

- 我个人看法是：一般没必要浪费这个性能，需要的时候执行下脚本就行了。
- 官网文档：<https://goaccess.io/man#examples>，查询关键字：**REAL TIME HTML OUTPUT**

```
goaccess -f /var/log/nginx/access.log -p /etc/goaccess_log_conf_nginx.conf -o /usr/local/nginx/report/index.html --real-time-html --daemonize 
```

## 资料

- <https://www.fanhaobai.com/2017/06/go-access.html>
- <https://www.imydl.tech/lnmp/32.html>
