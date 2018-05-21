#!/bin/sh

echo "-----------------------------------------禁用防火墙"
systemctl stop firewalld.service
systemctl disable firewalld.service


echo "-----------------------------------------安装 docker 所需环境"

yum install -y yum-utils device-mapper-persistent-data lvm2

echo "-----------------------------------------添加 repo（可能网络会很慢，有时候会报：Timeout，所以要多试几次）"

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast

echo "-----------------------------------------开始安装 docker"

yum install -y docker-ce

echo "-----------------------------------------启动 Docker"

systemctl start docker.service

echo "-----------------------------------------安装结束"

echo "-----------------------------------------运行 hello world 镜像"

docker run hello-world

echo "-----------------------------------------安装 docker compose"
echo "docker compose 的版本检查：https://docs.docker.com/compose/install/#install-compose"

curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

echo "-----------------------------------------输出 docker compose 版本号"

docker-compose --version




