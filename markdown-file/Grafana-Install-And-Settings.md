# Grafana 安装和配置


## 对于版本

- [支持的 Elasticsearch 版本](http://docs.grafana.org/features/datasources/elasticsearch/#elasticsearch-version)


----------------------------------------------------------------------------------------------

## Grafana 安装

- CentOS 7.4
- rpm 文件包大小 53M
- 所需内存：300M 左右
- 官网下载：<https://grafana.com/grafana/download?platform=linux>
- 官网指导：<http://docs.grafana.org/installation/rpm/>

```
sudo yum install -y initscripts fontconfig urw-fonts
wget https://dl.grafana.com/oss/release/grafana-5.4.0-1.x86_64.rpm 
sudo yum localinstall -y grafana-5.4.0-1.x86_64.rpm 
```


- 启动 Grafana 服务（默认是不启动的）

```
sudo systemctl start grafana-server
sudo systemctl status grafana-server
```

- 将 Grafana 服务设置为开机启动：`sudo systemctl enable grafana-server`
- 开放端口：`firewall-cmd --add-port=3000/tcp --permanent`
- 重新加载防火墙配置：`firewall-cmd --reload`
- 访问：<http://192.168.0.105:3000>
- 默认管理账号；admin，密码：admin，登录后需要修改密码

----------------------------------------------------------------------------------------------

## 配置

- 官网指导：<http://docs.grafana.org/installation/configuration/>
- 安装包默认安装后的一些路径
	- 二进制文件：`/usr/sbin/grafana-server`
	- init.d 脚本：`/etc/init.d/grafana-server`
	- 配置文件：`/etc/grafana/grafana.ini`
	- 日志文件：`/var/log/grafana/grafana.log`
	- 插件目录是：`/var/lib/grafana/plugins`
	- 默认配置的 sqlite3 数据库：`/var/lib/grafana/grafana.db`
- 最重要的配置文件：`vim /etc/grafana/grafana.ini`
	- 可以修改用户名和密码
	- 端口
	- 数据路径
	- 数据库配置
	- 第三方认证
	- Session 有效期
- 添加数据源：<http://192.168.0.105:3000/datasources/new>
- 添加组织：<http://192.168.0.105:3000/admin/orgs>
- 添加用户：<http://192.168.0.105:3000/org/users>
- 添加插件：<http://192.168.0.105:3000/plugins>
- 个性化设置：<http://192.168.0.105:3000/org>
- 软件变量：<http://192.168.0.105:3000/admin/settings>


----------------------------------------------------------------------------------------------

## 数据源

#### Elasticsearch

使用：
- <https://cloud.tencent.com/info/68052367407c3bf21cc10c0263027f3f.html>
- <http://docs.grafana.org/features/datasources/elasticsearch/#using-elasticsearch-in-grafana>
- <>
- <>
- <>
- <>


----------------------------------------------------------------------------------------------


## 其他资料

- <https://blog.csdn.net/BianChengNinHao/article/details/80985302>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>

