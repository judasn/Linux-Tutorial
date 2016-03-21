# Linux 下常用压缩文件的解压、压缩


## 常用压缩包**解压**命令整理

Linux 后缀为 .tar.gz 格式的文件-解压
命令：`tar zxvf XXXXXX.tar.gz`

Linux 后缀为 .tar.bz2 格式的文件-解压
命令：`tar jxvf XXXXXX.tar.bz2`

Linux 后缀为 .tar 格式的文件-解压
命令：`tar xvf XXXXXX.tar`

Linux 后缀为 .gz 格式的文件-解压
命令：`gunzip XXXXXX.gz`

Linux 后缀为 .zip 格式的文件-解压
命令：`unzip XXXXXX.zip`

Linux 后缀为 .7z 格式的文件-解压
命令：`7za x XXXXXX.7z`

Linux 后缀为 .tar.xz 格式的文件-解压，解压出来是tar，再对tar进行解压
命令：`tar xf XXXXXX.tar.xz`

<h2 id="extract-compress2">常用文件进行**压缩**命令整理</h2>

Linux 压缩文件为后缀 .tar.gz 格式的文件
命令：`tar -czvf test11.tar.gz test11`

Linux 压缩文件为后缀 .tar.bz2 格式的文件
命令：`tar -cjvf test11.tar.gz test11`

Linux 压缩文件为后缀 .zip 格式的文件
命令：`zip -r test1.zip /opt/test1/`

Linux 压缩文件为后缀 .7z 格式的文件
命令：`7za a test1.7z /opt/test1/`


## 特殊格式

- rar 的安装：
    - 下载：`wget http://www.rarlab.com/rar/rarlinux-3.8.0.tar.gz`
    - 解压下载下来的压缩包：`tar zxvf rarlinux-3.8.0.tar.gz`
    - 进入解压后目录：`cd rar`
    - 编译：`make`
    - 安装：`make install`
- rar 解压：`rar x 文件名.rar`


## 资料

- <http://forum.ubuntu.org.cn/viewtopic.php?f=50&t=158893>

