<h1 id="jdk0">JDK 安装</h1>

------

*   [JDK 安装](#jdk0)
    *   [CentOS 下过程](#jdk1)
    *   [资料](#jdk2)
    
------

<h2 id="jdk1">CentOS 下过程</h2>

- `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/mod_dav_svn-1.8.15-1.x86_64.rpm`
- `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/serf-1.3.7-1.x86_64.rpm`
- `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-1.8.15-1.x86_64.rpm`
- `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-gnome-1.8.15-1.x86_64.rpm`
- `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-javahl-1.8.15-1.x86_64.rpm`
- `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-perl-1.8.15-1.x86_64.rpm`
- `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-python-1.8.15-1.x86_64.rpm`
- `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-tools-1.8.15-1.x86_64.rpm`
- `sudo rpm -ivh *.rpm`


- 检查是否已经安装了 SVN：`svn --version`
- CentOS 下安装（版本是 1.6）：`sudo yum install -y subversion`
- Ubuntu 下安装（版本是 1.6）：`sudo apt-get install -y subversion`

- subversion 1.8 编译安装
    - 官网安装说明（查找关键字 `Dependency Overview`）：<http://svn.apache.org/repos/asf/subversion/trunk/INSTALL>
    - 此时 1.8 最新版本为：`subversion-1.8.15.tar.gz`
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - 安装编译所需工具：
        - `sudo yum install -y gcc gcc-c++ autoconf libtool `
    - 所需依赖包说明：
        - （必要包）apr 和 apr-util 官网地址：<http://archive.apache.org/dist/apr/>
        - （必要包）zlib 官网地址：<ttp://www.zlib.net/>
        - （必要包）SQLite 官网地址：<http://www.sqlite.org/download.html>
        - （非必要包）OpenSSL 用于支持 HTTPS,官网地址：<http://www.openssl.org/source/>
        - （非必要包）Apache Serf 用于支持 HTTP,官网地址：<https://archive.apache.org/dist/serf/>
    - 所需依赖包下载：
        - apr 下载：`wget http://archive.apache.org/dist/apr/apr-1.5.2.tar.gz`
        - apr-util 下载：`wget http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.gz`
        - zlib 下载：`wget http://zlib.net/zlib-1.2.8.tar.gz`
        - SQLite 下载：`wget http://www.sqlite.org/2016/sqlite-amalgamation-3100200.zip`
        - OpenSSL 下载：`wget http://www.openssl.org/source/openssl-1.0.1r.tar.gz`
        - Apache Serf 下载：`wget https://archive.apache.org/dist/serf/serf-1.2.1.tar.bz2`
    - 安装依赖包：    
        - apr 安装：
            - 解压：`tar -zxvf apr-1.5.2.tar.gz`
            - 移动到我个人习惯的安装目录下：`mv apr-1.5.2/ /usr/program/`
            - 标准的 GNU 源码安装方式：
                - `cd /usr/program/apr-1.5.2`
                - `./configure`
                - `make`
                - `make install`
            - 安装完得到安装的配置路径：`/usr/local/apr/bin/apr-1-config`,这个需要记下来,下面会用到
        - apr-util 安装：
            - 解压：`tar -zxvf apr-util-1.5.4.tar.gz`
            - 移动到我个人习惯的安装目录下：`mv apr-util-1.5.4/ /usr/program/`
            - 标准的 GNU 源码安装方式：
                - `cd /usr/program/apr-util-1.5.4/`
                - `./configure  --with-apr=/usr/local/apr/bin/apr-1-config`
                - `make`
                - `make install`
            - 安装完得到安装的配置路径：`/usr/local/apr/bin/apu-1-config`,这个需要记下来,下面会用到
        - SQLite 安装：
            - 解压：`unzip sqlite-amalgamation-3100200.zip`
            - 移动到 subversion 目录下：`mv sqlite-amalgamation-3100200/ /usr/program/XXXXXX`
        - zlib 安装：
            - 解压：`tar -zxvf zlib-1.2.8.tar.gz`
            - 移动到我个人习惯的安装目录下：`mv zlib-1.2.8/ /usr/program/`
            - 标准的 GNU 源码安装方式：
                - `cd /usr/program/zlib-1.2.8/`
                - `./configure`
                - `make`
                - `make install`
        - OpenSSL 安装：
            - 解压：`tar -zxvf openssl-1.0.1r.tar.gz`
            - 移动到我个人习惯的安装目录下：`mv openssl-1.0.1r/ /usr/program/`
            - 标准的 GNU 源码安装方式：
                - `cd /usr/program/openssl-1.0.1r/`
                - `./config -fPIC`
                - `make`
                - `make install`
            - 安装完得到安装的配置路径：`/usr/local/ssl`,这个需要记下来,下面会用到
        - Apache Serf 安装：
            - 解压：`tar xjf serf-1.2.1.tar.bz2`
            - 移动到我个人习惯的安装目录下：`mv serf-1.2.1/ /usr/program/`
            - SCons 安装方式：
                - `cd /usr/program/serf-1.2.1/`
                - `./configure --prefix=/usr/local/serf --with-apr=/usr/local/apr/bin/apr-1-config --with-apr-util=/usr/local/apr/bin/apu-1-config --with-openssl=/usr/local/ssl`
                - `make`
                - `make install`
                
                
        
    - 下载 Subversion 压缩包：`wget http://apache.fayea.com/subversion/subversion-1.8.15.tar.gz`
    - 解压安装包：`sudo tar -zxvf jdk-8u72-linux-x64.tar.gz`



- 资料
 - <https://subversion.apache.org/source-code.html>
 - <http://svn.apache.org/repos/asf/subversion/trunk/INSTALL>
 