# Maven 安装和配置

## Maven 资料

- 官网：<http://maven.apache.org/>
- 官网下载：<http://maven.apache.org/download.cgi>
- 历史版本下载：<https://archive.apache.org/dist/maven/binaries/>
- 此时（20160208） Maven 最新版本为：**3.3.9**

##  Maven 安装（bash 环境）

- Maven 3.3 的 JDK 最低要求是 JDK 7
- 下载压缩包：`wget http://mirrors.cnnic.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz`
- 解压：`tar zxvf apache-maven-3.3.9-bin.tar.gz`
- 修改目录名，默认的太长了：`mv apache-maven-3.3.9/ maven3.3.9/`
- 移到我个人习惯的安装目录下：`mv maven3.3.9/ /usr/local`
- 环境变量设置：`vim /etc/profile`
- 在文件最尾巴添加下面内容：

``` ini
# Maven
MAVEN_HOME=/usr/local/maven3.3.9
M3_HOME=/usr/local/maven3.3.9
PATH=$PATH:$M3_HOME/bin
MAVEN_OPTS="-Xms256m -Xmx356m"
export M3_HOME
export MAVEN_HOME
export PATH
export MAVEN_OPTS
```

- 刷新配置文件：`source /etc/profile`
- 测试是否安装成功：`mvn -version`

## Maven 配置

- 创建本地参数：`mkdir -p /opt/maven-repository`
- 配置项目连接上私服
- 编辑配置文件：`vim /usr/local/maven3.3.9/conf/settings.xml`

``` xml
<?xml version="1.0" encoding="UTF-8"?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <!--本地仓库位置-->
    <localRepository>/opt/maven-repository</localRepository>

    <pluginGroups>
    </pluginGroups>

    <proxies>
    </proxies>

    <!--设置 Nexus 认证信息-->
    <servers>
        <server>
            <id>nexus-releases</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
        <server>
            <id>nexus-snapshots</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
    </servers>

    <!--有自己的 nexus 改为自己的-->
    <mirrors>
        <mirror>
            <id>aliyun-releases</id>
            <mirrorOf>*</mirrorOf>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        </mirror>
        <mirror>
            <id>aliyun-snapshots</id>
            <mirrorOf>*</mirrorOf>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        </mirror>
    </mirrors>

</settings>
```




## 资料

- <http://maven.apache.org/install.html>
- <http://www.tutorialspoint.com/maven/index.htm>
- <http://maven.apache.org/guides/getting-started/maven-in-five-minutes.html>
- <http://maven.apache.org/guides/getting-started/index.html>
- <http://maven.apache.org/general.html>
- <http://stackoverflow.com/questions/6950346/infrastructure-with-maven-jenkins-nexus>
- <http://blog.csdn.net/sxyx2008/article/details/7975129>
- <http://blog.csdn.net/xuke6677/article/details/8482472>