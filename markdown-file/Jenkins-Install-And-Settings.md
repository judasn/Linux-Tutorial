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
- 首次运行镜像：`docker run --name jenkins-master -p 8123:18080 -p 50000:50000 -v /etc/localtime:/etc/localtime -v /data/jenkins/jenkins_home:/var/jenkins_home -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai" -d --restart always jenkins/jenkins:lts`
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
	- 360 FireLine：代码规范检查，已经集成了阿里巴巴的代码规约（P3C）检查
    - AnsiColor（可选）：这个插件可以让Jenkins的控制台输出的log带有颜色
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
	- Docker Commons Plugin
	- Docker plugin
	- Kubernetes
	- Pre SCM BuildStep Plugin 在拉代码之前插入一些步骤
	- GitHub Pull Request Builder Github Pull Request时自动构建
	- GitHub API Plugin Github API插件
	- NodeJS Plugin


## Docker 的 Jenkins 与 Docker 结合使用

- 运行镜像命令：`docker run --name jenkins-master -p 8123:18080 -p 50000:50000 -v /etc/localtime:/etc/localtime -v /data/jenkins/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai" -d --restart always jenkins/jenkins:lts`
	- 比上面多了一步：`-v /var/run/docker.sock:/var/run/docker.sock`
- 这样，在 jenkins 里面写 shell 脚本调用 docker 程序，就可以直接调用宿主机的 docker 了。

-------------------------------------------------------------------

## Jenkins 安装（YUM）

- **需要 JDK8 环境**
- 当前最新版本：`2.138.1-1.1`（201810）
- 官网安装说明 RedHat Linux RPM packages：<https://pkg.jenkins.io/redhat-stable/>
- 官网在线安装（72M），该安装方式会自己生成一个 jenkins 用户组和用户：

```
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

sudo yum install -y jenkins
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

- 控制台输出方式启动：`java -jar /usr/lib/jenkins/jenkins.war --httpPort=18080`
- 内置 Jetty，默认是 18080 端口，你也可以改为其他（建议修改为其他）
- 可以看到有一个这个重点内容，这是你的初始化密码，等下会用到的：


```
Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

daacc724767640a29ddc99d159a80cf8

