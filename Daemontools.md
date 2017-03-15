# daemontools 工具

## supervisord

- 注意：Supervisor 能管理非 daemon 的进程，也就是说 Supervisor 不能管理守护进程。否则提示 Exited too quickly (process log may have details) 异常。
- 官网：<http://supervisord.org/installing.html>
- 安装过程：
	- 解释：easy_install 是 setuptools 包里带的一个命令，使用 easy_install 实际上是在调用 setuptools 来完成安装模块的工作,所以安装 setuptools 即可。
	- 安装：
		- `yum -y install python-setuptools`
		- `easy_install supervisor`
	- 生成配置文件：
		- `echo_supervisord_conf > /etc/supervisord.conf`
	- 创建专门的程序配置文件目录、日志目录：
		- `mkdir -p /var/log/supervisor`
		- `mkdir -p /etc/supervisor/conf.d/`
		- `echo -e "[include]\nfiles = /etc/supervisor/conf.d/*.conf">>/etc/supervisord.conf` 
- 安装完成的内容介绍：supervisor 安装完成后会生成三个执行程序：
	- supervisortd：supervisor 的守护进程服务（用于接收进程管理命令）
	- supervisorctl：客户端（用于和守护进程通信，发送管理进程的指令）
	- echo_supervisord_conf：生成初始配置文件程序。
- 程序位置：`/usr/bin/supervisord`
- 配置文件位置：`/etc/supervisord.conf`

### Logstash 进程进行守护

- 默认安装完 Supervisor 是已经启动的，所以在加入新配置之前，需要先停止程序：`ps -ef | grep supervisord`，kill 对应的 pid
- 创建配置文件：`vim /etc/supervisor/conf.d/logstash.conf`

``` nginx
[program:gitnavi-logstash]
command=/usr/program/elk/logstash-2.4.1/bin/logstash -f /usr/program/elk/logstash-2.4.1/config/logstash.conf
stdout_logfile=/var/log/supervisor/supervisord-logstash.log
stderr_logfile=/var/log/supervisor/supervisord-logstash-err.log
user=root
autostart=true
autorestart=true
startsecs=5
priority=1
stopasgroup=true
killasgroup=true
```

- 启动程序（默认会启动所有子任务）：`/usr/bin/supervisord -c /etc/supervisord.conf`
- 管理子任务的命令：
	- 启动所有子任务：`/usr/bin/supervisorctl start all`
	- 结束所有子任务：`/usr/bin/supervisorctl stop all`
	- 只载入最新的配置文件, 并不重启任何进程：`/usr/bin/supervisorctl reread`
	- 载入最新的配置文件，停止原来的所有进程并按新的配置启动管理所有进程：`/usr/bin/supervisorctl reload`
	- 根据最新的配置文件，启动新配置或有改动的进程，配置没有改动的进程不会受影响而重启：`/usr/bin/supervisorctl update`
	- 查看所有子任务状态，如果没有运行的子任务则是没有任何反馈信息：`/usr/bin/supervisorctl status`
- 管理所有子任务也可以用交互方式，输入命令：`supervisorctl`，会进入 supervisord 的交互模式下，如果当前有启动的任务，还可以看到对应的任务情况。
	- 在该交互下可以停止指定名称的子任务，比如 logstash 任务：`stop gitnavi-logstash`
	- 也可以停止所有子任务：`stop all`
	- 也可以启动所有子任务：`start all`
	- 更多命令可以输入：`help`

### 设置 supervisord 开启自启动

#### CentOS 6

- 创建文件：`vim /etc/init.d/supervisord`

``` nginx
#!/bin/sh
#
# Supervisor is a client/server system that
# allows its users to monitor and control a
# number of processes on UNIX-like operating
# systems.
#
# chkconfig: - 64 36
# description: Supervisor Server
# processname: supervisord
# Source init functions
. /etc/init.d/functions
RETVAL=0
prog="supervisord"
pidfile="/tmp/supervisord.pid"
lockfile="/var/lock/subsys/supervisord"
start()
{
echo -n $"Starting $prog: "
daemon --pidfile $pidfile supervisord -c /etc/supervisord.conf
RETVAL=$?
echo
[ $RETVAL -eq 0 ] && touch ${lockfile}
}
stop()
{
echo -n $"Shutting down $prog: "
killproc -p ${pidfile} /usr/bin/supervisord
RETVAL=$?
echo
if [ $RETVAL -eq 0 ] ; then
rm -f ${lockfile} ${pidfile}
fi
}
case "$1" in
start)
start ;;
stop) stop ;;
status)
status $prog ;;
restart)
stop
start ;;
*)
echo "Usage: $0 {start|stop|restart|status}" ;;
esac
```


- `chmod 755 /etc/init.d/supervisord`
- `chkconfig supervisord on`
- 以后启动可以用：`service supervisord start`
- 以后停止可以用：`service supervisord stop`


#### CentOS 7

- 创建文件：`vim /lib/systemd/system/supervisor.service`

``` ini
[Unit]
Description=supervisor
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/supervisord -c /etc/supervisord.conf
ExecStop=/usr/bin/supervisorctl $OPTIONS shutdown
ExecReload=/usr/bin/supervisorctl $OPTIONS reload
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
```

- `chmod 766 /lib/systemd/system/supervisor.service`
- `systemctl enable supervisor.service`
- `systemctl daemon-reload`

## 资料

- <http://blog.csdn.net/xyang81/article/details/51555473>
- <https://www.fangc.xyz/detail/centos6pei-zhi-supervisorkai-j/>
- <http://cpper.info/2016/04/14/supervisor-usage.html>
- <https://luckymrwang.github.io/2016/12/23/Supervisor%E5%AE%89%E8%A3%85%E4%BD%BF%E7%94%A8/>
- <http://www.aichengxu.com/linux/24569479.htm>
- <http://www.tianfeiyu.com/?p=2450>