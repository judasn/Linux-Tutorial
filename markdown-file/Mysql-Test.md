# MySQL 测试


## mysqlslap 工具

- 工具的官网说明：<https://dev.mysql.com/doc/refman/5.5/en/mysqlslap.html>
- 可能会遇到的报错：
    - 报：`mysqlslap: Error when connecting to server: Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)`
        - 可以这样解决：`ln -s /usr/program/mysql/data/mysql.sock /tmp/mysql.sock`，主要是我的 sock 文件位置是自己的配置的，跟 mysqlslap 默认去读的地方不一样。


### 进行基准测试：

- 先做软链接：`ln -s /usr/program/mysql/bin/mysqlslap /usr/bin`
- 自动生成简单测试数据并测试：`mysqlslap --defaults-file=/etc/my.cnf -a --auto-generate-sql-load-type=mixed --auto-generate-sql-add-autoincrement --engine=innodb --concurrency=50,100 --number-of-queries=1000 --iterations=2 --debug-info -uroot -p123456`
    - 该语句表示测试并发为50和100的情况，进行1000次访问(该值一般这样预估出来：并发客户数×每客户查询次数)。这样的测试方法迭代2次，最终显示最大、最小、平均值
    - 其中：`-a`，表示自动生成要测试的数据，等同于：`--auto-generate-sql`
    - 其中：`--debug-info`，代表要额外输出 CPU 以及内存的相关信息。
- 自动生成复杂测试数据并测试：`mysqlslap --defaults-file=/etc/my.cnf --concurrency=50,100,200 --iterations=2 --number-int-cols=7 --number-char-cols=13 --auto-generate-sql --auto-generate-sql-add-autoincrement --auto-generate-sql-load-type=mixed --engine=innodb --number-of-queries=1000 --debug-info -S /tmp/mysql.sock -uroot -p123456`
    - `-number-int-cols=7` 表示生成的表中必须有 7 个 int 类型的列
    - `-number-char-cols=13` 表示生成的表中必须有 13 个 char 类型的列
- 实际场景请求数较大的时候测试：`mysqlslap --defaults-file=/etc/my.cnf --concurrency=50,100,200,500,1000 --iterations=10 --number-int-cols=7 --number-char-cols=13 --auto-generate-sql --auto-generate-sql-add-autoincrement --auto-generate-sql-load-type=mixed --engine=innodb --number-of-queries=10000 --debug-info -S /tmp/mysql.sock -uroot -p123456`

### 测试结果含义解释：

- Average number of XXXXXXXX：运行所有语句的平均秒数
- Minimum number of XXXXXXXX：运行所有语句的最小秒数
- Maximum number of XXXXXXXX：运行所有语句的最大秒数
- Number of clients XXXXXXXX：客户端数量
- Average number of queries per client XXXXXXXX：每个客户端运行查询的平均数。其中这个数和上面的数相乘就等于number-of-queries


### 对自己的数据库进行测试：

- 数据库：`youmeek_nav`
- 简单测试语句：`mysqlslap --defaults-file=/etc/my.cnf --create-schema=youmeek_nav --query="SELECT * FROM nav_url;" --debug-info -uroot -p123456`
- 复杂测试语句：假设我把有3条sql要测试，我把这三条写入到一个 test.sql 文件中，3条sql用分号隔开，文件内容为：`SELECT * FROM sys_user;SELECT * FROM nav_column;SELECT * FROM nav_url;`
    - 那测试语句可以这样写：`mysqlslap --defaults-file=/etc/my.cnf --create-schema=youmeek_nav --query="/opt/test.sql" --delimiter=";" --debug-info -uroot -p123456`
    - `--delimiter=”;”` 表示文件中不同 sql 的分隔符是什么


### 其他一些参数：

- `mysqlslap --help` 查看所有参数
- `--auto-generate-sql-load-type=XXX`，XXX 代表要测试的是读还是写还是两者混合，该值分别有：read,write,update,mixed，默认是 mixed
- `--auto-generate-sql-add-autoincrement` 代表对生成的表自动添加 auto_increment 列
- `--debug-info` 代表要额外输出 CPU 以及内存的相关信息。
- `--only-print` 打印压力测试的时候 mysqlslap 到底做了什么事，通过 sql 语句方式告诉我们。


