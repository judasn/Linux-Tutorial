# Tomcat 8 安装和配置、优化


## Tomcat 8 安装

- Tomcat 8 安装
    - 官网：<http://tomcat.apache.org/>
    - Tomcat 8 官网下载：<http://tomcat.apache.org/download-80.cgi>
    - 此时（20160207） Tomcat 8 最新版本为：`apache-tomcat-8.0.32.tar.gz`
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - Tomcat 8 下载：`wget http://apache.fayea.com/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz`
    - 压缩包解压：`tar -zxvf apache-tomcat-8.0.32.tar.gz`
    - 移到解压出来文件夹到 /usr 下：`mv apache-tomcat-8.0.32/ /usr/program/`
    - 为了方便，修改解压目录的名字：`mv /usr/program/apache-tomcat-8.0.32/ /usr/program/tomcat8/`
- 设置 Iptables 规则（这一步是必须设置的）：
    - 一种方式：先关闭 iptables，防止出现拦截问题而测试不了：`service iptables stop`
    - 一种方式：在 iptables 中添加允许规则（Tomcat 默认端口是 8080）：
        - 添加规则：`sudo iptables -I INPUT -p tcp -m tcp --dport 8080 -j ACCEPT`
        - 保存规则：`sudo /etc/rc.d/init.d/iptables save`
        - 重启 iptables：`sudo service iptables restart`
- 测试安装好后的 Tomcat：
    - 启动 Tomcat：`sh /usr/program/tomcat8/bin/startup.sh ; tail -200f /usr/program/tomcat8/logs/catalina.out`
    - 访问：`http://服务器 IP 地址:8080/`
    - 停止 Tomcat：`sh /usr/program/tomcat8/bin/shutdown.sh`


## Tomcat 8 配置

