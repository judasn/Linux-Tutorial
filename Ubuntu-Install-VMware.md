# Ubuntu 安装 VMware

- 我个人习惯使用 VMware，在一些个性化和兼容性上，我觉得 VMware 比 box 好很多


## 安装说明

- 下载：VMware-Workstation-Full-10.0.4-2249910.x86_64.bundle
	- 下载地址（rzb0）：<http://pan.baidu.com/s/1dFuLD2D> 
- 安装组件：
``` nginx
命令：sudo apt-get update
命令：sudo apt-get install build-essential linux-headers-`uname -r`
```
- 进入软件下载后目录，比如我在 /opt/setups 下
	- `cd /opt/setups`
	- `chmod +x VMware*.bundle`
	- `sudo ./VMware*.bundle`
- 接下来会弹出图形界面，则效果跟 Windows 一样，那就没啥好说了。


## 资料

- [How To Install VMware Workstation 11 On Ubuntu 14.10](https://www.liberiangeek.net/2014/12/install-vmware-workstation-11-ubuntu-14-10/)

