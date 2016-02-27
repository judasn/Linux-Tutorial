# Linux-Tutorial

这是一篇基于 IntelliJ IDEA 角度下的 Hexo 博客搭建过程，我习惯用 IntelliJ IDEA 写 Markdown，虽然它预览不好，但是快捷键和 Git GUI 太好用了。

安装的使用前提：
安装 Git：已经讲过了
安装 IntelliJ IDEA：已经讲过了
安装 Node.js：本文会进行讲解

先看官网：<https://hexo.io/zh-cn/>
官网文档：<https://hexo.io/zh-cn/docs/>

Node.js 官网：<https://nodejs.org/en/>
Node.js 官网下载：<https://nodejs.org/en/download/stable/>
此时 Node.js 2016-02-27 最新文档版本是：v5.7.0 Stable，如果你不是使用这个版本，不排除会有其他问题出现，所以我这里也提供了百度云下载，我只关注 64 位系统，不考虑 32 位的。

假设你拿到我提供给你的文件：node-v5.7.0-x64.msi，双击进行安装，过程一律下一步，不需要多余的选择。

安装完之后，打开 Git Bash（后面的所有的命令都是基于这个的），输入：`npm -v`，会出现 3.6.0 字眼，则表示 Node.js安装成功


在安装 Hexo 之前，先说一下 node.js 的源，默认是：http://registry.npmjs.org
但是由于在国外，说不定你使用的时候无法下载软件。所以我们决定暂时使用淘宝提供的源，淘宝源地址：<http://npm.taobao.org/>
我们执行下面这一句（这个是一整句的）：

```bash
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"
```

现在验证下是否可以使用淘宝的 cnpm 命令：`cnpm info express`，如果能输出一大堆介绍，则说明成功了

执行完之后，现在除了默认 node.js 的命令前缀是 npm，还多了一个 cnpm 可以使用，
我们下面讲解的内容也都是基于此临时命令。

- 安装 Hexo（注意，现在是 cnpm 开头了，不是 npm 了）：`cnpm install -g hexo-cli`，安装时间不一定很快，有可能需要等 3 ~ 5 分钟。
安装完有 WARN 警告也没关系的。


现在假设我要创建一个 hexo 的 node.js 项目，项目目录是放在：E:\git_code\hexo

- 进入该目录：`cd e:/git_work_space/hexo`
- 然后执行：`hexo init`，这个时间也会比较长，也有可能要等几分钟，有显示 WARN 也不用管
- 最后执行：`npm install`，有显示 WARN 也不用管

然后在hexo的目录就会生成很多子目录和文件，如上图。


然后启动服务测试：命令：`hexo server`

浏览器访问：<http://localhost:4000/>

停止服务：在 Git Bash 下按 Ctrl + C 即可

由于默认主题太大众了，所以现在我们换个主题。

我这里选择：https://github.com/MOxFIVE/hexo-theme-yelee

继续在 Git Bash 中输入命令：`git clone https://github.com/MOxFIVE/hexo-theme-yelee.git themes/yelee`

现在修改 E:\git_work_space\hexo 目录下的项目配置文件：_config.yml，编辑如上图。

更改主题后，重新生成主题静态内容：`hexo d -g`

我们在重启一下服务：`hexo server`

重新访问：<http://localhost:4000/>，效果如上图


上面的这些操作也都是在本地看这个博客，现在我们需要把这些内容放在 Github 上面


======================================================

然后再 Github 上创建一个仓库，仓库名就是你的 Github 账号登录名，比如我的用户名是：judasn，那我要创建的仓库名字填写：judasn.github.io

首次创建耐心等待10分钟左右审核，之后即可访问静态主页如http://judasn.github.io

同步内容至GitHub
其实就是把hexo生成的public目录下的所有文件复制到judasn.github.io这个项目的根目录下，github会自动识别的，不然没啥的。


对于hexo目录的themes，里面要去掉一些googleapis相关的，不然会卡死的。





