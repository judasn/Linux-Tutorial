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
		- `rpm -ql jdk`，查看 jdk 是否被安装
	- 卸载
		- `rpm -e jdk`，卸载 jdk（一般卸载的时候都要先用 rpm -qa 看下整个软件的全名）
- YUM 软件管理：
	- `yum install -y httpd`，安装 apache
	- `yum remove -y httpd`，卸载 apache
	- `yum info -y httpd`，查看 apache 版本信息
	- `yum list --showduplicates httpd`，查看可以安装的版本
	- `yum install httpd-查询到的版本号`，安装指定版本
	- 更多命令可以看：<http://man.linuxde.net/yum>
- 查看某个配置文件，排除掉里面以 # 开头的注释内容：
    - `grep '^[^#]' /etc/openvpn/server.conf`
- 查看某个配置文件，排除掉里面以 # 开头和 ; 开头的注释内容：
    - `grep '^[^#;]' /etc/openvpn/server.conf`

## 资料

- <https://www.jianshu.com/p/180fb11a5b96>