This may also be found at: /root/.jenkins/secrets/initialAdminPassword
```

- 守护进程启动：`nohup java -jar /usr/lib/jenkins/jenkins.war --httpPort=18080 > /dev/null 2>&1 &`
- 浏览器访问 Jenkins 首页开始配置：<http://192.168.0.105:18080/>
- 特殊情况：
	- 如果配置插件过程遇到这个错误：`No valid crumb was included in the request`，则多重试几次。
	- 登录后把：<http://192.168.0.105:18080/configureSecurity/> 下面的 `防止跨站点请求伪造` 勾选去掉。遇到问题多试几次。

-------------------------------------------------------------------

## pipeline 语法

- 全局 pipeline 语法说明：<http://192.168.0.105:18080/job/react/pipeline-syntax/globals>
- 其他资料
	- <http://www.cnblogs.com/fengjian2016/p/8227532.html>
	- <https://github.com/nbbull/jenkins2Book>
	- <https://github.com/mcpaint/learning-jenkins-pipeline>
	- <https://www.cnblogs.com/fengjian2016/p/8227532.html>
	- <https://blog.csdn.net/diantun00/article/details/81075007>

#### 内置的参数

```
BUILD_NUMBER = ${env.BUILD_NUMBER}"
BUILD_ID = ${env.BUILD_ID}"
BUILD_DISPLAY_NAME = ${env.BUILD_DISPLAY_NAME}"
JOB_NAME = ${env.JOB_NAME}"
JOB_BASE_NAME = ${env.JOB_BASE_NAME}"
WORKSPACE = ${env.WORKSPACE}"
JENKINS_HOME = ${env.JENKINS_HOME}"
JENKINS_URL = ${env.JENKINS_URL}"
BUILD_URL = ${env.BUILD_URL}"
JOB_URL = ${env.JOB_URL}"
```

- 输出结果：

```
BUILD_NUMBER = 21
BUILD_ID = 21
BUILD_DISPLAY_NAME = #21
JOB_NAME = react
JOB_BASE_NAME = react
WORKSPACE = /root/.jenkins/workspace/react
JENKINS_HOME = /root/.jenkins
JENKINS_URL = http://192.168.0.105:18080/
BUILD_URL = http://192.168.0.105:18080/job/react/21/
JOB_URL = http://192.168.0.105:18080/job/react/
```

#### 构建时指定参数

- 如果要构建的时候明确输入参数值，可以用 `parameters`：

```
pipeline {
  agent any

  parameters {
    string(name: 'assignVersionValue', defaultValue: '1.1.3', description: '构建之前请先指定版本号')
  }
  
  tools {
    jdk 'JDK8'
    maven 'MAVEN3'
  }

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }


  environment {
    gitUrl = "https://gitee.com/youmeek/springboot-jenkins-demo.git"
    branchName = "master"
    giteeCredentialsId = "Gitee"
    projectWorkSpacePath = "${env.WORKSPACE}"
  }
  
  
  stages {
    
    stage('Check Env') {
    
      /*当指定的参数版本号等于空字符的时候进入 steps。这里的 when 对 当前 stage 有效，对其他 stage 无效*/
      when {
        environment name: 'assignVersionValue', value: ''
      }
    
      /*结束整个任务。如果不想结束整个任务，就不要用：exit 1*/
      steps {
        sh "exit 1"
      }
    }
    
    stage('Pre Env') {
    
      steps {
        echo "======================================项目名称 = ${env.JOB_NAME}"
        echo "======================================项目 URL = ${gitUrl}"
        echo "======================================项目分支 = ${branchName}"
        echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
        echo "======================================项目空间文件夹路径 = ${projectWorkSpacePath}"
        echo "======================================构建时自己指定的版本号值 = ${params.assignVersionValue}"
      }
    }
        
  }
}
```


#### 定时构建

```
pipeline {
  agent any
  
  /*采用 linux cron 语法即可*/
  triggers {
    cron('*/1 * * * *')
  }
  
  tools {
    jdk 'JDK8'
    maven 'MAVEN3'
  }

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }


  environment {
    gitUrl = "https://gitee.com/youmeek/springboot-jenkins-demo.git"
    branchName = "master"
    giteeCredentialsId = "Gitee"
    projectWorkSpacePath = "${env.WORKSPACE}"
  }
  
  
  stages {
    
    stage('Pre Env') {
      steps {
         echo "======================================项目名称 = ${env.JOB_NAME}"
         echo "======================================项目 URL = ${gitUrl}"
         echo "======================================项目分支 = ${branchName}"
         echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
         echo "======================================项目空间文件夹路径 = ${projectWorkSpacePath}"
      }
    }
    
  }
}

