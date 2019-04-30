# 常见日常监控

## 系统信息

- 查看 CentOS 版本号：`cat /etc/redhat-release` 

---------------------------------------------------------------------

## 综合监控

- [nmon](Nmon.md)



---------------------------------------------------------------------


## 系统负载

#### 命令：w（判断整体瓶颈）

```
 12:04:52 up 16 days, 12:54,  1 user,  load average: 0.06, 0.13, 0.12
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    116.21.24.85     11:57    4.00s 16:18   0.01s w
```

- 第一行：
	- `12:04:52` 表示当前系统时间
	- `up 16 days` 表示系统运行时间
	- `1 user` 表示登录用户数
	- `load average` 表示平均负载，0.06 表示一分钟内系统的平均负载值，0.13 表示五分钟内系统的平均负载值，0.12 表示十五分钟内系统的平均负载值。一般这个字不要超过服务器的 CPU 线程数（process）就没有关系。
		- 查看 CPU 总的线程数：`grep 'processor' /proc/cpuinfo | sort -u | wc -l`
- 第二行：
	- 开始表示各个登录用户的情况，当前登录者是 root，登录者 IP 116.21.24.85
- 还有一个简化版本的命令：`uptime`

```
10:56:16 up 26 days, 20:05,  1 user,  load average: 0.00, 0.01, 0.05
```


#### 命令：vmstat（判断 RAM 和 I/0 瓶颈）

- 命令：`vmstat 5 10`，每 5 秒采样一次，共 10 次。

```
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0  72648      0 674564    0    0     0     7    0   26  1  1 99  0  0
 0  0      0  72648      0 674596    0    0     0     0  442  557  1  0 99  0  0
 0  0      0  72648      0 674596    0    0     0    12  438  574  0  1 99  0  0
 0  0      0  72648      0 674596    0    0     0     0  430  540  0  0 100  0  0
 0  0      0  72648      0 674596    0    0     0     0  448  567  0  1 99  0  0
 0  0      0  72648      0 674596    0    0     0     0  459  574  1  0 99  0  0
 0  0      0  72648      0 674596    0    0     0     0  425  543  0  1 99  0  0
 0  0      0  72276      0 674600    0    0     0     0  480  643  2  3 95  0  0
```

- 第二行：
	- `r` 表示运行和等待CPU时间片的进程数，该数字如果长期大于服务器CPU的进程数，则说明CPU不够用了。
	- `b` 表示等待资源的进程数，比如等I/O，内存等。该数字如果长时间大于 1，则需要关注一下。
	- `si` 表示由交换区写入到内存的数据量
	- `so` 表示由内存写入到交换区的数据量
	- **如果 si 和 so 的数字比较高，并且不断变化时，说明内存不够了。而且不断变化也表示对系统性能影响很大。**
	- `bi` 表示从块设备读取数据的量（读磁盘）
	- `bo` 表示从块设备写入数据的量（写磁盘）
	- **如果bi和bo两个数字比较高，则说明，磁盘IO压力大。**
	- `in` 每秒 CPU 的中断次数，包括时间中断
	- `cs` 每秒上下文切换次数，例如我们调用系统函数，就要进行上下文切换，线程的切换，也要进程上下文切换，这个值要越小越好，太大了，要考虑调低线程或者进程的数目
	- `wa` 表示I/O等待所占用CPU的时间比

#### 命令：sar（综合）

- sar(system activity reporter 系统活动情况报告)
- sar 是目前 linux 上最为全面的系统性能分析工具之一，可以从多方面对系统的活动情况进行报告。包括（文件的读写、系统调用、磁盘I/O、cpu效率、内存使用、进程活动以及IPC有关的活动）
- 如果没安装，运行：`yum install -y sysstat`

##### sar 之 CPU 使用情况（判断 CPU 瓶颈）

- 命令：`sar -u 5 10`，每 5 秒采样一次，共 10 次

```
01:57:29 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
01:57:34 PM     all      1.81      0.00      0.40      0.00      0.00     97.78
01:57:39 PM     all      0.20      0.00      0.40      0.00      0.00     99.39
01:57:44 PM     all      0.40      0.00      0.60      0.00      0.00     98.99
01:57:49 PM     all      0.20      0.00      0.40      0.00      0.00     99.39
01:57:54 PM     all      0.80      0.00      1.41      0.00      0.00     97.79
01:57:59 PM     all      0.40      0.00      0.60      0.00      0.00     98.99
01:58:04 PM     all      0.20      0.00      0.40      0.00      0.00     99.39
01:58:09 PM     all      0.20      0.00      0.40      0.00      0.00     99.39
01:58:14 PM     all      0.40      0.00      0.61      0.00      0.00     98.99
01:58:19 PM     all      0.20      0.00      0.61      0.00      0.00     99.19
Average:        all      0.48      0.00      0.59      0.00      0.00     98.93
```

- 列说明：
	- `CPU：all` 表示统计信息为所有 CPU的平均值。
	- `%user`：显示在用户级别(application)运行使用 CPU 总时间的百分比。
	- `%nice`：显示在用户级别，用于nice操作，所占用 CPU总时间的百分比。
	- `%system`：在核心级别(kernel)运行所使用 CPU总时间的百分比。
	- `%iowait`：显示用于等待I/O操作占用 CPU总时间的百分比。
	- `%steal`：管理程序(hypervisor)为另一个虚拟进程提供服务而等待虚拟 CPU 的百分比。
	- `%idle`：显示 CPU空闲时间占用 CPU总时间的百分比。
- **总结**：
	- 1.若 `%iowait` 的值过高，表示硬盘存在I/O瓶颈
	- 2.若 `%idle` 的值高但系统响应慢时，有可能是 CPU 等待分配内存，此时应加大内存容量，可以使用内存监控命令分析内存。
	- 3.若 `%idle` 的值持续低于1，则系统的 CPU 处理能力相对较低，表明系统中最需要解决的资源是 CPU。

##### sar 之 RAM 使用情况（判断内存瓶颈）

- 命令：`sar -B 5 10`，每 5 秒采样一次，共 10 次