## sysbench 工具

- 工具的官网说明：<https://launchpad.net/sysbench>
- 开源地址：<https://github.com/akopytov/sysbench>

### 安装

- 当前（201703）最新版本为：**1.0.3**，下面的操作也都是基于此版本，网络上的资料很多都是 0.4 和 0.5 不支持本文的语法。
- 安装编译相关工具包：`yum -y install automake libtool`
- 下载：<https://github.com/akopytov/sysbench/releases>
- 假设我这边下载下来的文件名为：`sysbench-1.0.3.zip`
- 我的 MySQL 安装路径为：`/usr/program/mysql`
	- include 目录位置：`/usr/program/mysql/include`
	- libs 目录位置：`/usr/program/mysql/lib`
- 设置 MySQL 包路径变量：`export LD_LIBRARY_PATH=/usr/program/mysql/lib/`
- 解压压缩包：`unzip sysbench-1.0.3.zip`
- 开始编译安装：
	- `cd sysbench-1.0.3`
	- `./autogen.sh`
	- `./configure --with-mysql-includes=/usr/program/mysql/include --with-mysql-libs=/usr/program/mysql/lib/`
	- `make`
	- `make install`
	- 测试是否安装成功：`sysbench --version`
- 安装完之后在这个目录下有一些 lua 测试脚本：`cd /usr/local/share/sysbench`，等下测试的时候需要指定这些脚本位置，用这些脚本测试的。
- 默认这些脚本生成的数据都是 10000 个，如果你想要更多，需要修改：`vim /usr/local/share/sysbench/oltp_common.lua` 文件。常修改的参数：
	- `tables`，生成多少张表
	- `table_size`，每张表多少记录数

### 开始测试

- 做不同的类型测试之前，最好都重启下 MySQL
- 创建一个数据库，名字为：`sbtest`
- select 测试：
	- 准备测试数据：`sysbench /usr/local/share/sysbench/oltp_point_select.lua --threads=15 --report-interval=10 --time=120 --mysql-user=root --mysql-password=123456 --mysql-host=127.0.0.1 --mysql-port=3306 prepare`
	- 开始测试：`sysbench /usr/local/share/sysbench/oltp_point_select.lua --threads=15 --report-interval=10 --time=120 --mysql-user=root --mysql-password=123456 --mysql-host=127.0.0.1 --mysql-port=3306 run`
	- 清除测试数据：`sysbench /usr/local/share/sysbench/oltp_point_select.lua --threads=15 --report-interval=10 --time=120 --mysql-user=root --mysql-password=123456 --mysql-host=127.0.0.1 --mysql-port=3306 cleanup`
- 读写测试：
	- 读写测试我开了线程比较多，也修改了 oltp_common.lua 内容，有可能会报：`MySQL error: 1461 "Can't create more than max_prepared_stmt_count statements`，那你需要在 MySQL 中执行这句临时设置 SQL：`SET GLOBAL max_prepared_stmt_count=100000;`
	- 准备测试数据：`sysbench /usr/local/share/sysbench/oltp_read_write.lua --threads=100 --report-interval=10 --time=100 --mysql-user=root --mysql-password=123456 --mysql-host=127.0.0.1 --mysql-port=3306 prepare`
	- 开始测试：`sysbench /usr/local/share/sysbench/oltp_read_write.lua --threads=100 --report-interval=10 --time=100 --mysql-user=root --mysql-password=123456 --mysql-host=127.0.0.1 --mysql-port=3306 run`
	- 清除测试数据：`sysbench /usr/local/share/sysbench/oltp_read_write.lua --threads=100 --report-interval=10 --time=100 --mysql-user=root --mysql-password=123456 --mysql-host=127.0.0.1 --mysql-port=3306 cleanup`

