 
 
# SonarQube 使用
 
## 环境说明
 
- CentOS 7.3
- 不建议在 Windows 上使用
 
## SonarQube 基本概念

- 官网：<https://www.sonarqube.org/>
- 官网下载：<https://www.sonarqube.org/downloads/>
- Github 主页（主要是用 Java 开发）：<https://github.com/SonarSource/sonarqube>
- 当前（2018-02）最新 LTS 是：6.7.1，最新发布版本：7.0
- 主要支持的语言项目有：

```
C/C++
JavaScript
C#
Java
COBOL
TypeScript
PL/SQL
PL/I
PHP
ABAP
T-SQL
VB.NET
VB6
Python
RPG
Flex
Objective-C
Swift
Web（HTML and JSF/JSP）
XML
```

## Docker 的 SonarQube 安装和基本配置

#### 简单 docker 方式

- 一个命令（没有挂载）：`docker run -d --name sonarqube -p 19000:9000 -p 19092:9092 -e "TZ=Asia/Shanghai" -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD=sonar -e SONARQUBE_JDBC_URL=jdbc:postgresql://112.74.49.55:5433/sonar sonarqube`
- 一个命令（有挂载）：`docker run -d --name sonarqube -p 19000:9000 -p 19092:9092 -v /data/docker/ci/sonarqube/conf:/opt/sonarqube/conf -v /data/docker/ci/sonarqube/data:/opt/sonarqube/data -v /data/docker/ci/sonarqube/extension:/opt/sonarqube/extensions -v /data/docker/ci/sonarqube/bundled-plugins:/opt/sonarqube/lib/bundled-plugins -e "TZ=Asia/Shanghai" -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD=sonar -e SONARQUBE_JDBC_URL=jdbc:postgresql://120.79.2.92:5433/sonar sonarqube`



- 在浏览器里打开：<http://112.74.49.55:19000/>
- 管理员用户名、密码都是：`admin`

#### docker-compose 方式

- 官网文档：<https://github.com/SonarSource/docker-sonarqube/blob/master/recipes.md>

```
postgresql:
  restart: always
  image: sameersbn/postgresql:9.6-2
  ports:
    - "5433:5432"
  environment:
    - DB_USER=sonar
    - DB_PASS=sonar
    - DB_NAME=sonar
    - DB_EXTENSION=pg_trgm
  volumes:
    - /data/docker/ci/postgresql:/var/lib/postgresql
sonarqube:
  restart: always
  image: sonarqube
  ports:
   - "19000:9000"
   - "19092:9092"
  links:
    - postgresql:postgresql
  depends_on:
    - postgresql
  environment:
    - SONARQUBE_JDBC_URL=jdbc:postgresql://postgresql:5433/sonar
    - SONARQUBE_JDBC_USERNAME=sonar
    - SONARQUBE_JDBC_PASSWORD=sonar
  volumes:
    - /data/docker/ci/sonarqube/conf:/opt/sonarqube/conf
    - /data/docker/ci/sonarqube/data:/opt/sonarqube/data
    - /data/docker/ci/sonarqube/extension:/opt/sonarqube/extensions
    - /data/docker/ci/sonarqube/bundled-plugins:/opt/sonarqube/lib/bundled-plugins
```


- 一整套完整服务：

```
version: '3'

networks:
  prodnetwork:
    driver: bridge

services:
 nexus:
  image: sonatype/nexus3
  ports:
    - 8081:8081
  networks:
    - prodnetwork

 jenkins:
  image: jenkins
  ports:
    - 8080:8080
  networks:
    - prodnetwork
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - /usr/local/bin/docker:/usr/bin/docker
    - /opt/jenkins/:/var/lib/jenkins/
  links:
    - nexus
    - gitlab
    - sonar
  environment:
    - NEXUS_PORT=8081
    - SONAR_PORT=9000
    - SONAR_DB_PORT=5432

 sonar:
  image: sonarqube
  ports:
   - 9000:9000
  networks:
    - prodnetwork
  links:
    - sonardb
  environment:
   - SONARQUBE_JDBC_URL=jdbc:postgresql://sonardb:5432/sonar
   - SONARQUBE_JDBC_USERNAME=sonar
   - SONARQUBE_JDBC_PASSWORD=sonar
 sonardb:
  networks:
    - prodnetwork
  image: postgres
  ports: 
   - 5432:5432
  environment:
   - POSTGRES_DB=sonar
   - POSTGRES_USER=sonar
   - POSTGRES_PASSWORD=sonar 
  volumes:
    - /opt/postgres/data:/var/lib/postgresql/data

 gitlab:
  image: gitlab/gitlab-ce
  restart: always
  networks:
    - prodnetwork
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      # external_url 'https://gitlab.example.com'
      # Add any other gitlab.rb configuration here, each on its own line
  ports:
    - 80:80
    - 443:443
    - 2222:22
  volumes:
    - /opt/gitlab/config:/etc/gitlab
    - /opt/gitlab/logs:/var/log/gitlab
    - /opt/gitlab/data:/var/opt/gitlab
```



## SonarQube 插件

这里我安装的插件：

chinese 中文支持
php php代码支持
Android Android支持
安装成功后，重启 sonarqube 服务，再次访问 http://ip:9000/ 即可看到中文界面


## 与 Jenkins 集成

用 admin 用户登陆 sonarQube，【配置】–>【权限】 –>【用户】
输入admin,得到token,复制此token
jenkins安装sonar相关插件
Jenkins 点击【系统管理】 –> 【系统设置]】 配置 Sonar，设置完保存


## 资料

- <http://witmax.cn/sonarqube-docker.html>
- <https://www.chen-hao.com.cn/posts/2754/>
- <>
- <>
- <>
























