# Yum 下载安装包及对应依赖包

------

## 安装


- 安装该软件：`yum install -y yum-plugin-downloadonly`

- 以下载 openssh-server 为例：
    - `yum install -y openssh-server --downloadonly --downloaddir=/opt/ssh`
    - 在 /opt/ssh 目录下有如下内容：
    
``` nginx
-rw-r--r--. 1 root root 280524 Aug 13  2015 openssh-5.3p1-112.el6_7.x86_64.rpm
-rw-r--r--. 1 root root 448872 Aug 13  2015 openssh-clients-5.3p1-112.el6_7.x86_64.rpm
-rw-r--r--. 1 root root 331544 Aug 13  2015 openssh-server-5.3p1-112.el6_7.x86_64.rpm
```

- 安装下载的 rpm 文件：`sudo rpm -ivh *.rpm`
- 利用 yum 安装 rpm 文件，并自动满足依赖的 rpm 文件：`sudo yum localinstall *.rpm`


## 资料

- <http://www.jianshu.com/p/5930545b5591> 