```

#### 同时构建其他 Job

```
stage('运行其他任务') {
  steps {
      build job: '任务名称'
  }
}
```


-------------------------------------------------------------------

## Jenkins 前端 React 项目构建

- **确保**：安装了 [Node.js](Node-Install-And-Usage.md)

#### 简单的 pipeline 写法（开源项目）

```
pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  /*=======================================常修改变量-start=======================================*/

  environment {
    gitUrl = "https://github.com/satan31415/heh_umi_template.git"
    branchName = "master"
    projectBuildPath = "${env.WORKSPACE}/dist"
    nginxHtmlRoot = "/usr/share/nginx/react"
  }
  
  /*=======================================常修改变量-end=======================================*/
  
  stages {
    
    stage('Pre Env') {
      steps {
         echo "======================================项目名称 = ${env.JOB_NAME}"
         echo "======================================项目 URL = ${gitUrl}"
         echo "======================================项目分支 = ${branchName}"
         echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
         echo "======================================项目 Build 文件夹路径 = ${projectBuildPath}"
         echo "======================================项目 Nginx 的 ROOT 路径 = ${nginxHtmlRoot}"
      }
    }
    
    stage('Git Clone'){
      steps {
          git branch: "${branchName}", url: "${gitUrl}"
      }
    }

    stage('NPM Install') {
      steps {
        sh "npm install"
      }
    }

    stage('NPM Build') {
      steps {
        sh "npm run build"
      }
    }

    stage('Nginx Deploy') {
      steps {
        sh "rm -rf ${nginxHtmlRoot}/"
        sh "cp -r ${projectBuildPath}/ ${nginxHtmlRoot}/"
      }
    }


  }
}
```


#### 简单的 pipeline 写法（闭源项目 -- 码云为例）

- 新增一个全局凭据：<http://192.168.0.105:18080/credentials/store/system/domain/_/newCredentials>
- 类型：`Username with password`
- 范围：`全局`
- Username：`你的 Gitee 账号`
- Password：`你的 Gitee 密码`
- **ID**：`只要是唯一值就行，后面要用到`
- 描述：`最好跟 ID 一致，方便认`

```
pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  /*=======================================常修改变量-start=======================================*/

  environment {
    gitUrl = "https://gitee.com/youmeek/react-demo.git"
    branchName = "master"
    giteeCredentialsId = "上面全局凭据填写的 ID"
    projectBuildPath = "${env.WORKSPACE}/dist"
    nginxHtmlRoot = "/usr/share/nginx/react"
  }
  
  /*=======================================常修改变量-end=======================================*/
  
  stages {
    
    stage('Pre Env') {
      steps {
         echo "======================================项目名称 = ${env.JOB_NAME}"
         echo "======================================项目 URL = ${gitUrl}"
         echo "======================================项目分支 = ${branchName}"
         echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
         echo "======================================项目 Build 文件夹路径 = ${projectBuildPath}"
         echo "======================================项目 Nginx 的 ROOT 路径 = ${nginxHtmlRoot}"
      }
    }
    
    stage('Git Clone'){
      steps {
          git branch: "${branchName}",
          credentialsId: "${giteeCredentialsId}",
          url: "${gitUrl}"
      }
    }

    stage('NPM Install') {
      steps {
        sh "npm install"
      }
    }

    stage('NPM Build') {
      steps {
        sh "npm run build"
      }
    }

    stage('Nginx Deploy') {
      steps {
        sh "rm -rf ${nginxHtmlRoot}/"
        sh "cp -r ${projectBuildPath}/ ${nginxHtmlRoot}/"
      }
    }


  }
}
```


-------------------------------------------------------------------

## Jenkins 后端 Spring Boot 项目构建

#### 安装 Maven

- [参考该文章](Maven-Install-And-Settings.md)

#### 配置工具

- 访问：<http://192.168.0.105:18080/configureTools/>
- 我习惯自己安装，所以这里修改配置：
	- **需要注意**：配置里面的 `别名` 不要随便取名字，后面 Pipeline 要用到的。在 tool 标签里面会用到。
	- 具体可以查看该图片说明：[点击查看](https://upload-images.jianshu.io/upload_images/12159-ef61595aebaa4244.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### 简单的 pipeline 写法（Jar 方式运行）（闭源项目 -- 码云为例）

###### 用 supervisord 做进程控制

- [supervisord 的使用](Daemontools.md)
- 生成 supervisord 的配置文件会写在 Pipeline，所以只要你保证服务器 supervisord 正常运行即可

###### 配置 Jenkins

- **必须**：新增一个全局凭据，方法参考前端部分

```
pipeline {
  agent any

  /*=======================================工具环境修改-start=======================================*/
  tools {
    jdk 'JDK8'
    maven 'MAVEN3'
  }
  /*=======================================工具环境修改-end=======================================*/

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  /*=======================================常修改变量-start=======================================*/

  environment {
    gitUrl = "https://gitee.com/youmeek/springboot-jenkins-demo.git"
    branchName = "master"
    giteeCredentialsId = "Gitee"
    projectWorkSpacePath = "${env.WORKSPACE}"
    projectBuildTargetPath = "${env.WORKSPACE}/target"
    projectJarNewName = "${env.JOB_NAME}.jar"
    supervisorConfigFileFullPath = "/etc/supervisor/conf.d/${env.JOB_NAME}.conf"
    supervisorLogPath = "/var/log/supervisor"

  }
  
  /*=======================================常修改变量-end=======================================*/
  
  stages {
    
    stage('Pre Env') {
      steps {
         echo "======================================项目名称 = ${env.JOB_NAME}"
         echo "======================================项目 URL = ${gitUrl}"
         echo "======================================项目分支 = ${branchName}"
         echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
         echo "======================================项目空间文件夹路径 = ${projectWorkSpacePath}"
         echo "======================================项目 build 后 jar 路径 = ${projectBuildTargetPath}"
         echo "======================================项目 jar 新名称 = ${projectJarNewName}"
         echo "======================================supervisor 配置文件路径 = ${supervisorConfigFileFullPath}"
         echo "======================================supervisor 存放 log 路径 = ${supervisorLogPath}"
      }
    }
    
    stage('Git Clone'){
      steps {
          git branch: "${branchName}",
          credentialsId: "${giteeCredentialsId}",
          url: "${gitUrl}"
      }
    }

    stage('Maven Clean') {
      steps {
        sh "mvn clean"
      }
    }

    stage('Maven Package') {
      steps {
        sh "mvn package -DskipTests"
      }
    }

    stage('Spring Boot Run') {
      steps {

sh """
mv ${projectBuildTargetPath}/*.jar ${projectBuildTargetPath}/${projectJarNewName}

if [ ! -f ${supervisorConfigFileFullPath} ]; then

touch ${supervisorConfigFileFullPath}
    
cat << EOF >> ${supervisorConfigFileFullPath}
[program:${env.JOB_NAME}]
command=java -jar ${projectBuildTargetPath}/${projectJarNewName}
stdout_logfile=${supervisorLogPath}/${env.JOB_NAME}.log
stderr_logfile=${supervisorLogPath}/${env.JOB_NAME}-err.log
user=root
autostart=true
autorestart=false
startsecs=5
priority=1
stopasgroup=true
killasgroup=true
EOF

/usr/bin/supervisorctl update
fi

/usr/bin/supervisorctl restart ${env.JOB_NAME}
"""

      }
    }

  }
}
```



#### 简单的 pipeline 写法（Docker 方式运行）（闭源项目 -- 码云为例）

- **确保** 项目根目录有 Dockerfile 文件（部分内容自己修改），内容模板：

```
FROM java:8
VOLUME /tmp

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD ./target/buildApp.jar /app.jar