```
02:32:15 PM  pgpgin/s pgpgout/s   fault/s  majflt/s  pgfree/s pgscank/s pgscand/s pgsteal/s    %vmeff
02:32:20 PM      0.00      0.81    258.47      0.00     27.22      0.00      0.00      0.00      0.00
02:32:25 PM      0.00      0.00    611.54      0.00    300.20      0.00      0.00      0.00      0.00
02:32:30 PM      0.00     26.61     10.08      0.00     11.90      0.00      0.00      0.00      0.00
02:32:35 PM      0.00      1.62      3.64      0.00      3.84      0.00      0.00      0.00      0.00
02:32:40 PM      0.00      0.00      3.42      0.00      4.43      0.00      0.00      0.00      0.00
02:32:45 PM      0.00      0.00      3.43      0.00      3.83      0.00      0.00      0.00      0.00
02:32:50 PM      0.00      1.62      3.84      0.00      5.86      0.00      0.00      0.00      0.00
02:32:55 PM      0.00      0.00      3.41      0.00      3.82      0.00      0.00      0.00      0.00
02:33:00 PM      0.00      2.42    763.84      0.00    208.69      0.00      0.00      0.00      0.00
02:33:05 PM      0.00     13.74   2409.70      0.00    929.70      0.00      0.00      0.00      0.00
Average:         0.00      4.68    406.50      0.00    149.69      0.00      0.00      0.00      0.00
```

- `pgpgin/s`：表示每秒从磁盘或SWAP置换到内存的字节数(KB)
- `pgpgout/s`：表示每秒从内存置换到磁盘或SWAP的字节数(KB)
- `fault/s`：每秒钟系统产生的缺页数,即主缺页与次缺页之和(major + minor)
- `majflt/s`：每秒钟产生的主缺页数
- `pgfree/s`：每秒被放入空闲队列中的页个数
- `pgscank/s`：每秒被kswapd扫描的页个数
- `pgscand/s`：每秒直接被扫描的页个数
- `pgsteal/s`：每秒钟从cache中被清除来满足内存需要的页个数
- `%vmeff`：每秒清除的页(pgsteal)占总扫描页(pgscank+pgscand)的百分比

##### sar 之 I/O 使用情况（判断 I/O 瓶颈）

- 命令：`sar -b 5 10`，每 5 秒采样一次，共 10 次

```
02:34:13 PM       tps      rtps      wtps   bread/s   bwrtn/s
02:34:18 PM      3.03      0.00      3.03      0.00     59.80
02:34:23 PM      0.00      0.00      0.00      0.00      0.00
02:34:28 PM      0.00      0.00      0.00      0.00      0.00
02:34:33 PM      0.00      0.00      0.00      0.00      0.00
02:34:38 PM      1.61      0.00      1.61      0.00     24.80
02:34:43 PM      0.00      0.00      0.00      0.00      0.00
02:34:48 PM      0.40      0.00      0.40      0.00      4.86
02:34:53 PM      0.00      0.00      0.00      0.00      0.00
02:34:58 PM      0.00      0.00      0.00      0.00      0.00
02:35:03 PM      0.00      0.00      0.00      0.00      0.00
Average:         0.50      0.00      0.50      0.00      8.94
```

- `tps`：每秒钟物理设备的 I/O 传输总量
- `rtps`：每秒钟从物理设备读入的数据总量
- `wtps`：每秒钟向物理设备写入的数据总量
- `bread/s`：每秒钟从物理设备读入的数据量，单位为块/s
- `bwrtn/s`：每秒钟向物理设备写入的数据量，单位为块/s

##### sar 之 DEV（网卡）流量查看（判断网络瓶颈）

- 命令：`sar -n DEV`，查看网卡历史流量（因为是按时间显示每棵的流量，所以有很多）
- 如果要动态显示当前的网卡流量：`sar -n DEV 1`
- 采样收集网卡流量：`sar -n DEV 5 10`，每 5 秒采样一次，共 10 次
- 如果要查看其他日期下的记录，可以到这个目录下：`cd /var/log/sa` 查看下记录的文件，然后选择一个文件，比如：`sar -n DEV -f /var/log/sa/sa01`）

```
01:46:24 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
01:46:25 PM        lo      3.00      3.00      0.18      0.18      0.00      0.00      0.00
01:46:25 PM      eth0      4.00      4.00      0.55      0.56      0.00      0.00      0.00
```

- `01:46:25 PM` 表示时间
- `IFACE` 表示网卡名称
- `rxpck/s` 每秒钟接收到的 **包数目**，一般如果这个数字大于 4000 一般是被攻击了。
- `txpck/s` 每秒钟发送出去的 **包数目**
- `rxkB/s` 每秒钟接收到的数据量(单位kb)，一般如果这个数字大于 5000 一般是被攻击了。
- `txkB/s` 每秒钟发送出去的数据量(单位kb)
- `rxcmp/s`：每秒钟接收到的压缩包数目
- `txcmp/s`：每秒钟发送出去的压缩包数目
- `txmcst/s`：每秒钟接收到的多播包的包数目

- 查看 TCP 相关的一些数据（每隔 1 秒采样一次，一共 5 次）：`sar -n TCP,ETCP 1 5`

```
Linux 3.10.0-693.2.2.el7.x86_64 (youmeek) 	07/17/2018 	_x86_64_	(2 CPU)

12:05:47 PM  active/s passive/s    iseg/s    oseg/s
12:05:48 PM      0.00      0.00      1.00      0.00

12:05:47 PM  atmptf/s  estres/s retrans/s isegerr/s   orsts/s
12:05:48 PM      0.00      0.00      0.00      0.00      0.00

12:05:48 PM  active/s passive/s    iseg/s    oseg/s
12:05:49 PM      0.00      0.00      1.00      1.00

12:05:48 PM  atmptf/s  estres/s retrans/s isegerr/s   orsts/s
12:05:49 PM      0.00      0.00      0.00      0.00      0.00

12:05:49 PM  active/s passive/s    iseg/s    oseg/s
12:05:50 PM      0.00      0.00      1.00      1.00

12:05:49 PM  atmptf/s  estres/s retrans/s isegerr/s   orsts/s
12:05:50 PM      0.00      0.00      0.00      0.00      0.00

12:05:50 PM  active/s passive/s    iseg/s    oseg/s
12:05:51 PM      0.00      0.00      3.00      3.00

12:05:50 PM  atmptf/s  estres/s retrans/s isegerr/s   orsts/s
12:05:51 PM      0.00      0.00      0.00      0.00      0.00

12:05:51 PM  active/s passive/s    iseg/s    oseg/s
12:05:52 PM      0.00      0.00      1.00      1.00

12:05:51 PM  atmptf/s  estres/s retrans/s isegerr/s   orsts/s
12:05:52 PM      0.00      0.00      0.00      0.00      0.00

Average:     active/s passive/s    iseg/s    oseg/s
Average:         0.00      0.00      1.40      1.20

Average:     atmptf/s  estres/s retrans/s isegerr/s   orsts/s
Average:         0.00      0.00      0.00      0.00      0.00
```


