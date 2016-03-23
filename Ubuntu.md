# Ubuntu 介绍




## 常用系统设置




右键桌面设置中有一个“开启工作区“这个类似虚拟桌面，可以有多个桌面，工作的时候很有用。

桌面右键设置唤醒和黑屏之后唤醒不需要输入密码，既然是平时的开发机，那就没啥多大隐私，而且是在自己家里， 设置密码太麻烦了。

改变鼠标图标大小，小了我看着不爽，下面三个文章是我找的，但是都不适合我：
http://askubuntu.com/questions/66843/how-to-change-mouse-cursor-and-theme
http://www.wikihow.com/Change-Themes-on-Ubuntu-with-Gnome-Tweak-Tool
http://askubuntu.com/questions/126491/how-do-i-change-the-cursor-and-its-size
我最终的方式是：安装dconf-tools
安装后好，编辑这个文件，命令：gedit ~/ .Xresources
在打开的文件中添加这句话：Xcursor.size:48，其中48是文字大小，默认系统是24的大小，然后重启电脑即可。

查看隐藏文件和目录：按Ctrl+H
http://jingyan.baidu.com/article/49711c61415945fa441b7c89.html

Ubuntu使用root账号登录图形界面，必须先给root设置密码，并解锁：
设置密码：sudo passwd root
解锁：sudo passwd -u root
锁住：sudo passwd -l root
解锁之后，修改这个配置文件，命令：vi /etc/lightdm/lightdm.conf，最后添加一行：greeter-show-manual-login=true （这一行表示可以输入用户名的方式登录账号），重启电脑，登录界面就有一个可以输入用户名的输入框，直接输入root，再输入密码。

不输入密码执行sudo命令方法介绍：
http://www.nenew.net/nopasswd-exec-sudo-sudoers.html
http://blog.xuite.net/chingwei/blog/38359401……A2%BC(需要穿越)

通过find命令查找系统文件的：（要查找整个硬盘，可以先切换到根目录，cd /）

find / -name 文件名（文件名可以用使用通配符）


------------------------------------------------------------------------------------------

1.查看内核版本
 uname -a
 
2.查看 Ubuntu 发行版本
 cat /etc/issue
 
3.查看发行代号
 sudo lsb_release -a 



------------------------------------------------------------------------------------------

## 修改源

简单地讲：修改资源源地址主要是为了加快下载速度，默认的资源源地址在是境外，速度肯定没有境内速度快。

了解源这东西：<http://wiki.ubuntu.org.cn/%E6%BA%90%E5%88%97%E8%A1%A8>

文章的重点是页面最下面，每个版本的源地址都是不一样的，所以要懂得替换对应的版本英文名称，各个版本的英文名称大家自己找下，然后进行修改。


> 国内常用源配置方法：

- 163 源：<http://mirrors.163.com/.help/ubuntu.html> 
- 阿里源：<http://mirrors.aliyun.com/help/ubuntu>
- sohu：<http://mirrors.sohu.com/help/ubuntu.html>

> 替换过程（更换之前最好备份一下 sources.list 配置文件）：

- 我以 Ubuntu 14.04 为例，使用网易源：
- 备份下：`sudo cp /etc/apt/sources.list /etc/apt/sources_20151128_back.list`
- 用 gedit 编辑器打开配置文件：`sudo gedit /etc/apt/sources.list`，替换里面所有内容为下面这些内容：
 - deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
 - deb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
 - deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
 - deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
 - deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
 - deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
 - deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
 - deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
 - deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
 - deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse

> 更换源之后，需要在终端中执行，这是必须做的，不然你后面可能会遇到 apt-get 安装会提示：未发现软件包。

- `sudo apt-get update`

## 安装软件基础

- 取回更新的软件包列表信息：`sudo apt-get update`
- 查看已经安装了哪些包：`dpkg -l`
- 查看已安装列表中是否有vim软件，没有安装则没有数据显示：`dpkg -l | grep vim`
- 查看vim软件安装位置：`dpkg -L vim`
- 安装名为XXX的软件：`sudo apt-get install XXX`
- 卸载名为XXX的软件（保留配置文档）：`sudo apt-get remove XXX`
- 卸载名为XXX的软件（删除配置文档）：`sudo apt-get –purge remove XXX`
- 升级系统所有有新版本的软件：`sudo apt-get upgrade`
- 删除已下载的旧包文件：`sudo apt-get autoclean`
- 删除所有已下载的包文件：`sudo apt-get clean`
- 卸载所有自动安装且不再使用的软件包：`sudo apt-get autoremove`



绿色版软件解压之后，是需要单独为它创建启动器，不然你只能用终端打开，用终端就太慢了，下面文章是常见的通过创建desktop文件来新建启动器的。 不知道除了创建desktop文件还有其他方式吗？我很讨厌这种方式，可是一直没找到，有的可以给我留言，感谢了！
http://my.oschina.net/Obahua/blog/110612
http://www.cnblogs.com/enein/articles/2818864.html
http://blog.chinaunix.net/uid-26404477-id-3462663.html




## 安装常用系统软件

- 安装各个软件之前的必须先执行的命令：`sudo apt-get update`





> sysv-rc-conf

- 介绍：管理启动项，一般是用在 Ubuntu 系统上的，CentOS 一般大家用 chkconfig
- 安装：`sudo apt-get install -y sysv-rc-conf `
- 资料：
 - http://blog.csdn.net/gatieme/article/details/45251389
 - http://gm100861.blog.51cto.com/1930562/950066
 




------------------------------------------------------------------------------------------

## 安装常用生活软件

------------------------------------------------------------------------------------------
## 安装常用开发软件


------------------------------------------------------------------------------------------
## Ubuntu 其他资料




Ubuntu 桌面入门指南：
http://wiki.ubuntu.org.cn/Ubuntu%E6%A1%8C%E9%9D%A2%E5%85%A5%E9%97%A8%E6%8C%87%E5%8D%97

Ubuntu 服务器入门指南：
http://wiki.ubuntu.org.cn/Ubuntu%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%85%A5%E9%97%A8%E6%8C%87%E5%8D%97

技巧教程：
http://wiki.ubuntu.org.cn/UbuntuSkills

视频教程：
http://www.imooc.com/index/search?words=Linux
http://study.163.com/search.htm?p=Linux
http://www.icoolxue.com/album/show/26
http://www.howzhi.com/search?q=Linux
http://www.icoolxue.com/search/album/view/1/10?q=Linux
http://www.verycd.com/topics/2843130/
http://www.verycd.com/topics/2752094/
http://www.verycd.com/topics/2772159/
http://www.verycd.com/topics/2973546/
http://www.verycd.com/topics/2958768/
http://www.verycd.com/topics/2872853/
http://www.verycd.com/topics/2749954/
http://www.verycd.com/topics/2739186/
http://www.verycd.com/topics/2748974/
http://www.verycd.com/topics/2738557/
