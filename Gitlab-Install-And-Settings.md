# Gitlab 安装和配置

## 本文前提

- 本文只讲解 Gitlab 的搭建配置相关，至于开发流程本质跟 Github 没啥区别的，所以读这篇文章建议最好是已经会了 Github 那种开发流程。

## 测试机子硬件最低建议

- CPU：1 core
- 内存：2G

## 安装

- 我习惯使用 root 用户
- 有开源版本和收费版本，各版本比较：<https://about.gitlab.com/products/>
- 官网：<https://about.gitlab.com/>
- 中文网：<https://www.gitlab.com.cn/>
- 官网下载：<https://about.gitlab.com/downloads/>
- 安装的系统环境要求：<https://docs.gitlab.com/ce/install/requirements.html>
	- 从文章看目前要求 ruby 2.3，用 yum 版本过低，那就源码安装 ruby 吧，官网当前最新是：2.4.1（大小：14M）
- 安装 ruby
	- 下载：<https://www.ruby-lang.org/en/downloads/>
	- 解压：`tar zxvf ruby-2.4.1.tar.gz`
	- 编译安装：
		- `cd ruby-2.4.1`
		- `./configure`
		- `make`，过程有点慢
		- `make install`
	- 默认安装到这个目录：`/usr/local`
	- 查看当前版本号：`ruby -v`
- CentOS 6 安装流程：<https://about.gitlab.com/downloads/#centos6>
	- 当前（201703）的版本是：`GitLab Community Edition 9.0.0`
	- `sudo yum install -y curl openssh-server openssh-clients postfix cronie`
	- `sudo service postfix start`
	- `sudo chkconfig postfix on`
	- `sudo lokkit -s http -s ssh`
	- `curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash`
	- `sudo yum install gitlab-ce`，软件大小：272M，下载速度不稳定
	- `sudo gitlab-ctl reconfigure`，这个过程比较慢
- 如果上面的下载比较慢，也有国内的镜像：
	- 清华：<https://mirror.tuna.tsinghua.edu.cn/help/gitlab-ce/>


## 配置

- 配置域名 / IP
	- 编辑配置文件：`sudo vim /etc/gitlab/gitlab.rb`
	- 找到 13 行左右：`external_url 'http://gitlab.example.com'`，改为你的域名 / IP
	- 重启服务：`sudo gitlab-ctl reconfigure`
- 前面的初始化配置完成之后，访问当前机子 IP：`http://192.168.1.111:80`
- 默认用户是 root，并且没有密码，所以第一次访问是让你设置你的 root 密码，我设置为：gitlab123456（至少 8 位数）
- 设置会初始化密码之后，你就需要登录了。输入设置的密码。
- root 管理员登录之后常用的设置地址（请求地址都是 RESTful 风格很好懂，也应该不会再变了。）：
	- 用户管理：<http://192.168.1.111/admin/users>
	- 用户组管理：<http://192.168.1.111/admin/groups>
	- 项目管理：<http://192.168.1.111/admin/projects>
	- 添加 SSH Keys：<http://192.168.1.111/profile/keys>
	- 给新创建的用户设置密码：<http://192.168.1.111/admin/users/用户名/edit>
		- 新创建的用户，他首次登录会要求他强制修改密码的，这个设定很棒！
- 普通用户登录之后常去的链接：
	- 配置 SSH Keys：<http://192.168.1.111/profile/keys>


## 权限

- 官网帮助文档的权限说明：<http://192.168.1.111/help/user/permissions>

### 用户组的权限

- 用户组有这几种权限的概念：`Guest、Reporter、Developer、Master、Owner`
- 这个概念在设置用户组的时候会遇到，叫做：`Add user(s) to the group`，比如链接：<http://192.168.1.111/admin/groups/组名称>

|行为|Guest|Reporter|Developer|Master|Owner|
|---|---|--:|---|---|---|
|浏览组|✓|✓|✓|✓|✓|
|编辑组|   |   |   |   |✓|
|创建项目|   |   |   |✓|✓|
|管理组成员|   |   |   |   |✓|
|移除组|   |   |   |   |✓|

