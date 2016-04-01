# Jenkins 安装和配置


## Jenkins 安装

- Jenkins 安装
    - 官网：<http://jenkins-ci.org/>
    - 官网帮助中心：<https://wiki.jenkins-ci.org/display/JENKINS/Use+Jenkins>
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