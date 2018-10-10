# Tomcat 8 安装和配置、优化


## Tomcat 8 安装

- Tomcat 8 安装
    - 官网：<http://tomcat.apache.org/>
    - Tomcat 8 官网下载：<http://tomcat.apache.org/download-80.cgi>
    - 此时（20160207） Tomcat 8 最新版本为：`apache-tomcat-8.0.32.tar.gz`
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - Tomcat 8 下载（201706 更新：旧版本失效）：`wget http://apache.fayea.com/tomcat/tomcat-8/v8.0.44/bin/apache-tomcat-8.0.44.tar.gz`
    - 压缩包解压：`tar -zxvf apache-tomcat-8.0.32.tar.gz`
    - 移到解压出来文件夹到 /usr 下：`mv apache-tomcat-8.0.32/ /usr/program/`
    - 为了方便，修改解压目录的名字：`mv /usr/program/apache-tomcat-8.0.32/ /usr/program/tomcat8/`
- 设置 Iptables 规则（这一步是必须设置的）：
    - 一种方式：先关闭 iptables，防止出现拦截问题而测试不了：`service iptables stop`
    - 一种方式：在 iptables 中添加允许规则（Tomcat 默认端口是 8080）：
        - 添加规则：`iptables -I INPUT -p tcp -m tcp --dport 8080 -j ACCEPT`
        - 保存规则：`service iptables save`
        - 重启 iptables：`service iptables restart`
- 测试安装好后的 Tomcat：
    - 启动 Tomcat：`sh /usr/program/tomcat8/bin/startup.sh ; tail -200f /usr/program/tomcat8/logs/catalina.out`
    - 访问：`http://服务器 IP 地址:8080/`
    - 停止 Tomcat：`sh /usr/program/tomcat8/bin/shutdown.sh`
- 如果启动报：`java.net.UnknownHostException 或 localhost. This prevents creation of a GUID`
    - 解决办法：
        - 修改配置文件：`vim /etc/sysconfig/network`，把里面的 HOSTNAME 改为你自己设置的一个名字，比如我这边改为：youmeek
        - 修改配置文件：`vim /etc/hosts`，把第一行的 127.0.0.1 这一行删掉，然后再最后一行增加这句：`127.0.0.1 localhost youmeek`，这里最后的 youmeek 就是主机名
        - 然后重启计算机：`reboot`
- 如果启动报：`java.net.BindException: 地址已在使用 / java.net.BindException: Address already in use`
    - 解决办法：这表示端口被占用，修改 Tomcat 的 server.xml 配置文件，把端口改了即可。


## Tomcat 8 配置

- 设置 Tomcat 相关变量：
    - `vim /usr/program/tomcat8/bin/catalina.sh`
	- 在配置文件的可编辑内容最上面（98 行开始），加上如下内容（具体参数根据你服务器情况自行修改）：
	``` ini
	JAVA_HOME=/usr/program/jdk1.8.0_72
    CATALINA_HOME=/usr/program/tomcat8
    CATALINA_OPTS="-Dfile.encoding=UTF-8 -server -Xms2048m -Xmx2048m -Xmn1024m -XX:PermSize=256m -XX:MaxPermSize=512m -XX:SurvivorRatio=10 -XX:MaxTenuringThreshold=15 -XX:NewRatio=2 -XX:+DisableExplicitGC"
    CATALINA_PID=$CATALINA_HOME/catalina.pid
	```
- 如果使用 `shutdown.sh` 还无法停止 tomcat，可以修改其配置：`vim /usr/program/tomcat8/bin/shutdown.sh`
    - 把最尾巴这一行：`exec "$PRGDIR"/"$EXECUTABLE" stop "$@"`
    - 改为：`exec "$PRGDIR"/"$EXECUTABLE" stop 10 -force`
    
    
## Tomcat 8 优化

