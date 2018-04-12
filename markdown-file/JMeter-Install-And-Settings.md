# JMeter 安装和配置


## JMeter 介绍

- JMeter 用 Java 开发，需要 JDK 环境，当前最新版至少需要 JDK 8
- 官网：<https://jmeter.apache.org/>
- 官网下载：<https://jmeter.apache.org/download_jmeter.cgi>
- 官网插件库：<https://jmeter-plugins.org/wiki/Start/>
- 官网 Github 源码：<https://github.com/apache/jmeter>
- 当前（201804）最新版本为 4.0

## JMeter Windows 安装

- 因为是绿色版本，直接解压即可，比如我解压后目录：`D:\software\portable\apache-jmeter-4.0\bin`
- 直接双击运行：`ApacheJMeter.jar`（会根据当前系统是中文自行进行切换语言）
	- 也可以直接双击：`jmeter.bat`（显示的是英文版本）
	- 如果是作为分布式中的客户端，需要执行：`jmeter-server.bat`
- 其他：
	- `jmeter.log` 是 JMeter 的 log
	- `jmeter.properties` 是 JMeter 软件配置

## JMeter Linux 安装

- 解压 zip 包，假设我放在 
- 增加环境变量：`vim ~/.zshrc`（我用的是 zsh）

```
# JMeter
JMETER_HOME=/usr/local/apache-jmeter-4.0
PATH=$PATH:$JMETER_HOME/bin
export JMETER_HOME
export PATH 
```

- 刷新配置：`source ~/.zshrc`
- 测试：`jmeter -v`，输出结果：

```
Apr 12, 2018 10:14:24 AM java.util.prefs.FileSystemPreferences$1 run
INFO: Created user preferences directory.
    _    ____   _    ____ _   _ _____       _ __  __ _____ _____ _____ ____     
   / \  |  _ \ / \  / ___| | | | ____|     | |  \/  | ____|_   _| ____|  _ \   
  / _ \ | |_) / _ \| |   | |_| |  _|    _  | | |\/| |  _|   | | |  _| | |_) | 
 / ___ \|  __/ ___ \ |___|  _  | |___  | |_| | |  | | |___  | | | |___|  _ <  
/_/   \_\_| /_/   \_\____|_| |_|_____|  \___/|_|  |_|_____| |_| |_____|_| \_\ 4.0 r1823414  

Copyright (c) 1999-2018 The Apache Software Foundation
```

## JMeter Linux 测试

- Windows 是 GUI 操作，测试方便，Linux 只能用命令，所以这里进行记录
- 准备好 jmx 测试脚本文件（可以在 Windows 上使用后，保存的脚本就是 jmx 后缀文件）
- 测试：`jmeter -n -t /opt/myTest.jmx -l /opt/myReport.jtl`
	- 参数 n 表示以 nogui 方式运行测试计划
	- 参数 t 表示指定测试计划
	- 参数 l 表示生成测试报告
- 显示 ... end of run 即脚本运行结束
- 如果要后台运行 JMeter 可以：`setsid jmeter -n -t /opt/myTest.jmx -l /opt/myReport.jtl`
- 将上一步运行结束后生成的.jtl 文件拷贝到 win 上，打开 win 上的 Jmeter，随便新建一个项目，也可以用之前的项目，添加监听器，在监听器界面点击浏览，选择该.jtl 文件，就可以查看结果了


## JMeter 分布式安装

- 分布式环境：分为 server、client
	- server 等同于 controller、master（server 其实也可以作为 Client 使用，但是不推荐这样做）
	- client 等同于 agent、slave
- **注意事项**
	- 1、保持 controller 和 agent 机器的 JDK、jmeter 以及插件等配置版本一致；
	- 2、如果测试数据有用到 CSV 或者其他方式进行参数化，需要将 data pools 在每台 Agent 上复制一份，且读取路径必须保持一致；
	- 3、确保 controller 和 agent 机器在同一个子网里面；
	- 4、检查防火墙是否被关闭，端口是否被占用（防火墙会影响脚本执行和测试结构收集，端口占用会导致 Agent 机报错）；
	- 5、分布式测试中，通过远程启动代理服务器，默认查看结果树中的响应数据为空，只有错误信息会被报回；
	- 6、如果并发较高，建议将 controller 机设置为只启动测试脚本和收集汇总测试结果，在配置文件里去掉 controller 机的 IP；
	- 7、分布式测试中，如果 1S 启动 100 个模拟请求，有 5 个 Agent 机，那么需要将脚本的线程数设置为 20，否则模拟请求数会变成 500，和预期结果相差太大。
- 分布式测试流程：
	- 运行所有 agent 机器上的 jmeter-server.bat 文件
	- 假定我们使用两台机器 192.168.0.1 和 192.168.0.2 作为 agent
	- 修改 controller 机器的 JMeter /bin/jmeter.properties 文件

```
默认值是：
remote_hosts=127.0.0.1

修改为：
remote_hosts=192.168.0.1:1099,192.168.0.2:1099

其中默认 RMI 端口是 1099，如果被占用，可以看 http://jmeter.apache.org/usermanual/remote-test.html 进行修改
```

- 启动 Controller 机器上的 JMeter.bat，进入 Run -> Remote Start


## JMeter 基础知识

### 线程组

