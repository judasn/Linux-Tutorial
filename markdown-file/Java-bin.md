# Java bin 目录下的工具

## 频繁GC问题或内存溢出排查流程

- 使用 `jps`，查看线程ID，假设 PID 为 12011
- 使用 `jstat -gc 12011 250 20`，查看gc情况，一般比较关注PERM区的情况，查看GC的增长情况。
- 使用 `jstat -gccause`：额外输出上次GC原因
- 使用 `jmap -dump:format=b,file=/opt/myHeapDumpFileName 12011`，生成堆转储文件
- 使用 jhat 或者可视化工具（Eclipse Memory Analyzer 、IBM HeapAnalyzer）分析堆情况。
- 结合代码解决内存溢出或泄露问题。

## 死锁问题

- 使用 `jps`查看线程ID，假设 PID 为 12011
- 使用 `jstack 12011` 查看线程情况

## jps

- 显示当前所有 java 进程 pid 的命令

```
16470 Jps
12011 Bootstrap
```

- `jps -v` 跟：`ps -ef|grep java` 主要输出内容一样
- `12011` 是我这边的一个 java 应用的 pid，下面的其他命令都是自己与此应用进行分析的

## jstat

- 显示进程中的类装载、内存、垃圾收集、JIT编译等运行数据。
- `jstat -gc 12011 250 10`，查询进程 12011 的垃圾收集情况，每250毫秒查询一次，一共查询10次。

```
 S0C    S1C    S0U    S1U      EC       EU        OC         OU       MC     MU    CCSC   CCSU   YGC     YGCT    FGC    FGCT     GCT   
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
34944.0 34944.0 1006.5  0.0   279616.0 235729.8  699072.0   12407.5   20736.0 20145.5 2560.0 2411.8      6    0.392   0      0.000    0.392
```

- 列含义说明：
	-S0C 年轻代中第一个survivor（幸存区）的容量 (字节) 
	-S1C 年轻代中第二个survivor（幸存区）的容量 (字节) 
	-S0U 年轻代中第一个survivor（幸存区）目前已使用空间 (字节) 
	-S1U 年轻代中第二个survivor（幸存区）目前已使用空间 (字节) 
	-EC 年轻代中Eden（伊甸园）的容量 (字节) 
	-EU 年轻代中Eden（伊甸园）目前已使用空间 (字节) 
	-OC Old代的容量 (字节) 
	-OU Old代目前已使用空间 (字节) 
	-PC Perm(持久代)的容量 (字节) 
	-PUPerm(持久代)目前已使用空间 (字节) 
	-YGC 从应用程序启动到采样时年轻代中gc次数 
	-YGCT 从应用程序启动到采样时年轻代中gc所用时间(s) 
	-FGC 从应用程序启动到采样时old代(全gc)gc次数 
	-FGCT 从应用程序启动到采样时old代(全gc)gc所用时间(s) 
	-GCT 从应用程序启动到采样时gc用的总时间(s)

- `jstat -gccapacity 12011 250 10`，查询进程 12011 VM内存中三代（young,old,perm）对象的使用和占用大小，每250毫秒查询一次，一共查询10次。

```
 NGCMN    NGCMX     NGC     S0C   S1C       EC      OGCMN      OGCMX       OGC         OC       MCMN     MCMX      MC     CCSMN    CCSMX     CCSC    YGC    FGC 
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
349504.0 1398080.0 349504.0 34944.0 34944.0 279616.0   699072.0  2796224.0   699072.0   699072.0      0.0 1067008.0  20736.0      0.0 1048576.0   2560.0      6     0
```

- 列含义说明：
	- NGCMN 年轻代(young)中初始化(最小)的大小(字节)
	- NGCMX 年轻代(young)的最大容量 (字节) 
	- NGC 年轻代(young)中当前的容量 (字节) 
	- S0C 年轻代中第一个survivor（幸存区）的容量 (字节) 
	- S1C 年轻代中第二个survivor（幸存区）的容量 (字节) 
	- EC 年轻代中Eden（伊甸园）的容量 (字节) 
	- OGCMN old代中初始化(最小)的大小 (字节) 
	- OGCMX old代的最大容量(字节) 
	- OGC old代当前新生成的容量 (字节) 
	- OC Old代的容量 (字节) 
	- PGCMN perm代中初始化(最小)的大小 (字节) 
	- PGCMX perm代的最大容量 (字节)
	- PGC perm代当前新生成的容量 (字节) 
	- PC Perm(持久代)的容量 (字节) 
	- YGC 从应用程序启动到采样时年轻代中gc次数 
	- FGC 从应用程序启动到采样时old代(全gc)gc次数
