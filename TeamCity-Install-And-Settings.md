#  TeamCity 安装和配置



- ![TeamCity](http://img.youmeek.com/2016/TeamCity.jpg)


## 本文初衷

- 让大家了解持续集成（CI），以及入门了解 JetBrains 家的 TeamCity 的一些简单实用。
- TeamCity 的一些复杂使用我暂时也不会，一样也是要看文档的，所以不管怎样你都要养成看官网文档的习惯。
- TeamCity 和 Jenkins、Hudson 其实是非常一样的，基本流程都是差不多的，所以如果你会其他的几个 CI 工具的话，学习起来很快。
- Docker 已经开始在引入到 CI、CD（持续交付）过程中，可以大大简化整体的过程，也许这是未来的一个方向，有兴趣的可以了解更多。


## 它是什么

- 官网定义（就一句话）：`Powerful Continuous Integration out of the box`
- 官网首页：<https://www.jetbrains.com/teamcity/>
- 官网特性总结：<https://www.jetbrains.com/teamcity/features/>
- 百度百科：<http://baike.baidu.com/view/3703414.htm>
- 官网文档：<https://confluence.jetbrains.com/display/TCD9/TeamCity+Documentation>
- 支持的平台、环境如下图（看不懂也没关系，只要知道它最友好的是 Java 开发即可）：
- ![TeamCity](http://img.youmeek.com/2016/TeamCity-Supported-Platforms-and-Environments.png)
- 对上图的具体讲解可以看（**很重要**）：<https://confluence.jetbrains.com/display/TCD9/Supported+Platforms+and+Environments>

## 为什么会出现

- TeamCity 的出现需要了解这个概念：持续集成（Continuous Integration）
- 百科定义：<http://baike.baidu.com/view/5253255.htm>
- 网络文章：<http://www.ruanyifeng.com/blog/2015/09/continuous-integration.html>


## 哪些人喜欢它

- [持续集成学习笔记－入门篇（1）持续集成基本概念](http://blog.csdn.net/leijiantian/article/details/7916483)
- [7 reasons why you should be using Continuous Integration](https://about.gitlab.com/2015/02/03/7-reasons-why-you-should-be-using-ci/)
- [What is CI and why use it?](https://blog.rainforestqa.com/2014-07-17-what-is-CI-and-why-use-it/)


## 哪些人不喜欢它

- Google 不到结果，应该是没人不喜欢，只是有些人用不惯


## 为什么学习它

- 更好地保证项目质量


## 同类工具

- Jenkins：<http://jenkins-ci.org/>
- Travis CI：<http://travis-ci.org/>
- Bamboo：<http://www.atlassian.com/software/bamboo>
- Hudson：<http://hudson-ci.org/>
- QuickBuild：<http://www.pmease.com/>
- 其他：<http://www.oschina.net/project/tag/344/ci?lang=0&os=0&sort=view&p=1>
- 好的网络文章介绍：
    - [持续集成工具的选择](http://cristal.iteye.com/blog/482658)


## TeamCity 入门

- 先来看一段官网的介绍视频
- 这个视频其实已经很清楚地说明了一个整理流程是怎样的，我今天只是做一个更加清晰的细节讲解而已
- 你需要穿越：<https://www.youtube.com/watch?v=J-iYMMG6jmc#action=share>


### TeamCity 安装部署（Linux 环境）

- 在我讲之前，如果你英文还可以，就到官网这里看下：
- [Installation Quick Start](https://confluence.jetbrains.com/display/TCD9/Installation+Quick+Start#InstallationQuickStart-onLinuxandOSX)
- 安装环境要求：
    - JDK 1.7 以上，如果你要使用的是 2016 最新的 TeamCity 9.1 的话，JDK 官网推荐的 1.8
- 安装包下载：<https://www.jetbrains.com/teamcity/download/#section=linux-version>
- 开始安装（eg：TeamCity-9.1.6.tar.gz）：
    - 解压压缩包（解压速度有点慢）：`tar zxf TeamCity-9.1.6.tar.gz`
    - 解压完的目录结构讲解：<https://confluence.jetbrains.com/display/TCD9/TeamCity+Home+Directory>
    - 下载的 tar.gz 的本质是已经里面捆绑了一个 Tomcat，所以如果你会 Tomcat 的话，有些东西你可以自己改的。
    - 按我个人习惯，把解压缩的目录放在 usr 目录下：`mv TeamCity/ /usr/program/`
    - 进入解压目录：`cd /usr/program/TeamCity/`
    - 启动程序：`/usr/program/TeamCity/bin/runAll.sh start`
    - 停止程序：`/usr/program/TeamCity/bin/runAll.sh stop`
    - 启动需要点时间，最好能给它一两分钟吧
    

### 首次进入

- 假设我们已经启动了 TeamCity
- 访问（TeamCity 默认端口是：8111）：<http://192.168.1.113:8111/>
- 如果访问不了，请先关闭防火墙：`service iptables stop`
- 你也可以选择把端口加入白名单中：
    - `sudo iptables -I INPUT -p tcp -m tcp --dport 8111 -j ACCEPT`
    - `sudo /etc/rc.d/init.d/iptables save`
    - `sudo service iptables restart`
- 如果你要改变端口，找到下面这个 8111 位置：`vim /usr/program/TeamCity/conf/server.xml`

``` nginx
<Connector port="8111" ...
```

- 在假设你已经可以访问的情况，我们开始进入 TeamCity 的设置向导：
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-a-1.jpg)
    - 如上图英文所示，TeamCity 的一些软件安装的配置、服务的配置默认都会放在：`/root/.BuildServer`
    - 如果你要了解更多 TeamCity Data Directory 目录，你可以看：<https://confluence.jetbrains.com/display/TCD9/TeamCity+Data+Directory>
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-a-2.jpg)
    - 如上图英文所示，TeamCity 的一些构建历史、用户信息、构建结果等这类数据是需要放在关系型数据库上的，而默认它给我们内置了一个。
    - 如果你要了解更多 TeamCity External Database，你可以看：<https://confluence.jetbrains.com/display/TCD9/Setting+up+an+External+Database>
    - 首次使用，官网是建议使用默认的：`Internal(HSQLDB)`，这样我们无需在一开始使用的就考虑数据库迁移或安装的问题，我们只要好好感受 TeamCity 给我们的，等我们决定要使用了，后续再更换数据也是可以的。但是内置的有一个注意点：'TeamCity with the native MSSQL external database driver is not compatible with Oracle Java 6 Update 29, due to a bug in Java itself. You can use earlier or later versions of Oracle Java.'
    - 假设我们就选 `Internal(HSQLDB)` ，则在创建初始化数据库的过程稍微需要点时间，我这边是几分钟。
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-a-3.jpg)
    - 如上图所示，接受下协议
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-b-1.jpg)
    - 如上图所示，我们要创建一个顶级管理员账号，我个人习惯测试的账号是：`admin`，`123456`
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-b-2.jpg)
    - 如上图所示，安装完首次进来地址：<http://192.168.1.113:8111/profile.html?tab=userGeneralSettings>
    - 我们可以完善一些管理员信息和基础配置信息，这些配置不配置都无所谓了，只是完善了可以更加好用而已
    - 如果你有 SMTP 的邮箱，你可以来这里开启邮件通知功能：<http://192.168.1.113:8111/admin/admin.html?item=email>
    - 如果你要开启通知功能那肯定下一步就是考虑通知内容的模板要如何设定：<https://confluence.jetbrains.com/display/TCD9//Customizing+Notifications>
    - 模板存放路径在：`/root/.BuildServer/config/_notifications`，用的是 FreeMarker 的语法


### 项目的构建、管理

- 建议可以看下官网：<https://confluence.jetbrains.com/display/TCD9/Configure+and+Run+Your+First+Build>
- 现在让我们开始创建一个项目进行构建
- 项目管理地址：<http://192.168.1.113:8111/admin/admin.html?item=projects  >
- 假设我现在有一个项目的结构是这样的：
    - Youshop-Parent，输出是 pom
        - Youshop-manage，输出是 pom
            - Youshop-pojo，输出 jar
- 我们现在以 Youshop-pojo 为例，让它自动构建并发布到 Nexus 中，其他项目道理是一样的，这里就不多说。
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-1.jpg)
- 如上图，由于目前只要是公司的项目都应该是在版本控制的，所以这里我们选择：**Create project from URL**
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-2.jpg)
- 如上图，我们可以看出 TeamCity 也支持 HTTP、SVN、Git 等链接方式。
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-3.jpg)
- 输入你项目托管商的账号密码，我这里用的是 oschina 的。
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-4.jpg)
- 账号、密码验证通过，现在可以给这个项目配置一个项目基本信息。
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-5.jpg)
- 在从版本控制中下载文件和扫描文件
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-6.jpg)
- TeamCity 自动扫描到我是用 Maven 构建的项目，所以把 POM 文件找出来了，如果你一个项目有多种构建方式，有对应的配置文件的话，这里都会显示出来的。
- 我们勾选 Maven 前面的复选框，点击：`Use Selected`
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-7.jpg)
- 由于我们的目标是构建完自动发布到 Nexus，所以我们的 **Maven Goals** 应该是：`clean install deploy`，这里我们应该点击：`Edit`，进行编辑。
- 如果你不懂 **Maven Goals**，那你需要学习下，这个很重要。
    - 官网：<http://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html>
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-8.jpg)
    - 如上图，这台服务器必须装有 Maven、JDK
    - 如上图，`Goals` 我们的目标是 `clean install deploy`
    - 如上图，`Maven Home` 我建议是自己自定义路径，这样肯定不会有问题。所以你服务器上的 Maven 安装路径是什么你就在这里填写上去。Maven 目前支持的最高版本是：3.2.5
        - 下载 Maven 3.2.5：<http://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/>
    - 如上图，`Java Parameters` 我建议也是自己自定义路径，别选择其他选项。
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-9.jpg)
    - 如上图，点击 `run`，开始手动构建该项目
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-10.jpg)
    - 如上图，我们看到简略的构建日志
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-11.jpg)
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-c-12.jpg)
    - 如上 2 张图，我们看到详细的构建内容
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-d-1.jpg)
    - 如上图，当我们版本控制中有提交的时候，TeamCity 会识别到记录
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-d-2.jpg)
    - 如上图，我们可以看到提交的 Commit Message 信息。
    - 如上图，右边红圈的三个按钮是用来处理这次提交的，常用的是第一次按钮，点击对此次版本进行构建
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-d-3.jpg)
    - 如上图，如果你要看所有的提交记录，可以在 Change Log 看到并且指定版本构建
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-e-1.jpg)
    - 如上图，如果在你不想要这个项目的时候可以进行删除
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-e-2.jpg)
    - 如上图，因为 Goals 里面有 deploy 命令，所以构建完成会发布到 Nexus 中，这样团队的人就可以用到最新的代码了
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-e-3.gif)
    - 如上 gif 图演示，项目常去的几个配置地方就是这样些了


