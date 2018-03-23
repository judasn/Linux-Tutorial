#!/bin/sh

echo "禁用防火墙"
systemctl stop firewalld.service
systemctl disable firewalld.service

echo "开始常用工具安装"
yum install -y zip unzip lrzsz git epel-release

echo "开始常用工具结束"
echo "开始安装 zsh"
yum install -y zsh

echo "开始安装 oh-my-zsh"
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

echo "设置默认终端为 oh-my-zsh"
chsh -s /bin/zsh root

echo "====================="

echo "开始安装 vim"
yum install -y vim

echo "设置 vim 配置"
curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc

echo "安装 docker 所需环境"

yum install -y yum-utils device-mapper-persistent-data lvm2

echo "添加 repo（可能网络会很慢，有时候会报：Timeout，所以要多试几次）"

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast

echo "开始安装 docker"

yum install -y docker-ce

echo "启动 Docker"

systemctl start docker.service

echo "安装结束"

echo "运行 hello world 镜像"

docker run hello-world

echo "安装 docker compose"

curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

echo "输出 docker compose 版本号"

docker-compose --version

echo "docker 加速"

touch /etc/docker/daemon.json

cat << EOF >> /etc/docker/daemon.json
{
  "registry-mirrors": ["https://ldhc17y9.mirror.aliyuncs.com"]
}
EOF



