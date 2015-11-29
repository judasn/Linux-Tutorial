<h1 id="ubuntu0">Ubuntu 介绍</h1>

------

*   [Ubuntu 介绍](#linux0)
    *   [Ubuntu 安装和分区](#linux1)
    *   [网络配置](#linux2)
    *   [常用系统设置](#linux3)
    *   [修改源](#linux4)
    *   [安装软件基础](#linux4)
    *   [安装常用组件](#linux4)
    *   [安装常用生活软件](#linux4)
    *   [安装常用开发软件](#linux4)
    *   [Ubuntu 其他资料](#linux4)

------

------------------------------------------------------------------------------------------

<h2 id="ubuntu1">Ubuntu 安装和分区</h2>


先下载该教程：<http://pan.baidu.com/s/1gdw7CuJ>

看完上面两个视频，你对 Ubuntu 的安装就有了一个大概的了解，视频中 Ubuntu 虽然版本较早 13.04 的， 但是没关系，对于 Ubuntu 来讲新旧版本安装基本都一样的，所以别担心，驱动的问题也别担心，我们不是要 Ubuntu 打游戏的，所以常见驱动系统是已经帮我们集成的。但是分区这一块的话，我个人建议是手工分区，视频中没有最终执行手动分区，只是演示了一下又返回了。 我个人是要求你手动分区的。

但是再讲分区之前，用什么设备安装是第一前提，我这里推荐用 U 盘，你准备一个 4 G 以上的 U 盘，把 Ubuntu 系统进行格式化到里面，用这个 U 盘作为安装盘进行安装。这个过程不难，具体看如下文章：
<http://www.Ubuntukylin.com/ask/index.php?qa=jc_1>
<http://www.wubantu.com/36bc2075036fab76.html>
<http://tieba.baidu.com/p/2795415868>
<http://www.Ubuntukylin.com/public/pdf/UK1410install.pdf>

好了假设你现在已经格式化好 U 盘，现在可以开始讲分区了。这里特别说明的是有多个硬盘的，多块硬盘分区方案就没视频中那么简单，特别是 Linux 的盘符不了解的就更加难了，所以看下图：



以我这边为例：我这边机子的硬盘是：一个 128 G 固态 + 500 G 的机械，我给一个分区方案给你们参考。下面的内容需要你先看过视频才能看懂：
Linux 一般可分 3 个分区，分别是 `boot 分区`、`swap 分区` 和 `根分区`（根分区也就是斜杠/） boot 是主分区类型，swap 是是逻辑分区，/ 是逻辑分区，其他如果你还想划分的也都是逻辑分区。 最近年代生产的的主板，可能还需要分出一个 EFI 分区启动。EFI 的选择和 swap 一样，都在那个下拉菜单中。 怎么判断你要不要分出一个 EFI 呢？如果你根据我的要求分了 boot，swap，根之后，点击下一步报错，有提示 EFI 相关的错误信息，那就分一个给它，我这边就是有报错的。

**120 G 固态硬盘：**
- `/boot` == 1G(主分区)，这里为boot单独挂载是有必要的。系统崩溃的时候，损坏的是这个分区。我们重装系统之后，其他分区我们保留下来，重新挂载上去就可以用了。
- `/EFI` == 100M(主分区) （我有提示报错需要分这个，我就分了）
- `/swap` == 12G(逻辑分区）一般大家的说法这个大小是跟你机子的内存大小相关的，也有说法内存大不需要这个，但是还是建议分，我内存是12G，所以我分12G。
- `/` ==　100G(逻辑分区)

**500 G 机械硬盘：**
`/home` == 500G（逻辑分区）（我的安装程序我不安装到home下，都是安装到opt目录下的，这样固态的性能才能发挥出来）

分区后的安装都是下一步的，而且 Ubuntu kylin 还是中文的说明，所以没啥难度。 到此假设你给自己的电脑安装了 Ubuntu，那下一讲我将讲 Ubuntu 的相关设置。

如果你想用 VMware 虚拟机安装，这个教程推荐给你，讲得很详细。
<http://www.jikexueyuan.com/course/1583.html> 
------------------------------------------------------------------------------------------
<h2 id="ubuntu">网络配置</h2>


现在大家默认家里都是有路由器来着，所以如果只是为了联网，基本这些都不需要配置，直接插上网线一般就可以用了。 比较特殊的可能就是有的家里没路由器，而且还是 PPPOE 拨号上网的，那这个也有对应的设置可以参考：
<http://wiki.ubuntu.org.cn/ADSL%EF%BC%88PPPOE…….8D%97>
<http://wiki.debian.org.hk/w/Connect_Internet_with_PPPoEConf>
<http://wiki.debian.org.hk/w/Connect_Internet_with_NetworkManager_via_PPPoE>
<http://tfeng.org/?p=4171>

上面四篇文章讲了很多方法，我个人平时是喜好用进入DOS的图形界面进行设置方式：
命令：
> sudo pppoeconf


如果你在 Ubuntu 网络连接的时候出现这种情况：未找到合法的活动链接
可以编辑/etc/NetworkManager/NetworkManager.conf，把文件里的managed=false改成managed=true，重启电脑后应该就可以了。
具体可以看：<http://blog.sina.cn/dpool/blog/s/blog_81b02feb0102uwkn.html>

如果你是某个高校的学生，学校联网有自己的独立客户端的话，那你就关注下是否有linux系统的客户端了，这里我就帮不上了。

你有可能跟我一样还需要不时穿越，通用设置VPN的方法我也准备好了，你只要根据下面图片设置即可，但是需要注意的是，配置好后，最好重启电脑，不然可能没办法连接上，这点很重要。


设置局域网静态 IP（固定 IP）
我目前有一台 Windows，一台 Ubuntu，Ubuntu 有时候是直接在 Windows 上直接 SSH 连接上去的，所以如果自动分配 IP 的话就比较麻烦。

> 编辑配置文件：`sudo vim /etc/network/interfaces`
> 配置文件内容中，部分信息改为如下：
> 
>> auto eth0
>> \# iface eth0 inet dhcp
>> 
>> \# 注释上面默认配置的 DHCP 设置,改为下面这个 static
>> iface eth0 inet static 
>> address 192.168.1.103 # IP 地址
>> netmask 255.255.255.0 # 子网掩码

------------------------------------------------------------------------------------------

设置DNS服务器
> 编辑配置文件：`sudo vim /etc/resolvconf/resolv.conf.d/base`
> 如果里面没内容，则新增下面两个：（我是广州电信，这两个 DNS 是我根据 360 安全卫士 DNS 优选功能自动筛选出来的，每个地区的人得到结果可能都不一样）
>
>> nameserver 123.125.81.6
>> nameserver 8.8.8.8

> 更新resolv.conf文件：`sudo resolvconf -u`
> 重启服务：`sudo /etc/init.d/networking restart`


如果你的 Ubuntu 设置固定 IP 后网络图标消失且无法查看 IP：
> `sudo vim /etc/NetworkManager/NetworkManager.conf`
>
>> 修改该值为：managed=true （原为 false）

- 资料：
 - http://www.ha97.com/4895.html
 - http://blog.csdn.net/big2chris/article/details/9970127
------------------------------------------------------------------------------------------

<h2 id="ubuntu">常用系统设置</h2>




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
 
2.查看UBUNTU发行版本
 cat /etc/issue
 
3.查看发行代号
 sudo lsb_release -a 



------------------------------------------------------------------------------------------

<h2 id="ubuntu">修改源</h2>

先了解源这东西：http://wiki.ubuntu.org.cn/%E6%BA%90%E5%88%97%E8%A1%A8
文章的重点是页面最下面，每个版本的源地址都是不一样的，所以要懂得替换对应的版本英文名称，然后进行修改。


注意：更换之前最好备份一下 sources.list 配置文件。

替换过程：
> 备份下：`cp /etc/apt/sources.list /etc/apt/sources_20151128_back.list`
> 用 gedit 编辑器打开配置文件：`sudo gedit /etc/apt/sources.list`


 
163镜像源：http://mirrors.163.com/.help/ubuntu.html 
阿里源：http://mirrors.aliyun.com/help/ubuntu
sohu：官网：http://mirrors.sohu.com/help/ubuntu.html

更换源之后，需要在终端中执行，这是必须做的，不然你后面怎么apt-get安装都是会提示：未发现软件包。
> `sudo apt-get update`

------------------------------------------------------------------------------------------

<h2 id="ubuntu">安装软件基础</h2>


查看软件版本：

默认aptitude是没有安装的，所以要安装下：sudo apt-get install aptitude

aptitude show wiznote(软件名称)

也可用apt-show-versions (要先安装sudo apt-get install apt-show-versions)

 查看软件安装位置:
dpkg -L wiznote(软件名称)
 
查看软件是否安装：
dpkg -l | grep wiznote(软件名称)


清除所有已删除包的残馀配置文件
 dpkg -l |grep ^rc|awk '{print $2}' |sudo xargs dpkg -P
如果报如下错误，证明你的系统中没有残留配置文件了，无须担心。


备份当前系统安装的所有包的列表
 
dpkg --get-selections | grep -v deinstall > ~/somefile
从上面备份的安装包的列表文件恢复所有包
 dpkg --set-selections < ~/somefile
sudo dselect  或者 sudo  apt-get  dselect-upgrade  

 清理旧版本的软件缓存
 sudo apt-get autoclean

清理所有软件缓存
 sudo apt-get clean
 
删除系统不再使用的孤立软件
 sudo apt-get autoremove

sudo apt-get autoclean
sudo apt-get clean 清理系统，不影响安装的软件使用
sudo apt-get autoremove
 
这三个命令主要清理升级缓存以及无用包的。
------------------
apt-get remove 卸载已安装的软件包（保留配置文档）
apt-get –purge remove 卸载已安装的软件包（删除配置文档）
apt-get clean 清理系统，不影响安装的软件使用
apt-get upgrade 更新任何已安装的软件包
apt-get dist-upgrade 将系统升级到新版本
apt-cache search 查找软件包

 
 查看已经安装了哪些包
dpkg -l




------------------------------------------------------------------------------------------

<h2 id="ubuntu">安装常用系统软件</h2>

> 安装各个软件之前的必须先执行的命令：`sudo apt-get update`

---

> VIM
- 介绍：
- 安装：`sudo apt-get -y install vim`
- 资料：

---

> Tmux
- 介绍：
- 安装：`sudo apt-get -y install tmux`
- 资料：
 - http://blog.jobbole.com/87278/
 - http://foocoder.com/blog/zhong-duan-huan-jing-zhi-tmux.html/  
 - http://www.xzcblog.com/post-146.html
 - http://cenalulu.github.io/linux/tmux/  
 - http://blog.kissdata.com/2014/07/29/tmux.html  

---

> SSH（Secure Shell）
- 介绍：
- 安装：`sudo apt-get -y install openssh-server openssh-client`
- 资料：
 - 编辑SSH配置文件：`sudo vim /etc/ssh/sshd_config`
   - 注释掉：`PermitRootLogin without-password`
   - 新增一行：`PermitRootLogin yes`（表示允许root账号ssh登录）
Port 22 # 可以指定其他端口
Protocol 2,1 # 指定了SSH协议版本，目前SSH只有两个版本2和1
PasswordAuthentication yes #是否开启密码验证，因为SSH也可以设置秘钥类授权登录的方式，如果用这种方式我们可以考虑关掉密码登录的方式。
PermitEmptyPasswords no # 是否允许密码为空，与上面参数配合用。
 - http://www.jikexueyuan.com/course/861_1.html?ss=1 

配置基于秘钥的认证方式
生成秘钥和公钥文件
命令：ssh-keygen，默认生成这些文件是在/root/.ssh/id_rsa，询问你是否需要口令密码，直接回车即可，没必要再用口令了。
命令：cd /root/.ssh，可以看到有两个文件：id_rsa(私钥)和id_rsa.pub(公钥)

在.ssh目录下创建SSH认证文件，命令：touch authorized_keys
将公钥内容写到SSH认证文件里面，命令：cat id_rsa.pub >> authorized_keys

修改SSH认证文件权限，命令：
chmod 700 /root/.ssh
chmod 600 authorized_keys

现在SSH客户端可以去拿着SSH服务器端上的id_rsa，然后客户端指定秘钥文件地址即可，这个一般由于你使用的客户端决定的。

命令：sudo service ssh restart
命令：sudo ifconfig，查看自己的网卡，在以太网的网卡上看到自己的IP
安装SSH服务
命令：sudo sysv-rc-conf ssh on


------------------------------------------------------------------------------------------

<h2 id="ubuntu">安装常用生活软件</h2>

------------------------------------------------------------------------------------------
<h2 id="ubuntu">安装常用开发软件</h2>


------------------------------------------------------------------------------------------
<h2 id="ubuntu">Ubuntu 其他资料</h2>




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