- 更多其他参数的使用可以看：[Java命令学习系列（四）——jstat](https://mp.weixin.qq.com/s?__biz=MzI3NzE0NjcwMg==&mid=402330276&idx=2&sn=58117de92512f83090d0a9de738eeacd&scene=21#wechat_redirect)

## jmap

- 生成堆转储快照（heapdump）
- 堆Dump是反应Java堆使用情况的内存镜像，其中主要包括系统信息、虚拟机属性、完整的线程Dump、所有类和对象的状态等。 一般，在内存不足、GC异常等情况下，我们就会怀疑有内存泄露。这个时候我们就可以制作堆Dump来查看具体情况，分析原因。
- 常见内存错误：
	- outOfMemoryError 年老代内存不足。
	- outOfMemoryError:PermGen Space 永久代内存不足。
	- outOfMemoryError:GC overhead limit exceed 垃圾回收时间占用系统运行时间的98%或以上。
- `jmap -heap 12011`，查看指定进程堆（heap）使用情况

```
Attaching to process ID 12011, please wait...
Debugger attached successfully.
Server compiler detected.
JVM version is 25.151-b12

using thread-local object allocation.
Mark Sweep Compact GC

Heap Configuration:
   MinHeapFreeRatio         = 40
   MaxHeapFreeRatio         = 70
   MaxHeapSize              = 4294967296 (4096.0MB)
   NewSize                  = 357892096 (341.3125MB)
   MaxNewSize               = 1431633920 (1365.3125MB)
   OldSize                  = 715849728 (682.6875MB)
   NewRatio                 = 2
   SurvivorRatio            = 8
   MetaspaceSize            = 21807104 (20.796875MB)
   CompressedClassSpaceSize = 1073741824 (1024.0MB)
   MaxMetaspaceSize         = 17592186044415 MB
   G1HeapRegionSize         = 0 (0.0MB)

Heap Usage:
New Generation (Eden + 1 Survivor Space):
   capacity = 322109440 (307.1875MB)
   used     = 242418024 (231.1878433227539MB)
   free     = 79691416 (75.9996566772461MB)
   75.2595217327378% used
Eden Space:
   capacity = 286326784 (273.0625MB)
   used     = 241387328 (230.20489501953125MB)
   free     = 44939456 (42.85760498046875MB)
   84.30483681191348% used
From Space:
   capacity = 35782656 (34.125MB)
   used     = 1030696 (0.9829483032226562MB)
   free     = 34751960 (33.142051696777344MB)
   2.88043458819826% used
To Space:
   capacity = 35782656 (34.125MB)
   used     = 0 (0.0MB)
   free     = 35782656 (34.125MB)
   0.0% used
tenured generation:
   capacity = 715849728 (682.6875MB)
   used     = 12705280 (12.11669921875MB)
   free     = 703144448 (670.57080078125MB)
   1.774852947908084% used

7067 interned Strings occupying 596016 bytes.
```


- `jmap -histo 12011`，查看堆内存(histogram)中的对象数量及大小（下面 demo 内容太多，所以选取其中一部分）
	- `jmap -histo:live 12011`，查看堆内存(histogram)中的对象数量及大小，但是JVM会先触发gc，然后再统计信息
	- `jmap -dump:format=b,file=/opt/myHeapDumpFileName 12011`，将内存使用的详细情况输出到文件，之后一般使用其他工具进行分析。
	- 生成的文件可以用一些可视化工具（Eclipse Memory Analyzer 、IBM HeapAnalyzer）来查看

```
编号              个数          字节   类名
 508:             6            192  java.lang.invoke.LambdaForm$BasicType
 509:             8            192  java.lang.invoke.MethodHandleImpl$Intrinsic
 510:             8            192  java.math.RoundingMode
 511:             6            192  java.net.NetworkInterface$1checkedAddresses
 512:             6            192  java.rmi.server.UID
 513:             3            192  java.text.DateFormatSymbols
 514:             8            192  java.util.Formatter$FixedString
 515:             6            192  java.util.TreeMap$KeyIterator
 516:             8            192  java.util.regex.Pattern$Slice
 517:             8            192  jdk.net.SocketFlow$Status
 518:             6            192  net.sf.ehcache.DefaultElementEvictionData
 519:             3            192  net.sf.ehcache.store.chm.SelectableConcurrentHashMap
 520:             8            192  org.apache.logging.log4j.Level
 521:             8            192  org.apache.logging.log4j.core.appender.rolling.RolloverFrequency
 522:             4            192  org.apache.logging.log4j.core.impl.ThrowableProxy
 523:             3            192  org.apache.logging.log4j.core.layout.PatternLayout
 524:            12            192  org.apache.logging.log4j.core.util.datetime.FastDateParser$NumberStrategy
 525:             3            192  org.apache.logging.log4j.core.util.datetime.FixedDateFormat
 526:             8            192  org.apache.logging.log4j.spi.StandardLevel
 527:             2            192  sun.nio.ch.ServerSocketChannelImpl
 528:             4            192  sun.nio.cs.StreamEncoder
 529:             6            192  sun.reflect.generics.reflectiveObjects.TypeVariableImpl
 530:            11            176  java.text.NumberFormat$Field
 531:            11            176  java.util.concurrent.ConcurrentSkipListSet
 532:             2            176  javax.management.remote.rmi.NoCallStackClassLoader
 533:            11            176  org.apache.logging.log4j.core.lookup.MapLookup
 534:             8            168  [Ljava.lang.reflect.TypeVariable;
 535:             1            168  [[Ljava.math.BigInteger;
```

## jstack

- jstack命令主要用来查看Java线程的调用堆栈的，可以用来分析线程问题（如死锁）
- jstack用于生成java虚拟机当前时刻的线程快照。
- 线程快照是当前java虚拟机内每一条线程正在执行的方法堆栈的集合，生成线程快照的主要目的是定位线程出现长时间停顿的原因，如线程间死锁、死循环、请求外部资源导致的长时间等待等。 线程出现停顿的时候通过jstack来查看各个线程的调用堆栈，就可以知道没有响应的线程到底在后台做什么事情，或者等待什么资源。 如果java程序崩溃生成core文件，jstack工具可以用来获得core文件的java stack和native stack的信息，从而可以轻松地知道java程序是如何崩溃和在程序何处发生问题。另外，jstack工具还可以附属到正在运行的java程序中，看到当时运行的java程序的java stack和native stack的信息, 如果现在运行的java程序呈现hung的状态，jstack是非常有用的。
- `jstack 12011`，查看线程情况
- `jstack -l 12011`，除堆栈外，显示关于锁的附件信息
- 下面 demo 内容太多，所以选取其中一部分

```
2018-03-08 14:28:13
Full thread dump Java HotSpot(TM) 64-Bit Server VM (25.151-b12 mixed mode):

"Attach Listener" #53 daemon prio=9 os_prio=0 tid=0x00007f8a34009000 nid=0x865 waiting on condition [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"Log4j2-AsyncLoggerConfig-1" #16 daemon prio=5 os_prio=0 tid=0x00007f8a5c48d800 nid=0x2f0c waiting on condition [0x00007f8a4cbfe000]
   java.lang.Thread.State: WAITING (parking)
	at sun.misc.Unsafe.park(Native Method)
	- parking to wait for  <0x00000007155e4850> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
	at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.await(AbstractQueuedSynchronizer.java:2039)
	at com.lmax.disruptor.BlockingWaitStrategy.waitFor(BlockingWaitStrategy.java:45)
	at com.lmax.disruptor.ProcessingSequenceBarrier.waitFor(ProcessingSequenceBarrier.java:56)
	at com.lmax.disruptor.BatchEventProcessor.run(BatchEventProcessor.java:124)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at java.lang.Thread.run(Thread.java:748)

"Wrapper-Control-Event-Monitor" #13 daemon prio=5 os_prio=0 tid=0x00007f8a5c34e000 nid=0x2efc waiting on condition [0x00007f8a60314000]
   java.lang.Thread.State: TIMED_WAITING (sleeping)
	at java.lang.Thread.sleep(Native Method)
	at org.tanukisoftware.wrapper.WrapperManager$3.run(WrapperManager.java:731)

"RMI TCP Accept-0" #11 daemon prio=5 os_prio=0 tid=0x00007f8a5c32f800 nid=0x2efa runnable [0x00007f8a60619000]
   java.lang.Thread.State: RUNNABLE
	at java.net.PlainSocketImpl.socketAccept(Native Method)
	at java.net.AbstractPlainSocketImpl.accept(AbstractPlainSocketImpl.java:409)
	at java.net.ServerSocket.implAccept(ServerSocket.java:545)
	at java.net.ServerSocket.accept(ServerSocket.java:513)
	at sun.management.jmxremote.LocalRMIServerSocketFactory$1.accept(LocalRMIServerSocketFactory.java:52)
	at sun.rmi.transport.tcp.TCPTransport$AcceptLoop.executeAcceptLoop(TCPTransport.java:400)
	at sun.rmi.transport.tcp.TCPTransport$AcceptLoop.run(TCPTransport.java:372)
	at java.lang.Thread.run(Thread.java:748)

"Service Thread" #7 daemon prio=9 os_prio=0 tid=0x00007f8a5c0b4800 nid=0x2ef3 runnable [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"C1 CompilerThread1" #6 daemon prio=9 os_prio=0 tid=0x00007f8a5c0b1800 nid=0x2ef2 waiting on condition [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"C2 CompilerThread0" #5 daemon prio=9 os_prio=0 tid=0x00007f8a5c0af800 nid=0x2ef1 waiting on condition [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"Signal Dispatcher" #4 daemon prio=9 os_prio=0 tid=0x00007f8a5c0aa800 nid=0x2ef0 runnable [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"Finalizer" #3 daemon prio=8 os_prio=0 tid=0x00007f8a5c07b000 nid=0x2eef in Object.wait() [0x00007f8a614f4000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000007155e5ba8> (a java.lang.ref.ReferenceQueue$Lock)
	at java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:143)
	- locked <0x00000007155e5ba8> (a java.lang.ref.ReferenceQueue$Lock)
	at java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:164)
	at java.lang.ref.Finalizer$FinalizerThread.run(Finalizer.java:209)

"VM Thread" os_prio=0 tid=0x00007f8a5c06e800 nid=0x2eed runnable 

"VM Periodic Task Thread" os_prio=0 tid=0x00007f8a5c332000 nid=0x2efb waiting on condition 

JNI global references: 281
```


## 资料

- <https://juejin.im/entry/5a9220f85188257a856f5d6e>
