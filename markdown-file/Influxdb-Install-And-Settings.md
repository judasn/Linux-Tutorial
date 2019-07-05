# Influxdb 安装和配置



## Influxdb Docker 安装

- 官网库：<https://docs.docker.com/samples/library/influxdb>


```
docker run -d --name influxdb \
-p 8086:8086 -p 8083:8083 \
-e INFLUXDB_HTTP_AUTH_ENABLED=true \
-e INFLUXDB_ADMIN_ENABLED=true -e INFLUXDB_ADMIN_USER=admin -e INFLUXDB_ADMIN_PASSWORD=123456 \
-e INFLUXDB_DB=mydb1 \
-v /Users/gitnavi/docker_data/influxdb/data:/var/lib/influxdb influxdb
```


- 进入终端交互：

```
docker exec -it influxdb /bin/bash

输入：influx，开始终端交互

auth admin 123456
show databases;

use springboot
show measurements

show series from "jvm_buffer_total_capacity"

select * from "jvm_buffer_total_capacity"


如果你要再额外创建数据库：
create database demo

如果你要再创建用户：
create user "myuser" with password '123456' with all privileges
```


----------------------------------------------------------------------------------------------

## 配置



----------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------


## 其他资料

- <https://www.cnblogs.com/woshimrf/p/docker-influxdb.html>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>

