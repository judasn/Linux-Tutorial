<h1 id="extract-compress0">Linux 下常用压缩文件的解压、压缩</h1>

------

*   [Linux 下常用压缩文件的解压、压缩](#extract-compress0)
    *   [常用压缩包解压命令整理](#extract-compress1)
    *   [常用文件压缩命令整理](#extract-compress2)
    *   [资料](#extract-compress3)

------

<h2 id="extract-compress1">常用压缩包**解压**命令整理</h2>

Linux 后缀为 .tar.gz 格式的文件-解压
命令：`tar -zxvf XXXXXX.tar.gz`

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
        
<h2 id="extract-compress3">资料</h2>

- <http://forum.ubuntu.org.cn/viewtopic.php?f=50&t=158893>

