# 常见日常监控

## 系统信息

- 查看 CentOS 版本号：`cat /etc/redhat-release` 

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
	- `wa` 表示I/O等待所占用CPU的时间比


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
	- `avgqu-sz`: 平均等待处理的IO请求队列长度
	- `await`: 平均每次IO请求等待时间(包括等待时间和处理时间，毫秒为单位)
	- `svctm`: 平均每次IO请求的处理时间(毫秒为单位)
	- `%util`: 采用周期内用于IO操作的时间比率，即IO队列非空的时间比率
- **总结**
	- `iowait%` 表示CPU等待IO时间占整个CPU周期的百分比，如果iowait值超过50%，或者明显大于%system、%user以及%idle，表示IO可能存在问题。
	- `%util` 表示磁盘忙碌情况，一般该值超过80%表示该磁盘可能处于繁忙状态

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


## CPU 的基本信息查看

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


## CPU 监控

- Linux 的 CPU 简单监控一般简单
- 常用命令就是 `top`
	- 命令：`top -bn1`，可以完全显示所有进程出来，但是不能实时展示数据，只能暂时命令当时的数据。
- `top` 可以动态显示进程所占的系统资源，每隔 3 秒变一次，占用系统资源最高的进程放最前面。
- 在 `top` 命令状态下还可以按数字键 <kbd>1<kbd> 显示各个 CPU 线程使用状态
- 在 `top` 命令状态下按 <kbd>shfit</kbd> + <kbd>m</kbd> 可以按照 **内存使用** 大小排序
- 在 `top` 命令状态下按 <kbd>shfit</kbd> + <kbd>p</kbd> 可以按照 **CPU 使用** 大小排序
- 展示数据上，%CPU 表示进程占用的 CPU 百分比，%MEM 表示进程占用的内存百分比


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


## 硬盘查看

- `df -h`：自动以合适的磁盘容量单位查看磁盘大小和使用空间
- `df -m`：以磁盘容量单位 M 为数值结果查看磁盘使用情况
- `du -sh /opt/tomcat6`：查看tomcat6这个文件夹大小 (h的意思human-readable用人类可读性较好方式显示，系统会自动调节单位，显示合适大小的单位)
- `du /opt --max-depth=1 -h`：查看指定录入下包括子目录的各个文件大小情况

## 硬盘 IO 监控

- 安装 iotop：`yum install -y iotop`
- 查看命令：`iotop`
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

## 网络监控

- 安装 iftop（需要有 EPEL 源）：`yum install -y iftop`
	- 如果没有 EPEL 源：`yum install -y epel-release`
- 常用命令：
	- `iftop`：默认是监控第一块网卡的流量
	- `iftop -i eth1`：监控eth1
	- `iftop -n`：直接显示IP, 不进行DNS反解析
	- `iftop -N`：直接显示连接埠编号, 不显示服务名称
	- `iftop -F 192.168.1.0/24 or 192.168.1.0/255.255.255.0`：显示某个网段进出封包流量

## 端口使用情况

- 安装 lsof：`yum install -y lsof`
- 查看 3316 端口是否有被使用：`lsof -i:3316`，**有被使用会输出类似如下信息，如果没被使用会没有任何信息返回**

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


- 查看所有在用的端口：`netstat -ntlp`

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

- 查看当前连接80端口的机子有多少：`netstat -an|grep 80|sort -r`
- 查看已经连接的IP有多少连接数：`netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n`

#### 网络排查

- ping 命令查看丢包、域名解析地址
	- `ping 116.196.110.69`
	- `ping www.GitNavi.com`
- telnet 测试端口的连通性
	- `yum install -y telnet`
	- `telnet 116.196.110.68 3306`
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


## 参考资料

- <http://man.linuxde.net/dd>
- <https://linux.cn/article-6104-1.html>
- <http://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858923.html>
- <http://coolnull.com/3649.html>
- <http://www.rfyy.net/archives/2456.html>
- <http://programmerfamily.com/blog/linux/sav.html>































