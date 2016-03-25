# Ubuntu 常用的软件

## 安装软件基础

- 取回更新的软件包列表信息：`sudo apt-get update`
- 查看已经安装了哪些包：`sudo dpkg -l`
- 查看已安装列表中是否有 Vim 软件，没有安装则没有数据显示：`sudo dpkg -l | grep vim`
- 查看 Vim 软件安装位置：`sudo dpkg -L vim`
- 安装名为 Vim 的软件：`sudo apt-get install vim`
- 卸载名为 Vim 的软件（保留配置文档）：`sudo apt-get remove vim`
- 卸载名为 Vim 的软件（删除配置文档）：`sudo apt-get –purge remove vim`
- 升级系统所有有新版本的软件：`sudo apt-get upgrade`
- 删除已下载的旧包文件：`sudo apt-get autoclean`
- 删除所有已下载的包文件：`sudo apt-get clean`
- 卸载所有自动安装且不再使用的软件包：`sudo apt-get autoremove`


## 安装常用系统软件

- sysv-rc-conf
    - 介绍：管理启动项，一般是用在 Ubuntu 系统上的，CentOS 一般用的 chkconfig，两者用法差不多
    - 安装：`sudo apt-get install -y sysv-rc-conf`
    - 资料：
        - 图文资料：<http://blog.csdn.net/gatieme/article/details/45251389>
        - 图文资料：<http://gm100861.blog.51cto.com/1930562/950066>
 


