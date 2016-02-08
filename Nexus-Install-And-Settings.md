<h1 id="nexus0">Nexus 安装和配置</h1>

------

*   [Nexus 安装和配置](#nexus0)
    *   [Nexus 安装](#nexus1)
    *   [Nexus 配置](#nexus2)
    *   [资料](#nexus3)
    
------

<h2 id="nexus1">Nexus 安装</h2>

- Nexus 安装
    - 官网：<http://www.sonatype.org/nexus/>
    - 官网下载：<http://www.sonatype.org/nexus/archived/>
    - 此时（20160207） Nexus 最新版本为：**2.12.0-01**
    - JDK 要求是 JDK 7，官网要求 7u6 或之后版本，包括 JDK 8
    - 官网帮助说明 1：<http://books.sonatype.com/nexus-book/2.11/reference/prerequisites.html>
    - 官网帮助说明 2：<http://books.sonatype.com/sonatype-clm-book/html/clm-book/installation-configuration.html>
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - 压缩包下载：`wget http://download.sonatype.com/nexus/oss/nexus-2.12.0-01-bundle.tar.gz`
    - 如果地址下载不了，那是因为你需要开 VPN，你也可以选择降低要求下载 2.11.4-01 版本：<http://pan.baidu.com/s/1mgSNJtA>
        - `sudo cp nexus-2.11.4-01-bundle.tar.gz /usr/local`
        - `cd /usr/local`
        - `sudo tar xvzf nexus-2.11.4-01-bundle.tar.gz`
        - 创建软链接：`sudo ln -s nexus-2.11.4-01 nexus`
        - 设置 NEXUS_HOME 系统变量：``
        - ``


<h2 id="nexus3">资料</h2>

- <http://stackoverflow.com/questions/4969156/java-net-unknownhostexception>