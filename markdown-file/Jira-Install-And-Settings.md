# Jira 安装和配置

## Jira 7.13.3

- 最新 7.13.3 版本时间：2019-04

#### 数据库

```
docker run \
	--name mysql-jira \
	--restart always \
	-p 3306:3306 \
	-e MYSQL_ROOT_PASSWORD=adg123456 \
	-e MYSQL_DATABASE=jira_db \
	-e MYSQL_USER=jira_user \
	-e MYSQL_PASSWORD=jira_123456 \
	-d \
	mysql:5.7
```

- 连上容器：`docker exec -it mysql-jira /bin/bash`
	- 连上 MySQL：`mysql -u root -p`
- 设置编码：**必须做这一步，不然配置过程会报错，JIRA 的 DB 要求是 utf8mb4**

```
SET NAMES 'utf8mb4';
alter database jira_db character set utf8mb4;
```


#### 安装

- 下载：<https://www.atlassian.com/software/jira/download>
    - 选择：tar.gz 类型下载
- 解压：`tar zxvf atlassian-jira-software-7.13.3.tar.gz`
- 创建 home 目录：`mkdir /usr/local/atlassian-jira-software-7.13.3-standalone/data`
- 配置 home 变量：

```
编辑：vim ~/.zshrc

在文件尾部添加：

JIRA_HOME=/usr/local/atlassian-jira-software-7.13.3-standalone/data
export JIRA_HOME


刷新配置：`source ~/.zshrc`
```

- 设置 MySQL 连接：
- 把 mysql-connector-java-5.1.47.jar 放在目录 `/usr/local/atlassian-jira-software-7.13.3-standalone/atlassian-jira/WEB-INF/lib`


#### License 过程

- 参考自己的为知笔记

#### 运行

- 启动：`sh /usr/local/atlassian-jira-software-7.13.3-standalone/bin/start-jira.sh`
- 停止：`sh /usr/local/atlassian-jira-software-7.13.3-standalone/bin/stop-jira.sh`
    - `ps -ef | grep java`
- 查看 log：`tail -300f /usr/local/atlassian-jira-software-7.13.3-standalone/logs/catalina.out`
- 访问：<http://服务器ip:8080>
    - 注意防火墙配置
- 如果需要更换端口号可以修改：`/usr/local/atlassian-jira-software-7.13.3-standalone/conf/server.xml` 文件中的内容。


#### 中文化

- 从 7.x 版本默认已经有中文支持，不需要再汉化了
- 在安装后首次进入的时候就可以配置，选择中文了
        

#### 首次配置

- 参考文章：<https://blog.csdn.net/yelllowcong/article/details/79624970>
- 因为步骤一样，所以我就不再截图了。

    
