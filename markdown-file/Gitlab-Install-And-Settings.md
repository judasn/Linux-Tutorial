# Gitlab 安装和配置

## Docker Compose 安装方式


- 创建宿主机挂载目录：`mkdir -p /data/docker/gitlab/gitlab /data/docker/gitlab/redis /data/docker/gitlab/postgresql`
- 赋权（避免挂载的时候，一些程序需要容器中的用户的特定权限使用）：`chown -R 777 /data/docker/gitlab/gitlab /data/docker/gitlab/redis /data/docker/gitlab/postgresql`
- 这里使用 docker-compose 的启动方式，所以需要创建 docker-compose.yml 文件：

```yml
gitlab:
  image: sameersbn/gitlab:10.4.2-1
  ports:
    - "10022:22"
    - "10080:80"
  links:
    - gitlab-redis:redisio
    - gitlab-postgresql:postgresql
  environment:
    - GITLAB_PORT=80
    - GITLAB_SSH_PORT=22
    - GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string
    - GITLAB_SECRETS_SECRET_KEY_BASE=long-and-random-alpha-numeric-string
    - GITLAB_SECRETS_OTP_KEY_BASE=long-and-random-alpha-numeric-string
  volumes:
    - /data/docker/gitlab/gitlab:/home/git/data
  restart: always
gitlab-redis:
  image: sameersbn/redis
  volumes:
    - /data/docker/gitlab/redis:/var/lib/redis
  restart: always
gitlab-postgresql:
  image: sameersbn/postgresql:9.6-2
  environment:
    - DB_NAME=gitlabhq_production
    - DB_USER=gitlab
    - DB_PASS=password
    - DB_EXTENSION=pg_trgm
  volumes:
    - /data/docker/gitlab/postgresql:/var/lib/postgresql
  restart: always
```

- 启动：`docker-compose up -d`
- 浏览器访问：<http://192.168.0.105:10080>

## Gitlab 高可用方案（High Availability）

- 官网：<https://about.gitlab.com/high-availability/>
- 本质就是把文件、缓存、数据库抽离出来，然后部署多个 Gitlab 用 nginx 前面做负载。


## 原始安装方式（推荐）

- 推荐至少内存 4G，它有大量组件
- 有开源版本和收费版本，各版本比较：<https://about.gitlab.com/products/>
- 官网：<https://about.gitlab.com/>
- 中文网：<https://www.gitlab.com.cn/>
- 官网下载：<https://about.gitlab.com/downloads/>
- 官网安装说明：<https://about.gitlab.com/installation/#centos-7>
- 如果上面的下载比较慢，也有国内的镜像：
	- 清华：<https://mirror.tuna.tsinghua.edu.cn/help/gitlab-ce/>
- 参考：<https://ken.io/note/centos7-gitlab-install-tutorial>

```
sudo yum install -y curl policycoreutils-python openssh-server

sudo systemctl enable sshd
sudo systemctl start sshd

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="http://192.168.1.123:8181" yum install -y gitlab-ce
```


## 配置

- 配置域名 / IP
	- 编辑配置文件：`sudo vim /etc/gitlab/gitlab.rb`
	- 找到 13 行左右：`external_url 'http://gitlab.example.com'`，改为你的域名 / IP
	- 刷新配置：`sudo gitlab-ctl reconfigure`，第一次这个时间会比较久，我花了好几分钟
	- 启动服务：`sudo gitlab-ctl start`
	- 停止服务：`sudo gitlab-ctl stop`
	- 重启服务：`sudo gitlab-ctl restart`
- 前面的初始化配置完成之后，访问当前机子 IP：`http://192.168.1.111:80`
- 默认用户是 `root`，并且没有密码，所以第一次访问是让你设置你的 root 密码，我设置为：gitlab123456（至少 8 位数）
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

## 配置 Jenkins 拉取代码权限

- Gitlab 创建一个 Access Token：<http://192.168.0.105:10080/profile/personal_access_tokens>
	- 填写任意 Name 字符串
	- 勾选：API `Access the authenticated user's API`
	- 点击：Create personal access token，会生成一个类似格式的字符串：`wt93jQzA8yu5a6pfsk3s`，这个 Jenkinsfile 会用到
- 先访问 Jenkins 插件安装页面，安装下面三个插件：<http://192.168.0.105:18080/pluginManager/available>
	- Gitlab：可能会直接安装不成功，如果不成功根据报错的详细信息可以看到 hpi 文件的下载地址，挂代理下载下来，然后离线安装即可
	- Gitlab Hook：用于触发 GitLab 的一些 WebHooks 来构建项目
	- Gitlab Authentication 这个插件提供了使用GitLab进行用户认证和授权的方案
