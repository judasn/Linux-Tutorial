#!/bin/sh

echo "安装 vim 和对应配置"

yum install -y vim

curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc


echo "安装 zsh 和 oh-my-zsh"

yum install -y zsh

yum install -y git

wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

chsh -s /bin/zsh root

echo "请重新连接就可以体验 zsh 了."
