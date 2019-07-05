# Prometheus 安装和配置

- 特别说明：一般这类环境要尽可能保证所有服务器时间一致

## Prometheus Docker 安装

- 官网：<https://prometheus.io/>
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

vim  /usr/local/prometheus/prometheus.yml

scrape_configs:
  - job_name: 'centos7'
    static_configs:
    - targets: ['127.0.0.1:9100']
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


验证nginx-module-vts模块：http://IP/status

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
wget -O nginx-vts-exporter-0.5.zip https://github.com/hnlq715/nginx-vts-exporter/archive/v0.5.zip
unzip nginx-vts-exporter-0.5.zip
mv nginx-vts-exporter-0.5  /usr/local/prometheus/nginx-vts-exporter
chmod +x /usr/local/prometheus/nginx-vts-exporter/bin/nginx-vts-exporter

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
ExecStart=/usr/local/prometheus/nginx-vts-exporter/bin/nginx-vts-exporter -nginx.scrape_uri=http://localhost/status/format/json
Restart=on-failure

[Install]
WantedBy=multi-user.target
```


```
启动nginx-vts-exporter
systemctl start nginx_vts_exporter.service
systemctl status nginx_vts_exporter.service
```


```
修改prometheus.yml，加入下面的监控目标：

- job_name: nginx
    static_configs:
      - targets: ['127.0.0.1:9913']
        labels:
          instance: web1

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



----------------------------------------------------------------------------------------------


## 其他资料

- <https://www.aneasystone.com/archives/2018/11/prometheus-in-action.html>
    - 写得非常非常非常好
- <https://www.hi-linux.com/posts/27014.html>
- <>
- <>
- <>
- <>
- <>
- <>

