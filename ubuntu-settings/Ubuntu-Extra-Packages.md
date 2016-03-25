# Ubuntu 源设置


## 介绍

- 简单地讲：修改资源源地址主要是为了加快下载速度，默认的资源源地址在是境外，速度肯定没有境内速度快。
- 了解源这东西：<http://wiki.ubuntu.org.cn/%E6%BA%90%E5%88%97%E8%A1%A8>
- 文章的重点是页面最下面，每个版本的源地址都是不一样的，所以要懂得替换对应的版本英文名称，各个版本的英文名称大家自己找下，然后进行修改。


## 修改源

- 国内常用源配置方法：
    - 163 源：<http://mirrors.163.com/.help/ubuntu.html> 
    - 阿里源：<http://mirrors.aliyun.com/help/ubuntu>
    - sohu：<http://mirrors.sohu.com/help/ubuntu.html>
- 替换过程（更换之前最好备份一下 sources.list 配置文件）：
- 我以 Ubuntu 14.04 为例，使用网易源：
    - 备份下：`sudo cp /etc/apt/sources.list /etc/apt/sources_20151128_back.list`
    - 用 gedit 编辑器打开配置文件：`sudo gedit /etc/apt/sources.list`，替换里面所有内容为下面这些内容：
    ``` ini
    deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
    deb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
    deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
    deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
    deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
    deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
    deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
    deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
    deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
    deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
    ```
    - 更换源之后，需要在终端中执行：`sudo apt-get update`，这是必须做的，不然你后面可能会遇到 apt-get 安装会提示：未发现软件包。
