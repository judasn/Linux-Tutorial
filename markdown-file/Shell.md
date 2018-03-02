# Shell 脚本编程

## 环境

- CentOS 7.3
- bash
- IntelliJ IDEA 2017.1 + Vim
- Xshell 5

## 基础

- shell 本质是一个命令解析器，我们这里讲的是 shell 脚本的编写/编程。
- shell 的软件有：sh、bash、zsh、csh、tcsh、ksh 等，Linux 发行版一般是 bash，我个人常用 bash 和 zsh
- 查看 bash 版本号：`bash --version`，CentOS 7.3 是 4.2.46
- shell 脚本文件后缀：`sh`
- shell 脚本开头语言标识。文件开头是：`#!/bin/sh` 或 `#!/bin/bash`（优先使用这个）（其实也可以不加，因为 Linux 默认就是 bash，只是为了合理，一般都要加），主要是告诉哪个解析器来执行脚本。如果该语句写在非第一行，那就是当做注释使用。
	- 其中 /bin/sh 是 bash 的软链接，所以以上两种写法都可以。（证明：`ls -l /bin/sh`）
	- 但是业界上，sh 和 bash 其实是有历史区别的。
	- sh 即 Bourne shell，POSIX（Portable Operating System Interface）标准的 shell 解释器，它的二进制文件路径通常是 /bin/sh，由 Bell Labs 开发。
	- bash 是 Bourne shell 的替代品，属 GNU Project，二进制文件路径通常是 /bin/bash。
	- Mac OS 上 /bin/sh 和 /bin/bash 是两个不同的文件
- 换行符（line separator）：IntelliJ IDEA 下编写脚本的时候一定要注意后下角的 LF 还是 CRLF，LF 才是 Linux 的要求。
- 执行脚本命令：`bash /opt/test.sh`（推荐），还有：`. /opt/test.sh`，`source /opt/test.sh`
	- 用 source 或是 点开头 的优点是：后面执行的脚本可以读取 source 或 点 执行脚本中的变量内容，但是这个读取也只是基于一个 shell 状态下，如果是另外开的 shell 是没有用的。
- 注释：用 # 号开头，只有单行注释，没有多行注释的用法。
- 如果脚本是用于 Crontab 定时任务，则定义在 /etc/profile 中的环境变量是无法使用的，需要重新定义。
- 给脚本赋上执行权限：` chmod +x gitnavi.sh`

## 变量

### 变量概念

- **敲黑板，重点**：等于号，左右两边不要有空格，这个跟一般语言的语法很有冲突感。
- 查看系统的环境变量列表：`env` 或 `set`
- 用户环境变量设置位置：`vim ~/.bash_profile`
- 全局环境变量：`vim /etc/profile`，或者在目录：/etc/profile.d/ 下自己写一个 sh 文件，然后设置一下变量
- 变量命名只能使用字母，下划线和数字，并且不能以数字开头
- 环境变量要建议设置为全大写
- 环境变量需要 export 导出，完整设置，比如下面设置 JDK：

```
JAVA_HOME=/usr/program/jdk1.8.0_121
export JAVA_HOME
```

- 普通字符串变量：`gitnavi_url="gitnavi.com"`，虽然也可以用单引号或是不使用任何符号，但是不推荐。
	- 使用双引号可以在变量中使用其他变量，双引号内容中有双引号，再加个转移斜杠即可，如下：
	- `str="Hello, \"${gitnavi_url}\"! \n"`
- 数值型变量：`gitnavi_age=3`
- 路径型变量：`gitnavi_patch=/com/gitnavi/youmeek`
- 删除变量：`unset gitnavi_url`
- 使用变量：
	- `echo $gitnavi_url`，不推荐这种
	- `echo ${gitnavi_url}`，推荐这种
- 拼接字符串：

``` shell
gitnavi_url="gitnavi.com"
gitnavi_say="hello, ${gitnavi_url} !"

echo ${gitnavi_say}
```

- 获取字符串长度，多加一个 # 号：

``` shell
gitnavi_url="gitnavi.com"
echo ${#gitnavi_url}
```

- 截取字符串（下标是从 0 开始）：

``` shell
gitnavi_url="gitnavi.com"
echo ${gitnavi_url:1:4}
```

- 查找子字符串出现的最开始下标位置（下标开始是 0，所以下面结果是：2）：

``` shell
gitnavi_url="gitnavi.com"
echo `expr index "${gitnavi_url}" navi`
```

## 控制流

### 条件语句

- if

``` shell
if [ condition ]
then
    command
fi
```

- if - else

``` shell
if [ condition ]
then
    command
else
    command
fi
```

- if - else if - else if - else

``` shell
if [ condition1 ]
then
    command1
elif [ condition2 ]
    command2
elif [ condition3 ]
    command3
else
    commandN
fi
```

### case 语句（switch - case）

- 条件可以是一个变量或是常数

``` shell
case "${gitnavi_url}" in
    "${condition1}" )
        command1
    ;;

    "helloworld" )
        command2
    ;;

    * )
        command3    # 这里相当于 case 语句的 default 
    ;;
        
esac
```


### 循环语句

- for 语句
- 列表是一组值（数字、**字符串**等）组成的序列，每个值通过空格分隔。每循环一次，就将列表中的下一个值赋给变量。

``` shell
for 变量 in 列表
do
    command1
    command2
    ...
    commandN
done
```

- while 语句

``` shell
while [ condition ]
do
    command
done
```


## 资料

- <https://github.com/qinjx/30min_guides/blob/master/shell.md>
- <http://www.runoob.com/linux/linux-shell.html>
- <http://c.biancheng.net/cpp/shell/>
- <https://www.zybuluo.com/yangfch3/note/619239>
- <https://tinylab.gitbooks.io/shellbook/content/>
- <http://www.jianshu.com/p/e1c8e5bfa45e>
