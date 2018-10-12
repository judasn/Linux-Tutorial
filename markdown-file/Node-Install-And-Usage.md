# Node 安装和配置

## Node 安装

- 官网：<https://nodejs.org>
- 官网下载：<https://nodejs.org/zh-cn/download/>
- 历史版本下载：<https://nodejs.org/zh-cn/download/releases/>
- 此时（20171212） Maven 最新版本为：**8.9.3 (includes npm 5.5.1)**
- 官网安装教程：<https://nodejs.org/en/download/package-manager/>
- 官网 CentOS 系统下的安装教程：<https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora>
- 官网文档复制过来就是：

```
如果你是要安装 node 8 系列，下载这个 yum 源
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -

如果你是要安装 node 9 系列，下载这个 yum 源
curl --silent --location https://rpm.nodesource.com/setup_9.x | sudo bash -

然后通过 yum 开始安装（软件大小：51M 左右）
sudo yum -y install nodejs
```

- 验证：`node -v`
- 注意:因为网络原因，最好先把脚本下载到本地，再用代理进行安装


## nrm 快速切换 NPM 源

- 安装：`npm install -g nrm`
- 列表源：`nrm ls`
- 使用源：`nrm use taobao`
- 更多使用方法：<https://segmentfault.com/a/1190000000473869>
