<h1 id="subversion0">Subversion 1.8 安装</h1>

------

*   [Subversion 1.8 安装](#subversion0)
    *   [RPM 安装（推荐）](#subversion1)
    *   [编译安装（不推荐）](#subversion2)
    *   [资料](#subversion3)
    
------

<h2 id="subversion1">RPM 安装（推荐）</h2>

- wandisco 整理的 RPM 文件官网：<http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/>
- 下载下面几个 RPM 文件：
    - 创建目录来保存下载的 RPM：`sudo mkdir /opt/setups/subversion/ ; cd /opt/setups/subversion/`
    - `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/mod_dav_svn-1.8.15-1.x86_64.rpm`
    - `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/serf-1.3.7-1.x86_64.rpm`
    - `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-1.8.15-1.x86_64.rpm`
    - `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-gnome-1.8.15-1.x86_64.rpm`
    - `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-javahl-1.8.15-1.x86_64.rpm`
    - `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-perl-1.8.15-1.x86_64.rpm`
    - `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-python-1.8.15-1.x86_64.rpm`
    - `wget http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/x86_64/subversion-tools-1.8.15-1.x86_64.rpm`
    - 如果上面的 RPM 链接失效，你也可以考虑下载我提供的百度云盘地址：<http://pan.baidu.com/s/1pKnGia3>
    
    
- 安装下载的 RPM 文件：
    - `sudo rpm -ivh *.rpm`


- 检查安装后的版本：
    - `svn --version`


<h2 id="subversion2">编译安装（不推荐）</h2>

- subversion 1.8 编译安装（本人没有尝试成功，所以不推荐，下面内容只供参考）
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
        - （必要包）Subversion 官网地址：<https://subversion.apache.org/download.cgi>
    - 所需依赖包下载：
        - apr 下载：`wget http://archive.apache.org/dist/apr/apr-1.5.2.tar.gz`
        - apr-util 下载：`wget http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.gz`
        - zlib 下载：`wget http://zlib.net/zlib-1.2.8.tar.gz`
        - SQLite 下载：`wget http://www.sqlite.org/2016/sqlite-amalgamation-3100200.zip`
        - Subversion 下载：`wget http://apache.fayea.com/subversion/subversion-1.8.15.tar.gz`
    - 安装依赖包：    
        - apr 安装：
            - 解压：`tar -zxvf apr-1.5.2.tar.gz`
            - 移动到我个人习惯的安装目录下：`mv apr-1.5.2/ /usr/program/`
            - 标准的 GNU 源码安装方式：
                - `cd /usr/program/apr-1.5.2`
                - `./configure`
                - `make`
                - `make install`
            - 安装完得到安装的配置路径：`/usr/local/apr/bin/apr-1-config`，这个需要记下来，下面会用到
        - apr-util 安装：
            - 解压：`tar -zxvf apr-util-1.5.4.tar.gz`
            - 移动到我个人习惯的安装目录下：`mv apr-util-1.5.4/ /usr/program/`
            - 标准的 GNU 源码安装方式：
                - `cd /usr/program/apr-util-1.5.4/`
                - `./configure  --with-apr=/usr/local/apr/bin/apr-1-config`
                - `make`
                - `make install`
            - 安装完得到安装的配置路径：`/usr/local/apr/bin/apu-1-config`，这个需要记下来，下面会用到
        - zlib 安装：
            - 解压：`tar -zxvf zlib-1.2.8.tar.gz`
            - 移动到我个人习惯的安装目录下：`mv zlib-1.2.8/ /usr/program/`
            - 标准的 GNU 源码安装方式：
                - `cd /usr/program/zlib-1.2.8/`
                - `./configure`
                - `make`
                - `make install`
        - Subversion 解压：
            - 解压：`tar -zxvf subversion-1.8.15.tar.gz`
            - 移动到我个人习惯的安装目录下：`mv subversion-1.8.15/ /usr/program/`
        - SQLite 安装：
            - 解压：`unzip sqlite-amalgamation-3100200.zip`
            - 移动到 subversion 目录下：`mv sqlite-amalgamation-3100200/ /usr/program/subversion-1.8.15/`
        - Subversion 安装：
            - 标准的 GNU 源码安装方式：
                - `cd /usr/program/subversion-1.8.15/`
                - `./configure --prefix=/usr/local/subversion --with-apr=/usr/local/apr/bin/apr-1-config  --with-apr-util=/usr/local/apr/bin/apu-1-config`
                - `make`
                - `make install`
                
                
<h2 id="subversion3">资料</h2>

- <http://tecadmin.net/install-subversion-1-8-on-centos-rhel/>
- <http://svn.apache.org/repos/asf/subversion/trunk/INSTALL>
- <http://chenpipi.blog.51cto.com/8563610/1613007>
- <https://blog.linuxeye.com/348.html>
- <http://jingyan.baidu.com/article/046a7b3efb6a5df9c27fa991.html>