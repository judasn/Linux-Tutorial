#!/bin/sh
# 本文原内容来自：https://github.com/judasn/Linux-Tutorial/blob/master/CentOS-Extra-Packages.md

echo "源设置开始"

echo "备份默认源设置"
sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
cd /etc/yum.repos.d/

echo "下载网易 centos6 源"
sudo wget http://mirrors.163.com/.help/CentOS6-Base-163.repo

echo "安装网易 centos6 源"
sudo mv CentOS6-Base-163.repo CentOS-Base.repo
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

echo "清除缓存后更新程序"
sudo yum clean all
sudo yum makecache
sudo yum update -y

echo "使用第三方源"
echo "安装 EPEL 源"
sudo yum install -y epel-release
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

echo "安装 RepoForge 源"
wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
sudo rpm -ivh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag

echo "清除缓存后更新程序"
sudo yum clean all
sudo yum makecache
sudo yum update -y

echo "测试安装 htop"
sudo yum install -y htop

echo "完成源设置"