- 参数说明：
	- `--threads=15` 表示发起 15 个并发连接
	- `--report-interval=10` 表示控制台每 10 秒输出一次测试进度报告
	- `--time=120` 总的测试时长为 120 秒
	- `--max-requests=0` 表示总请求数为 0，因为上面已经定义了总执行时长，所以总请求数可以设定为 0；也可以只设定总请求数，不设定执行时长
	- `--percentile=99` 表示设定采样比例，即丢弃1%的长请求，在剩余的99%里取最大值。默认是 95%，


### 测试报告

Running the test with following options:
Number of threads: 15
Report intermediate results every 10 second(s)
Initializing random number generator from current time


Initializing worker threads...

Threads started!

[ 10s ] thds: 15 tps: 337.43 qps: 6773.72 (r/w/o: 4745.03/1351.92/676.76) lat (ms,95%): 73.13 err/s: 0.40 reconn/s: 0.00
[ 20s ] thds: 15 tps: 340.12 qps: 6813.82 (r/w/o: 4772.12/1361.06/680.63) lat (ms,95%): 71.83 err/s: 0.40 reconn/s: 0.00
[ 30s ] thds: 15 tps: 344.78 qps: 6897.36 (r/w/o: 4828.36/1379.23/689.77) lat (ms,95%): 71.83 err/s: 0.20 reconn/s: 0.00
[ 40s ] thds: 15 tps: 343.32 qps: 6876.75 (r/w/o: 4815.15/1374.47/687.14) lat (ms,95%): 71.83 err/s: 0.60 reconn/s: 0.00
[ 50s ] thds: 15 tps: 342.80 qps: 6864.76 (r/w/o: 4806.67/1371.89/686.20) lat (ms,95%): 73.13 err/s: 0.50 reconn/s: 0.00
[ 60s ] thds: 15 tps: 347.90 qps: 6960.74 (r/w/o: 4873.93/1390.71/696.10) lat (ms,95%): 70.55 err/s: 0.30 reconn/s: 0.00
[ 70s ] thds: 15 tps: 346.70 qps: 6942.39 (r/w/o: 4859.29/1389.30/693.80) lat (ms,95%): 70.55 err/s: 0.40 reconn/s: 0.00
[ 80s ] thds: 15 tps: 345.60 qps: 6914.88 (r/w/o: 4841.48/1382.00/691.40) lat (ms,95%): 70.55 err/s: 0.20 reconn/s: 0.00
[ 90s ] thds: 15 tps: 341.10 qps: 6830.31 (r/w/o: 4782.20/1365.40/682.70) lat (ms,95%): 74.46 err/s: 0.50 reconn/s: 0.00
[ 100s ] thds: 15 tps: 341.20 qps: 6829.33 (r/w/o: 4782.12/1364.41/682.80) lat (ms,95%): 74.46 err/s: 0.40 reconn/s: 0.00
[ 110s ] thds: 15 tps: 343.40 qps: 6875.79 (r/w/o: 4812.29/1376.50/687.00) lat (ms,95%): 71.83 err/s: 0.20 reconn/s: 0.00
[ 120s ] thds: 15 tps: 347.00 qps: 6943.51 (r/w/o: 4862.40/1386.70/694.40) lat (ms,95%): 71.83 err/s: 0.40 reconn/s: 0.00
SQL statistics:
    queries performed:
        read:                            577836 --读总数
        write:                           164978 --写总数
        other:                           82503 --其他操作(CURD之外的操作，例如COMMIT)
        total:                           825317 --全部总数
    transactions:                        41229  (343.51 per sec.) --总事务数(每秒事务数，这个每秒事务数也就是：TPS 吞吐量)
    queries:                             825317 (6876.33 per sec.) --查询总数(查询次数)
    ignored errors:                      45     (0.37 per sec.) --总忽略错误总数(每秒忽略错误次数)
    reconnects:                          0      (0.00 per sec.) --重连总数(每秒重连次数)

General statistics:
    total time:                          120.0214s --总耗时
    total number of events:              41229  --共发生多少事务数

