# Bash 常用命令


## 基础常用命令

- `某个命令 --h`，对这个命令进行解释
- `某个命令 --help`，解释这个命令(更详细)
- `man某个命令`，文档式解释这个命令(更更详细)(执行该命令后,还可以按/+关键字进行查询结果的搜索)
- `Ctrl + c`，结束命令
- `TAB键`，自动补全命令（按一次自动补全，连续按两次，提示所有以输入开头字母的所有命令）
- `键盘上下键`，输入临近的历史命令
- `history`，查看所有的历史命令
- `Ctrl + r`，进入历史命令的搜索功能模式
- `clear`，清除屏幕里面的所有命令
- `pwd`，显示当前目录路径（常用）
- `firefox&`，最后后面的 **&** 符号，表示使用后台方式打开 Firefox，然后显示该进程的 PID 值
- `jobs`，查看后台运行的程序列表
- `ifconfig`，查看 IP 等信息（常用）
- `locate 搜索关键字`，快速搜索系统文件/文件夹（类似 Windows 上的 everything 索引式搜索）（常用）
	- `updatedb`，配合上面的 locate，给 locate 的索引更新（locate 默认是一天更新一次索引）（常用）
- `date`，查看系统时间（常用）
	- `date -s20080103`，设置日期（常用）
	- `date -s18:24`，设置时间，如果要同时更改 BIOS 时间，再执行 `hwclock --systohc`（常用）
- `cal`，在终端中查看日历，肯定没有农历显示的
- `uptime`，查看系统已经运行了多久，当前有几个用户等信息（常用）
- `echo "字符串内容"`，输出 "字符串内容"
- `cat 文件路名`，显示文件内容（属于打印语句）
- `cat -n 文件名`，显示文件，并每一行内容都编号
- `more 文件名`，用分页的方式查看文件内容（按 space 翻下一页，按 *Ctrl + B* 返回上页）
- `less`文件名，用分页的方式查看文件内容（带上下翻页）
	- 按 **j** 向下移动，按 **k** 向上移动
	- 按 **/** 后，输入要查找的字符串内容，可以对文件进行向下查询，如果存在多个结果可以按 **n** 调到下一个结果出
	- 按 **？** 后，输入要查找的字符串内容，可以对文件进行向上查询，如果存在多个结果可以按 **n** 调到下一个结果出
- `tail -200f 文件名`，查看文件被更新的新内容尾 200 行，如果文件还有在新增可以动态查看到（一般用于查看日记文件）
- `shutdown`
    - `shutdown -hnow`，立即关机
    - `shutdown -h+10`，10 分钟后关机
    - `shutdown -h23:30`，23:30 关机
    - `shutdown -rnew`，立即重启
- `poweroff`，立即关机（常用）
- `reboot`，立即重启（常用）
- `zip mytest.zip /opt/test/`，把 /opt 目录下的 test/ 目录进行压缩，压缩成一个名叫 mytest 的 zip 文件
	- `unzip mytest.zip`，对 mytest.zip 这个文件进行解压，解压到当前所在目录
	- `unzip mytest.zip -d /opt/setups/`，对 mytest.zip 这个文件进行解压，解压到 /opt/setups/ 目录下
- `tar -cvf mytest.tar mytest/`，对 mytest/ 目录进行归档处理（归档和压缩不一样）
- `tar -xvf mytest.tar`，释放 mytest.tar 这个归档文件，释放到当前目录
	- `tar -xvf mytest.tar -C /opt/setups/`，释放 mytest.tar 这个归档文件，释放到 /opt/setups/ 目录下
- `last`，显示最近登录的帐户及时间
- `lastlog`，显示系统所有用户各自在最近登录的记录，如果没有登录过的用户会显示 **从未登陆过**
- `ls`，列出当前目录下的所有没有隐藏的文件 / 文件夹。
	- `ls -a`，列出包括以．号开头的隐藏文件 / 文件夹（也就是所有文件）
	- `ls -R`，显示出目录下以及其所有子目录的文件 / 文件夹（递归地方式，不显示隐藏的文件）
	- `ls -a -R`，显示出目录下以及其所有子目录的文件 / 文件夹（递归地方式，显示隐藏的文件）
	- `ls -l`，列出目录下所有文件的权限、所有者、文件大小、修改时间及名称（也就是显示详细信息，不显示隐藏文件）。显示出来的效果如下：

		``` nginx
		-rwxr-xr-x. 1 root root 4096 3月 26 10:57，其中最前面的 - 表示这是一个普通文件
		lrwxrwxrwx. 1 root root 4096 3月 26 10:57，其中最前面的 l 表示这是一个链接文件，类似 Windows 的快捷方式
		drwxr-xr-x. 5 root root 4096 3月 26 10:57，其中最前面的 d 表示这是一个目录
		```

	- `ls -ld 目录名`，显示该目录的基本信息
	- `ls -t`，依照文件最后修改时间的顺序列出文件名。
	- `ls -F`，列出当前目录下的文件名及其类型。以 **/** 结尾表示为目录名，以 **\*** 结尾表示为可执行文件，以 **@** 结尾表示为符号连接
	- `ls -lg`，同上，并显示出文件的所有者工作组名。
	- `ls -lh`，查看文件夹类文件详细信息，文件大小，文件修改时间
	- `ls /opt | head -5`，显示 opt 目录下前 5 条记录
	- `ls -l /opt |grep "^-"|wc -l`，统计 opt 目录下文件的个数，不会递归统计
	- `ls -lR /opt |grep "^-"|wc -l`，统计 opt 目录下文件的个数，会递归统计
	- `ls -l /opt |grep "^d"|wc -l`，统计 opt 目录下目录的个数，不会递归统计
	- `ls -lR /opt |grep "^d"|wc -l`，统计 opt 目录下目录的个数，会递归统计
	- `ls -lR /opt |grep "js"|wc -l`，统计 opt 目录下 js 文件的个数，会递归统计
