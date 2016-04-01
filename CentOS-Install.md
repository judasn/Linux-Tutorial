# CentOS 安装 


## 概括

- 本教程中主要演示了 VirtualBox 和 VMware Workstation 下安装 `CentOS 6.6` 的过程。
- VirtualBox 是免费开源，我个人在使用经历中遇到过很多次崩溃、安装有问题等，所以它不是我主推的虚拟机
- VMware Workstation 是商业软件，很好用，一些辅助功能也很到位，主推该虚拟机。


## VirtualBox 下安装 CentOS 过程

- VirtualBox 的介绍和下载
 - 官网：<https://www.virtualbox.org/>
 - wiki：<https://zh.wikipedia.org/zh/VirtualBox>
 - 百度 wiki：<http://baike.baidu.com/view/1047853.htm>
 - 百度云下载（32 位和 64 位一体）：<http://pan.baidu.com/s/1kTR3hOj>
 - 官网下载：<https://www.virtualbox.org/wiki/Downloads>


- 安装细节开始：
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-1.jpg)
 	- 如上图标注 1 所示：点击 `新建` 一个虚拟机。
 	- 如上图标注 2 所示：在填写 `名称` 的时候，输入 `CentOS` 相关字眼的时候，下面的版本类型会跟着变化，自动识别为 `Red Hat`
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-2.jpg)
 	- 如上图标注 1 所示：我们装的是 64 位系统，如果你本机内存足够大，建议可以给 2 ~ 4 G 的容量
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-3.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-4.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-5.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-6.jpg)
 	- 如上图所示，命名最好规范，最好要带上系统版本号，硬盘大小建议在 8 ~ 20 G
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-b-1.gif)
 	- 如上图 gif 演示，当我们创建好虚拟机之后，需要选择模拟光驱进行系统镜像安装
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-7.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-8.jpg)
 	- 如上图箭头所示，我们这里选择 `Skip`，跳过对镜像的检查，这个一般需要检查很久，而且我们用 iso 文件安装的，一般没这个必要
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-9.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-12.jpg)
 	- 如上图标注 1 所示，建议 Linux 纯新手使用简体中文环境
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-13.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-14.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-15.jpg)
 	- 如上图标注 1 所示，因为我们是用全新的虚拟机，虚拟出来的硬盘都是空的，所以这里可以忽略所有数据
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-16.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-17.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-18.jpg)
 	- 再次强调下，root 账号也就是图上所说的 `根账号`，它是最顶级账号，密码最好别忘记了
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-19.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-20.jpg)
    - 如上图标注 1 所示，因为我们是用全新的虚拟机，所以这里选择 `使用所有空间` ，然后 CentOS 会按它默认的方式进行分区
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-21.jpg)
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-22.jpg)
 	- `Desktop` 代表：图形界面版，会默认安装很多软件，建议新手选择此模式，我后面其他文章的讲解都是基于此系统下，如果你不是此模式的系统可能在安装某些软件的时候会出现某些依赖包没有安装的情况
 	- `basic sever` 代表：命令行界面，有良好基础的基本都会喜欢这个 
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-23.jpg)
 	- 上一步我选择的是 `Desktop` 所以有很多软件需要安装，这个过程大概需要 5 ~ 10 分钟
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-24.jpg)
 	- 安装完成
 - ![VirtualBox 下安装](images/CentOS-Install-VirtualBox-a-25.jpg) 
 	- 安装完成后一定要把盘片删除，防止系统启动的时候去读盘，重新进入安装系统模式


## VMware 下安装 CentOS 过程

- VMware Workstation 的介绍和下载
 - 官网：<https://www.vmware.com/products/workstation>
 - wiki：<https://zh.wikipedia.org/wiki/VMware_Workstation>
 - 百度 wiki：<http://baike.baidu.com/view/555554.htm>
 - 百度云下载（64 位）：<http://pan.baidu.com/s/1eRuJAFK>
 - 官网下载：<http://www.vmware.com/products/workstation/workstation-evaluation>

  
- 安装细节开始：
 - ![VMware 下安装](images/CentOS-install-VMware-a-1.jpg) 
 - ![VMware 下安装](images/CentOS-install-VMware-a-2.jpg)
    - 默认 VMware 选择的是 `典型` 我不推荐，我下面的步骤是选择 `自定义（高级）`。如果你非常了解 Linux 系统倒是可以考虑选择 `典型`，在它默认安装完的系统上可以很好地按你的需求进行修改
 - ![VMware 下安装](images/CentOS-install-VMware-a-3.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-4.jpg)
    - 牢记：不要在这一步就选择镜像文件，不然也会直接进入 `典型` 模式，直接按它的规则进行系统安装
 - ![VMware 下安装](images/CentOS-install-VMware-a-5.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-6.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-7.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-8.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-9.jpg)
	- 桥接模式：（建议选择此模式）创建一个独立的虚拟主机，在桥接模式下的虚拟主机网络一般要为其配 IP 地址、子网掩码、默认网关（虚拟机ip地址要与主机ip地址处于同网段）
	- NAT 模式：把物理主机作为路由器进行访问互联网，优势:联网简单，劣势:虚拟主机无法与物理主机通讯
	- 主机模式：把虚拟主机网络与真实网络隔开，但是各个虚拟机之间可以互相连接，虚拟机和物理机也可以连接
	- > 上面解释来源：<http://jingyan.baidu.com/article/3f16e003cd0a0d2591c103b4.html>
 - ![VMware 下安装](images/CentOS-install-VMware-a-10.jpg)
	- Buslogic 和 LSIlogic 都是虚拟硬盘 SCSI 设备的类型，旧版本的 OS 默认的是 Buslogic，LSIlogic 类型的硬盘改进了性能，对于小文件的读取速度有提高，支持非 SCSI 硬盘比较好。
	- > 上面解释来源：<http://www.cnblogs.com/R-zqiang/archive/2012/11/23/2785134.html>
 - ![VMware 下安装](images/CentOS-install-VMware-a-11.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-12.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-13.jpg)
    - 强烈建议至少要给 20 G，不然装不了多少软件的
 - ![VMware 下安装](images/CentOS-install-VMware-a-14.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-15.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-b-1.gif)
	- 如上图 gif 所示，在创建完虚拟机之后，我们要加载系统镜像，然后启动虚拟机进行安装，接下来的安装步骤跟上面使用 VirtualBox 安装细节基本一样，不一样的地方是我这里选择的是自定义分区，不再是选择默认分区方式
 - ![VMware 下安装](images/CentOS-install-VMware-a-16.jpg)
	- 如上图箭头所示，这里我们选择自定义分区方式
 - ![VMware 下安装](images/CentOS-install-VMware-b-2.gif)
	- 如上图 gif 所示，我只把最基本的区分出来，如果你有自己的需求可以自己设置
	- 简单分区方案：
	   - `/boot` == 500 M（主分区）
	   - `/swap` == 2 G（逻辑分区）一般大家的说法这个大小是跟你机子的内存大小相关的，也有说法内存大不需要这个，但是还是建议分，虚拟机内存 2 G，所以我分 2 G
	   - `/` == 剩余容量（逻辑分区）剩余的空间都给了根分区
 - ![VMware 下安装](images/CentOS-install-VMware-a-17.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-18.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-19.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-20.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-21.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-22.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-23.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-24.jpg)
 - ![VMware 下安装](images/CentOS-install-VMware-a-25.jpg)