Latency (ms):
         min:                                  7.19 --最小耗时
         avg:                                 43.66 --平均耗时
         max:                                162.82 --最长耗时
         95th percentile:                     71.83 --超过95%平均耗时
         sum:                            1799860.45

Threads fairness:
    events (avg/stddev):           2748.6000/132.71 --总处理事件数/标准偏差
    execution time (avg/stddev):   119.9907/0.00 --总执行时间/标准偏差

## QPS 和 TPS 和说明

### 基本概念

- QPS：Queries Per Second意思是“每秒查询率”，是一台服务器每秒能够相应的查询次数，是对一个特定的查询服务器在规定时间内所处理流量多少的衡量标准。
- TPS是TransactionsPerSecond的缩写，也就是事务数/秒。它是软件测试结果的测量单位。一个事务是指一个客户机向服务器发送请求然后服务器做出反应的过程。客户机在发送请求时开始计时，收到服务器响应后结束计时，以此来计算使用的时间和完成的事务个数，最终利用这些信息来估计得分。客户机使用加权协函数平均方法来计算客户机的得分，测试软件就是利用客户机的这些信息使用加权协函数平均方法来计算服务器端的整体TPS得分。
- QPS（TPS）= 并发数/平均响应时间 或者 并发数 = QPS平均响应时间 **这里响应时间的单位是秒*
- 举例，我们一个HTTP请求的响应时间是20ms，在10个并发的情况下，QPS就是 QPS=10*1000/20=500。
- 这里有个关键的点就是QPS一定是跟并发数联系在一起的，离开并发数谈QPS是没意义的。


### QPS、TPS和性能的关系

- 一个系统吞吐量通常由QPS（TPS）、并发数两个因素决定，每套系统这两个值都有一个相对极限值，在应用场景访问压力下，只要某一项达到系统最高值，系统的吞吐量就上不去了，如果压力继续增大，系统的吞吐量反而会下降，原因是系统超负荷工作，上下文切换、内存等等其它消耗导致系统性能下降。
- 开始，系统只有一个用户，CPU工作肯定是不饱合的。一方面该服务器可能有多个cpu，但是只处理单个进程，另一方面，在处理一个进程中，有些阶段可能是IO阶段，这个时候会造成CPU等待，但是有没有其他请 求进程可以被处理）。随着并发用户数的增加，CPU利用率上升，QPS相应也增加（公式为QPS=并发用户数/平均响应时间。）随着并发用户数的增加，平均响应时间也在增加，而且平均响应时间的增加是一个指数增加曲线。而当并发数增加到很大时，每秒钟都会有很多请求需要处理，会造成进程（线程）频繁切换，反正真正用于处理请求的时间变少，每秒能够处 理的请求数反而变少，同时用户的请求等待时间也会变大，甚至超过用户的心理底线。 ）


### 结论

- 我们对单台服务器进行压测有了性能测试数据以后，我们可以根据业务上能接受最大客户响应时间对应到相应的QPS数，从而计算出需要的服务器的数量。举例来说，响应时间10ms和1000ms对通过浏览器的客户是没有明显体验差别的，基于1000ms估算服务器的数量我们的成本会降低很多。
- 每天300wPV的在单台机器上，这台机器需要多少QPS？对于这样的问题，假设每天80%的访问集中在20%的时间里，这20%时间叫做峰值时间。( 3000000 * 0.8 ) / (3600 * 24 * 0.2 ) = 139 (QPS).
- 如果一台机器的QPS是58，需要几台机器来支持？答：139 / 58 = 3



## 资料

- <https://my.oschina.net/moooofly/blog/152547>
- <http://www.techug.com/post/mysql-mysqlslap.html>
- <http://jixiuf.github.io/blog/mysql%E5%8E%8B%E5%8A%9B%E6%B5%8B%E8%AF%95/>
- <http://blog.chinaunix.net/uid-25723371-id-3498970.html>
- <http://nsimple.top/archives/mysql-sysbench-tool.html>
- <https://dearhwj.gitbooks.io/itbook/content/test/performance_test_qps_tps.html>