- Tomcat 6/7/8 的优化参数有点不一样，最好按下面的方式看一下官网这个文档是否还保留着这个参数
- 启动tomcat，访问该地址，下面要讲解的一些配置信息，在该文档下都有说明的：
	- 文档：<http://127.0.0.1:8080/docs/config>
	- 你也可以直接看网络版本：
		- Tomcat 6 文档：<https://tomcat.apache.org/tomcat-6.0-doc/config>
		- Tomcat 7 文档：<https://tomcat.apache.org/tomcat-7.0-doc/config/>
		- Tomcat 8 文档：<https://tomcat.apache.org/tomcat-8.0-doc/config/>
- 如果你需要查看 Tomcat 的运行状态可以配置tomcat管理员账户，然后登陆 Tomcat 后台进行查看
- 编辑 /opt/tomcat8/bin/conf/tomcat-users.xml 文件，在里面添加下面信息：

``` xml
<role rolename="tomcat"/>
<role rolename="manager-gui"/>
<role rolename="manager-status"/>

<user username="tomcat" password="123456" roles="tomcat,manager-gui,manager-status"/>
```
- 编辑配置文件：`vim /usr/program/tomcat8/conf/server.xml`

#### 打开默认被注释的连接池配置

- 默认值：

``` xml
<!--
<Executor name="tomcatThreadPool" namePrefix="catalina-exec-"
    maxThreads="150" minSpareThreads="4"/>
-->
```

- 修改为：

``` xml
<Executor
        name="tomcatThreadPool"
        namePrefix="catalina-exec-"
        maxThreads="500"
        minSpareThreads="30"
        maxIdleTime="60000"
        prestartminSpareThreads = "true"
        maxQueueSize = "100"
/>
```

- 重点参数解释：
    - maxThreads，最大并发数，默认设置 200，一般建议在 500 ~ 800，根据硬件设施和业务来判断
    - minSpareThreads，Tomcat 初始化时创建的线程数，默认设置 25
    - prestartminSpareThreads，在 Tomcat 初始化的时候就初始化 minSpareThreads 的参数值，如果不等于 true，minSpareThreads 的值就没啥效果了
    - maxQueueSize，最大的等待队列数，超过则拒绝请求
    - maxIdleTime，如果当前线程大于初始化线程，那空闲线程存活的时间，单位毫秒，默认60000=60秒=1分钟。

#### 修改默认的链接参数配置

- 默认值：

``` xml
<Connector 
    port="8080" 
    protocol="HTTP/1.1" 
    connectionTimeout="20000" 
    redirectPort="8443" 
/>
```

- 修改为：

``` xml
<Connector 
   executor="tomcatThreadPool"
   port="8080" 
   protocol="org.apache.coyote.http11.Http11Nio2Protocol" 
   connectionTimeout="20000" 
   maxConnections="10000" 
   redirectPort="8443" 
   enableLookups="false" 
   acceptCount="100" 
   maxPostSize="10485760" 
   maxHttpHeaderSize="8192" 
   disableUploadTimeout="true" 
   URIEncoding="utf-8"
/>
```

- 重点参数解释：
    - protocol，Tomcat 8 设置 nio2 更好：org.apache.coyote.http11.Http11Nio2Protocol（如果这个用不了，就用下面那个）
    - protocol，Tomcat 6、7 设置 nio 更好：org.apache.coyote.http11.Http11NioProtocol
    - enableLookups，禁用DNS查询，tomcat 8 默认已经是禁用了。
    - maxConnections，最大连接数，tomcat 8 默认设置 10000
    - acceptCount，指定当所有可以使用的处理请求的线程数都被使用时，可以放到处理队列中的请求数，超过这个数的请求将不予处理，默认设置 100
    - maxPostSize，以 FORM URL 参数方式的 POST 提交方式，限制提交最大的大小，默认是 2097152(2兆)，它使用的单位是字节。10485760 为 10M。如果要禁用限制，则可以设置为 -1。
    - maxHttpHeaderSize，http请求头信息的最大程度，超过此长度的部分不予处理。一般8K。
- 禁用 AJP（如果你服务器没有使用 Apache） 
	- 把下面这一行注释掉，默认 Tomcat 是开启的。

``` xml
<!-- <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" /> -->
```

