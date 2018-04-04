# YApi 安装和配置


## 部署的环境

- 系统：`CentOS 7.4`
- 硬件要求：`1 GB RAM minimum`
- ip：`http://192.168.1.121`
- docker version：`17.12.1-ce, build 7390fc6`
- docker-compose version：`1.18.0, build 8dd22a9`

> 建议部署成 http 站点，因 chrome 浏览器安全限制，部署成 https 会导致测试功能在请求 http 站点时文件上传功能异常。--[来源](https://yapi.ymfe.org/devops.html)

## Docker 快速部署

- 一个好心人的维护：<https://github.com/branchzero/yapi-docker>
- 使用方法：
	- work path：`mkdir -p /opt/git-data`
	- clone：`cd /opt/git-data && git clone https://github.com/branchzero/yapi-docker.git`
	- permission：`chmod -R 777 /opt/git-data`
	- run command：`cd /opt/git-data/yapi-docker && docker-compose up -d`
	- open chrome：`http://192.168.1.121:3000`
- 初始化管理员账号名：`admin@admin.com`，密码：`ymfe.org`

## YApi 介绍

- 官网：<https://yapi.ymfe.org/index.html>
- Github：<https://github.com/YMFE/yapi>
- 官网在线演示：<http://yapi.demo.qunar.com/>
- 使用手册：<https://yapi.ymfe.org/usage.html>
