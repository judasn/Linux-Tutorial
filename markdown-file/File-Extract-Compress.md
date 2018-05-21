# Linux 下常用压缩文件的解压、压缩


## 常用压缩包--解压--令整理

- Linux 后缀为 `.war` 格式的文件（一般用在部署 Tomcat 项目的时候）
- 命令：`unzip -oq XXXXXX.war -d ROOT`
	- 如果没有 ROOT 目录会自动创建 ROOT 目录。

- Linux 后缀为 `.tar.gz` 格式的文件-解压
- 命令：`tar zxvf XXXXXX.tar.gz`

- Linux 后缀为 `.bz2` 格式的文件-解压
- 命令：`bzip2 -d XXXXXX.bz2`

- Linux 后缀为 `.tar.bz2` 格式的文件-解压
- 命令：`tar jxvf XXXXXX.tar.bz2`

- Linux 后缀为 `.tar` 格式的文件-解压
- 命令：`tar zxvf XXXXXX.tar`

- Linux 后缀为 `.gz` 格式的文件-解压
- 命令：`gunzip XXXXXX.gz`

- Linux 后缀为 `.zip` 格式的文件-解压
- 命令：`unzip XXXXXX.zip`
- 命令：`unzip XXXXXX.zip -d /opt/`，解压到指定目录

- Linux 后缀为 `.7z` 格式的文件-解压
- 命令：`7za x XXXXXX.7z`

- Linux 后缀为 `.tar.xz` 格式的文件-解压，解压出来是tar，再对tar进行解压
- 命令：`tar xf XXXXXX.tar.xz`



-----------------------------------------------------------


## 常用文件进行--压缩--命令整理

- Linux 压缩文件夹为后缀 `.war` 格式的文件（最好不要对根目录进行压缩，不然会多出一级目录）
- 命令：`jar -cvfM0 cas.war /opt/cas/META-INF /opt/cas/WEB-INF`

- Linux 压缩文件为后缀 `.tar` 格式的文件
- 命令：`tar -zcvf test11.tar test11`

- Linux 压缩文件为后缀 `.tar.gz` 格式的文件
- 命令：`tar -zcvf test11.tar.gz test11`

- Linux 压缩文件为后缀 `.bz2` 格式的文件
- 命令：`bzip2 -v test.txt`

- Linux 压缩文件为后缀 `.tar.bz2` 格式的文件
- 命令：`tar -jcvf test11.tar.gz test11`

- Linux 压缩文件为后缀 `.zip` 格式的文件
- 命令：`zip -r test1.zip /opt/test1/`

- Linux 压缩文件为后缀 `.7z` 格式的文件
- 命令：`7za a test1.7z /opt/test1/`


## 特殊格式

- 7z
    - 7z 的安装：
        - 访问官网下载解压包：<http://sourceforge.net/projects/p7zip/files/p7zip/>
        - 解压压缩包：`tar jxvf p7zip_15.14_src_all.tar.bz2`
        - 进入目录：`cd p7zip_15.14`
        - 执行安装：`sh install.sh`
- rar
    - rar 的安装：
        - 下载：`wget http://www.rarlab.com/rar/rarlinux-3.8.0.tar.gz`
        - 解压下载下来的压缩包：`tar zxvf rarlinux-3.8.0.tar.gz`
        - 进入解压后目录：`cd rar`
        - 编译：`make`
        - 安装：`make install`
    - rar 解压：`rar x 文件名.rar`

## jar 包操作

### 修改 jar 包配置文件

- 命令：`vim mytest.jar`，这时候会展示 jar 中所有层级目录下的所有文件
- 输入：`/log4j2.xml` 回车，光标定位到该文件，然后再回车，进入编辑该文件状态
- 此时可以修改配置文件了，修改后 `:wq` 保存退出，接着 `：q` 退出 jar 编辑状态

### 更新 Jar 包中的文件

- 替换（新增）jar 根目录下的文件：`jar uvf mytest.jar ClassToAdd.class`  
- 一般 class 文件都是在多层目录里面的，需要这样做：`jar uvf mytest.jar com/youmeek/ClassToAdd.class`
	- 需要在 jar 所在的文件夹下创建：`mkdir -p ./com/youmeek`，该目录必须和原 jar 里面的层级目录结构一致


## 资料

- <http://forum.ubuntu.org.cn/viewtopic.php?f=50&t=158893>

