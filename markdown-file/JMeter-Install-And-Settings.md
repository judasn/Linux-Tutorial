# JMeter 安装和配置


## JMeter 介绍

- 用 Java 开发，需要 JDK 环境，最新版至少需要 JDK 8
- 官网：<https://jmeter.apache.org/>
- 官网下载：<https://jmeter.apache.org/download_jmeter.cgi>
- 官网插件库：<https://jmeter-plugins.org/wiki/Start/>
- 官网 Github 源码：<https://github.com/apache/jmeter>
- 当前（201804）最新版本为 4.0
- 关于介绍，这位童鞋写得很好，我无法超越，所以借用下：<http://blog.51cto.com/ydhome/1862841>

```
Jmeter 是纯 java 应用，对于 CPU 和内存的消耗比较大，并且受到 JVM 的一些限制； 

一般情况下，依据机器配置，单机的发压量为 300～600，因此，当需要模拟数以千计的并发用户时，使用单台机器模拟所有的并发用户就容易卡死，引起 JAVA 内存溢出错误；(在 1.4GHz～3GHz 的 CPU、1GB 内存的 JMeter 客户端上，可以处理线程 100～300
单台机器模拟的时候，如果并发数量较多且发送的网络包较大时，单机的网络带宽就会成为测试瓶颈，无法真正模拟高并发，导致测试结果失真（例如在要一秒内发送 3000 个请求，合计 512kb，但是测试电脑只有 256 的上传带宽，那么实际测试的时候只是模拟了在一秒内发送 1500 个请求（256kb）的场景，导致测试结果失真。下载带宽的影响也是类似的）；即：如果所有负载由一台机器产生，网卡和交换机端口都可能产生瓶颈，所以一个 JMeter 客户端线程数不应超过 100。
真正的业务场景并发，我觉得应该是用户数大，每个用户的请求数小。如：更可能是 1000 个用户在 2 秒内各发起 2 个请求，而不是 200 个用户在 2 秒内各发起 10 个请求，虽然总的请求数都是 2000 个。

为避免以上问题，更合理地进行性能测试，我们可以使用 Jmeter 提供的分布式测试功能。

注意：

（1）每一台 jmeter 远程服务器（slave 机器）都执行相同的测试计划，jmeter 不会在执行期间做负载均衡，每一台服务器都会完整地运行测试计划；

（2）采用 JMeter 远程模式并不会比独立运行相同数目的非 GUI 测试更耗费资源。但是，如果使用大量的 JMeter 远程服务器，可能会导致客户端过载，或者网络连接发生拥塞；

（3）默认情况下，master 机器是不执行参与生成并发数据的；

（4）调度机 (master) 和执行机 (slave) 最好分开，由于 master 需要发送信息给 slave 并且会接收 slave 回传回来的测试数据，所以 mater 自身会有消耗，所以建议单独用一台机器作为 mater。
```

## JMeter Windows 安装

- 因为是绿色版本，直接解压即可，比如我解压后目录：`D:\software\portable\apache-jmeter-4.0\bin`
- 直接双击运行：`ApacheJMeter.jar`（会根据当前系统是中文自行进行切换语言）
	- 也可以直接双击：`jmeter.bat`（显示的是英文版本）
	- 如果是作为分布式中的客户端，需要执行：`jmeter-server.bat`
- 其他：
	- `jmeter.log` 是 JMeter 的 log
	- `jmeter.properties` 是 JMeter 软件配置

## JMeter Linux 安装

## JMeter 基础知识

### 线程组

- Ramp-up Period（in seconds）
- 决定多长时间启动所有线程。如果使用 10 个线程，ramp-up period 是 100 秒，那么 JMeter 用 100 秒使所有 10 个线程启动并运行。每个线程会在上一个线程启动后 10 秒（100/10）启动。Ramp-up 需要要充足长以避免在启动测试时有一个太大的工作负载，并且要充足小以至于最后一个线程在第一个完成前启动。一般设置 ramp-up 等于线程数，有需求再根据该值进行调整。


### 定时器

- 默认情况下，Jmeter 线程在发送请求之间没有间歇。建议为线程组添加某种定时器，以便设定请求之间应该隔多长时间。如果测试人员不设定这种延迟，Jmeter 可能会在短时间内产生大量访问请求，导致服务器被大量请求所淹没。
- 定时器会让作用域内的每一个采样器都在执行前等待一个固定时长。如果测试人员为线程组添加了多个定时器，那么 Jmeter 会将这些定时器的时长叠加起来，共同影响作用域范围内的采样器。定时器可以作为采样器或者逻辑控制器的子项，目的是只影响作用域内的采样器。

#### synchronized timer（时间集合点，主要用于模拟高并发测试）

- 该定时器主要是为了阻塞线程，直到指定的线程数量到达后，再一起释放，可以瞬间产生很大的压力。
- 假设这样的配置：
	- Number of Simulated Users to Group By = 10
	- Timeout in milliseconds = 0
- 该配置表示当用户（线程）数达到 10 的时候才开始测试。
- 下面那个参数 0，表示达到 10 个用户就开始访问。如果填写 1000，则表示达到 10 用户后，延迟 1000 毫秒才开始访问。

#### Constant Throughput Timer（常数吞吐量定时器，主要用于预设好 QPS 场景下测试）

- constant throughput timer 常数吞吐量定时器可以让 jmeter 以指定数字的吞吐量（即指定 tps，只是这里要求指定每分钟的执行数，而不是每秒）执行。吞吐量计算的范围可以为指定为当前线程、当前线程组、所有线程组，并且计算吞吐量的依据可以是最近一次线程的执行时延。

## JMeter 资料

- 国内视频教程：
	- [JMeter 性能测试入门篇 - 慕课网](https://www.imooc.com/learn/735)
	- [JMeter 之 HTTP 协议接口性能测试 - 慕课网](https://www.imooc.com/learn/791)
	- [JMeter 性能测试进阶案例实战 - 慕课网](https://coding.imooc.com/class/142.html)
	- [性能测试工具—Jmeter- 我要自学网](http://www.51zxw.net/list.aspx?page=2&cid=520)
	- [jmeter 视频教学课程 - 小强](https://www.youtube.com/watch?v=zIiXpCBaBgQ&list=PL3rfV4zNE8CD-rAwlXlGXilN5QpkqDWox)
- 国外视频教程：
	- [JMeter Beginner](https://www.youtube.com/playlist?list=PLhW3qG5bs-L-zox1h3eIL7CZh5zJmci4c)
	- [JMeter Advanced](https://www.youtube.com/playlist?list=PLhW3qG5bs-L_Eosy1Nj1tKHC5jcBAVkPb)
	- []()
	- []()



## 资料

- <http://blog.51cto.com/ydhome/1862841>
- <http://blog.51cto.com/ydhome/1869970>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
