# SSR Ubuntu 客户端

## 介绍

- 因为某些原因，这个东西不做过多解释

## 安装

- 需要 Git 环境：<sudo apt-get install git>
- 需要 Python 2 环境：<sudo apt-get install python>
- 官网脚本：<https://github.com/the0demiurge/CharlesScripts/blob/master/charles/bin/ssr>
- 我们这里使用别人提供的文件，如果该文件被屏蔽，就自行用上面官网的文件。

```
wget http://www.djangoz.com/ssr

sudo mv ssr /usr/local/bin

sudo chmod 766 /usr/local/bin/ssr

ssr install
```

- 配置：`ssr config`
	- 这是一个 vim 的配置界面，也可以直接编辑其源文件：
- 主要修改如下内容：

```
"server":"12.26.68.99",        //服务器ip
"server_port":9191,        //端口
"password":"123456",       //密码
"protocol":"auth_sha1_v4", //协议插件
"obfs":"http_simple",      //混淆插件
"method":"aes-256-cfb",    //加密方式
```


- 启动：`ssr start`
- 其他常用命令：
	- `ssr stop`
	- `ssr help`
- 然后就可以用 Chrome 的 SwitchyOmega
- AutoProxy：https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt

## 配置终端代理 polipo

- 安装：`sudo apt-get install polipo`
- 修改配置（一般不要变动，直接复制上去即可）：`sudo vim /etc/polipo/config`

```
# This file only needs to list configuration variables that deviate  
# from the default values.  See /usr/share/doc/polipo/examples/config.sample  
# and "polipo -v" for variables you can tweak and further information.  
  
logSyslog = true  
logFile = /var/log/polipo/polipo.log  
  
proxyAddress = "0.0.0.0"  
  
socksParentProxy = "127.0.0.1:1080"  
socksProxyType = socks5  
  
chunkHighMark = 50331648  
objectHighMark = 16384  
  
serverMaxSlots = 64  
serverSlots = 16  
serverSlots1 = 32  
```

- 重启：`sudo service polipo restart`

#### 开始测试 polipo

- 获取自己当前 IP：`curl ip.gs`
	- 这时候应该是国内 IP

- **开始使用代理**：`export http_proxy=http://127.0.0.1:8123`

- 获取自己当前 IP：`curl ip.gs`
	- 这时候应该是国外 IP

- **取消代理**：`unset http_proxy`

- 获取自己当前 IP：`curl ip.gs`
	- 这时候应该是国内 IP
- 另外：在浏览器中输入 <http://127.0.0.1:8123/> 便可以进入到 Polipo 的使用说明和配置界面。

## 材料

- <https://www.jianshu.com/p/a0f3268bfa33>