- 关闭自动部署功能：
- 旧值：
```
<Host name="localhost"  appBase="webapps" unpackWARs="true" autoDeploy="true">
```

- 新值：
```
<Host name="localhost"  appBase="webapps" unpackWARs="true" autoDeploy="false">
```

## JVM 优化（JDK 8）

- 模型资料来源：<http://xmuzyq.iteye.com/blog/599750>
- 配比资料：<http://www.jianshu.com/p/d45e12241af4>
- JDK8 配比：[关键系统的JVM参数推荐(2018仲夏版)](https://mp.weixin.qq.com/s/FHY0MelBfmgdRpT4zWF9dQ)
- JDK8 常用配比总结 8G 内存：`CATALINA_OPTS="-Dfile.encoding=UTF-8 -Xms4g -Xmx4g"`
- Java 的内存模型看：[这篇文章](Java-bin.md)
- Linux 修改 /usr/program/tomcat8/bin/catalina.sh 文件，把下面信息添加到文件第一行。
	- 如果服务器只运行一个 Tomcat，堆栈信息可以这样配置：
		- 机子内存如果是 4G：
			- `CATALINA_OPTS="-Dfile.encoding=UTF-8 -server -Xms2g -Xmx2g"`
		- 机子内存如果是 8G：
			- `CATALINA_OPTS="-Dfile.encoding=UTF-8 -server -Xms4g -Xmx4g"`
		- 机子内存如果是 16G：
			- `CATALINA_OPTS="-Dfile.encoding=UTF-8 -server -Xms8g -Xmx8g"`
		- 机子内存如果是 32G：
			- `CATALINA_OPTS="-Dfile.encoding=UTF-8 -server -Xms16g -Xmx16g"`
	- 如果是 8G 开发机
		- `-Xms2g -Xmx2g`
	- 如果是 16G 开发机
		- `-Xms4g -Xmx4g`
	- 还有一个参数：`-XX:MetaspaceSize=128M -XX:MaxMetaspaceSize=512M`
		- 这个可以通过调试来确认什么值合适，一般通过使用 `jstat -gc PID 250 20`，查看 gc 情况下的 MC、MU 情况。
		- 默认 MaxMetaspaceSize 是 -1，无上限，所以如果硬件还行，不配置也没啥问题。
		- 自己也了解 JVM 实际情况，那就根据实际情况调整。一般项目可以推荐：`-XX:MetaspaceSize=128M -XX:MaxMetaspaceSize=512M`
- Windows 修改 /tomcat7/bin/catalina.bat 文件，找到这一行：`echo Using CATALINA_BASE:   "%CATALINA_BASE%"`，然后在其上面添加如下内容，此方法只对解压版的 Tomcat 有效果，对于安装版本的需要点击安装后任务栏上的那个 Tomcat 图标，打开配置中有一个 `Java` Tab 的进行编辑。
``` nginx
set JAVA_OPTS=%JAVA_OPTS% -Dfile.encoding="UTF-8" -Dsun.jnu.encoding="UTF8" -Ddefault.client.encoding="UTF-8" -Duser.language=Zh
set JAVA_OPTS=%JAVA_OPTS% -server -Xms4g -Xmx4g
```

## tomcat-manager 监控配置（tomcat 8.0.53）

####  开启步骤

- 不同的 Tomcat 版本会有差异。
- 官网文档：<https://tomcat.apache.org/tomcat-8.0-doc/manager-howto.html>
- **先确保解压的 tomcat/webapps 下有 manager 项目**
- 在配置文件里面添加可访问用户：`vim /usr/local/tomcat8/conf/tomcat-users.xml`，比如：

```
<role rolename="tomcat"/>
<role rolename="manager-gui"/>
<role rolename="manager-status"/>

<user username="tomcat" password="123456" roles="tomcat,manager-gui,manager-status"/>
```

- 正常情况下，manager ui 界面只运行内网：127.0.0.1 访问，这里我们要关闭这个限制。
- 修改 webapps 下 manager 项目下的配置：`vim /usr/local/tomcat8/webapps/manager/META-INF/context.xml`
- 旧值：

```
<Context antiResourceLocking="false" privileged="true" >
  <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|jav
</Context>
```

- 新值：

```
<Context antiResourceLocking="false" privileged="true" >
  <!--
  <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
  -->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|jav
</Context>
```

- 浏览器访问：<http://120.78.72.28:8080/manager/status>

#### 可以看到 JVM 堆栈信息

![image.png](https://upload-images.jianshu.io/upload_images/12159-e86a32e685f91dde.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 可以看到 HTTP 连接数情况

![image.png](https://upload-images.jianshu.io/upload_images/12159-99d9fffee0c3c17f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 配置文件里面限制的最大线程数：`Max threads: 200`
- 当前线程数：`Current thread count: 10`
- 当前繁忙的线程数：`Current thread busy: 1`
	- 如果当前繁忙线程已经是接近最大线程数，那基本可以表示负载到了
- 保持连接数：`Keep alive sockets count: 1`


## Tomcat 8 的 Log 分割


- 修改前提：本人为 Tomcat8.5，安装目录为：/usr/program/tomcat8
- 网络上的官网地址现在打不开：<http://cronolog.org/download/index.html>
- 阿里云的 CentOS 有 epel 源所以可以直接下载：`yum install cronolog`，此时：2017-02，最新版本为：1.6.2-10.el6
- 安装完后，查看下安装后的目录位置：`which cronolog`，我这边得到的结果是：`/usr/sbin/cronolog`，记下这个结果，后面有用到。
- 修改 catalina.sh 中的内容：`vim /usr/program/tomcat8/bin/catalina.sh`
- 找到这段代码（预计在 416 行前后）：

``` ini

shift
touch "$CATALINA_OUT"
if [ "$1" = "-security" ] ; then
if [ $have_tty -eq 1 ]; then
  echo "Using Security Manager"
fi
shift
eval $_NOHUP "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $JAVA_OPTS $CATALINA_OPTS \
  -classpath "\"$CLASSPATH\"" \
  -Djava.security.manager \
  -Djava.security.policy=="\"$CATALINA_BASE/conf/catalina.policy\"" \
  -Dcatalina.base="\"$CATALINA_BASE\"" \
  -Dcatalina.home="\"$CATALINA_HOME\"" \
  -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
  org.apache.catalina.startup.Bootstrap "$@" start \
  >> "$CATALINA_OUT" 2>&1 "&"

else
eval $_NOHUP "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $JAVA_OPTS $CATALINA_OPTS \
  -classpath "\"$CLASSPATH\"" \
  -Dcatalina.base="\"$CATALINA_BASE\"" \
  -Dcatalina.home="\"$CATALINA_HOME\"" \
  -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
  org.apache.catalina.startup.Bootstrap "$@" start \
  >> "$CATALINA_OUT" 2>&1 "&"

fi

```

- 将上面代码改为如下，其中请注意这个关键字：`/usr/sbin/cronolog`，这个是我上面提到的安装路径，你如果跟我不一样，需要自己修改该相关。

``` ini

shift
# touch "$CATALINA_OUT"
if [ "$1" = "-security" ] ; then
if [ $have_tty -eq 1 ]; then
  echo "Using Security Manager"
fi
shift
eval $_NOHUP "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $JAVA_OPTS $CATALINA_OPTS \
  -classpath "\"$CLASSPATH\"" \
  -Djava.security.manager \
  -Djava.security.policy=="\"$CATALINA_BASE/conf/catalina.policy\"" \
  -Dcatalina.base="\"$CATALINA_BASE\"" \
  -Dcatalina.home="\"$CATALINA_HOME\"" \
  -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
  org.apache.catalina.startup.Bootstrap "$@" start 2>&1 | /usr/sbin/cronolog "$CATALINA_BASE"/logs/catalina.%Y-%m-%d.out >> /dev/null &

else
eval $_NOHUP "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $JAVA_OPTS $CATALINA_OPTS \
  -classpath "\"$CLASSPATH\"" \
  -Dcatalina.base="\"$CATALINA_BASE\"" \
  -Dcatalina.home="\"$CATALINA_HOME\"" \
  -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
  org.apache.catalina.startup.Bootstrap "$@" start 2>&1 | /usr/sbin/cronolog "$CATALINA_BASE"/logs/catalina.%Y-%m-%d.out >> /dev/null &

fi

```

## 禁止外网通过 8080 端口访问 Tomcat

- 添加 iptables 规则：
	- `iptables -t filter -A INPUT -p tcp -m tcp --dport 8080 -s localhost -j ACCEPT`
	- `iptables -t filter -A INPUT -p tcp -m tcp --dport 8080 -j REJECT`
	- `service iptables save`
	- `service iptables restart`

## Dockerfile 构建 Tomcat 镜像并部署 war 包

- 因为我自己改了 Tomcat 的几个配置文件，所以要把那几个文件和 Dockerfile 放一起进行构建。
- 在宿主机上创建 dockerfile 存放目录和 logs 目录：`mkdir -p /opt/cas-dockerfile/ /data/logs/tomcat/`

```
FROM tomcat:8.0.46-jre8
MAINTAINER GitNavi <gitnavi@qq.com>

RUN rm -rf /usr/local/tomcat/webapps/*

ADD server.xml /usr/local/tomcat/conf/
ADD cas.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]

EXPOSE 8081
```

- 须知：容器中的 Tomcat 日志我是输出在容器的目录下：`/data/logs/`，所以我挂载中会有这个挂载选项
- 开始构建：
	- `cd /opt/cas-dockerfile`
	- `docker build . --tag="sso/cas-tomcat8:v1.0.9"`
	- `docker run -d -p 8111:8081 -v /data/logs/tomcat/:/data/logs/ --name="cas-tomcat-1.0.9" sso/cas-tomcat8:v1.0.9`
	- 查看启动后容器列表：`docker ps`
	- 进入 tomcat 容器终端查看一些情况：`docker exec -it 57a682478233 /bin/bash`
	- jar 应用的日志是输出在容器的 /opt 目录下，因为我们上面用了挂载，所在在我们宿主机的 /usr/local/logs 目录下可以看到输出的日志
- CentOS 7 防火墙开放端口：
	- `firewall-cmd --zone=public --add-port=8111/tcp --permanent`
	- `firewall-cmd --reload`

## 其他

- Tomcat 历史版本下载地址整理（不间断更新）：
    - **Tomcat 9.0.0.M4**：`wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-9/v9.0.0.M4/bin/apache-tomcat-9.0.0.M4.tar.gz`
    - **Tomcat 8.0.32**：`wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz`
    - **Tomcat 7.0.68**：`wget http://apache.fayea.com/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz`
    - **Tomcat 6.0.45**：`wget http://mirrors.cnnic.cn/apache/tomcat/tomcat-6/v6.0.45/bin/apache-tomcat-6.0.45.tar.gz`

## 其他问题


#### log4j2 输出的时间与北京时间相差 8 小时

- 原因是系统时区不对。
- 设置时区：

```
timedatectl set-timezone Asia/Shanghai
timedatectl status
```



## 资料

- <http://www.jikexueyuan.com/course/2064_3.html?ss=1>
- <http://www.wellho.net/mouth/2163_CATALINA-OPTS-v-JAVA-OPTS-What-is-the-difference-.html>
- <http://blog.csdn.net/sunlovefly2012/article/details/47395165>
- <http://blog.csdn.net/lifetragedy/article/details/7708724>
- <http://ihuangweiwei.iteye.com/blog/1233941>
- <http://www.cnblogs.com/ggjucheng/archive/2013/04/16/3024731.html>
- <https://tomcat.apache.org/tomcat-8.0-doc/config/http.html#Connector_Comparison>
- <http://www.apelearn.com/study_v2/chapter23.html>
- <http://blog.csdn.net/hanzheng260561728/article/details/51236131>
- <http://blog.csdn.net/attagain/article/details/38639007>