### 配置自动构建触发行为

- 官网提供的触发行为有：<https://confluence.jetbrains.com/display/TCD9/Configuring+Build+Triggers>
- 下面我们举例说常见的：`VCS Trigger`、`Schedule Trigger`
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-f-1.jpg)
    - 如上图，点击 `Add new trigger` 添加触发器
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-f-2.jpg)
    - 如上图，常见的触发器就这些了
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-f-3.jpg)
    - 如上图，配置好 `VCS Trigger` 效果是，当我们有代码提交的时候，TeamCity 检查到新版本之后自动构建，这个最常用 
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-f-4.jpg)
    - 如上图，`Schedule Trigger` 的作用就是定时构建，除了常用的几个输入框设置定时外，TeamCity 还可以使用 Cron 语法进行设置
    - TeamCity 采用的 Cron 语法是 Quartz，具体你可以看：[Quartz CronTrigger Tutorial](http://www.quartz-scheduler.org/documentation/quartz-1.x/tutorials/crontrigger#CronTriggersTutorial-Specialcharacters)
    - 如果你不懂 Cron 语法那就算了，但是我想做 Java 这个应该要会的


### 集成 IntelliJ IDEA

- 安装 IntelliJ IDEA：<https://confluence.jetbrains.com/display/TCD9/IntelliJ+Platform+Plugin>
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-g-1.jpg)
    - 如上图，我们可以直接连上 TeamCity 服务器，这里的用户名密码是 TeamCity 的账号系统。
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-g-2.jpg)
    - 如上图，连上去的效果是这里会打钩
- ![TeamCity 向导](http://img.youmeek.com/2016/TeamCity-guide-g-3.jpg)
    - 如上图，我们可以直接把别人提交的内容做 patch 直接用 IntelliJ IDEA 进行整合
    - 还有其他很多结合玩法大家可以自己去尝试下


### 其他

- TeamCity 的插件列表：<https://confluence.jetbrains.com/display/TW/TeamCity+Plugins>
- 使用外部数据库：
    - 使用外部数据库：<https://confluence.jetbrains.com/display/TCD9/Setting+up+an+External+Database>
    - 迁移到外部数据库：<https://confluence.jetbrains.com/display/TCD9/Migrating+to+an+External+Database>
- 数据备份：<https://confluence.jetbrains.com/display/TCD9/TeamCity+Data+Backup>
- 代码检查功能：
    - <https://confluence.jetbrains.com/display/TCD9/Code+Quality+Tools>
    - <https://confluence.jetbrains.com/display/TCD9/Code+Quality+Tools#CodeQualityTools-IntelliJIDEA-poweredCodeAnalysisTools>  
    - <https://confluence.jetbrains.com/pages/viewpage.action?pageId=74847276>