- 设置 Tomcat 相关变量：
    - `sudo vim /usr/program/tomcat8/bin/catalina.sh`
	- 在配置文件的可编辑内容最上面（98 行开始），加上如下内容（具体参数根据你服务器情况自行修改）：
	``` ini
	JAVA_HOME=/usr/program/jdk1.8.0_72
    CATALINA_HOME=/usr/program/tomcat8
    CATALINA_OPTS="-server -Xms528m -Xmx528m -XX:PermSize=256m -XX:MaxPermSize=358m"
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
- 编辑 /opt/tomcat7/bin/conf/tomcat-users.xml 文件，在里面添加下面信息：
``` xml
<role rolename="manager"/>
<role rolename="manager-gui"/>
<role rolename="admin"/>
<role rolename="admin-gui"/>
<user username="tomcat" password="tomcat" roles="admin-gui,admin,manager-gui,manager"/>
```
- 编辑配置文件：`vim /usr/program/tomcat7/conf/server.xml`
	- 打开默认被注释的连接池配置：
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
            minSpareThreads="100" 
            prestartminSpareThreads = "true"
            maxQueueSize = "100"
	    />
	    ```
        - 重点参数解释：
            - maxThreads，最大并发数，默认设置 200，一般建议在 500 ~ 800，根据硬件设施和业务来判断
            - minSpareThreads，Tomcat 初始化时创建的线程数，默认设置 25
            - prestartminSpareThreads，在 Tomcat 初始化的时候就初始化 minSpareThreads 的参数值，如果不等于 true，minSpareThreads 的值就没啥效果了
            - maxQueueSize，最大的等待队列数，超过则拒绝请求
    - 修改默认的链接参数配置：
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
           compression="on" 
           disableUploadTimeout="true" 
           compressionMinSize="2048" 
           acceptorThreadCount="2" 
           compressableMimeType="text/html,text/xml,text/plain,text/css,text/javascript,application/javascript" 
           URIEncoding="utf-8"
        />
        ```
        - 重点参数解释：
            - protocol，Tomcat 8 设置 nio2 更好：org.apache.coyote.http11.Http11Nio2Protocol（如果这个用不了，就用下面那个）
            - protocol，Tomcat 6、7 设置 nio 更好：org.apache.coyote.http11.Http11NioProtocol
            - enableLookups，禁用DNS查询
            - acceptCount，指定当所有可以使用的处理请求的线程数都被使用时，可以放到处理队列中的请求数，超过这个数的请求将不予处理，默认设置 100
            - maxPostSize，以 FORM URL 参数方式的 POST 提交方式，限制提交最大的大小，默认是 2097152(2兆)，它使用的单位是字节。10485760 为 10M。如果要禁用限制，则可以设置为 -1。
            - acceptorThreadCount，用于接收连接的线程的数量，默认值是1。一般这个指需要改动的时候是因为该服务器是一个多核CPU，如果是多核 CPU 一般配置为 2.
	- 禁用 AJP（如果你服务器没有使用 Apache） 
		- 把下面这一行注释掉，默认 Tomcat 是开启的。
		``` xml
		<!-- <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" /> -->
		```



## JVM 优化

- 模型资料来源：<http://xmuzyq.iteye.com/blog/599750>
- Java 的内存模型分为：
	- Young，年轻代（易被 GC）。Young 区被划分为三部分，Eden 区和两个大小严格相同的 Survivor 区，其中 Survivor 区间中，某一时刻只有其中一个是被使用的，另外一个留做垃圾收集时复制对象用，在 Young 区间变满的时候，minor GC 就会将存活的对象移到空闲的Survivor 区间中，根据 JVM 的策略，在经过几次垃圾收集后，任然存活于 Survivor 的对象将被移动到 Tenured  区间。
	- Tenured，终身代。Tenured 区主要保存生命周期长的对象，一般是一些老的对象，当一些对象在 Young 复制转移一定的次数以后，对象就会被转移到 Tenured 区，一般如果系统中用了 application 级别的缓存，缓存中的对象往往会被转移到这一区间。
	- Perm，永久代。主要保存 class,method,filed 对象，这部门的空间一般不会溢出，除非一次性加载了很多的类，不过在涉及到热部署的应用服务器的时候，有时候会遇到 java.lang.OutOfMemoryError : PermGen space 的错误，造成这个错误的很大原因就有可能是每次都重新部署，但是重新部署后，类的 class 没有被卸载掉，这样就造成了大量的 class 对象保存在了 perm 中，这种情况下，一般重新启动应用服务器可以解决问题。
- Linux 修改 /usr/program/tomcat7/bin/catalina.sh 文件，把下面信息添加到文件第一行。Windows 和 Linux 有点不一样的地方在于，在 Linux 下，下面的的参数值是被引号包围的，而 Windows 不需要引号包围。
	- 如果服务器只运行一个 Tomcat
		- 机子内存如果是 8G，一般 PermSize 配置是主要保证系统能稳定起来就行：
			- `JAVA_OPTS="-Dfile.encoding=UTF-8 -server -Xms6144m -Xmx6144m -XX:NewSize=1024m -XX:MaxNewSize=2048m -XX:PermSize=512m -XX:MaxPermSize=512m -XX:MaxTenuringThreshold=10 -XX:NewRatio=2 -XX:+DisableExplicitGC"`
		- 机子内存如果是 16G，一般 PermSize 配置是主要保证系统能稳定起来就行：
			- `JAVA_OPTS="-Dfile.encoding=UTF-8 -server -Xms13312m -Xmx13312m -XX:NewSize=3072m -XX:MaxNewSize=4096m -XX:PermSize=512m -XX:MaxPermSize=512m -XX:MaxTenuringThreshold=10 -XX:NewRatio=2 -XX:+DisableExplicitGC"`
		- 机子内存如果是 32G，一般 PermSize 配置是主要保证系统能稳定起来就行：
			- `JAVA_OPTS="-Dfile.encoding=UTF-8 -server -Xms29696m -Xmx29696m -XX:NewSize=6144m -XX:MaxNewSize=9216m -XX:PermSize=1024m -XX:MaxPermSize=1024m -XX:MaxTenuringThreshold=10 -XX:NewRatio=2 -XX:+DisableExplicitGC"`
	- 如果是开发机
		- `-Xms550m -Xmx1250m -XX:PermSize=550m -XX:MaxPermSize=1250m`
	- 参数说明：
	``` nginx 
	-Dfile.encoding：默认文件编码
	-server：表示这是应用于服务器的配置，JVM 内部会有特殊处理的
	-Xmx1024m：设置JVM最大可用内存为1024MB
	-Xms1024m：设置JVM最小内存为1024m。此值可以设置与-Xmx相同，以避免每次垃圾回收完成后JVM重新分配内存。
	-XX:NewSize：设置年轻代大小
	-XX:MaxNewSize：设置最大的年轻代大小
	-XX:PermSize：设置永久代大小
	-XX:MaxPermSize：设置最大永久代大小
	-XX:NewRatio=4：设置年轻代（包括 Eden 和两个 Survivor 区）与终身代的比值（除去永久代）。设置为 4，则年轻代与终身代所占比值为 1：4，年轻代占整个堆栈的 1/5
	-XX:MaxTenuringThreshold=10：设置垃圾最大年龄，默认为：15。如果设置为 0 的话，则年轻代对象不经过 Survivor 区，直接进入年老代。对于年老代比较多的应用，可以提高效率。如果将此值设置为一个较大值，则年轻代对象会在 Survivor 区进行多次复制，这样可以增加对象再年轻代的存活时间，增加在年轻代即被回收的概论。
	-XX:+DisableExplicitGC：这个将会忽略手动调用 GC 的代码使得 System.gc() 的调用就会变成一个空调用，完全不会触发任何 GC
	```


## 其他

- Tomcat 历史版本下载地址整理（不间断更新）：
    - **Tomcat 9.0.0.M4**：`wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-9/v9.0.0.M4/bin/apache-tomcat-9.0.0.M4.tar.gz`
    - **Tomcat 8.0.32**：`wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz`
    - **Tomcat 7.0.68**：`wget http://apache.fayea.com/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz`
    - **Tomcat 6.0.45**：`wget http://mirrors.cnnic.cn/apache/tomcat/tomcat-6/v6.0.45/bin/apache-tomcat-6.0.45.tar.gz`

## 资料

- <http://www.jikexueyuan.com/course/2064_3.html?ss=1>
- <http://www.wellho.net/mouth/2163_CATALINA-OPTS-v-JAVA-OPTS-What-is-the-difference-.html>
- <http://blog.csdn.net/sunlovefly2012/article/details/47395165>
- <http://blog.csdn.net/lifetragedy/article/details/7708724>
- <http://ihuangweiwei.iteye.com/blog/1233941>
- <http://www.cnblogs.com/ggjucheng/archive/2013/04/16/3024731.html>
- <https://tomcat.apache.org/tomcat-8.0-doc/config/http.html#Connector_Comparison>
- <http://www.apelearn.com/study_v2/chapter23.html>
