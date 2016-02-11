<h1 id="maven0">Maven 安装和配置</h1>

------

*   [Maven 安装和配置](#maven0)
    *   [Maven 安装](#maven1)
    *   [Maven 配置](#maven2)
    *   [资料](#maven3)
    
------

<h2 id="maven1">Maven 安装</h2>

- Maven 安装
    - 官网：<http://maven.apache.org/>
    - 官网下载：<http://maven.apache.org/download.cgi>
    - 此时（20160208） Maven 最新版本为：**3.3.9**
    - Maven 3.3 的 JDK 最低要求是 JDK 7
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - 下载压缩包：`wget http://mirrors.cnnic.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz`
    - 解压：`tar zxvf apache-maven-3.3.9-bin.tar.gz`
    - 修改目录名，默认的太长了：`mv apache-maven-3.3.9-bin/ maven3.3.9/`
    - 移到我个人习惯的安装目录下：`mv maven3.3.9/` /usr/program`
    - 环境变量设置：`vim /etc/profile`
    - 在文件最尾巴添加下面内容：
    ```
    # Maven
    MAVEN_HOME=/usr/program/maven3.3.9
    PATH=$PATH:$MAVEN_HOME/bin
    MAVEN_OPTS="-Xms256m -Xmx356m"
    export MAVEN_HOME
    export PATH
    export MAVEN_OPTS
    ```
    - 刷新配置文件：`source /etc/profile`
    - 测试是否安装成功：`mvn -version`


<h2 id="maven2">Maven 配置</h2>


<h2 id="maven3">资料</h2>

- <http://maven.apache.org/install.html>
- <http://www.tutorialspoint.com/maven/index.htm>
- <http://maven.apache.org/guides/getting-started/maven-in-five-minutes.html>
- <http://maven.apache.org/guides/getting-started/index.html>
- <http://maven.apache.org/general.html>