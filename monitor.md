# 常见日常监控

## 系统查看

- 查看 CentOS 版本号：`cat /etc/redhat-release` 

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


## 参考资料

- <http://man.linuxde.net/dd>
- <https://linux.cn/article-6104-1.html>
- <http://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858923.html>
- <http://coolnull.com/3649.html>































