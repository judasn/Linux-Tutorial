# 被黑客入侵的检查

------

## 思路


- 看下查看系统资源占用有无异常：`top`
- 查看当前系统登录者有哪些，及其登录记录：`last | more`
- 查看当前系统所有用户有哪些：`cat /etc/passwd |awk -F \: '{print $1}'`
    - 更多详细可以用：`cat /etc/passwd`
- 查看开放的端口，比如常用的80,22,8009，后面的箭头表示端口对应占用的程序：`netstat -lnp`
- 检查某个端口的具体信息：`lsof -i :18954`
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

``` bash
中间部分：外部连接列表，即记录了哪些ip正在和本机的网络连接

右边部分：实时参数分别是该访问 ip 连接到本机 2 秒，10 秒和 40 秒的平均流量

=> 代表发送数据，<= 代表接收数据

底部会显示一些全局的统计数据，peek 是指峰值情况，cumm 是从 iftop 运行至今的累计情况，而 rates 表示最近 2 秒、10 秒、40 秒内总共接收或者发送的平均网络流量。

TX:  cumm:   143MB   peak:   10.5Mb    rates:   1.03Mb  1.54Mb  2.10Mb
RX:          12.7GB          228Mb              189Mb   191Mb   183Mb
TOTAL:       12.9GB          229Mb              190Mb   193Mb   185MbW

```

- 禁用 root 账号登录：`vim /etc/ssh/sshd_config`
    - 把 PermitRootLogin 属性 yes 改为 no
- 如果安全度要更高，可以考虑禁用口令登录，采用私钥/公钥方式：`vim /etc/ssh/sshd_config`
    - 设置属性：PasswordAuthentication 为 no
- 如果还要限制指定 IP 登录，可以考虑编辑：hosts.allow 和 hosts.deny 两个文件





## 资料

- <http://www.jianshu.com/p/97b9dc47b88c> 
