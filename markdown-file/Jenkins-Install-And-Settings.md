# Jenkins 安装和配置

## Jenkins 介绍

- 官网：<http://jenkins-ci.org/>
- 官网插件库：<https://plugins.jenkins.io/>
- 官网下载：<https://jenkins.io/download/>
- 官网帮助中心：<https://wiki.jenkins-ci.org/display/JENKINS/Use+Jenkins>

## Docker 下安装 Jenkins

- 先禁用 selinux
	- 编辑配置文件：`vim /etc/selinux/config`
	- 把 `SELINUX=enforcing` 改为 `SELINUX=disabled`
	- 重启服务器
- 官网下载中有介绍其版本标识：<https://jenkins.io/download/>
	- 我们就选用：Long-term Support (LTS)
- 官网关于 Docker 部署也有专门文档：<https://github.com/jenkinsci/docker/blob/master/README.md>
- 先创建一个宿主机以后用来存放数据的目录：`mkdir -p /data/jenkins/jenkins_home && chmod 777 -R /data/jenkins/jenkins_home`
- 安装镜像（813MB，有点大）：`docker pull jenkins/jenkins:lts`
- 查看下载下来的镜像：`docker images`
- 首次运行镜像：`docker run --name jenkins-master -p 8123:8080 -p 50000:50000 -v /etc/localtime:/etc/localtime -v /data/jenkins/jenkins_home:/var/jenkins_home -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai" -d --restart always jenkins/jenkins:lts`
	- 这里的 8080 端口是 jenkins 运行程序的端口，必须要有映射的。50000 端口是非必须映射的，但是如果你要用 Jenkins 分布式构建这个就必须开放
- 如果报下面的错误：

```
touch: cannot touch '/var/jenkins_home/copy_reference_file.log': Permission denied
Can not write to /var/jenkins_home/copy_reference_file.log. Wrong volume permissions?
```

