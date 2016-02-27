# Linux-Tutorial


1.安装 Git
2.安装 Node.js
http://nodejs.org/
此时2016-02-27，最新的版本是：v5.7.0 Stable，如果你不是使用这个版本，不排除会有其他问题出现。

打开 cmd，输入：`npm -v`，如果能出现版本号代表没问题了


打开 Git Shell，输入：
npm install hexo-cli -g
npm install hexo --save


#如果命令无法运行，可以尝试更换taobao的npm源
npm install -g cnpm --registry=https://registry.npm.taobao.org

假设我的 hexo 目录是放在：E:\git_code\hexo
则在 Git Shell 中进入该目录

然后执行：`hexo init`
再执行：`npm install`

然后在hexo的目录就会生成很多子目录和文件

现在来安装Hexo插件

npm install hexo-generator-index --save
npm install hexo-generator-archive --save
npm install hexo-generator-category --save
npm install hexo-generator-tag --save
npm install hexo-server --save
npm install hexo-deployer-git --save
npm install hexo-deployer-heroku --save
npm install hexo-deployer-rsync --save
npm install hexo-deployer-openshift --save
npm install hexo-renderer-marked@0.2 --save
npm install hexo-renderer-stylus@0.2 --save
npm install hexo-generator-feed@1 --save
npm install hexo-generator-sitemap@1 --save

然后启动服务测试：命令：`hexo server`

浏览器访问：`localhost:4000`

然后再 Github 上创建一个仓库，仓库名就是你的 Github 账号登录名，比如我的用户名是：judasn，那我要创建的仓库名字填写：judasn.github.io

首次创建耐心等待10分钟左右审核，之后即可访问静态主页如http://judasn.github.io

同步内容至GitHub
其实就是把hexo生成的public目录下的所有文件复制到judasn.github.io这个项目的根目录下，github会自动识别的，不然没啥的。



资料：
http://wsgzao.github.io/post/hexo-guide/



