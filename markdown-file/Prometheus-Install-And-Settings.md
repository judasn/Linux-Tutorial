# Prometheus 安装和配置

- 不错的发展史说明：<https://caicloud.io/blog/5a5db4203255f5063f2bd462>
- 特别说明：一般这类环境要尽可能保证所有服务器时间一致
- Prometheus 本地存储不适合存长久数据，一般存储一个月就够了。要永久存储需要用到远端存储，远端存储可以用 OpenTSDB
- Prometheus 也不适合做日志存储，日志存储还是推荐 ELK 方案

## Prometheus Docker 安装

- 官网：<https://prometheus.io/>
- Docker 官方镜像：<https://hub.docker.com/r/prom/prometheus/>
- 这里以 Spring Boot Metrics 为收集信息
- 创建配置文件：`vim /data/docker/prometheus/config/prometheus.yml`
- 在 scrape_configs 位置下增加我们自己应用的路径信息

```
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  - job_name: 'springboot'
    metrics_path: '/tkey-actuator/actuator/prometheus'
    static_configs:
    - targets: ['192.168.2.225:8811']
```

- 启动

```
docker run -d --name prometheus -p 9091:9090 \
-v /data/docker/prometheus/config/prometheus.yml:/etc/prometheus/prometheus.yml \
prom/prometheus
```

- 然后配置 Grafana，使用这个 dashboard：<https://grafana.com/dashboards/10280>


----------------------------------------------------------------------------------------------

## 配置

- 官网 exporter 列表：<https://prometheus.io/docs/instrumenting/exporters/>
- 官网 exporter 暴露的端口列表：<https://github.com/prometheus/prometheus/wiki/Default-port-allocations>


### CentOS7 服务器

- 当前最新版本：node_exporter 0.18.1（201907）

```
mkdir -p /usr/local/prometheus/node_exporter

cd /usr/local/prometheus/node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz

tar -zxvf node_exporter-0.18.1.linux-amd64.tar.gz

```


```
创建Systemd服务
vim /etc/systemd/system/node_exporter.service



[Unit]
Description=node_exporter
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/prometheus/node_exporter/node_exporter-0.18.1.linux-amd64/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

- 关于 ExecStart 参数，可以再附带一些启动监控的参数，官网介绍：<https://github.com/prometheus/node_exporter/blob/master/README.md#enabled-by-default>
    - 格式：`ExecStart=/usr/local/prometheus/node_exporter/node_exporter-0.18.1.linux-amd64/node_exporter --collectors.enabled meminfo,hwmon,entropy`


```
启动 Node exporter
systemctl start node_exporter

systemctl daemon-reload

systemctl status node_exporter

```


```
修改prometheus.yml，加入下面的监控目标：

vim  /data/docker/prometheus/config/prometheus.yml

scrape_configs:
  - job_name: 'centos7'
    static_configs:
    - targets: ['192.168.1.3:9100']
      labels:
        instance: centos7_node1

```

- 重启 prometheus：`docker restart prometheus`
- Grafana 有现成的 dashboard：
    - <https://grafana.com/dashboards/405>
    - <https://grafana.com/dashboards/8919>

----------------------------------------------------------------------------------------------


### Nginx 指标

- 这里使用 Nginx VTS exporter：<https://github.com/hnlq715/nginx-vts-exporter>

- 安装 nginx 模块：

```
git clone --depth=1 https://github.com/vozlt/nginx-module-vts.git


编译 nginx 的时候加上：
./configure --prefix=/usr/local/nginx --with-http_ssl_module --add-module=/opt/nginx-module-vts

make（已经安装过了，就不要再 make install）
```


```
也有人做好了 docker 镜像：
https://hub.docker.com/r/xcgd/nginx-vts

docker run --name nginx-vts -p 80:80 -v /data/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:ro -d xcgd/nginx-vts
```


```
修改Nginx配置


http {
    vhost_traffic_status_zone;
    vhost_traffic_status_filter_by_host on;

    ...

    server {

        ...

        location /status {
            vhost_traffic_status_display;
            vhost_traffic_status_display_format html;
        }
    }
}


验证nginx-module-vts模块：http://192.168.1.3/status，会展示：
Nginx Vhost Traffic Status 统计表

```

```
如果不想统计流量的server，可以禁用vhost_traffic_status，配置示例：
server {
    ...
    vhost_traffic_status off;
    ...
}
```


- 安装 nginx-vts-exporter

```
官网版本：https://github.com/hnlq715/nginx-vts-exporter/releases

wget https://github.com/hnlq715/nginx-vts-exporter/releases/download/v0.10.3/nginx-vts-exporter-0.10.3.linux-amd64.tar.gz

tar zxvf nginx-vts-exporter-0.10.3.linux-amd64.tar.gz

chmod +x /usr/local/nginx-vts-exporter-0.10.3.linux-amd64/nginx-vts-exporter
```

```
创建Systemd服务
vim /etc/systemd/system/nginx_vts_exporter.service


[Unit]
Description=nginx_exporter
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/nginx-vts-exporter-0.10.3.linux-amd64/nginx-vts-exporter -nginx.scrape_uri=http://192.168.1.3/status/format/json
Restart=on-failure

[Install]
WantedBy=multi-user.target
```


```
启动nginx-vts-exporter
systemctl start nginx_vts_exporter.service
systemctl daemon-reload
systemctl status nginx_vts_exporter.service
```


```
修改 prometheus.yml，加入下面的监控目标：
vim  /data/docker/prometheus/config/prometheus.yml

scrape_configs:
  - job_name: 'nginx'
    static_configs:
    - targets: ['192.168.1.3:9913']
      labels:
        instance: nginx1


如果nginx 有加 basic auth，则需要这样：
scrape_configs:
  - job_name: "nginx"
    metrics_path: /status/format/prometheus
    basic_auth:
      username: youmeek
      password: '123456'
    static_configs:
    - targets: ['192.168.1.3:9913']
      labels:
        instance: 'nginx1'

```

- 重启 prometheus：`docker restart prometheus`
- Grafana 有现成的 dashboard：
    - <https://grafana.com/dashboards/2949>
    - <https://grafana.com/dashboards/2984>

----------------------------------------------------------------------------------------------



### 微服务下的多服务收集

- <https://blog.csdn.net/zhuyu19911016520/article/details/88411371>

----------------------------------------------------------------------------------------------


### 告警

- <https://blog.csdn.net/zhuyu19911016520/article/details/88627004>
- <https://www.jianshu.com/p/e59cfd15612e>

- 告警配置

- 告警检测

- [Grafana+Prometheus系统监控之邮件报警功能](https://blog.52itstyle.vip/archives/2014/)
- [Grafana+Prometheus系统监控之钉钉报警功能](https://blog.52itstyle.vip/archives/2029/)
- [Grafana+Prometheus系统监控之webhook](https://blog.52itstyle.vip/archives/2068/)


## 远端存储方案

- <https://segmentfault.com/a/1190000015576540>


----------------------------------------------------------------------------------------------


## 其他资料

- <https://www.aneasystone.com/archives/2018/11/prometheus-in-action.html>
    - 写得非常非常非常好
- <https://www.hi-linux.com/posts/27014.html>
- <https://www.linuxea.com/1915.html>
- <>
- <>
- <>
- <>
- <>

