# GitLab 安装和配置

##  GitLab 介绍


- 官网：<>
- 官网下载：<https://www.gitlab.cc/downloads>
- 官网安装说明：<https://doc.gitlab.cc/ce/install/requirements.html>
- 开源版本和企业版本对比：<https://www.gitlab.cc/features/#enterprise>

## GitLab 安装（CentOS 6）

- 安装并开放 HTTP 和 SSH、邮件相关服务和端口
	- 命令：`sudo yum install -y curl openssh-server openssh-clients postfix cronie`
	- 命令：`sudo service postfix start`
	- 命令：`sudo chkconfig postfix on`
	- 命令：`sudo lokkit -s http -s ssh`
- 添加 GitLab 仓库，并安装到服务器上（8.8.4 安装包有：261M）：
	- `curl -sS http://packages.gitlab.cc/install/gitlab-ce/script.rpm.sh | sudo bash`
	- `sudo yum install -y gitlab-ce`
- 启动 GitLab：`sudo gitlab-ctl reconfigure`，使用这个命令会输出一堆的日志出来，整个启动过程需要耗时 20 秒左右

## GitLab 配置

- 用浏览器访问服务器 IP，比如我的是：http://192.168.1.113，就可以直接看到 GitLab 配置初始化界面，让你先重置管理员密码，因为密码不能太简单，所以我改为：http://192.168.1.113，这样比较好记又复杂
- 重新访问：http://192.168.1.113，输入账号密码：root、http://192.168.1.113
- 访问管理员控制台，添加用户：http://192.168.1.113/admin/users


## 资料
