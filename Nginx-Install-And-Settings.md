# Nginx 安装和配置


## Nginx 说明

- Nginx 是一个很强大的高性能 Web 和反向代理服务器，常被我们用作负载均衡服务器，也可以作为邮件代理服务器
- Nginx WIKI：<https://zh.wikipedia.org/zh/Nginx>
- Nginx 百科：<http://baike.baidu.com/item/nginx>
- Nginx 官网：<http://nginx.org/en/>
- Nginx 官网下载：<http://nginx.org/en/download.html>
    - 源码包方式下载：<http://nginx.org/en/download.html>，注意该页面的：`Stable version`，这个表示稳定版本，2016-03-22 最新版本是：`nginx-1.8.1`，这是一个  **tar.gz** 的文件链接。
    - 构建包方式下载：<http://nginx.org/en/linux_packages.html#stable>
- Nginx 文档：
    - 优先：<https://www.nginx.com/resources/wiki/>
    - 次要：<http://nginx.org/en/docs/>
- Nginx 模块地址：<https://www.nginx.com/resources/wiki/modules/>


## Nginx 源码编译安装

- 官网下载最新稳定版本 **1.8.1**，大小：814K
- 官网安装说明：<https://www.nginx.com/resources/wiki/start/topics/tutorials/install/>
- 源码编译配置参数说明：
    - <https://www.nginx.com/resources/wiki/start/topics/tutorials/installoptions/>
    - <http://nginx.org/en/docs/configure.html>
- 开始安装：
    - 安装依赖包：`yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel`
    - 预设几个文件夹，方便等下安装的时候有些文件可以进行存放：
        - `mkdir -p /usr/local/nginx /var/log/nginx /var/temp/nginx`
    - 下载源码包：``wget http://nginx.org/download/nginx-1.8.1.tar.gz`
    - 解压：`tar zxvf nginx-1.8.1.tar.gz`
    - 进入解压后目录：`cd nginx-1.8.1/`
    - 编译配置：

    ``` bash
    ./configure \
    --prefix=/usr/local/nginx \
    --pid-path=/var/local/nginx/nginx.pid \
    --lock-path=/var/lock/nginx/nginx.lock \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_gzip_static_module \
    --http-client-body-temp-path=/var/temp/nginx/client \
    --http-proxy-temp-path=/var/temp/nginx/proxy \
    --http-fastcgi-temp-path=/var/temp/nginx/fastcgi \
    --http-uwsgi-temp-path=/var/temp/nginx/uwsgi \
    --http-scgi-temp-path=/var/temp/nginx/scgi
    ```

    - 编译：`make`
    - 安装：`make install`
- 启动 Nginx
    - 先检查是否在 /usr/local 目录下生成了 Nginx 等相关文件：`cd /usr/local/nginx;ll`，正常的效果应该是显示这样的：
    
    ``` bash
    drwxr-xr-x. 2 root root 4096 3月  22 16:21 conf
    drwxr-xr-x. 2 root root 4096 3月  22 16:21 html
    drwxr-xr-x. 2 root root 4096 3月  22 16:21 sbin
    ```

    - 假设有生成对应的文件，那我们就删掉刚刚安装的解压包：`rm -rf /opt/setups/nginx-1.8.1`
    - 停止防火墙：`service iptables stop`
        - 或是把 80 端口加入到的排除列表：
        - `sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT`
        - `sudo service iptables save`
        - `sudo service iptables restart`
    - 启动：`/usr/local/nginx/sbin/nginx`，启动完成 shell 是不会有输出的
    - 访问：`192.168.1.114`，如果能看到：`Welcome to nginx!`，即可表示安装成功


## Nginx 配置



## 资料


