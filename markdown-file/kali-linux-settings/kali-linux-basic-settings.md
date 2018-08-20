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
	- 应该会提示有部分依赖不存在，则执行：`apt-get --fix-broken install`
- 安装完成后：
	- 终端输入：`im-config`，一路确定，选择：`fcitx`，重启电脑，在设置中新增输入法 

## 安装 Chrome 浏览器

- 下载 deb 文件：<https://www.chrome64bit.com/index.php/google-chrome-64-bit-for-linux>
- 安装 deb 文件：`dpkg -i 文件名`
	- 应该会提示有部分依赖不存在，则执行：`apt-get --fix-broken install`

## 安装 Visual Studio Code

- 下载 deb 文件：<https://code.visualstudio.com/>
- 安装 deb 文件：`dpkg -i 文件名`
	- 应该会提示有部分依赖不存在，则执行：`apt-get --fix-broken install`

## 安装 Peek（Gif 录制）

- 自己构建 deb 包安装

```
sudo apt install cmake valac libgtk-3-dev libkeybinder-3.0-dev libxml2-utils gettext txt2man

git clone https://github.com/phw/peek.git
mkdir peek/build
cd peek/build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DGSETTINGS_COMPILE=OFF ..
make package

sudo dpkg -i peek-*-Linux.deb
```

## 安装 shutter（截图软件）

- `apt-get install shutter`