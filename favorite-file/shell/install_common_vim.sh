#!/bin/sh


echo "-----------------------------------------开始常用工具安装"
yum install -y zip unzip lrzsz git epel-release

echo "-----------------------------------------开始安装 vim"
yum install -y vim

echo "-----------------------------------------设置 vim 配置"
curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc

