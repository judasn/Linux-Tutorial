<h1 id="nexus0">Nexus 安装和配置</h1>

------

*   [Nexus 安装和配置](#nexus0)
    *   [Nexus 安装](#nexus1)
    *   [Nexus 配置](#nexus2)
    *   [资料](#nexus3)
    
------

<h2 id="nexus1">Nexus 安装</h2>

- maven 的 全局配置：
```
<?xml version="1.0" encoding="UTF-8"?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <!--本地仓库路径-->
    <localRepository>D:/maven/my_local_repository</localRepository>

    <pluginGroups>
    </pluginGroups>

    <proxies>
    </proxies>


    <servers>
        <!--配置 nexus 仓库用户名密码 -->
        <server>
            <id>releases</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
        
        <!--配置 nexus 仓库用户名密码 -->
        <server>
            <id>snapshots</id>
            <username>admin</username>
            <password>admin123</password>
        </server>

        <!-- 配置 tomcat 的用户名和密码 -->
        <server>
            <id>tomcatRole</id>
            <username>admin</username>
            <password>admin</password>
        </server>
    </servers>

    
    <mirrors>
        <mirror>
            <id>privateNexusMirror</id>
            <name>YouMeek Nexus</name>
            <mirrorOf>*</mirrorOf>
            <url>http://192.168.0.110:8081/nexus/content/groups/public/</url>
        </mirror>
    </mirrors>

    
    <profiles>
        <profile>
            <id>privateNexusProfile</id>
            <repositories>
                <repository>
                    <id>privateRepo</id>
                    <url>http://192.168.0.110:8081/nexus/content/groups/public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>
        </profile>
    </profiles>
    

    <activeProfiles>
        <activeProfile>privateNexusProfile</activeProfile>
    </activeProfiles>
    
</settings>
```
    
    
<h2 id="nexus3">资料</h2>

- <http://www.aliog.com/57903.html>
- <>
- <>
- <>
- <>