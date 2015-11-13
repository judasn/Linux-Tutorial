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

看完上面两个视频，你对 Ubuntu 的安装就有了一个大概的了解，视频中 Ubuntu 虽然版本较早 13.04 的， 但是没关系，对于 Ubuntu 来讲新旧版本安装基本都一样的，所以别担心，驱动的问题也别担心，我们不是要 Ubuntu 打游戏的，所以常见驱动系统是集成的。但是分区这一块的话，我个人建议是手工分区，视频中没有最终执行手动分区，只是演示了一下又返回了。 我个人是要求你手动分区的。

但是再讲分区之前，用什么设备安装是第一前提，我这里推荐用 U盘，你准备一个 4 G 以上的 U盘，把 Ubuntu 系统进行格式化到里面，用这个 U 盘作为安装盘进行安装，教程不难，看如下：
<http://www.Ubuntukylin.com/ask/index.php?qa=jc_1>
<http://www.wubantu.com/36bc2075036fab76.html>
<http://tieba.baidu.com/p/2795415868>
<http://www.Ubuntukylin.com/public/pdf/UK1410install.pdf>

好了，现在可以开始讲分区了。这里特别说明的是有多个硬盘的，多块硬盘分区方案就没视频中那么简单，特别是 Linux 的盘符不了解的就更加难了，所以看下图：



以我这边为例：我这边有一个128G固态+500G的机械，我给一个分区方案给你们参考。下面的内容需要你先看过视频才能看懂：
Linux一般可分3个分区，分别是boot分区、swap分区和根分区（根分区也就是斜杠/） boot是主分区类型，swap是是逻辑分区，/是逻辑分区，其他如果你还想划分的也都是逻辑分区。 最近年代生产的的主板，可能还需要分出一个EFI分区启动。EFI的选择和swap一样，都在那个下拉菜单中。 怎么判断你要不要分出一个EFI了？如果你根据我的要求分了boot，swap，根之后，点击下一步报错，有提示EFI相关的错误信息， 那就分一个给它，我这边就是有报错的。

120G固态硬盘：
/boot > 1G(主分区)，这里为boot单独挂载是有必要的。系统崩溃的时候，损坏的是这个分区。我们重装系统之后，其他分区我们保留下来，重新挂载上去就可以用了。
/EFI > 100M(主分区) （我有提示报错需要分这个，我就分了）
/swap > 12G(逻辑分区）一般大家的说法这个大小是跟你机子的内存大小相关的，也有说法内存大不需要这个，但是还是建议分，我内存是12G，所以我分12G。
/ >　100G(逻辑分区)

500G机械硬盘：
/home > 500G（逻辑分区）（我的安装程序我不安装到home下，都是安装到opt目录下的，这样固态的性能才能发挥出来）

分区后的安装都是下一步的，而且 Ubuntu kylin 还是中文的说明，所以没啥难度。 到此假设你给自己的电脑安装了 Ubuntu，那下一讲我将讲 Ubuntu 的相关设置。

------------------------------------------------------------------------------------------
<h2 id="ubuntu">网络配置</h2>


但是基本现在大家默认家里都是有路由器来着，所以如果只是为了联网，基本这些都不需要配置，直接插上网线一般就可以用了。 比较特殊的可能就是有的家里没路由器，而且还是PPPOE拨号上网的，那这个也有对应的设置可以参考：
http://wiki.ubuntu.org.cn/ADSL%EF%BC%88PPPOE…….8D%97
http://wiki.debian.org.hk/w/Connect_Internet_with_PPPoEConf
http://wiki.debian.org.hk/w/Connect_Internet_with_NetworkManager_via_PPPoE
http://tfeng.org/?p=4171

上面四篇文章讲了很多方法，我个人平时是喜好用这种方式：
命令：sudo pppoeconf，进入DOS的图形界面进行设置。

如果你在ubuntu网络连接的时候出现这种情况：：未找到合法的活动链接
可以编辑/etc/NetworkManager/NetworkManager.conf，把文件里的managed=false改成managed=true，重启电脑后应该就可以了。
具体可以看： http://blog.sina.cn/dpool/blog/s/blog_81b02feb0102uwkn.html

如果你是某个高校的学生，学校联网有自己的独立客户端的话，那你就关注下是否有linux系统的客户端了，这里我就帮不上了。

你有可能跟我一样还需要不时穿越，通用设置VPN的方法我也准备好了，你只要根据下面图片设置即可，但是需要注意的是，配置好后，最好重启电脑，不然可能没办法连接上，这点很重要。

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

find -name 文件名（文件名可以用使用通配符）

------------------------------------------------------------------------------------------

<h2 id="ubuntu">修改源</h2>

------------------------------------------------------------------------------------------

<h2 id="ubuntu">安装软件基础</h2>

------------------------------------------------------------------------------------------

<h2 id="ubuntu">安装常用组件</h2>

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
