# Prometheus 安装和配置

## Prometheus Docker 安装

- 官网：<https://prometheus.io/>
- 这里以 Spring Boot Metrics 为收集信息
- 创建配置文件：/Users/gitnavi/docker_data/prometheus/config/prometheus.yml
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
-v /Users/gitnavi/docker_data/prometheus/config/prometheus.yml:/etc/prometheus/prometheus.yml \
prom/prometheus
```

- 然后配置 Grafana，使用这个 dashboard：<https://grafana.com/dashboards/10280>


----------------------------------------------------------------------------------------------

## 配置


### 微服务下的多服务收集

- <https://blog.csdn.net/zhuyu19911016520/article/details/88411371>


### 告警

- <https://blog.csdn.net/zhuyu19911016520/article/details/88627004>
- <https://www.jianshu.com/p/e59cfd15612e>

----------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------


## 其他资料

- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>