- Ramp-up Period（in seconds）
	- 决定多长时间启动所有线程。如果使用 10 个线程，ramp-up period 是 100 秒，那么 JMeter 用 100 秒使所有 10 个线程启动并运行。每个线程会在上一个线程启动后 10 秒（100/10）启动。Ramp-up 需要要充足长以避免在启动测试时有一个太大的工作负载，并且要充足小以至于最后一个线程在第一个完成前启动。一般设置 ramp-up 等于线程数，有需求再根据该值进行调整。
	- 一般不要设置为 0，不然 JMeter 一启动就会发送大量请求，服务器可能瞬间过载，测试不出平时那种因为平均访问带来的高负载情况。
	- 估值方法：假设线程数为 100， 估计的点击率为每秒 10 次， 那么估计的理想 ramp-up period 就是 100/10 = 10 秒。每秒点击率需要自己获取系统数据，或是自己估值。


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


### 聚合报告

- `Label`：每个 JMeter 的 element（例如 HTTP Request）都有一个 Name 属性，这里显示的就是 Name 属性的值
- `Samples`：表示你这次测试中一共发出了多少个请求，如果模拟 10 个用户，每个用户迭代 10 次，那么这里显示 100
- `Average`：平均响应时间——默认情况下是单个 Request 的平均响应时间，当使用了 Transaction Controller 时，也可以以 Transaction 为单位显示平均响应时间（单位是毫秒）
- `Median`：中位数，也就是 50％ 用户的响应时间（单位是毫秒）
- `90% Line`：90％ 用户的响应时间
- `Note`：关于 50％ 和 90％ 并发用户数的含义，请参考下文
- `http://www.cnblogs.com/jackei/archive/2006/11/11/557972.html
- `Min`：最小响应时间
- `Max`：最大响应时间
- `Error%`：本次测试中出现错误的请求的数量 / 请求的总数（怎么测试出整个系统的压力了? 如果 Error% 里面开始出现大量的错误，那就说明系统开始有瓶颈了，基本这时候就是最大压力节点，也就可以得到系统最大并发数是多少了。一般错误率不高于 1%，优秀的情况是不高于 0.01%）（若出现错误就要看服务端的日志，查找定位原因）
- `Throughput`：吞吐量——默认情况下表示每秒完成的请求数（Request per Second），当使用了 Transaction Controller 时，也可以表示类似 LoadRunner 的 Transaction per Second 数
- `KB/Sec`：每秒从服务器端接收到的数据量，相当于 LoadRunner 中的 Throughput/Sec，主要看网络传输能力


## 常见问题

- 个人经验：
	- 对开发机中的项目测试：一般 100 线程，循环 10 次即可。
	- 对服务器上的小项目测试：一般 300 线程，循环 10 次即可。
	- 对服务器上的中大型项目测试：采用分布式测试，分别测试：300 ~ 5000 线程情况。
		- 假设好一点的机子设置 500 线程，一般的机子设置 300 线程。预计总 5000 线程需要 5 台好机子， 9 台一般机子。  
		- 也可以通过修改 JVM 方式来调整每台机子性能上限，修改 /bin/jmeter 的合适值
```
: "${HEAP:="-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m"}"
```

- JMeter 即使加了 cookie manage 也没有保存 session 的，一个原因是：HTTP 请求默认值，中服务器 IP，只能填 IP 或是域名，一定不要在这里面在加上某个后缀地址，这样没办法保存的 session 的
- 测试多用户的同时测试的效果，一种是用 jmeter 的 csv 功能，一种是复制几个脚本，每个脚本里面的登录信息不一样。或者是创建两个不同的线程组，每个线程组的登录信息不一样，然后每个线程组都有自己的 HTTP Cookie 管理器
- 在压力测试过程中，要监控服务器情况，可以使用 [nmon 系统性能监控工具的使用](Nmon.md)

## JMeter 资料

- 图文：
	- [官网 User's Manual](http://jmeter.apache.org/usermanual/)
	- [快速学习Jmeter性能测试工具](http://gitbook.cn/books/58de71a8be13fa66243873ef/index.html)
	- [jmeter：菜鸟入门到进阶系列](http://www.cnblogs.com/imyalost/p/7062784.html)
- 国内视频教程：
	- [JMeter 性能测试入门篇 - 慕课网](https://www.imooc.com/learn/735)
	- [JMeter 之 HTTP 协议接口性能测试 - 慕课网](https://www.imooc.com/learn/791)
	- [JMeter 性能测试进阶案例实战 - 慕课网](https://coding.imooc.com/class/142.html)
	- [性能测试工具—Jmeter- 我要自学网](http://www.51zxw.net/list.aspx?page=2&cid=520)
	- [jmeter 视频教学课程 - 小强](https://www.youtube.com/watch?v=zIiXpCBaBgQ&list=PL3rfV4zNE8CD-rAwlXlGXilN5QpkqDWox)
- 国外视频教程：
	- [JMeter Beginner](https://www.youtube.com/playlist?list=PLhW3qG5bs-L-zox1h3eIL7CZh5zJmci4c)
	- [JMeter Advanced](https://www.youtube.com/playlist?list=PLhW3qG5bs-L_Eosy1Nj1tKHC5jcBAVkPb)


## 资料

- <http://gitbook.cn/books/58de71a8be13fa66243873ef/index.html>
- <http://blog.51cto.com/ydhome/1862841>
- <http://blog.51cto.com/ydhome/1869970>
- <http://www.zhihu.com/question/22224874/answer/93890576>
- <https://blog.csdn.net/musen518/article/details/50502302>
- <http://www.ltesting.net/html/77/n-159277.html>
- <https://blog.csdn.net/github_27109687/article/details/71968662>
- <http://jmeter.apache.org/usermanual/remote-test.html>
- <https://blog.csdn.net/qq_34021712/article/details/78682397>
- <http://www.cnblogs.com/imyalost/p/8306866.html>