- 安装完插件后，访问 Jenkins 这个路径（Jenkins-->Credentials-->System-->Global credentials(unrestricted)-->Add Credentials）
	- 该路径链接地址：<http://192.168.0.105:18080/credentials/store/system/domain/_/newCredentials>
	- kind 下拉框选择：`GitLab API token`
	- token 就填写我们刚刚生成的 access token
	- ID 填写我们 Gitlab 账号


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


## Gitlab 的其他功能使用

#### 创建用户

- 地址：<http://119.23.252.150:10080/admin/users/>
- 创建用户是没有填写密码的地方，默认是创建后会发送邮件给用户进行首次使用的密码设置。但是，有时候没必要这样，你可以创建好用户之后，编辑该用户就可以强制设置密码了（即使你设置了，第一次用户使用还是要让你修改密码...真是严苛）


#### 创建群组

- 地址：<http://119.23.252.150:10080/groups>
- 群组主要有三种 Visibility Level：
	- Private（私有，内部成员才能看到），The group and its projects can only be viewed by members.
	- Internal（内部，只要能登录 Gitlab 就可以看到），The group and any internal projects can be viewed by any logged in user.
	- Public（所有人都可以看到），The group and any public projects can be viewed without any authentication.

#### 创建项目

- 地址：<http://119.23.252.150:10080/>

#### 增加 SSH keys

- 地址：<http://119.23.252.150:10080/profile/keys>
- 官网指导：<http://119.23.252.150:10080/help/ssh/README>
- 新增 SSH keys：`ssh-keygen -t rsa -C "gitnavi@qq.com" -b 4096`
- linux 读取 SSH keys 值：`cat ~/.ssh/id_rsa.pub`，复制到 gitlab 配置页面


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


## 接入第三方登录

- 官网文档：
    - <https://docs.gitlab.com/ce/integration/omniauth.html>
    - <https://docs.gitlab.com/ce/integration/oauth2_generic.html>
    - <https://gitlab.com/satorix/omniauth-oauth2-generic#gitlab-config-example>

- gitlab 自己本身维护一套用户系统，第三方认证服务一套用户系统，gitlab 可以将两者关联起来，然后用户可以选择其中一种方式进行登录而已。
- 所以，gitlab 第三方认证只能用于网页登录，clone 时仍然使用用户在 gitlab 的账户密码，推荐使用 ssh-key 来操作仓库，不再使用账户密码。
- 重要参数：block_auto_created_users=true 的时候则自动注册的账户是被锁定的，需要管理员账户手动的为这些账户解锁，可以改为 false
- 编辑配置文件引入第三方：`sudo vim /etc/gitlab/gitlab.rb`，在 309 行有默认的一些注释配置
    - 其中 oauth2_generic 模块默认是没有，需要自己 gem，其他主流的那些都自带，配置即可使用。

```
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['google_oauth2', 'facebook', 'twitter', 'oauth2_generic']
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_sync_profile_attributes'] = ['email','username']
gitlab_rails['omniauth_external_providers'] = ['google_oauth2', 'facebook', 'twitter', 'oauth2_generic']
gitlab_rails['omniauth_providers'] = [
    {
        "name"=> "google_oauth2",
        "label"=> "Google",
        "app_id"=> "123456",
        "app_secret"=> "123456",
        "args"=> {
            "access_type"=> 'offline',
            "approval_prompt"=> '123456'
        }
    },
    {
        "name"=> "facebook",
        "label"=> "facebook",
        "app_id"=> "123456",
        "app_secret"=> "123456"
    },
    {
        "name"=> "twitter",
        "label"=> "twitter",
        "app_id"=> "123456",
        "app_secret"=> "123456"
    },
    {
        "name" => "oauth2_generic",
        "app_id" => "123456",
        "app_secret" => "123456",
        "args" => {
          client_options: {
            "site" => "http://sso.cdk8s.com:9090/sso",
            "user_info_url" => "/oauth/userinfo"
          },
          user_response_structure: {
            root_path: ["user_attribute"],
            attributes: { 
              "nickname": "username" 
            }
          }
        }
    }
]

```


## 资料

- <http://blog.smallmuou.xyz/git/2016/03/11/%E5%85%B3%E4%BA%8EGitlab%E8%8B%A5%E5%B9%B2%E6%9D%83%E9%99%90%E9%97%AE%E9%A2%98.html>
- <https://zhangmengpl.gitbooks.io/gitlab-guide/content/whatisgitflow.html>
- <https://blog.coderstory.cn/2017/02/01/gitlab/>
- <https://xuanwo.org/2016/04/13/gitlab-install-intro/>
- <https://softlns.github.io/2016/11/14/jenkins-gitlab-docker/>