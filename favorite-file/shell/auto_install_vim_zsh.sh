#!/bin/sh

echo "开始安装 zsh"
yum install -y zsh

echo "开始安装 oh-my-zsh"
yum install -y git
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

echo "设置默认终端为 oh-my-zsh"
chsh -s /bin/zsh root

echo "====================="

echo "开始安装 vim"
yum install -y vim

echo "设置 vim 配置"
curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc

