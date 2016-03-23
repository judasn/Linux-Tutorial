# 黑客入侵检查

------

## 思路

- 扫描木马工具：`clamAV`
    - 官网：<http://pkgs.repoforge.org/clamav/>
- CentOS 安装：`yum install -y clamav*`
- 启动 clamAV 服务：`service clamd restart` 
- 更新病毒库：`freshclam`  
- 扫描方法：
    - 扫描 /etc 目录，并把扫描结果放在 /root 目录下：`clamscan -r /etc --max-dir-recursion=5 -l /root/etcclamav.log`
    - 扫描 /bin 目录，并把扫描结果放在 /root 目录下：`clamscan -r /bin --max-dir-recursion=5 -l /root/binclamav.log`
    - 扫描 /usr 目录，并把扫描结果放在 /root 目录下：`clamscan -r /usr --max-dir-recursion=5 -l /root/usrclamav.log`
- 如果日志有类似内容，表示有木马病毒：
    - `/usr/bin/.sshd: Linux.Trojan.Agent FOUND`
    - `/usr/sbin/ss: Linux.Trojan.Agent FOUND`
    - `/usr/sbin/lsof: Linux.Trojan.Agent FOUND`
- 看下当前有多少登录者：`who`
- 看下最近有哪些登录者：`last`
- 查看最近尝试登录的账号信息：`grep "sshd" /var/log/secure`
    - 很多这种信息就表示有人在不断地尝试用 root 登录：`Failed password for root from 222.186.56.168 port 4080 ssh2`
- 查看最近登录成功的账号信息：`grep "Accepted" /var/log/secure`，可以看到：pop3, ssh, telnet, ftp 类型
- 看下查看系统资源占用有无异常：`top`
- 看下所有进程：`ps aux`
- 查看当前系统登录者有哪些，及其登录记录：`last | more`
- 把最近执行的所有命令输出到一个文件，然后下载下来细细研究：`history >> /opt/test.txt`
- 查看当前系统所有用户有哪些：`cat /etc/passwd |awk -F \: '{print $1}'`
    - 更多详细可以用：`cat /etc/passwd`
- 查看开放的端口，比如常用的80,22,8009，后面的箭头表示端口对应占用的程序：`netstat -lnp`
- 检查某个端口的具体信息：`lsof -i :18954`
- 检查启动项：`chkconfig`
- 检查定时器：`cat /etc/crontab`
- 检查其他系统重要文件：
    - `cat /etc/rc.local`
    - `cd /etc/init.d;ll`
- 检查文件：
    - `find / -uid 0 –perm -4000 –print`
    - `find / -size +10000k –print`
    - `find / -name "…" –print`
    - `find / -name ".. " –print`
    - `find / -name ". " –print`
    - `find / -name " " –print`
- 下载 iftop 分析流量，查看是否被黑客当做肉鸡使用
- 安装 iftop
    - 官网：<http://www.ex-parrot.com/~pdw/iftop/>
    - 使用文章：<https://linux.cn/article-1843-1.html>
    - 没有安装第三方源的情况：
        - 安装依赖包：`yum install -y flex byacc  libpcap ncurses ncurses-devel libpcap-devel`
        - 下载源码包：`wget http://www.ex-parrot.com/pdw/iftop/download/iftop-0.17.tar.gz`
        - 解压：`tar zxf iftop-0.17.tar.gz`
        - 进入解压目录：`cd iftop-0.17/`
        - 编译：`./configure`
        - 安装：`make && make install`
    - 有第三方源的情况（eg：EPEL）：
        - `yum install -y iftop`
- 运行：`iftop`
    - 显示端口与 IP 信息：`iftop -nP`

``` nginx
中间部分：外部连接列表，即记录了哪些ip正在和本机的网络连接

右边部分：实时参数分别是该访问 ip 连接到本机 2 秒，10 秒和 40 秒的平均流量

=> 代表发送数据，<= 代表接收数据

底部会显示一些全局的统计数据，peek 是指峰值情况，cumm 是从 iftop 运行至今的累计情况，而 rates 表示最近 2 秒、10 秒、40 秒内总共接收或者发送的平均网络流量。

TX:（发送流量）  cumm:   143MB   peak:   10.5Mb    rates:   1.03Mb  1.54Mb  2.10Mb
RX:（接收流量）          12.7GB          228Mb              189Mb   191Mb   183Mb
TOTAL:（总的流量）       12.9GB          229Mb              190Mb   193Mb   185MbW

```

- 禁用 root 账号登录：`vim /etc/ssh/sshd_config`
    - 把 PermitRootLogin 属性 yes 改为 no
- 如果安全度要更高，可以考虑禁用口令登录，采用私钥/公钥方式：`vim /etc/ssh/sshd_config`
    - 设置属性：PasswordAuthentication 为 no
- 如果还要限制指定 IP 登录，可以考虑编辑：hosts.allow 和 hosts.deny 两个文件



## 资料

- <http://www.jianshu.com/p/97b9dc47b88c> 
- <http://monklof.com/post/10/> 
- <http://yafeilee.me/blogs/54be6e876c69341430050000> 
- <http://coolnull.com/4174.html> 
- <http://www.oicqzone.com/pc/2014110420118.html> 
