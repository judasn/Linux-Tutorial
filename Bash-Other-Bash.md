# Bash 其他常用命令

## 其他常用命令

- 编辑 hosts 文件：`vim /etc/hosts`，添加内容格式：`127.0.0.1 www.youmeek.com`
- RPM 文件操作命令：
	- 安装
		- `rpm -i example.rpm`，安装 example.rpm 包
		- `rpm -iv example.rpm`，安装 example.rpm 包并在安装过程中显示正在安装的文件信息
		- `rpm -ivh example.rpm`，安装 example.rpm 包并在安装过程中显示正在安装的文件信息及安装进度
	- 查询
		- `rpm -qa | grep jdk`，查看 jdk 是否被安装
	- 卸载
		- `rpm -e jdk`，卸载 jdk（一般卸载的时候都要先用 rpm -qa 看下整个软件的全名）

## 资料


