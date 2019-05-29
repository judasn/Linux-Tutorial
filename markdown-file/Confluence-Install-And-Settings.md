# Confluence 安装和配置

## Confluence 6.15.4

- 最新 6.15.4 版本时间：2019-05

#### 数据库

```
docker run \
	--name mysql-confluence \
	--restart always \
	-p 3316:3306 \
	-e MYSQL_ROOT_PASSWORD=adg123456 \
	-e MYSQL_DATABASE=confluence_db \
	-e MYSQL_USER=confluence_user \
	-e MYSQL_PASSWORD=confluence_123456 \
	-d \
	mysql:5.7
```

- 连上容器：`docker exec -it mysql-confluence /bin/bash`
	- 连上 MySQL：`mysql -u root -p`
- 设置编码：
    - **必须做这一步，不然配置过程会报错，confluence 的 DB 要求是 utf8，还不能是 utf8mb4**
    - **并且排序规则还必须是：utf8_bin**
    - **数据库必须使用'READ-COMMITTED'作为默认隔离级别**

```
SET NAMES 'utf8';
alter database confluence_db character set utf8 collate utf8_bin;
SET GLOBAL tx_isolation='READ-COMMITTED';
```

#### 安装

- 下载：<https://www.atlassian.com/software/confluence/download>
    - 选择：linux64 类型下载
- 授权：`chmod +x atlassian-confluence-6.15.4-x64.bin`


```
./atlassian-confluence-6.15.4-x64.bin

开始提示：

Unpacking JRE ...
Starting Installer ...

This will install Confluence 6.9.0 on your computer.
OK [o, Enter], Cancel [c]

>> 输入o或直接回车

Click Next to continue, or Cancel to exit Setup.

Choose the appropriate installation or upgrade option.
Please choose one of the following:
Express Install (uses default settings) [1], 
Custom Install (recommended for advanced users) [2, Enter], 
Upgrade an existing Confluence installation [3]
1
>> 这里输入数字1

See where Confluence will be installed and the settings that will be used.
Installation Directory: /opt/atlassian/confluence 
Home Directory: /var/atlassian/application-data/confluence 
HTTP Port: 8090 
RMI Port: 8000 
Install as service: Yes 
Install [i, Enter], Exit [e]
i

>> 输入i或者直接回车

Extracting files ...

Please wait a few moments while we configure Confluence.

Installation of Confluence 6.9.0 is complete
Start Confluence now?
Yes [y, Enter], No [n]

>> 输入y或者直接回车

Please wait a few moments while Confluence starts up.
Launching Confluence ...

Installation of Confluence 6.9.0 is complete
Your installation of Confluence 6.9.0 is now ready and can be accessed via
your browser.
Confluence 6.9.0 can be accessed at http://localhost:8090
Finishing installation ...

# 安装完成，访问本机的8090端口进行web端安装
# 开放防火墙端口
firewall-cmd --add-port=8090/tcp --permanent
firewall-cmd --add-port=8000/tcp --permanent
firewall-cmd --reload
```

- 默认是安装在 /opt 目录下：`/opt/atlassian/confluence/confluence/WEB-INF/lib`
- 启动：`sh /opt/atlassian/confluence/bin/start-confluence.sh`
- 停止：`sh /opt/atlassian/confluence/bin/stop-confluence.sh`
- 查看 log：`tail -300f /opt/atlassian/confluence/logs/catalina.out`
- 卸载：`sh  /opt/atlassian/confluence/uninstall`
- 设置 MySQL 连接驱动，把 mysql-connector-java-5.1.47.jar 放在目录 `/opt/atlassian/confluence/confluence/WEB-INF/lib`

#### 首次配置

- 访问：<http://localhost:8090>
- 参考文章：<https://blog.51cto.com/m51cto/2131964>
- 参考文章：<https://www.qinjj.tech/2019/01/04/confluence%20install/>
- 因为步骤一样，所以我就不再截图了。

#### License 过程

- 参考自己的为知笔记


## 反向代理的配置可以参考

- <https://blog.51cto.com/m51cto/2131964>

    
## 使用 markdown

- 点击右上角小齿轮 > 管理应用 > 搜索市场应用 > 输入 markdown > 安装


## 其他资料

- <https://www.qinjj.tech/2019/02/26/confluence%20maintain/>
- <https://www.qinjj.tech/2019/02/26/confluence_maintain2/>