```
- active/s：每秒钟本地主动开启的 tcp 连接，也就是本地程序使用 connect() 系统调用
- passive/s：每秒钟从源端发起的 tcp 连接，也就是本地程序使用 accept() 所接受的连接
- retrans/s: 每秒钟的 tcp 重传次数

atctive 和 passive 的数目通常可以用来衡量服务器的负载：接受连接的个数（passive），下游连接的个数（active）。可以简单认为 active 为出主机的连接，passive 为入主机的连接；但这个不是很严格的说法，比如 loalhost 和 localhost 之间的连接。

来自：https://zhuanlan.zhihu.com/p/39893236
```

---------------------------------------------------------------------

## CPU 监控

#### CPU 的基本信息查看

- Demo CPU 型号：[Intel® Xeon® Processor E5-2620 v2(15M Cache, 2.10 GHz)](http://ark.intel.com/products/75789/Intel-Xeon-Processor-E5-2620-v2-15M-Cache-2_10-GHz)
- 该 CPU 显示的数据中有一项这个要注意：`Intel® Hyper-Threading Technology` 是 `Yes`。表示该 CPU 支持超线程
- `cat /proc/cpuinfo`，查看 CPU 总体信息
- `grep 'physical id' /proc/cpuinfo | sort -u | wc -l`，查看物理 CPU 个数
    - 结果：2
    - 物理 CPU：物理 CPU 也就是机器外面就能看到的一个个 CPU，每个物理 CPU 还带有单独的风扇
- `grep 'core id' /proc/cpuinfo | sort -u | wc -l`，查看每个物理 CPU 的核心数量
    - 结果：6，因为每个物理 CPU 是 6，所有 2 个物理 CPU 的总核心数量应该是：12
    - 核心数：一个核心就是一个物理线程，英特尔有个超线程技术可以把一个物理线程模拟出两个线程来用，充分发挥 CPU 性能，意思是一个核心可以有多个线程。
- `grep 'processor' /proc/cpuinfo | sort -u | wc -l`，查看 CPU 总的线程数，一般也叫做：逻辑 CPU 数量
    - 结果：24，正常情况下：CPU 的总核心数量 == CPU 线程数，但是如果该 CPU 支持超线程，那结果是：CPU 的总核心数量 X 2 == CPU 线程数
    - 线程数：线程数是一种逻辑的概念，简单地说，就是模拟出的 CPU 核心数。比如，可以通过一个 CPU 核心数模拟出 2 线程的 CPU，也就是说，这个单核心的 CPU 被模拟成了一个类似双核心 CPU 的功能。


#### CPU 监控

- Linux 的 CPU 简单监控一般简单
- 常用命令就是 `top`
	- 命令：`top -bn1`，可以完全显示所有进程出来，但是不能实时展示数据，只能暂时命令当时的数据。
- `top` 可以动态显示进程所占的系统资源，每隔 3 秒变一次，占用系统资源最高的进程放最前面。
- 在 `top` 命令状态下还可以按数字键 <kbd>1<kbd> 显示各个 CPU 线程使用状态
- 在 `top` 命令状态下按 <kbd>shfit</kbd> + <kbd>m</kbd> 可以按照 **内存使用** 大小排序
- 在 `top` 命令状态下按 <kbd>shfit</kbd> + <kbd>p</kbd> 可以按照 **CPU 使用** 大小排序
- 展示数据上，%CPU 表示进程占用的 CPU 百分比，%MEM 表示进程占用的内存百分比
- mac 下不一样：要先输入 o，然后输入 cpu 则按 cpu 使用量排序，输入 rsize 则按内存使用量排序。

#### CPU 其他工具

- htop 综合工具：`yum install -y htop`
	- 这几篇文章讲得很好，我没必要再贴过来了，大家自己看：
	- [htop 命令完胜 top 命令](http://blog.51cto.com/215687833/1788493)
	- [htop 命令详解](https://blog.csdn.net/freeking101/article/details/79173903)
- mpstat 实时监控 CPU 状态：`yum install -y sysstat`
	- 可以具体到某个核心，比如我有 2 核的 CPU，因为 CPU 核心下标是从 0 开始，所以我要查看 0 的状况（间隔 3 秒获取一次指标，一共获取 5 次）：`mpstat -P 0 3 5`
	- 打印总 CPU 和各个核心指标：`mpstat -P ALL 1`
	- 获取所有核心的平均值：`mpstat 3 5`

```
Linux 3.10.0-693.2.2.el7.x86_64 (iZwz998aag1ggy168n3wg2Z) 	06/23/2018 	_x86_64_	(2 CPU)

11:44:52 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
11:44:53 AM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
11:44:54 AM    0    1.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00   99.00
11:44:55 AM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
11:44:56 AM    0    0.00    0.00    1.00    0.00    0.00    0.00    0.00    0.00    0.00   99.00
11:44:57 AM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
Average:       0    0.20    0.00    0.20    0.00    0.00    0.00    0.00    0.00    0.00   99.60
```

- %usr 用户进程消耗 CPU 情况
- %sys 系统进程消耗 CPU 情况
- %iowait  表示 CPU 等待 IO 时间占整个 CPU 周期的百分比
- %idle  显示 CPU 空闲时间占用 CPU 总时间的百分比

#### 类似 top 的 pidstat

- 安装：`yum install -y sysstat`
- 每隔 2 秒采样一次，一共 5 次：`pidstat 2 5`

```
Linux 3.10.0-693.el7.x86_64 (youmeek) 	07/17/2018 	_x86_64_	(8 CPU)

11:52:58 AM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
11:53:00 AM     0     16813    0.50    0.99    0.00    1.49     1  pidstat
11:53:00 AM     0     24757   50.99   12.87    0.00   63.86     0  java
11:53:00 AM     0     24799   60.40    3.47    0.00   63.86     5  java
11:53:00 AM     0     24841   99.50    7.43    0.00  100.00     0  java

11:53:00 AM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
11:53:02 AM     0     24757   56.50    0.50    0.00   57.00     0  java
11:53:02 AM     0     24799  100.00    6.50    0.00  100.00     5  java
11:53:02 AM     0     24841   58.00    2.50    0.00   60.50     0  java

11:53:02 AM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
11:53:04 AM     0     16813    0.00    1.00    0.00    1.00     2  pidstat
11:53:04 AM     0     24757   62.00    5.50    0.00   67.50     0  java
11:53:04 AM     0     24799   54.00   14.00    0.00   68.00     5  java
11:53:04 AM     0     24841   39.50    9.00    0.00   48.50     0  java

11:53:04 AM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
11:53:06 AM     0     16813    0.50    0.50    0.00    1.00     2  pidstat
11:53:06 AM     0     24757   80.00   13.50    0.00   93.50     0  java
11:53:06 AM     0     24799   56.50    0.50    0.00   57.00     5  java
11:53:06 AM     0     24841    1.00    0.50    0.00    1.50     0  java

11:53:06 AM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
11:53:08 AM     0     16813    0.00    0.50    0.00    0.50     2  pidstat
11:53:08 AM     0     24757   58.50    1.00    0.00   59.50     0  java
11:53:08 AM     0     24799   60.00    1.50    0.00   61.50     5  java
11:53:08 AM     0     24841    1.00    0.50    0.00    1.50     0  java

Average:      UID       PID    %usr %system  %guest    %CPU   CPU  Command
Average:        0     16813    0.20    0.60    0.00    0.80     -  pidstat
Average:        0     24757   61.58    6.69    0.00   68.26     -  java
Average:        0     24799   66.47    5.19    0.00   71.66     -  java
Average:        0     24841   39.92    3.99    0.00   43.91     -  java
```

---------------------------------------------------------------------


## 内存监控

- Linux 的内存本质是虚拟内存，这样说是因为它的内存是：物理内存 + 交换分区。有一个内存模块来管理应用的内存使用。
- 如果所以你内存大，可以考虑把 swap 分区改得小点或者直接关掉。
- 但是，如果是用的云主机，一般是没交换分区的，`free -g` 中的 Swap 都是 0。
- 查看内存使用命令：
	- 以 M 为容量单位展示数据：`free -m`
	- 以 G 为容量单位展示数据：`free -g`
	- CentOS 6 和 CentOS 7 展示出来的数据有差别，CentOS 7 比较容易看，比如下面的数据格式是 CentOS 7 的 `free -g`：

```
              total        used        free      shared  buff/cache   available
Mem:             11           0          10           0           0          10
Swap:             5           0           5

```

- 在以上结果中，其中可以用的内存是看 `available` 列。
- 对于 CentOS 6 的系统可以使用下面命令：

```
[root@bogon ~]# free -mlt
             total       used       free     shared    buffers     cached
Mem:         16080      15919        160          0        278      11934
Low:         16080      15919        160
High:            0          0          0
-/+ buffers/cache:       3706      12373
Swap:            0          0          0
Total:       16080      15919        160
```

- 以上的结果重点关注是：`-/+ buffers/cache`，这一行代表实际使用情况。


##### pidstat 采样内存使用情况

- 安装：`yum install -y sysstat`
- 每隔 2 秒采样一次，一共 3 次：`pidstat -r 2 3`

```
Linux 3.10.0-693.el7.x86_64 (youmeek) 	07/17/2018 	_x86_64_	(8 CPU)

11:56:34 AM   UID       PID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
11:56:36 AM     0     23960    168.81      0.00  108312   1124   0.01  pidstat
11:56:36 AM     0     24757      8.42      0.00 9360696 3862788  23.75  java
11:56:36 AM     0     24799      8.91      0.00 10424088 4988468  30.67  java
11:56:36 AM     0     24841     11.39      0.00 10423576 4968428  30.54  java

11:56:36 AM   UID       PID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
11:56:38 AM     0     23960    169.50      0.00  108312   1200   0.01  pidstat
11:56:38 AM     0     24757      6.00      0.00 9360696 3862788  23.75  java
11:56:38 AM     0     24799      5.50      0.00 10424088 4988468  30.67  java
11:56:38 AM     0     24841      7.00      0.00 10423576 4968428  30.54  java

11:56:38 AM   UID       PID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
11:56:40 AM     0     23960    160.00      0.00  108312   1200   0.01  pidstat
11:56:40 AM     0     24757      6.50      0.00 9360696 3862788  23.75  java
11:56:40 AM     0     24799      6.00      0.00 10424088 4988468  30.67  java
11:56:40 AM     0     24841      8.00      0.00 10423576 4968428  30.54  java

Average:      UID       PID  minflt/s  majflt/s     VSZ    RSS   %MEM  Command
Average:        0     23960    166.11      0.00  108312   1175   0.01  pidstat
Average:        0     24757      6.98      0.00 9360696 3862788  23.75  java
Average:        0     24799      6.81      0.00 10424088 4988468  30.67  java
Average:        0     24841      8.80      0.00 10423576 4968428  30.54  java
```


---------------------------------------------------------------------

## 硬盘监控

#### 硬盘容量相关查看

- `df -h`：自动以合适的磁盘容量单位查看磁盘大小和使用空间
- `df -m`：以磁盘容量单位 M 为数值结果查看磁盘使用情况
- `du -sh /opt/tomcat6`：查看tomcat6这个文件夹大小 (h的意思human-readable用人类可读性较好方式显示，系统会自动调节单位，显示合适大小的单位)
- `du /opt --max-depth=1 -h`：查看指定录入下包括子目录的各个文件大小情况


#### 命令：iostat（判断 I/0 瓶颈）

- 命令：`iostat -x -k 3 3`，每 3 秒采样一次，共 3 次。

```
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.55    0.00    0.52    0.00    0.00   98.93

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
vda               0.00     0.04    0.02    0.62     0.44     6.49    21.65     0.00    1.42    1.17    1.42   0.25   0.02

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.34    0.00    0.00    0.00    0.00   99.66

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
vda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.02    0.00    0.34    0.00    0.00   97.64

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
vda               0.00     0.00    0.00    1.68     0.00    16.16    19.20     0.00    0.20    0.00    0.20   0.20   0.03
```

- 列说明：
	- `rrqm/s`: 每秒对该设备的读请求被合并次数，文件系统会对读取同块(block)的请求进行合并
	- `wrqm/s`: 每秒对该设备的写请求被合并次数
	- `r/s`: 每秒完成的读次数
	- `w/s`: 每秒完成的写次数
	- `rkB/s`: 每秒读数据量(kB为单位)
	- `wkB/s`: 每秒写数据量(kB为单位)
	- `avgrq-sz`:平均每次IO操作的数据量(扇区数为单位)
	- `avgqu-sz`: 平均等待处理的IO请求队列长度（队列长度大于 1 表示设备处于饱和状态。）
	- `await`: 系统发往 IO 设备的请求的平均响应时间(毫秒为单位)。这包括请求排队的时间，以及请求处理的时间。超过经验值的平均响应时间表明设备处于饱和状态，或者设备有问题。
	- `svctm`: 平均每次IO请求的处理时间(毫秒为单位)
	- `%util`: 采用周期内用于IO操作的时间比率，即IO队列非空的时间比率（就是繁忙程度，值越高表示越繁忙）
- **总结**
	- `iowait%` 表示CPU等待IO时间占整个CPU周期的百分比，如果iowait值超过50%，或者明显大于%system、%user以及%idle，表示IO可能存在问题。
	- `%util` （重点参数）表示磁盘忙碌情况，一般该值超过80%表示该磁盘可能处于繁忙状态


#### 硬盘 IO 监控

- 安装 iotop：`yum install -y iotop`
- 查看所有进程 I/O 情况命令：`iotop`
- 只查看当前正在处理 I/O 的进程：`iotop -o`
- 只查看当前正在处理 I/O 的线程，每隔 5 秒刷新一次：`iotop -o -d 5`
- 只查看当前正在处理 I/O 的进程（-P 参数决定），每隔 5 秒刷新一次：`iotop -o -P -d 5`
- 只查看当前正在处理 I/O 的进程（-P 参数决定），每隔 5 秒刷新一次，使用 KB/s 单位（默认是 B/s）：`iotop -o -P -k -d 5`
- 使用 dd 命令测量服务器延迟：`dd if=/dev/zero of=/opt/ioTest2.txt bs=512 count=1000 oflag=dsync`
- 使用 dd 命令来测量服务器的吞吐率（写速度)：`dd if=/dev/zero of=/opt/ioTest1.txt bs=1G count=1 oflag=dsync`
	- 该命令创建了一个 10M 大小的文件 ioTest1.txt，其中参数解释：
	- if 代表输入文件。如果不指定 if，默认就会从 stdin 中读取输入。
	- of 代表输出文件。如果不指定 of，默认就会将 stdout 作为默认输出。
	- bs 代表字节为单位的块大小。
	- count 代表被复制的块数。
	- /dev/zero 是一个字符设备，会不断返回0值字节（\0）。
	- oflag=dsync：使用同步I/O。不要省略这个选项。这个选项能够帮助你去除 caching 的影响，以便呈现给你精准的结果。
    - conv=fdatasyn: 这个选项和 oflag=dsync 含义一样。
	
- 该命令执行完成后展示的数据：

```
[root@youmeek ~]# dd if=/dev/zero of=/opt/ioTest1.txt bs=1G count=1 oflag=dsync
记录了1+0 的读入
记录了1+0 的写出
1073741824字节(1.1 GB)已复制，5.43328 秒，198 MB/秒
```

- 利用 hdparm 测试硬盘速度：`yum install -y hdparm`
- 查看硬盘分区情况：`df -h`，然后根据分区测试：
- 测试硬盘分区的读取速度：`hdparm -T /dev/sda`
- 测试硬盘分区缓存的读取速度：`hdparm -t /dev/sda`
- 也可以以上两个参数一起测试：`hdparm -Tt /dev/sda`，结果数据如下：

```
/dev/sda:
Timing cached reads:   3462 MB in  2.00 seconds = 1731.24 MB/sec
Timing buffered disk reads: 806 MB in  3.00 seconds = 268.52 MB/sec
```


##### pidstat 采样硬盘使用情况

- 安装：`yum install -y sysstat`
- 每隔 2 秒采样一次，一共 3 次：`pidstat -d 2 3`

```
Linux 3.10.0-693.el7.x86_64 (youmeek) 	07/17/2018 	_x86_64_	(8 CPU)

11:57:29 AM   UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command

11:57:31 AM   UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
11:57:33 AM     0     24757      0.00      2.00      0.00  java
11:57:33 AM     0     24799      0.00     14.00      0.00  java

11:57:33 AM   UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
11:57:35 AM     0     24841      0.00      8.00      0.00  java

Average:      UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
Average:        0     24757      0.00      0.66      0.00  java
Average:        0     24799      0.00      4.65      0.00  java
Average:        0     24841      0.00      2.66      0.00  java
```

- 输出指标含义：

```
kB_rd/s: 每秒进程从磁盘读取的数据量(以 kB 为单位)
kB_wr/s: 每秒进程向磁盘写的数据量(以 kB 为单位)
kB_ccwr/s：任务取消的写入磁盘的 KB。当任务截断脏的 pagecache 的时候会发生。
```


---------------------------------------------------------------------


## 网络监控

#### 网络监控常用

- 安装 iftop（需要有 EPEL 源）：`yum install -y iftop`
	- 如果没有 EPEL 源：`yum install -y epel-release`
- 常用命令：
	- `iftop`：默认是监控第一块网卡的流量
	- `iftop -i eth0`：监控 eth0
	- `iftop -n`：直接显示IP, 不进行DNS反解析
	- `iftop -N`：直接显示连接埠编号, 不显示服务名称
	- `iftop -F 192.168.1.0/24 or 192.168.1.0/255.255.255.0`：显示某个网段进出封包流量
    - `iftop -nP`：显示端口与 IP 信息

``` nginx
中间部分：外部连接列表，即记录了哪些ip正在和本机的网络连接

右边部分：实时参数分别是该访问 ip 连接到本机 2 秒，10 秒和 40 秒的平均流量

=> 代表发送数据，<= 代表接收数据

底部会显示一些全局的统计数据，peek 是指峰值情况，cumm 是从 iftop 运行至今的累计情况，而 rates 表示最近 2 秒、10 秒、40 秒内总共接收或者发送的平均网络流量。

TX:（发送流量）  cumm:   143MB   peak:   10.5Mb    rates:   1.03Mb  1.54Mb  2.10Mb
RX:（接收流量）          12.7GB          228Mb              189Mb   191Mb   183Mb
TOTAL:（总的流量）       12.9GB          229Mb              190Mb   193Mb   185MbW

```

### 端口使用情况（也可以用来查看端口占用）

#### lsof

- 安装 lsof：`yum install -y lsof`
- 查看 3316 端口是否有被使用（macOS 也适用）：`lsof -i:3316`，**有被使用会输出类似如下信息，如果没被使用会没有任何信息返回**

```
COMMAND     PID USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
java      12011 root   77u  IPv6 4506842      0t0  TCP JDu4e00u53f7:58560->116.196.110.69:aicc-cmi (ESTABLISHED)
java      12011 root   78u  IPv6 4506843      0t0  TCP JDu4e00u53f7:58576->116.196.110.69:aicc-cmi (ESTABLISHED)
java      12011 root   79u  IPv6 4506844      0t0  TCP JDu4e00u53f7:58578->116.196.110.69:aicc-cmi (ESTABLISHED)
java      12011 root   80u  IPv6 4506845      0t0  TCP JDu4e00u53f7:58574->116.196.110.69:aicc-cmi (ESTABLISHED)
java      12011 root   82u  IPv6 4506846      0t0  TCP JDu4e00u53f7:58562->116.196.110.69:aicc-cmi (ESTABLISHED)
java      12011 root   83u  IPv6 4506847      0t0  TCP JDu4e00u53f7:58564->116.196.110.69:aicc-cmi (ESTABLISHED)
java      12011 root   84u  IPv6 4506848      0t0  TCP JDu4e00u53f7:58566->116.196.110.69:aicc-cmi (ESTABLISHED)
java      12011 root   85u  IPv6 4506849      0t0  TCP JDu4e00u53f7:58568->116.196.110.69:aicc-cmi (ESTABLISHED)
java      12011 root   86u  IPv6 4506850      0t0  TCP JDu4e00u53f7:58570->116.196.110.69:aicc-cmi (ESTABLISHED)
java      12011 root   87u  IPv6 4506851      0t0  TCP JDu4e00u53f7:58572->116.196.110.69:aicc-cmi (ESTABLISHED)
docker-pr 13551 root    4u  IPv6 2116824      0t0  TCP *:aicc-cmi (LISTEN)
```

#### netstat

- 更多用法可以看：[netstat 的10个基本用法](https://linux.cn/article-2434-1.html)
- 查看所有在用的端口（macOS 也适用）：`netstat -ntlp`

```
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/systemd           
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      746/sshd            
tcp        0      0 127.0.0.1:32000         0.0.0.0:*               LISTEN      12011/java          
tcp6       0      0 :::9066                 :::*                    LISTEN      12011/java          
tcp6       0      0 :::6379                 :::*                    LISTEN      28668/docker-proxy  
tcp6       0      0 :::111                  :::*                    LISTEN      1/systemd           
tcp6       0      0 :::3316                 :::*                    LISTEN      13551/docker-proxy  
tcp6       0      0 :::22                   :::*                    LISTEN      746/sshd            
tcp6       0      0 :::35224                :::*                    LISTEN      12011/java          
tcp6       0      0 :::3326                 :::*                    LISTEN      14203/docker-proxy  
tcp6       0      0 :::1984                 :::*                    LISTEN      12011/java          
tcp6       0      0 :::8066                 :::*                    LISTEN      12011/java          
tcp6       0      0 :::43107                :::*                    LISTEN      12011/java 
```

- 查看当前连接80端口的机子有多少，并且是属于什么状态：`netstat -an|grep 80|sort -r`
- 查看已经连接的IP有多少连接数：`netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n`
- 查看已经连接的IP有多少连接数，只显示前 5 个：`netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n | head -5`
- 查看每个 ip 跟服务器建立的连接数：`netstat -nat|awk '{print$5}'|awk -F : '{print$1}'|sort|uniq -c|sort -rn`

```
262 127.0.0.1
118
103 172.22.100.141
 12 172.22.100.29
  7 172.22.100.183
  6 116.21.17.144
  6 0.0.0.0
  5 192.168.1.109
  4 172.22.100.32
  4 172.22.100.121
  4 172.22.100.108
  4 172.18.1.39
  3 172.22.100.2
  3 172.22.100.190
```


- 统计当前连接的一些状态情况：`netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'` 或者 `netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn`

```
TIME_WAIT 96（是表示系统在等待客户端响应，以便再次连接时候能快速响应，如果积压很多，要开始注意了，准备阻塞了。这篇文章可以看下：http://blog.51cto.com/jschu/1728001）
CLOSE_WAIT 11（如果积压很多，要开始注意了，准备阻塞了。可以看这篇文章：http://blog.51cto.com/net881004/2164020）
FIN_WAIT2 17
ESTABLISHED 102（表示正常数据传输状态）
```

- TIME_WAIT 和 CLOSE_WAIT 说明：

```
Linux 系统下，TCP连接断开后，会以TIME_WAIT状态保留一定的时间，然后才会释放端口。当并发请求过多的时候，就会产生大量的TIME_WAIT状态 的连接，无法及时断开的话，会占用大量的端口资源和服务器资源。这个时候我们可以优化TCP的内核参数，来及时将TIME_WAIT状态的端口清理掉。

来源：http://zhangbin.junxilinux.com/?p=219

=================================

出现大量close_wait的现象，主要原因是某种情况下对方关闭了socket链接，但是另一端由于正在读写，没有关闭连接。代码需要判断socket，一旦读到0，断开连接，read返回负，检查一下errno，如果不是AGAIN，就断开连接。
Linux分配给一个用户的文件句柄是有限的，而TIME_WAIT和CLOSE_WAIT两种状态如果一直被保持，那么意味着对应数目的通道就一直被占着，一旦达到句柄数上限，新的请求就无法被处理了，接着就是大量Too Many Open Files异常，导致tomcat崩溃。关于TIME_WAIT过多的解决方案参见TIME_WAIT数量太多。

常见错误原因：
1.代码层面上未对连接进行关闭，比如关闭代码未写在 finally 块关闭，如果程序中发生异常就会跳过关闭代码，自然未发出指令关闭，连接一直由程序托管，内核也无权处理，自然不会发出 FIN 请求，导致连接一直在 CLOSE_WAIT 。
2.程序响应过慢，比如双方进行通讯，当客户端请求服务端迟迟得不到响应，就断开连接，重新发起请求，导致服务端一直忙于业务处理，没空去关闭连接。这种情况也会导致这个问题。一般如果有多个节点，nginx 进行负载，其中某个节点很高，其他节点不高，那可能就是负载算法不正常，都落在一台机子上了，以至于它忙不过来。

来源：https://juejin.im/post/5b59e61ae51d4519634fe257
```

- 查看网络接口接受、发送的数据包情况（每隔 3 秒统计一次）：`netstat -i 3`


```
Kernel Interface table
Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
eth0      1500 10903298      0      0 0      10847741      0      0      0 BMRU
lo       65536   453650      0      0 0        453650      0      0      0 LRU
eth0      1500 10903335      0      0 0      10847777      0      0      0 BMRU
lo       65536   453650      0      0 0        453650      0      0      0 LRU
eth0      1500 10903363      0      0 0      10847798      0      0      0 BMRU
lo       65536   453650      0      0 0        453650      0      0      0 LRU
eth0      1500 10903393      0      0 0      10847836      0      0      0 BMRU
lo       65536   453650      0      0 0        453650      0      0      0 LRU
eth0      1500 10903437      0      0 0      10847867      0      0      0 BMRU
lo       65536   453650      0      0 0        453650      0      0      0 LRU
```

- 接收（该值是历史累加数据，不是瞬间数据，要计算时间内的差值需要自己减）：
	- RX-OK 已接收字节数
	- RX-ERR 已接收错误字节数（数据值大说明网络存在问题）
	- RX-DRP 已丢失字节数（数据值大说明网络存在问题）
	- RX-OVR 由于误差而遗失字节数（数据值大说明网络存在问题）
- 发送（该值是历史累加数据，不是瞬间数据，要计算时间内的差值需要自己减）：
	- TX-OK 已发送字节数
	- TX-ERR 已发送错误字节数（数据值大说明网络存在问题）
	- TX-DRP 已丢失字节数（数据值大说明网络存在问题）
	- TX-OVR 由于误差而遗失字节数（数据值大说明网络存在问题）


#### 网络排查

- ping 命令查看丢包、域名解析地址
	- `ping 116.196.110.69`
	- `ping www.GitNavi.com`
- telnet 测试端口的连通性（验证服务的可用性）
	- `yum install -y telnet`
	- `telnet 116.196.110.68 3306`
	- `telnet www.youmeek.com 80`
- tracert（跟踪路由）查看网络请求节点访问情况，用于确定 IP 数据报访问目标所采取的路径。
	- `yum install -y traceroute`
	- `traceroute gitnavi.com`
- nslookup 命令查看 DNS 是否可用
	- `yum install -y bind-utils`
	- 输入：`nslookup`，然后终端进入交互模式，然后输入：`www.baidu.com`，此时会展示类似这样的信息：

```
Server:		103.224.222.221（这个是你本机的信息）
Address:	103.224.222.221#53（这个是你本机的信息）

（下面是百度的信息）
Non-authoritative answer:
www.baidu.COM	canonical name = www.a.shifen.COM.
Name:	www.a.shifen.COM
Address: 220.181.112.244
Name:	www.a.shifen.COM
Address: 220.181.111.188
```

- 此时我们假设换个 DNS，我们在刚刚的交互阶段继续输入：`server 8.8.8.8`，表示我们此时用 8.8.8.8 的 DNS，然后我们在交互中再输入：`www.baidu.com`，此时会出现这个信息：

```
Server:		8.8.8.8
Address:	8.8.8.8#53

Non-authoritative answer:
www.baidu.com	canonical name = www.a.shifen.com.
Name:	www.a.shifen.com
Address: 180.97.33.108
Name:	www.a.shifen.com
Address: 180.97.33.107
```

- 以上表明，不同的 DNS 情况下，我们获取到的域名所属 IP 是不同的。

---------------------------------------------------------------------

## 查看 Linux 内核版本

- 对于一些复杂的层面问题，一般都要先确认内核版本，好帮助分析：`uname -r`

```
3.10.0-693.2.2.el7.x86_64
```


## dmesg 打印内核信息

- 开机信息存在：`tail -500f /var/log/dmesg`
- 查看尾部信息：`dmesg -T | tail`
	- 参数 `-T` 表示显示时间
- 只显示 error 和 warning 信息：`dmesg --level=err,warn -T`
- 有些 OOM 的错误会在这里显示，比如：

```
[1880957.563400] Out of memory: Kill process 18694 (perl) score 246 or sacrifice child
[1880957.563408] Killed process 18694 (perl) total-vm:1972392kB, anon-rss:1953348kB, file-rss:0kB
```

## 查看系统日志

- 查看系统日志：`tail -400f /var/log/messages`
- 可能会看到类似以下异常：

```
Out of memory: Kill process 19452 (java) score 264 or sacrifice child
```


---------------------------------------------------------------------

## 服务器故障排查顺序

#### 请求时好时坏

- 系统层面
	- 查看负载、CPU、内存、上线时间、高资源进程 PID：`htop`
	- 查看网络丢失情况：`netstat -i 3`，关注：RX-DRP、TX-DRP，如果两个任何一个有值，或者都有值，肯定是网络出了问题（该值是历史累加数据，不是瞬间数据）。
- 应用层面
	- 临时修改 nginx log 输出格式，输出完整信息，包括请求头

```
$request_body   请求体（含POST数据）
$http_XXX       指定某个请求头（XXX为字段名，全小写）
$cookie_XXX     指定某个cookie值（XXX为字段名，全小写）


类似用法：
log_format  special_main  '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$request_body" "$http_referer" '
    '"$http_user_agent" $http_x_forwarded_for "appid=$http_appid,appver=$http_appver,vuser=$http_vuser" '
    '"phpsessid=$cookie_phpsessid,vuser_cookie=$cookie___vuser" ';


access_log  /home/wwwlogs/hicrew.log special_main;

```



#### CPU 高，负载高，访问慢（没有数据库）

- **记录负载开始升高的时间**
- 常见场景
	- 虚拟机所在的宿主机资源瓶颈，多个虚拟机竞争资源
	- 定时任务大量的任务并发
	- 消息、请求堆积后恢复时的瞬时流量引起
	- 持久化任务引起
	- 更多可以看这篇：[线上异常排查总结](https://blog.csdn.net/freeiceflame/article/details/78006812)
- 系统层面
	- 查看负载、CPU、内存、上线时间、高资源进程 PID：`htop`
	- 查看磁盘使用情况：`df -h`
	- 查看磁盘当前情况：`iostat -x -k 3 3`。如果发现当前磁盘忙碌，则查看是哪个 PID 在忙碌：`iotop -o -P -k -d 5`
	- 查看 PID 具体在写什么东西：`lsof -p PID`
	- 查看系统日志：`tail -400f /var/log/messages`
	- 查看简化线程树：`pstree -a >> /opt/pstree-20180915.log`
	- 其他机子 ping（多个地区 ping），看下解析 IP 与网络丢包
	- 查看网络节点情况：`traceroute www.youmeek.com`
	- `ifconfig` 查看 dropped 和 error 是否在不断增加，判断网卡是否出现问题
	- `nslookup` 命令查看 DNS 是否可用
	- 如果 nginx 有安装：http_stub_status_module 模块，则查看当前统计
	- 查看 TCP 和 UDP 应用
		- `netstat -ntlp`
		- `netstat -nulp`
	- 统计当前连接的一些状态情况：`netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn`
	- 查看每个 ip 跟服务器建立的连接数：`netstat -nat|awk '{print$5}'|awk -F : '{print$1}'|sort|uniq -c|sort -rn`
	- 查看与后端应用端口连接的有多少：`lsof -i:8080|grep 'TCP'|wc -l`
	- 跟踪程序（按 `Ctrl + C` 停止跟踪）：`strace -tt -T -v -f -e trace=file -o /opt/strace-20180915.log -s 1024 -p PID`
	- 看下谁在线：`w`，`last`
	- 看下执行了哪些命令：`history`
- 程序、JVM 层面
	- 保存、查看 Nginx 程序 log
		- 通过 GoAccess 分析 log
	- 保存、查看 Java 程序 log
	- 使用内置 tomcat-manager 监控配置，或者使用类似工具：psi-probe
	- 使用 `ps -ef | grep java`，查看进程 PID
		- 根据高 CPU 的进程 PID，查看其线程 CPU 使用情况：`top -Hp PID`，找到占用 CPU 资源高的线程 PID
	- 保存堆栈情况：`jstack -l PID >> /opt/jstack-tomcat1-PID-20180917.log`
		- 把占用 CPU 资源高的线程十进制的 PID 转换成 16 进制：`printf "%x\n" PID`，比如：`printf "%x\n" 12401` 得到结果是：`3071`
		- 在刚刚输出的那个 log 文件中搜索：`3071`，可以找到：`nid=0x3071`
	- 使用 `jstat -gc PID 10000 10`，查看gc情况（截图）
	- 使用 `jstat -gccause PID`：额外输出上次GC原因（截图）
	- 使用 `jstat -gccause PID 10000 10`：额外输出上次GC原因，收集 10 次，每隔 10 秒
	- 使用 `jmap -dump:format=b,file=/opt/dumpfile-tomcat1-PID-20180917.hprof PID`，生成堆转储文件
		- 使用 jhat 或者可视化工具（Eclipse Memory Analyzer 、IBM HeapAnalyzer）分析堆情况。
	- 结合代码解决内存溢出或泄露问题。
	- 给 VM 增加 dump 触发参数：`-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/tomcat-1.hprof`

#### 一次 JVM 引起的 CPU 高排查

- 使用 `ps -ef | grep java`，查看进程 PID
	- 根据高 CPU 的进程 PID，查看其线程 CPU 使用情况：`top -Hp PID`，找到占用 CPU 资源高的线程 PID
- 保存堆栈情况：`jstack -l PID >> /opt/jstack-tomcat1-PID-20181017.log`
- 把占用 CPU 资源高的线程十进制的 PID 转换成 16 进制：`printf "%x\n" PID`，比如：`printf "%x\n" 12401` 得到结果是：`3071`
- 在刚刚输出的那个 log 文件中搜索：`3071`，可以找到：`nid=0x3071`
- 也可以在终端中直接看：`jstack PID |grep 十六进制线程 -A 30`，此时如果发现如下：

```
"GC task thread#0 (ParallelGC)" os_prio=0 tid=0x00007fd0ac01f000 nid=0x66f runnable 
```

- 这种情况一般是 heap 设置得过小，而又要频繁分配对象；二是内存泄露，对象一直不能被回收，导致 CPU 占用过高
- 使用：`jstat -gcutil PID 3000 10`：
- 正常情况结果应该是这样的：

```
S0     S1     E      O      M     CCS    YGC     YGCT    FGC    FGCT     GCT
0.00   0.00  67.63  38.09  78.03  68.82    124    0.966     5    0.778    1.744
0.00   0.00  67.68  38.09  78.03  68.82    124    0.966     5    0.778    1.744
0.00   0.00  67.68  38.09  78.03  68.82    124    0.966     5    0.778    1.744
0.00   0.00  67.68  38.09  78.03  68.82    124    0.966     5    0.778    1.744
0.00   0.00  67.68  38.09  78.03  68.82    124    0.966     5    0.778    1.744
0.00   0.00  67.68  38.09  78.03  68.82    124    0.966     5    0.778    1.744
0.00   0.00  67.68  38.09  78.03  68.82    124    0.966     5    0.778    1.744
0.00   0.00  67.68  38.09  78.03  68.82    124    0.966     5    0.778    1.744
0.00   0.00  67.71  38.09  78.03  68.82    124    0.966     5    0.778    1.744
0.00   0.00  67.71  38.09  78.03  68.82    124    0.966     5    0.778    1.744

```

- S0：SO 当前使用比例
- S1：S1 当前使用比例
- E：**Eden 区使用比例（百分比）（异常的时候，这里可能会接近 100%）**
- O：**old 区使用比例（百分比）（异常的时候，这里可能会接近 100%）**
- M：**Metaspace 区使用比例（百分比）（异常的时候，这里可能会接近 100%）**
- CCS：压缩使用比例
- YGC：年轻代垃圾回收次数
- FGC：老年代垃圾回收次数
- FGCT：老年代垃圾回收消耗时间（单位秒）
- GCT：垃圾回收消耗总时间（单位秒）
- **异常的时候每次 Full GC 时间也可能非常长，每次时间计算公式=FGCT值/FGC指）**
- `jmap -heap PID`，查看具体占用量是多大
- 使用 `jmap -dump:format=b,file=/opt/dumpfile-tomcat1-PID-20180917.hprof PID`，生成堆转储文件（如果设置的 heap 过大，dump 下来会也会非常大）
	- 使用 jhat 或者可视化工具（Eclipse Memory Analyzer 、IBM HeapAnalyzer）分析堆情况。
	- 一般这时候就只能根据 jhat 的分析，看源码了
- 这里有几篇类似经历的文章推荐给大家：
	- [三个神奇bug之Java占满CPU](http://luofei.me/?p=197)
	- [CPU 负载过高问题排查](http://zhouyun.me/2017/10/24/cpu_load_issue/)


#### CPU 低，负载高，访问慢（带数据库）

- 基于上面，但是侧重点在于 I/O 读写，以及是否有 MySQL 死锁，或者挂载了 NFS，而 NFS Server 出现问题
- mysql 下查看当前的连接数与执行的sql 语句：`show full processlist;`
- 检查慢查询日志，可能是慢查询引起负载高，根据配置文件查看存放位置：`log_slow_queries`
- 查看 MySQL 设置的最大连接数：`show variables like 'max_connections';`
	- 重新设置最大连接数：`set GLOBAL max_connections=300`




## 参考资料

- <http://man.linuxde.net/dd>
- <https://linux.cn/article-6104-1.html>
- <http://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858923.html>
- <http://coolnull.com/3649.html>
- <http://www.rfyy.net/archives/2456.html>
- <http://programmerfamily.com/blog/linux/sav.html>
- <https://www.jianshu.com/p/3991c0dba094>
- <https://www.jianshu.com/p/3667157d63bb>
- <https://www.cnblogs.com/yjd_hycf_space/p/7755633.html>
- <http://silverd.cn/2016/05/27/nginx-access-log.html>




