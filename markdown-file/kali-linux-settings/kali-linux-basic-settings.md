# 基础设置


## 修改源

- 编辑配置文件：`vim /etc/apt/sources.list`
- 在文件 **最前面** 添加以下条目，官网文档：<https://mirrors.ustc.edu.cn/help/kali.html>

```
#中科大的源
deb https://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
deb-src https://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
```

- `apt-get update` 更新索引

## 安装公共工具

- `apt-get install -y zip unzip lrzsz git`


## 安装 Zsh、Vim

```
apt-get install -y zsh

wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

chsh -s /bin/zsh root

apt-get install -y vim

curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc
```

## 安装搜狗输入法

- 下载 deb 文件：<http://pinyin.sogou.com/linux/>
- 安装依赖：`apt-get install -y fcitx`
- 安装 deb 文件：`dpkg -i 文件名`
	- 应该会提示有部分依赖不存在，则执行：`apt-get --fix-broken install -y`
- 安装完成后：
	- 终端输入：`im-config`，一路确定，在有一个提示选项中选择：`fcitx`，重启电脑，按 Ctrl + Space 就可以切换输入法 

## 安装 Visual Studio Code

- 下载 deb 文件：<https://code.visualstudio.com/>
- 安装 deb 文件：`dpkg -i 文件名`
	- 应该会提示有部分依赖不存在，则执行：`apt-get --fix-broken install -y`
- 安装扩展
	- 扩展仓库：<https://marketplace.visualstudio.com/>
	- 中文语言包
	- Markdown
	- GitLens 
	- REST Client 
	- Atom One Dark Theme

## 安装剪切板

- 命令：`sudo apt-get install parcellite`
	- 修改快捷键：`右键软件 | 首选项 | Hotkeys | 历史记录按键组合`

## 安装 Peek（Gif 录制）

- 自己构建 deb 包安装

```
sudo apt install cmake valac libgtk-3-dev libkeybinder-3.0-dev libxml2-utils gettext txt2man

git clone https://github.com/phw/peek.git --depth=1
mkdir peek/build
cd peek/build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DGSETTINGS_COMPILE=OFF ..
make package

sudo dpkg -i peek-*-Linux.deb
```

## 安装截图软

```
wget http://packages.linuxdeepin.com/deepin/pool/main/d/deepin-scrot/deepin-scrot_2.0-0deepin_all.deb
sudo dpkg -i deepin-scrot_2.0-0deepin_all.deb
 
apt-get --fix-broken install -y

//终端下启动
deepin-scrot
```

- 配置快捷键来截图方法（思路一样）：<https://www.jianshu.com/p/6f9eee3e3d2e>
	- Kali 的快捷键设置在：设置 - 设备 - Keyboard 下


## 升级 firefox

- 官网下载：<https://www.mozilla.org/en-US/firefox/new/>
- 假设放在 /opt 目录下，进行解压：`tar xjf firefox-*.tar.bz2`
- 进入图标存放目录|：`cd /usr/share/applications`
- 创建文件并编辑：`sudo vim firefoxnew.desktop`

``` ini
[Desktop Entry]
Name=firefoxnew
Name[zh_CN]=firefoxnew
Comment=firefox new
Exec=/opt/firefox/firefox
Icon=/opt/firefox/icons/updater.png
Terminal=false
Type=Application
Categories=Application;
Encoding=UTF-8
StartupNotify=true
```


## 安装 SSR 客户端

- 查看：<https://github.com/judasn/Linux-Tutorial/blob/master/markdown-file/SSR-Client-Ubuntu.md>