- `cd`，目录切换
	- `cd ..`，改变目录位置至当前目录的父目录(上级目录)。
	- `cd ~`，改变目录位置至用户登录时的工作目录。
	- `cd 回车`，回到家目录
	- `cd -`，上一个工作目录
	- `cd dir1/`，改变目录位置至 dir1 目录下。
	- `cd ~user`，改变目录位置至用户的工作目录。
	- `cd ../user`，改变目录位置至相对路径user的目录下。
	- `cd /../..`，改变目录位置至绝对路径的目录位置下。
- `cp 源文件 目标文件`，复制文件
	- `cp -r 源文件夹 目标文件夹`，复制文件夹
	- `cp -r -v 源文件夹 目标文件夹`，复制文件夹(显示详细信息，一般用于文件夹很大，需要查看复制进度的时候)
	- `cp /usr/share/easy-rsa/2.0/keys/{ca.crt,server.{crt,key},dh2048.pem,ta.key} /etc/openvpn/keys/`，复制同目录下花括号中的文件
- `tar cpf - . | tar xpf - -C /opt`，复制当前所有文件到 /opt 目录下，一般如果文件夹文件多的情况下用这个更好，用 cp 比较容易出问题
- `mv 文件 目标文件夹`，移动文件到目标文件夹
	- `mv 文件`，不指定目录重命名后的名字，用来重命名文件
- `touch 文件名`，创建一个空白文件/更新已有文件的时间(后者少用)
- `mkdir 文件夹名`，创建文件夹
- `mkdir -p /opt/setups/nginx/conf/`，创建一个名为 conf 文件夹，如果它的上级目录 nginx 没有也会跟着一起生成，如果有则跳过
- `rmdir 文件夹名`，删除文件夹(只能删除文件夹里面是没有东西的文件夹)
- `rm 文件`，删除文件
	- `rm -r 文件夹`，删除文件夹
	- `rm -r -i 文件夹`，在删除文件夹里的文件会提示(要的话,在提示后面输入yes)
	- `rm -r -f 文件夹`，强制删除
	- `rm -r -f 文件夹1/ 文件夹2/ 文件夹3/`删除多个
- `find`，高级查找
	- `find . -name *lin*`，其中 . 代表在当前目录找，-name 表示匹配文件名 / 文件夹名，\*lin\* 用通配符搜索含有lin的文件或是文件夹
	- `find . -iname *lin*`，其中 . 代表在当前目录找，-iname 表示匹配文件名 / 文件夹名（忽略大小写差异），\*lin\* 用通配符搜索含有lin的文件或是文件夹
	- `find / -name *.conf`，其中 / 代表根目录查找，*.conf代表搜索后缀会.conf的文件
	- `find /opt -name .oh-my-zsh`，其中 /opt 代表目录名，.oh-my-zsh 代表搜索的是隐藏文件 / 文件夹名字为 oh-my-zsh 的
	- `find /opt -type f -iname .oh-my-zsh`，其中 /opt 代表目录名，-type f 代表只找文件，.oh-my-zsh 代表搜索的是隐藏文件名字为 oh-my-zsh 的
	- `find /opt -type d -iname .oh-my-zsh`，其中 /opt 代表目录名，-type d 代表只找目录，.oh-my-zsh 代表搜索的是隐藏文件夹名字为 oh-my-zsh 的
	- `find . -name "lin*" -exec ls -l {} \;`，当前目录搜索lin开头的文件，然后用其搜索后的结果集，再执行ls -l的命令（这个命令可变，其他命令也可以），其中 -exec 和 {} \; 都是固定格式
	- `find /opt -type f -size +800M  -print0 | xargs -0 du -h | sort -nr`，找出 /opt 目录下大于 800 M 的文件
	- `find / -name "*tower*" -exec rm {} \;`，找到文件并删除
	- `du -hm --max-depth=2 | sort -nr | head -12`，找出系统中占用容量最大的前 12 个目录
