<h1 id="redis0">Redis 安装和配置</h1>

------

*   [Redis 安装和配置](#redis0)
    *   [Redis 安装](#redis1)
    *   [Redis 配置](#redis2)
    *   [资料](#redis3)
    
------

<h2 id="redis1">Redis 安装</h2>

- Redis 安装
    - 官网：<http://redis.io/>
    - 官网下载：<http://redis.io/download>
    - 此时（20160212） Redis 最新稳定版本为：**3.0.7**
    - 官网帮助中心：<http://redis.io/documentation>
    - 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
    - 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
    - Redis 下载：`wget http://download.redis.io/releases/redis-3.0.7.tar.gz` （大小：1.4 M）
        - 安装依赖包：`yum install -y gcc-c++ tcl`
        - 解压：`tar zxvf redis-3.0.7.tar.gz`
        - 移动到我个人安装目录：`mv redis-3.0.7/ /usr/program/`
        - 进入解压后目录：`cd /usr/program/redis-3.0.7/`
        - 编译：`make`
        - 编译安装：`make install`
            - 安装完之后会在：`/usr/local/bin` 目录下生成好几个 redis 相关的文件
        - 复制配置文件：`cp /usr/program/redis-3.0.7/redis.conf /etc/`
        - 修改配置：`vim /etc/redis.conf`
            - 把旧值：`daemonize no` 
            - 改为新值：`daemonize yes` 
        - 启动：`/usr/local/bin/redis-server /etc/redis.conf`
        - 查看是否启动：`ps -ef | grep redis`
        - 进入客户端：`redis-cli`
        - 关闭客户端：`redis-cli shutdown`
        - 清空数据：`redis-cli flushdb`
        - 开机启动配置：`echo "/usr/local/bin/redis-server /etc/redis.conf" >> /etc/rc.local`
        - 开放防火墙端口：
            - 添加规则：`sudo iptables -I INPUT -p tcp -m tcp --dport 6379 -j ACCEPT`
            - 保存规则：`sudo /etc/rc.d/init.d/iptables save`
            - 重启 iptables：`sudo service iptables restart`
        
        
<h2 id="redis3">资料</h2>

- <http://yanshisan.blog.51cto.com/7879234/1377992>
- <https://segmentfault.com/a/1190000002685224>
- <http://itbilu.com/linux/management/4kB2ninp.html>
- <http://keenwon.com/1335.html>