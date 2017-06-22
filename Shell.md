# Shell 脚本编程

## 环境

- CentOS 7.3
- bash + zsh
- IntelliJ IDEA 2017.1 + Vim
- Xshell 5

## 基础

- 查看 bash 版本号：`bash --version`，CentOS 7.3 是 4.2.46
- 查看 zsh 版本号：`zsh --version`
- 文件后缀：`sh`
- 开头语言标识。文件开头是：`#!/bin/sh` 或 `#!/bin/bash`（优先）（其实也可以不加，因为 Linux 默认就是 bash，只是为了合理，一般都要加），主要是告诉哪个解析器来执行脚本。如果该语句写在非第一行，那就是当做注释使用。
	- 其中 /bin/sh 是 bash 的软链接，所以以上两种写法都可以。（证明：`ls -l /bin/sh`）
- 换行符（line separator）：IntelliJ IDEA 下编写脚本的时候一定要注意后下角的 LF 还是 CRLF，LF 才是 Linux 的要求。
- 执行脚本命令：`bash /opt/test.sh`（推荐），还有：`. /opt/test.sh`，`source /opt/test.sh`
	- 用 source 或是 点开头 的优点是：后面执行的脚本可以读取 source 或 点 执行脚本中的变量内容
- 注释：用 # 号开头
- 如果脚本是用于 Crontab 定时任务，则定义在 /etc/profile 中的环境变量是无法使用的，需要重新定义。


## 变量

- 查看系统的环境变量列表：`env` 或 `set`
- 用户环境变量设置位置：`vim ~/.bash_profile`
- 全局环境变量：`vim /etc/profile`
- 环境变量要设置为全大写
- 环境变量需要 export 导出，完整设置，比如下面设置 JDK：

```
JAVA_HOME=/usr/program/jdk1.8.0_121
export JAVA_HOME
```






## 资料

- <>
