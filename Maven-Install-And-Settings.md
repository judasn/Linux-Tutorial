# Maven 安装和配置



##  Maven 安装

- Maven 安装
    - 官网：<http://maven.apache.org/>
    - 官网下载：<http://maven.apache.org/download.cgi>
    - 历史版本下载：<https://archive.apache.org/dist/maven/binaries/>
    - 此时（20160208） Maven 最新版本为：**3.3.9**
    - Maven 3.3 的 JDK 最低要求是 JDK 7
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - 下载压缩包：`wget http://mirrors.cnnic.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz`
    - 解压：`tar zxvf apache-maven-3.3.9-bin.tar.gz`
    - 修改目录名，默认的太长了：`mv apache-maven-3.3.9/ maven3.3.9/`
    - 移到我个人习惯的安装目录下：`mv maven3.3.9/ /usr/program`
    - 环境变量设置：`vim /etc/profile`
    - 在文件最尾巴添加下面内容：
    
    ``` ini
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


## Maven 配置

- 配置项目连接上私服
- 全局方式配置：

``` xml
<?xml version="1.0" encoding="UTF-8"?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <!--本地仓库位置-->
    <localRepository>D:/maven/my_local_repository</localRepository>

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

    <!--设置 Nexus 镜像，后面只要本地没对应的以来，则到 Nexus 去找-->
    <mirrors>
        <mirror>
            <id>nexus-releases</id>
            <mirrorOf>*</mirrorOf>
            <url>http://localhost:8081/nexus/content/groups/public</url>
        </mirror>
        <mirror>
            <id>nexus-snapshots</id>
            <mirrorOf>*</mirrorOf>
            <url>http://localhost:8081/nexus/content/groups/public-snapshots</url>
        </mirror>
    </mirrors>


    <profiles>
        <profile>
            <id>nexus</id>
            <repositories>
                <repository>
                    <id>nexus-releases</id>
                    <url>http://nexus-releases</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
                <repository>
                    <id>nexus-snapshots</id>
                    <url>http://nexus-snapshots</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>nexus-releases</id>
                    <url>http://nexus-releases</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </pluginRepository>
                <pluginRepository>
                    <id>nexus-snapshots</id>
                    <url>http://nexus-snapshots</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>

    <activeProfiles>
        <activeProfile>nexus</activeProfile>
    </activeProfiles>

</settings>
```

- 项目级别：




## 资料

- <http://maven.apache.org/install.html>
- <http://www.tutorialspoint.com/maven/index.htm>
- <http://maven.apache.org/guides/getting-started/maven-in-five-minutes.html>
- <http://maven.apache.org/guides/getting-started/index.html>
- <http://maven.apache.org/general.html>
- <http://stackoverflow.com/questions/6950346/infrastructure-with-maven-jenkins-nexus>
- <http://blog.csdn.net/sxyx2008/article/details/7975129>
- <http://blog.csdn.net/xuke6677/article/details/8482472>