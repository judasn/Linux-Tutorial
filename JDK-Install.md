# JDK 安装


## CentOS 下过程

- JDK 在 CentOS 和 Ubuntu 下安装过程是一样的，所以这里不再讲 Ubuntu 系统下的安装
- JDK 1.8 下载
 - 此时（20160205）最新版本：`jdk-8u72-linux-x64.tar.gz`
 - 官网：<http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html>
 - 百度云下载（64 位）：<http://pan.baidu.com/s/1eQZffbW>
 - 官网压缩包地址：<http://211.138.156.198:82/1Q2W3E4R5T6Y7U8I9O0P1Z2X3C4V5B/download.oracle.com/otn-pub/java/jdk/8u72-b15/jdk-8u72-linux-x64.tar.gz>
 - 在命令行模式下下载上面压缩包：
    - `cd /opt`
    - `sudo wget http://211.138.156.198:82/1Q2W3E4R5T6Y7U8I9O0P1Z2X3C4V5B/download.oracle.com/otn-pub/java/jdk/8u72-b15/jdk-8u72-linux-x64.tar.gz`


- 默认 CentOS 有安装 openJDK，建议先卸载掉
 - 检查 JDK 命令：`java -version`
 - 查询本地 JDK 安装程序情况； `rpm -qa|grep java`
    - 我查询出来的结果如下：
   
    ```
    java-1.6.0-openjdk-1.6.0.38-1.13.10.0.el6_7.x86_64
    java-1.7.0-openjdk-1.7.0.95-2.6.4.0.el6_7.x86_64
    tzdata-java-2015g-2.el6.noarch
    ```

    - 卸载上面三个文件（`--nodeps` 的作用：忽略依赖的检查）：
    - `sudo rpm -e --nodeps java-1.6.0-openjdk-1.6.0.38-1.13.10.0.el6_7.x86_64`
    - `sudo rpm -e --nodeps java-1.7.0-openjdk-1.7.0.95-2.6.4.0.el6_7.x86_64`
    - `sudo rpm -e --nodeps tzdata-java-2015g-2.el6.noarch`
    - 也可以一起卸载：`sudo rpm -e --nodeps java-1.6.0-openjdk-1.6.0.38-1.13.10.0.el6_7.x86_64 java-1.7.0-openjdk-1.7.0.95-2.6.4.0.el6_7.x86_64 tzdata-java-2015g-2.el6.noarch`

- JDK 1.8 安装
    - 我们以安装 `jdk-8u72-linux-x64.tar.gz` 为例
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - 解压安装包：`sudo tar -zxvf jdk-8u72-linux-x64.tar.gz`
    - 移到解压包到我个人习惯的安装目录下：`mv jdk1.8.0_72/ /usr/program/`
    - 配置环境变量：
        - 编辑配置文件：`sudo vim /etc/profile`
        - 在该文件的最尾巴，添加下面内容：
        ```
        # JDK
        JAVA_HOME=/usr/program/jdk1.8.0_72
        JRE_HOME=$JAVA_HOME/jre
        PATH=$PATH:$JAVA_HOME/bin
        CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
        export JAVA_HOME
        export JRE_HOME
        export PATH
        export CLASSPATH
        ```
        - 执行命令，刷新该配置（必备操作）：`source /etc/profile`
        - 检查是否使用了最新的 JDK：`java -version`



## 其他

- JDK 历史版本下载地址整理（不间断更新）：
    - **JDK 9**：<https://jdk9.java.net/download/>
    - **JDK 8**：<http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html>
    - **JDK 7**：<http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html>
    - **JDK 6**：<http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-javase6-419409.html>



## 资料

 - <http://www.jikexueyuan.com/course/480_1.html?ss=1>
 - <>
 - <>
 - <>
 