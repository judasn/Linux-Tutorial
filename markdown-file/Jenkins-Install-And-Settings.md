# Jenkins 安装和配置

## Jenkins 介绍

- 官网：<http://jenkins-ci.org/>
- 官网插件库：<https://plugins.jenkins.io/>
- 官网下载：<https://jenkins.io/download/>
- 官网帮助中心：<https://wiki.jenkins-ci.org/display/JENKINS/Use+Jenkins>

## Docker 下安装 Jenkins

- 配置：至少需要 2G 内存
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

- 我这里就不截图了，有需要截图可以看这博文，差不多就是这样的：[点击我o(∩_∩)o ](https://blog.csdn.net/boling_cavalry/article/details/78942408)
- 首次进入 Jenkins 的 Web UI 界面是一个解锁页面 Unlock Jenkins，需要让你输入：Administrator password
	- 这个密码放在：`/var/jenkins_home/secrets/initialAdminPassword`，你需要先：`docker exec -it ci_jenkins_1 /bin/bash`
		- 然后：`cat /data/jenkins/jenkins_home/secrets/initialAdminPassword`
		- 也有可能是这个目录：`cat /var/jenkins_home/secrets/initialAdminPassword`
- 然后再接下来就是插件的安装，我推荐直接用它推荐给我们的插件直接安装，稍后再安装自己需要定制的。
- 插件安装完会进入：Create First Admin User 页面，填写一个用户信息即可。
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
	- Gitlab Plugin：可能会直接安装不成功，如果不成功根据报错的详细信息可以看到 hpi 文件的下载地址，挂代理下载下来，然后离线安装即可
	- Gitlab Hook：用于触发 GitLab 的一些 WebHooks 来构建项目
	- Gitlab Authentication 这个插件提供了使用GitLab进行用户认证和授权的方案
	- FireLine Plugin：代码规范检查，已经集成了阿里巴巴的代码规约（P3C）检查
	- Docker Commons Plugin
	- Docker plugin
	- Kubernetes
	- Pre SCM BuildStep Plugin 在拉代码之前插入一些步骤
	- GitHub Pull Request Builder Github Pull Request时自动构建
	- GitHub API Plugin Github API插件
	- AnsiColor（可选）：这个插件可以让Jenkins的控制台输出的log带有颜色
	- NodeJS Plugin


## Docker 的 Jenkins 与 Docker 结合使用

- 运行镜像命令：`docker run --name jenkins-master -p 8123:8080 -p 50000:50000 -v /etc/localtime:/etc/localtime -v /data/jenkins/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai" -d --restart always jenkins/jenkins:lts`
	- 比上面多了一步：`-v /var/run/docker.sock:/var/run/docker.sock`
- 这样，在 jenkins 里面写 shell 脚本调用 docker 程序，就可以直接调用宿主机的 docker 了。

-------------------------------------------------------------------

## Jenkins 安装（YUM）

- **需要 JDK8 环境**
- 官网安装说明 RedHat Linux RPM packages：<https://pkg.jenkins.io/redhat-stable/>
- 官网在线安装（72M）：

```
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum install jenkins
```

- 查看安装后的情况：`rpm -ql jenkins`

```
/etc/init.d/jenkins
/etc/logrotate.d/jenkins
/etc/sysconfig/jenkins
/usr/lib/jenkins
/usr/lib/jenkins/jenkins.war
/usr/sbin/rcjenkins
/var/cache/jenkins
/var/lib/jenkins
/var/log/jenkins
```

- jenkins 相关目录释义：

```
/usr/lib/jenkins/：jenkins安装目录，war 包会放在这里。
/etc/sysconfig/jenkins：jenkins配置文件，“端口”，“JENKINS_HOME” 等都可以在这里配置。
/var/lib/jenkins/：默认的 JENKINS_HOME。
/var/log/jenkins/jenkins.log：jenkins 日志文件。
```

- 配置 jenkins 端口，默认是：8080

```
vim /etc/sysconfig/jenkins

56 行：JENKINS_PORT="8080"
```

- 控制台输出方式启动：`java -jar /usr/lib/jenkins/jenkins.war`
- 可以看到有一个这个重点内容，这是你的初始化密码，等下会用到的：


```
Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

daacc724767640a29ddc99d159a80cf8

This may also be found at: /root/.jenkins/secrets/initialAdminPassword
```

- 守护进程启动：`nohup java -jar /usr/lib/jenkins/jenkins.war > /opt/jenkins-nohup.log 2>&1 &`
- 浏览器访问 Jenkins 首页开始配置：<http://192.168.0.105:8080/>


-------------------------------------------------------------------


## 资料

- <http://stackoverflow.com/questions/4969156/java-net-unknownhostexception>
- <https://www.jianshu.com/p/b50e679e2409>
- <http://xkcoding.com/2018/01/04/devops-jenkins.html>
