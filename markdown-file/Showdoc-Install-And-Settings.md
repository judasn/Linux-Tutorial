# Showdoc 安装和配置

## Showdoc 介绍

- 官网：<https://www.showdoc.cc/web/#/>
- Github：<https://github.com/star7th/showdoc>
- 当前（201804）最新版：2.0.7

## Docker 下安装 Showdoc

- 场景：
	- 我的 git 数据目录地址 /opt/git-data
- clone 官网源码：`git clone --depth=1 https://github.com/star7th/showdoc.git`
- 进入源码目录：`cd /opt/git-data/showdoc`
- 构建 docker 镜像：`docker build -t showdoc ./`
- 运行镜像：`docker run -d --name showdoc -p 4999:80 showdoc`
- 浏览器输入：`http://47.106.127.131:4999/install`，进行程序的初始化，其实就是让你选择语言和几个提示
- 注意：
	- 容器中的数据存放目录为：`/var/www/html`，其中
		- 数据库文件：`/var/www/html/Sqlite/sqlite.db.php`
		- 图片：`/var/www/html/Public/Uploads`
	- 后续需要升级系统，更换服务器需要迁移这两个目录下的文件。我尝试挂载这两个目录，但是发现出现各种问题解决不了，所以就不管了。
- 网站首页地址：<http://47.106.127.131:4999/web/#/>
	- 没有什么系统管理员用户的概念，需要自己注册