- 解决办法：`chown -R 1000:1000 /data/jenkins/jenkins_home`，具体原因：[点击查看](http://www.cnblogs.com/jackluo/p/5783116.html)
	- 问题的本质就是，jenkins 镜像中的系统用户是：jenkins，当你进入容器 bash 内，输入：`whoami && id`，你就可以看到他的 uid 是 1000，所以这里才 chown 1000
- 查看容器运行情况：`docker ps`
- 进入容器中 Jenkins shell 交互界面：`docker exec -it bd290d5eb0d /bin/bash`

## 首次使用 Jenkins / Jenkins 插件推荐

- 首次进入 Jenkins 的 Web UI 界面是一个解锁页面，需要让你输入：Administrator password
	- 这个密码放在：`/var/jenkins_home/secrets/initialAdminPassword`，你需要先：`docker exec -it eec22d513b5b /bin/bash`，然后：`cat /data/jenkins/jenkins_home/secrets/initialAdminPassword`
- 然后再接下来就是插件的安装，我不推荐直接用它推荐给我们的插件直接安装，而是选择：`Select plugins to install`，我们自己选择插件安装。
- 我的这里的代码仓库是：Gitlab
- 推荐插件
	- Publish Over SSH（具体名字要看下）
	- Dashbroad View
	- Folders View
	- OWASP Markup Formatter Plugin
	- Build Name Setter Plugin
	- build timeout plugin
	- Credentials Binding Plugin
	- Embeddable Build Status Plugin
	- Pipeline
	- Build Pipeline Plugin
	- Docker Pipeline Plugin
	- Git plugin
	- GitLab Plugin
	- SSH Slaves plugin
	- Maven Integration plugin
	- Matrix Authorization Strategy Plugin
	- PAM Authentication plugin
	- LDAP Plugin
	- Role-based Authorization Strategy
	- Email Extension Plugin
	- Email Extension Template Plugin
	- Mailer Plugin
	- NotifyQQ（[QQ 消息通知](https://github.com/ameizi/NotifyQQ)）
	- 钉钉通知（[钉钉 消息通知](https://wiki.jenkins.io/display/JENKINS/Dingding+Notification+Plugin)）
	- oauth（具体名字要看下）
	- Build Failure Analyzer 分析构建错误日志并在构建页面显示错误
	- SSH plugin 支持通过SSH执行脚本
	- Pre SCM BuildStep Plugin 在拉代码之前插入一些步骤
	- GitHub API Plugin Github API插件
	- GitHub Pull Request Builder Github Pull Request时自动构建
	- GitHub plugin Github与Jenkins集成
	- GIT client plugin Git客户端插件
	- Maven Integration plugin：用于构建 Maven 项目
	- Gradle Plugin：用于构建 Gradle 项目
	- Gitlab Hook Plugin：用于触发 GitLab 的一些 WebHooks 来构建项目
	- FireLine Plugin：代码规范检查，已经集成了阿里巴巴的代码规约（P3C）检查
	- Gitlab Authentication 这个插件提供了使用GitLab进行用户认证和授权的方案
	- Docker Commons Plugin
	- Docker plugin
	- Kubernetes
	- Pre SCM BuildStep Plugin 在拉代码之前插入一些步骤
	- GitHub Pull Request Builder Github Pull Request时自动构建
	- GitHub API Plugin Github API插件
	- SonarQube Scanner for Jenkins ：代码质量管理插件。
	- AnsiColor（可选）：这个插件可以让Jenkins的控制台输出的log带有颜色
	- NodeJS Plugin


## Docker 的 Jenkins 与 Docker 结合使用

- 运行镜像命令：`docker run --name jenkins-master -p 8123:8080 -p 50000:50000 -v /etc/localtime:/etc/localtime -v /data/jenkins/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai" -d --restart always jenkins/jenkins:lts`
	- 比上面多了一步：`-v /var/run/docker.sock:/var/run/docker.sock`
- 这样，在 jenkins 里面写 shell 脚本调用 docker 程序，就可以直接调用宿主机的 docker 了。


## Jenkins 安装

- Jenkins 安装
    - 官网使用 Tomcat 部署方式指导：<https://wiki.jenkins-ci.org/display/JENKINS/Tomcat>
    - 此时（20160207） Jenkins 最新版本为：**1.647**
    - JDK 最低要求是 JDK 7，官网推荐是 JDK 8
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - Jenkins 下载：`wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war` （大小：61 M）
        - 我们假设这个 Tomcat 就是为了 Jenkins 专用的
        - 把下载下来的 jenkins.war 移到 Tomcat 的 webapps 目录下，比如我的是：`/usr/program/tomcat8/webapps`
        - 把 Jenkins.war 改名为 ROOT.war：`mv jenkins.war ROOT.war`
        - 删除 Tomcat 下 webapps 目录下多余的一些目录
        - 首次启动 Tomcat，让 Tomcat 解压 war
        - 设置 JENKINS_HOME：
            - 寻找 jenkins home 目录地址：`find / -name .jenkins`，我这边得到的结果是：`/root/.jenkins`
            - 对在 Tomcat 文章中讲解的系统变量 `CATALINA_OPTS` 进行设置：
                - 旧值：
                ```
                CATALINA_OPTS="-server -Xms528m -Xmx528m -XX:PermSize=256m -XX:MaxPermSize=358m"
                export CATALINA_OPTS
                ```
                - 改为：
                ```
                CATALINA_OPTS="-server -DJENKINS_HOME=/root/.jenkins -Xms528m -Xmx528m -XX:PermSize=256m -XX:MaxPermSize=358m"
                export CATALINA_OPTS
                ```

- Jenkins 各个组件配置：
    - 访问：<http://192.168.0.110:8080/configure>
- 其他问题
    - 如果访问的时候报这个异常：`java.net.UnknownHostException`，可以查看这篇文章：<http://stackoverflow.com/questions/4969156/java-net-unknownhostexception>


## 资料

- <http://stackoverflow.com/questions/4969156/java-net-unknownhostexception>
- <https://www.jianshu.com/p/b50e679e2409>
- <http://xkcoding.com/2018/01/04/devops-jenkins.html>