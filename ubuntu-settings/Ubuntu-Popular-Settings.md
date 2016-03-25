# Ubuntu 常用的设置



右键桌面设置中有一个“开启工作区“这个类似虚拟桌面，可以有多个桌面，工作的时候很有用。

桌面右键设置唤醒和黑屏之后唤醒不需要输入密码，既然是平时的开发机，那就没啥多大隐私，而且是在自己家里， 设置密码太麻烦了。


改变鼠标图标大小，小了我看着不爽，下面三个文章是我找的，但是都不适合我：
我最终的方式是：安装 dconf-tools
安装后好，编辑这个文件，命令：gedit ~/ .Xresources
在打开的文件中添加这句话：Xcursor.size:48，其中48是文字大小，默认系统是24的大小，然后重启电脑即可。



查看隐藏文件和目录：按 Ctrl+H
http://jingyan.baidu.com/article/49711c61415945fa441b7c89.html



Ubuntu使用root账号登录图形界面，必须先给root设置密码，并解锁：
设置密码：sudo passwd root
解锁：sudo passwd -u root
锁住：sudo passwd -l root
解锁之后，修改这个配置文件，命令：vi /etc/lightdm/lightdm.conf，最后添加一行：greeter-show-manual-login=true （这一行表示可以输入用户名的方式登录账号），重启电脑，登录界面就有一个可以输入用户名的输入框，直接输入root，再输入密码。



不输入密码执行sudo命令方法介绍：
http://www.nenew.net/nopasswd-exec-sudo-sudoers.html
http://blog.xuite.net/chingwei/blog/38359401……A2%BC(需要穿越)