RUN bash -c 'touch /app.jar'

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "-Xms512M", "-Xmx512M" , "-XX:MetaspaceSize=128M", "-XX:MaxMetaspaceSize=256M" ,"/app.jar"]
```

- Pipeline 写法

```
pipeline {
  agent any

  /*=======================================工具环境修改-start=======================================*/
  tools {
    jdk 'JDK8'
    maven 'MAVEN3'
  }
  /*=======================================工具环境修改-end=======================================*/

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  /*=======================================常修改变量-start=======================================*/

  environment {
    gitUrl = "https://gitee.com/youmeek/springboot-jenkins-demo.git"
    branchName = "master"
    giteeCredentialsId = "Gitee"
    projectWorkSpacePath = "${env.WORKSPACE}"
    projectBuildTargetPath = "${env.WORKSPACE}/target"
    projectJarNewName = "buildApp.jar"


    dockerImageName = "docker.youmeek.com/demo/${env.JOB_NAME}:${env.BUILD_NUMBER}"
    dockerContainerName = "${env.JOB_NAME}"
    inHostPort = "8082"
    inDockerAndJavaPort = "8081"
    inHostLogPath = "/data/docker/logs/${dockerContainerName}/${env.BUILD_NUMBER}"
    inDockerLogPath = "/data/logs"
    dockerRunParam = "--name=${dockerContainerName} --hostname=${dockerContainerName} -v /etc/hosts:/etc/hosts -v ${inHostLogPath}:${inDockerLogPath} --restart=always  -p ${inHostPort}:${inDockerAndJavaPort}"
  }
  
  /*=======================================常修改变量-end=======================================*/
  
  stages {
    
    stage('Pre Env') {
      steps {
         echo "======================================项目名称 = ${env.JOB_NAME}"
         echo "======================================项目 URL = ${gitUrl}"
         echo "======================================项目分支 = ${branchName}"
         echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
         echo "======================================项目空间文件夹路径 = ${projectWorkSpacePath}"
         echo "======================================项目 build 后 jar 路径 = ${projectBuildTargetPath}"
         echo "======================================项目 jar 新名称 = ${projectJarNewName}"
         echo "======================================Docker 镜像名称 = ${dockerImageName}"
         echo "======================================Docker 容器名称 = ${dockerContainerName}"
      }
    }
    
    stage('Git Clone'){
      steps {
          git branch: "${branchName}",
          credentialsId: "${giteeCredentialsId}",
          url: "${gitUrl}"
      }
    }

    stage('Maven Clean') {
      steps {
        sh "mvn clean"
      }
    }

    stage('Maven Package') {
      steps {
        sh "mvn package -DskipTests"
      }
    }

    stage('构建 Docker 镜像') {
      steps {
        sh """
            mv ${projectBuildTargetPath}/*.jar ${projectBuildTargetPath}/${projectJarNewName}
            
            cd ${projectWorkSpacePath}
            
            docker build -t ${dockerImageName} ./
        """
      }
    }

    stage('运行 Docker 镜像') {
      steps {
        sh """
            docker stop ${dockerContainerName} | true

            docker rm -f ${dockerContainerName} | true
            
            docker run -d  ${dockerRunParam} ${dockerImageName}
        """
      }
    }
    
    

    
    

  }
}
```


#### 简单的 pipeline 写法（Docker + Harbor 方式运行）（闭源项目 -- 码云为例）

- 请先看懂上面 Docker 方式
- 一共需要 3 台机子（要保证在内网环境，不然一定会有安全问题）
	- 一台部署 [Harbor](Harbor-Install-And-Usage.md)
	- 一台部署 Jenkins
	- 一台运行项目
- 确保 Jenkins 机子已经 Docker Login Harbor，这个就一次性的动作，所以自己在 Jenkins 服务器上操作即可
- 确保 Spring Boot 项目运行的机子已经 Docker Login Harbor，这个就一次性的动作，所以自己在 Jenkins 服务器上操作即可
- 确保 Spring Boot 项目运行的机子 docker remote api 开启（没有身份认证功能，所以才要保证内网）
- Pipeline 写法

```
pipeline {
  agent any

  /*=======================================工具环境修改-start=======================================*/
  tools {
    jdk 'JDK8'
    maven 'MAVEN3'
  }
  /*=======================================工具环境修改-end=======================================*/

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  /*=======================================常修改变量-start=======================================*/

  environment {
    gitUrl = "https://gitee.com/youmeek/springboot-jenkins-demo.git"
    branchName = "master"
    giteeCredentialsId = "Gitee"
    projectWorkSpacePath = "${env.WORKSPACE}"
    projectBuildTargetPath = "${env.WORKSPACE}/target"
    projectJarNewName = "buildApp.jar"

    projectDockerDaemon = "tcp://192.168.1.12:2376"
    harborUrl = "192.168.1.13"
    harborProjectName = "demo"
    dockerImageName = "${harborUrl}/${harborProjectName}/${env.JOB_NAME}:${env.BUILD_NUMBER}"
    dockerContainerName = "${env.JOB_NAME}"
    inHostPort = "8082"
    inDockerAndJavaPort = "8081"
    inHostLogPath = "/data/docker/logs/${dockerContainerName}/${env.BUILD_NUMBER}"
    inDockerLogPath = "/data/logs"
    dockerRunParam = "--name=${dockerContainerName} --hostname=${dockerContainerName} -v /etc/hosts:/etc/hosts -v ${inHostLogPath}:${inDockerLogPath} --restart=always  -p ${inHostPort}:${inDockerAndJavaPort}"
  }
  
  /*=======================================常修改变量-end=======================================*/
  
  stages {
    
    stage('Pre Env') {
      steps {
         echo "======================================项目名称 = ${env.JOB_NAME}"
         echo "======================================项目 URL = ${gitUrl}"
         echo "======================================项目分支 = ${branchName}"
         echo "======================================当前编译版本号 = ${env.BUILD_NUMBER}"
         echo "======================================项目空间文件夹路径 = ${projectWorkSpacePath}"
         echo "======================================项目 build 后 jar 路径 = ${projectBuildTargetPath}"
         echo "======================================项目 jar 新名称 = ${projectJarNewName}"
         echo "======================================Docker 镜像名称 = ${dockerImageName}"
         echo "======================================Docker 容器名称 = ${dockerContainerName}"
         echo "======================================harbor 地址 = ${harborUrl}"
         echo "======================================harbor 项目名称 = ${harborProjectName}"
         echo "======================================项目在宿主机的端口 = ${inHostPort}"
         echo "======================================项目在 Docker 容器中的端口 = ${inDockerAndJavaPort}"
         echo "======================================项目在宿主机的 log 路径 = ${inHostLogPath}"
         echo "======================================项目在 docker 容器的 log 路径 = ${inDockerLogPath}"
         echo "======================================项目运行的 Docker remote ip 信息 = ${projectDockerDaemon}"
         echo "======================================项目运行的参数 = ${dockerRunParam}"
      }
    }
    
    stage('Git Clone'){
      steps {
          git branch: "${branchName}",
          credentialsId: "${giteeCredentialsId}",
          url: "${gitUrl}"
      }
    }

    stage('Maven Clean') {
      steps {
        sh "mvn clean"
      }
    }

    stage('Maven Package') {
      steps {
        sh "mvn package -DskipTests"
      }
    }

    stage('构建 Docker 镜像') {
      steps {
        sh """
            mv ${projectBuildTargetPath}/*.jar ${projectBuildTargetPath}/${projectJarNewName}
            
            cd ${projectWorkSpacePath}
            
            docker build -t ${dockerImageName} ./
        """
      }
    }

    stage('Push Docker 镜像') {
      options {
        timeout(time: 5, unit: 'MINUTES') 
      }
      steps {
        sh """
          docker push ${dockerImageName}
          docker rmi ${dockerImageName}
        """
      }
    }

    stage('运行远程 Docker 镜像') {
      options {
        timeout(time: 5, unit: 'MINUTES') 
      }
      steps {
        sh """
            docker -H ${projectDockerDaemon} pull ${dockerImageName}
            
            docker -H ${projectDockerDaemon} stop ${dockerContainerName} | true
            
            docker -H ${projectDockerDaemon} rm -f ${dockerContainerName} | true
            
            docker -H ${projectDockerDaemon} run -d  ${dockerRunParam} ${dockerImageName}
        """
      }
    }
    
    

    
    

  }
}
```





-------------------------------------------------------------------

## 多节点 master 与 slave 

- 可以参考这篇：<http://www.cnblogs.com/sparkdev/p/7102622.html>


-------------------------------------------------------------------


## 资料

- <http://stackoverflow.com/questions/4969156/java-net-unknownhostexception>
- <https://www.jianshu.com/p/b50e679e2409>
- <http://xkcoding.com/2018/01/04/devops-jenkins.html>
