# Tmux 安装和配置

## 介绍

- 说明：`tmux is a "terminal multiplexer", it enables a number of terminals (or windows) to be accessed and controlled from a single terminal. tmux is intended to be a simple, modern, BSD-licensed alternative to programs such as GNU screen.`
	- 大家的主要用途：`提供了一个窗体组随时存储和恢复的功能`，本质有点类似守护进程感。
- 官网：<https://tmux.github.io/>
- 官网 Github：<https://github.com/tmux>
- 当前（201703）最新版本：**2.3**

## 安装

- CentOS：`yum install -y tmux`
- Ubuntu：`apt-get install -y tmux`
- Mac：`brew install tmux`
- 也可以看官网 GitHub 进行编译安装。

## 基本概念

- session：一个服务器可以包含多个会话，可以理解成是一个特定的终端组合，通常将同一任务下的工作放到一个会话中。
- window：一个会话可以包含多个窗口，一个窗口就相当于普通终端的一个标签，通常在不同的窗口中完成不同的工作。
- pane：一个窗口可以被分割成多个小的窗格。

## 基础用法

- 启动：`tmux`
- 信息查询：
    - `tmux list-keys` 列出所有可以的快捷键和其运行的 tmux 命令
    - `tmux list-commands` 列出所有的 tmux 命令及其参数
    - `tmux info` 流出所有的 session, window, pane, 运行的进程号，等。
- 窗口的控制：
	- session 会话：session是一个特定的终端组合。输入tmux就可以打开一个新的session
	    - `tmux new -s session_name` 创建一个叫做 session_name 的 tmux session
	    - `tmux attach -t session_name` 重新开启叫做 session_name 的 tmux session
	    - `tmux switch -t session_name` 转换到叫做 session_name 的 tmux session
	    - `tmux list-sessions` / tmux ls 列出现有的所有 session
	    - `tmux detach` 离开当前开启的 session
	    - `tmux kill-server` 关闭所有 session
	- window 窗口：session 中可以有不同的 window（但是同时只能看到一个 window）
	    - `tmux new-window` 创建一个新的 window
	    - `tmux list-windows`
	    - `tmux select-window -t :0-9` 根据索引转到该 window
	    - `tmux rename-window` 重命名当前 window
	- pane 面板：window 中可以有不同的 pane（可以把 window 分成不同的部分）
	    - `tmux split-window` 将 window 垂直划分为两个 pane
	    - `tmux split-window -h` 将 window 水平划分为两个 pane
	    - `tmux swap-pane -U` 在指定的方向（方向有：U、D、L、R 四种）交换 pane
	    - `tmux select-pane -U` 在指定的方向（方向有：U、D、L、R 四种）选择下一个 pane

## 高级用法

- **注意：** 有一个前缀快捷键的概念，也称作：`<prefix>`，默认快捷键：`Ctrl + B`，下面的这些操作都是必须先按这个快捷键后再输入对应的命令：
- 基本操作
	- `?` 列出所有快捷键；按q返回
	- `d` 脱离当前会话,可暂时返回Shell界面
	- `s` 选择并切换会话；在同时开启了多个会话时使用
	- `D` 选择要脱离的会话；在同时开启了多个会话时使用
	- `:` 进入命令行模式；此时可输入支持的命令，例如 kill-server 关闭所有tmux会话
	- `[` 复制模式，光标移动到复制内容位置，空格键开始，方向键选择复制，回车确认，q/Esc退出
	- `]` 进入粘贴模式，粘贴之前复制的内容，按q/Esc退出
	- `~` 列出提示信息缓存；其中包含了之前tmux返回的各种提示信息
	- `t` 显示当前的时间
	- `ctrl + z` 挂起当前会话
- 窗口操作
	- `c` 创建新窗口
	- `&` 关闭当前窗口
	- `[0-9]` 数字键切换到指定窗口
	- `p` 切换至上一窗口
	- `n` 切换至下一窗口
	- `l` 前后窗口间互相切换
	- `w` 通过窗口列表切换窗口
	- `,` 重命名当前窗口，便于识别
	- `.` 修改当前窗口编号，相当于重新排序
	- `f` 在所有窗口中查找关键词，便于窗口多了切换
- 面板操作
	- `"` 将当前面板上下分屏（我自己改成了 |）
	- `%` 将当前面板左右分屏（我自己改成了 -）
	- `x` 关闭当前分屏
	- `!` 将当前面板置于新窗口,即新建一个窗口,其中仅包含当前面板
	- `Ctrl + 方向键` 以1个单元格为单位移动边缘以调整当前面板大小
	- `Alt + 方向键` 以5个单元格为单位移动边缘以调整当前面板大小
	- `q` 显示面板编号
	- `o` 选择当前窗口中下一个面板
	- `方向键` 移动光标选择对应面板
	- `{` 向前置换当前面板
	- `}` 向后置换当前面板
	- `Alt+o` 逆时针旋转当前窗口的面板
	- `Ctrl+o` 顺时针旋转当前窗口的面板
	- `z` 最大化当前所在面板
	- `page up` 向上滚动屏幕，q 退出
	- `page down` 向下滚动屏幕，q 退出




## 资料

- <http://kuanghy.github.io/2016/09/29/tmux>
- <http://harttle.com/2015/11/06/tmux-startup.html>
- <http://cenalulu.github.io/linux/tmux/>
- <http://wdxtub.com/2016/03/30/tmux-guide/>
- <https://gist.github.com/ryerh/14b7c24dfd623ef8edc7>
- <http://cenalulu.github.io/linux/tmux/>
- <http://fishcried.com/2014-09-15/tmux/>
- <>
- <>