- `cat /etc/resolv.conf`，查看 DNS 设置
- `netstat -tlunp`，查看当前运行的服务，同时可以查看到：运行的程序已使用端口情况
- `env`，查看所有系统变量
- `export`，查看所有系统变量
- `echo $JAVA_HOME`，查看指定系统变量的值，这里查看的是自己配置的 JAVA_HOME。
- `unset $JAVA_HOME`，删除指定的环境变量


## 用户、权限-相关命令

- `hostname`，查看当前登陆用户全名
- `cat /etc/group`，查看所有组
- `cat /etc/passwd`，查看所有用户
- `groups youmeek`，查看 youmeek 用户属于哪个组
- `useradd youmeek -g judasn`，添加用户并绑定到 judasn 组下
- `userdel -r youmeek`，删除名字为 youmeek 的用户
	- 参数：`-r`，表示删除用户的时候连同用户的家目录一起删除
- 修改普通用户 youmeek 的权限跟 root 权限一样：
	- 常用方法（原理是把该用户加到可以直接使用 sudo 的一个权限状态而已）：
		- 编辑配置文件：`vim /etc/sudoers`
		- 找到 98 行（预估），有一个：`root    ALL=(ALL)   ALL`，在这一行下面再增加一行，效果如下：

		``` nginx
		root    ALL=(ALL)   ALL
		youmeek    ALL=(ALL)   ALL
		```

	- 另一种方法：
		- 编辑系统用户的配置文件：`vim /etc/passwd`，找到 **root** 和 **youmeek** 各自开头的那一行，比如 root 是：`root:x:0:0:root:/root:/bin/zsh`，这个代表的含义为：*用户名:密码:UserId:GroupId:描述:家目录:登录使用的 shell*
		- 通过这两行对比，我们可以直接修改 youmeek 所在行的 UserId 值 和 GroupId 值，都改为 0。
- `groupadd judasn`，添加一个名为 judasn 的用户组
- `groupdel judasn`，删除一个名为 judasn 的用户组（前提：先删除组下面的所有用户）
- `usermod 用户名 -g 组名`，把用户修改到其他组下
- `passwd youmeek`，修改 youmeek 用户的密码（前提：只有 root 用户才有修改其他用户的权限，其他用户只能修改自己的）
- `chmod 777 文件名/目录`，给指定文件增加最高权限，系统中的所有人都可以进行读写。
	- linux 的权限分为 rwx。r 代表：可读，w 代表：可写，x 代表：可执行
	- 这三个权限都可以转换成数值表示，r = 4，w = 2，x = 1，- = 0，所以总和是 7，也就是最大权限。第一个 7 是所属主（user）的权限，第二个 7 是所属组（group）的权限，最后一位 7 是非本群组用户（others）的权限。
- `su`：切换到 root 用户，终端目录还是原来的地方（常用）
	- `su -`：切换到 root 用户，其中 **-** 号另起一个终端并切换账号
	- `su 用户名`，切换指定用户帐号登陆，终端目录还是原来地方。
	- `su - 用户名`，切换到指定用户帐号登陆，其中 **-** 号另起一个终端并切换账号
- `exit`，注销当前用户（常用）
- `sudo 某个命令`，使用管理员权限使用命令，使用 sudo 回车之后需要输入当前登录账号的密码。（常用）
- `passwd`，修改当前用户密码（常用）



## 磁盘管理

- `df -h`，自动以合适的磁盘容量单位查看磁盘大小和使用空间
	- `df -k`，以磁盘容量单位 K 为数值结果查看磁盘使用情况
	- `df -m`，以磁盘容量单位 M 为数值结果查看磁盘使用情况
- `du -sh /opt`，查看 opt 这个文件夹大小 （h 的意思 human-readable 用人类可读性较好方式显示，系统会自动调节单位，显示合适大小的单位）
- `du -sh ./*`，查看当前目录下所有文件夹大小 （h 的意思 human-readable 用人类可读性较好方式显示，系统会自动调节单位，显示合适大小的单位）
- `du -sh /opt/setups/`，显示 /opt/setups/ 目录所占硬盘空间大小（s 表示 –summarize 仅显示总计，即当前目录的大小。h 表示 –human-readable 以 KB，MB，GB 为单位，提高信息的可读性）
- `mount /dev/sdb5 /newDir/`，把分区 sdb5 挂载在根目录下的一个名为 newDir 的空目录下，需要注意的是：这个目录最好为空，不然已有的那些文件将看不到，除非卸载挂载。
	- 挂载好之后，通过：`df -h`，查看挂载情况。
- `umount /newDir/`，卸载挂载，用目录名
	- 如果这样卸载不了可以使用：`umount -l /newDir/`
- `umount /dev/sdb5`，卸载挂载，用分区名



## 资料

- <http://wenku.baidu.com/view/1ad19bd226fff705cc170af3.html>
- <http://blog.csdn.net/nzing/article/details/9166057>
