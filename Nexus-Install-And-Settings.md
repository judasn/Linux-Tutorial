<h1 id="nexus0">Nexus 安装和配置</h1>

------

*   [Nexus 安装和配置](#nexus0)
    *   [Nexus 安装](#nexus1)
    *   [Nexus 配置](#nexus2)
    *   [资料](#nexus3)
    
------

<h2 id="nexus1">Nexus 安装</h2>

- Nexus 安装
    - 官网：<http://www.sonatype.org/nexus/>
    - 官网下载：<http://www.sonatype.org/nexus/archived/>
    - 此时（20160207） Nexus 最新版本为：**2.12.0-01**
    - JDK 要求是 JDK 7，官网要求 7u6 或之后版本，包括 JDK 8
    - 官网帮助说明 1：<http://books.sonatype.com/nexus-book/2.11/reference/install.html>
    - 官网帮助说明 2：<http://books.sonatype.com/sonatype-clm-book/html/clm-book/installation-configuration.html>
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - 压缩包下载（由于国内网络的原因不排除你下载不了）：`wget http://download.sonatype.com/nexus/oss/nexus-2.12.0-01-bundle.tar.gz`
    - 如果地址下载不了，那是因为你需要开 VPN，你也可以选择降低要求下载 2.11.4-01 版本：<http://pan.baidu.com/s/1mgSNJtA>
        - 解压压缩包：`tar zxvf nexus-2.11.4-01-bundle.tar.gz`
            - 解压出来有两个文件夹：
            - 这是程序目录：`nexus-2.11.4-01`
            - 这是仓库目录：`sonatype-work`
        - 移到目录到我的安装目录下：`mv nexus-2.11.4-01/ /usr/program/`
        - 进入安装目录：`cd /usr/program/`
        - 把目录名字改为更好看点：`mv nexus-2.11.4-01/ nexus2.11.4/`
        - 编辑系统配置文件：`vim /etc/profile`
        - 在文件的尾巴增加下面内容：
        ```
        # Nexus
        NEXUS_HOME=/usr/program/nexus2.11.4
        export NEXUS_HOME
        RUN_AS_USER=root
        export RUN_AS_USER
        ```
        - 刷新配置：`source /etc/profile`
        - 由于目录 `sonatype-work` 以后是做仓库用的，会存储很多 jar，所以这个目录一定要放在磁盘空间大的区内，目前我们还没第一次启动 Nexus，所以这里还是空文件
            - 我个人习惯把这类目录放在 `/opt` 下：`mv /opt/setup/sonatype-work/ /opt/`
            - 设置配置文件：`vim /usr/program/nexus2.11.4/conf/nexus.properties`
                - 把文件中该值：`nexus-work=${bundleBasedir}/../sonatype-work/nexus`
                - 改为：`nexus-work=/opt/sonatype-work/nexus`
        - 默认情况下如果你的 JDK 等系统变量设置好的是无需编辑 Nexus 的配置文件，但是这里还是给大家一下配置文件路径：`vim /usr/program/nexus2.11.4/bin/jsw/conf/wrapper.conf`
        - 开放防火墙端口：
            - 添加规则：`sudo iptables -I INPUT -p tcp -m tcp --dport 8081 -j ACCEPT`
            - 保存规则：`sudo /etc/rc.d/init.d/iptables save`
            - 重启 iptables：`sudo service iptables restart`
    - 测试安装结果：
        - 启动 Nexus：`/usr/program/nexus2.11.4/bin/nexus start`
        - 查看启动日志：`tail -200f /usr/program/nexus2.11.4/logs/wrapper.log`
        - 关闭 Nexus：`/usr/program/nexus2.11.4/bin/nexus stop`
        - 访问：http://192.168.0.110:8081/nexus
        - 登录账号密码：
            - 账号密码：**admin**
            - 密码：**admin123**
        
        
        
<h2 id="nexus2">Nexus 配置</h2>

- 下载远程中央库的索引到服务器
    - ![Nexus 配置](images/Nexus-Install-And-Settings-a-1.jpg)
    - 如上图标注 4 所示，把默认是 `False` 改为 `True`
    - ![Nexus 配置](images/Nexus-Install-And-Settings-a-2.gif)
    - 如上图 gif 所示，创建任务开始进行索引下载。需要特别提醒的是，如果你的私服是虚拟机，那得保证你分配的硬盘足够大，别像我一样吝啬只给 10 G（现在还剩下 1.9 G），结果报：**设备上没有空间**


- 项目上配置链接连接私服（下面内容涉及到 maven 的基础知识，请自行私下学习）：
    - 对项目独立设置：
        - 打开项目的 pom.xml 文件：
        - 添加下面内容：
        ```
        <repositories>
            <repository>
                <id>Nexus</id>
                <name>虚拟机-192.168.0.110-Nexus</name>
                <url>http://192.168.0.110:8081/nexus/content/groups/public/</url>
            </repository>
        </repositories>
        ```
    - 对全局配置进行设置：
        - 打开 maven 的 settings.xml 文件：
        - 添加下面内容：
        ```
        <mirrors>
            <mirror>
                <id>YouMeekNexus</id>
                <name>YouMeek Nexus</name>
                <mirrorOf>*</mirrorOf>
                <url>http://192.168.0.110:8081/nexus/content/groups/public/</url>
            </mirror>
        </mirrors>
        ```
    
    
<h2 id="nexus3">资料</h2>

- <http://www.cnblogs.com/leefreeman/p/4211530.html>
- <http://www.itdadao.com/article/89071/>
- <http://blog.zhaojunling.me/p/17>
- <http://m.blog.csdn.net/article/details?id=49228873>
- <http://mritd.me/2015/12/29/Nexus-2-11-CentOS%E6%90%AD%E5%BB%BA%E6%95%99%E7%A8%8B/>
- <http://mritd.me/2015/12/28/Nexus-%E7%A7%81%E6%9C%8D%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B/>
- <http://my.oschina.net/liangbo/blog/195739>