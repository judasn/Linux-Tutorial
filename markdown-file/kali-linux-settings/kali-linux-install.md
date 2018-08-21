# Kali Linux 安装


## 制作 U 盘


- 准备一个 U 盘，下载这个软件：[USBWriter（提取码：5aa2）](https://pan.baidu.com/s/1gg83h9T)
- USBWriter 的使用很简单，如下图即可制作一个 CentOS 系统盘

![VMware 下安装](../../images/CentOS-7-Install-a-0.jpg) 


## 安装过程

- 这几年的几个版本安装过程都是类似的，大家可以参考这个视频教程：
	- <https://www.bilibili.com/video/av16009708?from=search&seid=4281822536286289531>
	- 其中，安装第一步选择中文，安装完成就会是中文的，不需要像上面这个视频那么麻烦。
- 安装过程，比较差的机子差不多要 20 ~ 30 分钟。
- 比较重点的几个步骤推荐：
	- `使用整个磁盘`
	- `将所有文件放在同一个分区中`
	- `分区设定结束并修改写入磁盘`
	- `将改动写入磁盘 -- 是`
	- `使用网络镜像 -- 是`

## 软件及系统升级

- `apt-get update && apt-get upgrade`