### 项目组的权限

- 项目组也有这几种权限的概念：`Guest、Reporter、Developer、Master、Owner`
	- `Guest`：访客
	- `Reporter`：报告者; 可以理解为测试员、产品经理等，一般负责提交issue等
	- `Developer`：开发者; 负责开发
	- `Master`：主人; 一般是组长，负责对Master分支进行维护
	- `Owner`：拥有者; 一般是项目经理
- 这个概念在项目设置的时候会遇到，叫做：`Members`，比如我有一个组下的项目链接：<http://192.168.1.111/组名称/项目名称/settings/members>

|行为|Guest|Reporter|Developer|Master|Owner|
|---|---|--:|---|---|---|
|创建issue|✓|✓|✓|✓|✓|
|留言评论|✓|✓|✓|✓|✓|
|更新代码| |✓|✓|✓|✓|
|下载工程| |✓|✓|✓|✓|
|创建代码片段| |✓|✓|✓|✓|
|创建合并请求| | |✓|✓|✓|
|创建新分支| | |✓|✓|✓|
|提交代码到非保护分支| | |✓|✓|✓|
|强制提交到非保护分支| | |✓|✓|✓|
|移除非保护分支| | |✓|✓|✓|
|添加tag| | |✓|✓|✓|
|创建wiki| | |✓|✓|✓|
|管理issue处理者| | |✓|✓|✓|
|管理labels| | |✓|✓|✓|
|创建里程碑| | | |✓|✓|
|添加项目成员| | | |✓|✓|
|提交保护分支| | | |✓|✓|
|使能分支保护| | | |✓|✓|
|修改/移除tag| | | |✓|✓|
|编辑工程| | | |✓|✓|
|添加deploy keys| | | |✓|✓|
|配置hooks| | | |✓|✓|
|切换visibility level| | | | |✓|
|切换工程namespace| | | | |✓|
|移除工程| | | | |✓|
|强制提交保护分支| | | | |✓|
|移除保护分支| | | | |✓|

### 批量从一个项目中的成员转移到另外一个项目

- 项目的设置地址：<http://192.168.1.111/组名称/项目名称/settings/members>
	- 有一个 Import 按钮，跳转到：<http://192.168.1.111/组名称/项目名称/project_members/import>

### 限定哪些分支可以提交、可以 merge

- 也是在项目设置里面：<http://192.168.1.111/组名称/项目名称/settings/repository#>
- 设置 CI （持续集成） 的 key 也是在这个地址上设置。

## 使用 Gitlab 的一个开发流程 - Git flow

- Git flow：我是翻译成：Git 开发流程建议（不是规范，适合大点的团队），也有一个插件叫做这个，本质是用插件来帮你引导做规范的流程管理。
- 这几篇文章很好，不多说了：
	- 比较起源的一个说明（英文）：<http://nvie.com/posts/a-successful-git-branching-model/>
		- Git-flow 插件也是他开发的，插件地址：<https://github.com/nvie/gitflow>
		- Git-flow 插件的一些相关资料：
			- <https://www.git-tower.com/learn/git/ebook/cn/command-line/advanced-topics/git-flow>
			- <https://danielkummer.github.io/git-flow-cheatsheet/index.zh_CN.html>
	- <http://www.ruanyifeng.com/blog/2015/12/git-workflow.html>
	- <https://zhangmengpl.gitbooks.io/gitlab-guide/content/whatisgitflow.html>
	- <http://blog.jobbole.com/76867/>
	- <http://www.cnblogs.com/cnblogsfans/p/5075073.html>



## 资料

- <http://blog.smallmuou.xyz/git/2016/03/11/%E5%85%B3%E4%BA%8EGitlab%E8%8B%A5%E5%B9%B2%E6%9D%83%E9%99%90%E9%97%AE%E9%A2%98.html>
- <https://zhangmengpl.gitbooks.io/gitlab-guide/content/whatisgitflow.html>
- <https://blog.coderstory.cn/2017/02/01/gitlab/>
- <https://xuanwo.org/2016/04/13/gitlab-install-intro/>