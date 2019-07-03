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

-------------------------------------------------------------------


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

-------------------------------------------------------------------

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

-------------------------------------------------------------------

## Percona TPCC-MySQL 测试工具（优先推荐）

- 可以较好地模拟真实测试结果数据
- 官网主页：<https://github.com/Percona-Lab/tpcc-mysql>

```
TPC-C 是专门针对联机交易处理系统（OLTP系统）的规范，一般情况下我们也把这类系统称为业务处理系统。
TPC-C是TPC(Transaction Processing Performance Council)组织发布的一个测试规范，用于模拟测试复杂的在线事务处理系统。其测试结果包括每分钟事务数(tpmC)，以及每事务的成本(Price/tpmC)。
在进行大压力下MySQL的一些行为时经常使用。
```

### 安装

- 先确定本机安装过 MySQL
- 并且安装过：`yum install mysql-devel`

```
git clone https://github.com/Percona-Lab/tpcc-mysql
cd tpcc-mysql/src
make

如果make没报错，就会在tpcc-mysql 根目录文件夹下生成tpcc二进制命令行工具tpcc_load、tpcc_start

如果要同时支持 PgSQL 可以考虑：https://github.com/Percona-Lab/sysbench-tpcc
```

### 测试的几个表介绍

```
tpcc-mysql的业务逻辑及其相关的几个表作用如下：
New-Order：新订单，主要对应 new_orders 表
Payment：支付，主要对应 orders、history 表
Order-Status：订单状态，主要对应 orders、order_line 表
Delivery：发货，主要对应 order_line 表
Stock-Level：库存，主要对应 stock 表

其他相关表：
客户：主要对应customer表
地区：主要对应district表
商品：主要对应item表
仓库：主要对应warehouse表
```

### 准备

- 测试阿里云 ECS 与 RDS 是否相通：
- 记得在 RDS 添加账号和给账号配置权限，包括：配置权限、数据权限（默认添加账号后都是没有开启的，还要自己手动开启）
- 还要添加内网 ECS 到 RDS 的白名单 IP 里面
- 或者在 RDS 上开启外网访问设置，但是也设置 IP 白名单（访问 ip.cn 查看自己的外网 IP 地址，比如：120.85.112.97）
- RDS 的内网地址和外网地址不一样，要认真看。

```
ping rm-wz9v0vej02ys79jbj.mysql.rds.aliyuncs.com

mysql -h rm-wz9v0vej02ys79jbj.mysql.rds.aliyuncs.com -P 3306 -u myaccount -p

输入密码：Aa123456
```



```
创库，名字为：TPCC：
CREATE DATABASE TPCC DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;


导入项目中的出初始化数据脚本：
创建表：create_table.sql
/usr/bin/mysql -h rm-wz9v0vej02ys79jbj.mysql.rds.aliyuncs.com -u myaccount -p tpcc < /root/tpcc-mysql/create_table.sql

创建索引和外键：add_fkey_idx.sql
/usr/bin/mysql -h rm-wz9v0vej02ys79jbj.mysql.rds.aliyuncs.com -u myaccount -p tpcc < /root/tpcc-mysql/add_fkey_idx.sql
```


### 测试

- 数据库：阿里云 RDS-MySQL-5.7-2C4G
- 测试机：阿里云 ECS-4C4G-CentOS7.6
- 根据测试，不同的 ECS 测试机，不同的 RDS 测试结果有时候差距挺大的，这个很蛋疼。

- 需要注意的是 tpcc 默认会读取 /var/lib/mysql/mysql.sock 这个 socket 文件。因此，如果你的socket文件不在相应路径的话，可以做个软连接，或者通过TCP/IP的方式连接测试服务器
- 准备数据：

```
cd /opt/tpcc-mysql
./tpcc_load -h rm-wz9v0vej02ys79jbj.mysql.rds.aliyuncs.com -P 3306 -d TPCC -u myaccount -p Aa123456 -w 80
-w 80 表示创建 80 个仓库数据
这个过程花费时间还是挺长的，建议测试机是高性能计算型。2CPU 差不多要 8h，你自己估量下。
我这边 RDS 监控中，曲线上每秒 insert 差不多在 2W 差不多，如果你没有这个数，速度可能就很慢了。
我这边差不多用了 2.5h 完成数据准备。


插入过程 RDS-2C4G 的监控情况：
CPU利用率 24%
内存 30% ~ 40% （随着数据增加而增大）
连接数：1%
IOPS：9%
已使用存储空间：5.5G ~ 10G

要模拟出够真实的数据，仓库不要太少，一般要大于 100，
下面是基于 80 个库的最终数据：

select count(*) from customer;
    2400000
select count(*) from district;
    800    
select count(*) from history;
    2400000
select count(*) from item;
    100000
select count(*) from new_orders;
    720000
select count(*) from order_line;
    23996450
select count(*) from orders;
    2400000
select count(*) from stock;
    8000000
select count(*) from warehouse;
    80
```

- 开始测试：

```

./tpcc_start -h rm-wz9v0vej02ys79jbj.mysql.rds.aliyuncs.com -P 3306 -d TPCC -u myaccount -p Aa123456 -w 80 -c 200 -r 300 -l 1800 -f /opt/mysql_tpcc_100_20190325

-w 100 表示 100 个仓库数据
-c 200 表示并发 200 个线程
-r 300 表示预热 300 秒
-l 1800 表示持续压测 1800 秒
```


### 报表


```
<TpmC>
188.000 TpmC
TpmC结果值(每分钟事务数，该值是第一次统计结果中的新订单事务数除以总耗时分钟数，例如本例中是：372/2=186)
tpmC值在国内外被广泛用于衡量计算机系统的事务处理能力
```

- RDS-2C4G-80个仓库结果：
- CPU：100%，内存：34%，连接数：17%，IOPS：62%，磁盘空间：20G


```
1780, trx: 979, 95%: 1849.535, 99%: 2402.613, max_rt: 3401.947, 986|3248.772, 98|698.821, 103|4202.110, 101|4547.416
1790, trx: 1021, 95%: 1898.903, 99%: 2700.936, max_rt: 3848.142, 999|3150.117, 100|500.740, 102|3600.104, 100|5551.834
1800, trx: 989, 95%: 1899.472, 99%: 2847.899, max_rt: 4455.064, 989|3049.921, 101|699.144, 97|3599.021, 102|5151.141

STOPPING THREADS........................................................................................................................................................................................................

<Raw Results>
  [0] sc:2 lt:174378  rt:0  fl:0 avg_rt: 1192.8 (5)
  [1] sc:253 lt:173935  rt:0  fl:0 avg_rt: 542.7 (5)
  [2] sc:4726 lt:12712  rt:0  fl:0 avg_rt: 144.7 (5)
  [3] sc:0 lt:17435  rt:0  fl:0 avg_rt: 3029.8 (80)
  [4] sc:0 lt:17435  rt:0  fl:0 avg_rt: 3550.7 (20)
 in 1800 sec.

<Raw Results2(sum ver.)>
  [0] sc:2  lt:174378  rt:0  fl:0
  [1] sc:254  lt:174096  rt:0  fl:0
  [2] sc:4726  lt:12712  rt:0  fl:0
  [3] sc:0  lt:17437  rt:0  fl:0
  [4] sc:0  lt:17435  rt:0  fl:0

<Constraint Check> (all must be [OK])
 [transaction percentage]
        Payment: 43.45% (>=43.0%) [OK]
   Order-Status: 4.35% (>= 4.0%) [OK]
       Delivery: 4.35% (>= 4.0%) [OK]
    Stock-Level: 4.35% (>= 4.0%) [OK]
 [response time (at least 90% passed)]
      New-Order: 0.00%  [NG] *
        Payment: 0.15%  [NG] *
   Order-Status: 27.10%  [NG] *
       Delivery: 0.00%  [NG] *
    Stock-Level: 0.00%  [NG] *

<TpmC>
                 5812.667 TpmC
```

- 升级：RDS-4C8G-80个仓库结果
- CPU：100%，内存：55%，连接数：10%，IOPS：20%，磁盘空间：25G

```
1780, trx: 2303, 95%: 796.121, 99%: 1099.640, max_rt: 1596.883, 2293|2249.288, 232|256.393, 230|1694.050, 235|2550.775
1790, trx: 2336, 95%: 798.030, 99%: 1093.403, max_rt: 1547.840, 2338|2803.739, 234|305.185, 232|1799.869, 228|2453.748
1800, trx: 2305, 95%: 801.381, 99%: 1048.528, max_rt: 1297.465, 2306|1798.565, 229|304.329, 227|1649.609, 233|2549.599

STOPPING THREADS........................................................................................................................................................................................................

<Raw Results>
  [0] sc:7 lt:406567  rt:0  fl:0 avg_rt: 493.7 (5)
  [1] sc:10485 lt:395860  rt:0  fl:0 avg_rt: 240.1 (5)
  [2] sc:24615 lt:16045  rt:0  fl:0 avg_rt: 49.4 (5)
  [3] sc:0 lt:40651  rt:0  fl:0 avg_rt: 1273.6 (80)
  [4] sc:0 lt:40656  rt:0  fl:0 avg_rt: 1665.3 (20)
 in 1800 sec.

<Raw Results2(sum ver.)>
  [0] sc:7  lt:406569  rt:0  fl:0
  [1] sc:10487  lt:396098  rt:0  fl:0
  [2] sc:24615  lt:16045  rt:0  fl:0
  [3] sc:0  lt:40655  rt:0  fl:0
  [4] sc:0  lt:40659  rt:0  fl:0

<Constraint Check> (all must be [OK])
 [transaction percentage]
        Payment: 43.46% (>=43.0%) [OK]
   Order-Status: 4.35% (>= 4.0%) [OK]
       Delivery: 4.35% (>= 4.0%) [OK]
    Stock-Level: 4.35% (>= 4.0%) [OK]
 [response time (at least 90% passed)]
      New-Order: 0.00%  [NG] *
        Payment: 2.58%  [NG] *
   Order-Status: 60.54%  [NG] *
       Delivery: 0.00%  [NG] *
    Stock-Level: 0.00%  [NG] *

<TpmC>
                 13552.467 TpmC
```


- 升级：RDS-8C16G-80个仓库结果
- CPU：100%，内存：35%，连接数：5%，IOPS：18%，磁盘空间：30G

```
1780, trx: 4502, 95%: 398.131, 99%: 501.634, max_rt: 772.128, 4473|740.073, 446|183.361, 448|1042.264, 442|1302.569
1790, trx: 4465, 95%: 398.489, 99%: 541.424, max_rt: 803.659, 4476|845.313, 448|152.917, 450|997.319, 454|1250.160
1800, trx: 4506, 95%: 397.774, 99%: 501.334, max_rt: 747.074, 4508|701.625, 453|108.619, 450|1052.293, 451|1107.277

STOPPING THREADS........................................................................................................................................................................................................

<Raw Results>
  [0] sc:20 lt:803738  rt:0  fl:0 avg_rt: 240.5 (5)
  [1] sc:13844 lt:789535  rt:0  fl:0 avg_rt: 128.5 (5)
  [2] sc:54560 lt:25817  rt:0  fl:0 avg_rt: 22.1 (5)
  [3] sc:0 lt:80372  rt:0  fl:0 avg_rt: 739.8 (80)
  [4] sc:0 lt:80378  rt:0  fl:0 avg_rt: 771.1 (20)
 in 1800 sec.

<Raw Results2(sum ver.)>
  [0] sc:20  lt:803747  rt:0  fl:0
  [1] sc:13845  lt:789916  rt:0  fl:0
  [2] sc:54561  lt:25817  rt:0  fl:0
  [3] sc:0  lt:80377  rt:0  fl:0
  [4] sc:0  lt:80381  rt:0  fl:0

<Constraint Check> (all must be [OK])
 [transaction percentage]
        Payment: 43.47% (>=43.0%) [OK]
   Order-Status: 4.35% (>= 4.0%) [OK]
       Delivery: 4.35% (>= 4.0%) [OK]
    Stock-Level: 4.35% (>= 4.0%) [OK]
 [response time (at least 90% passed)]
      New-Order: 0.00%  [NG] *
        Payment: 1.72%  [NG] *
   Order-Status: 67.88%  [NG] *
       Delivery: 0.00%  [NG] *
    Stock-Level: 0.00%  [NG] *

<TpmC>
                 26791.934 TpmC
```


- 升级：RDS-16C64G-80个仓库结果
- CPU：100%，内存：18%，连接数：2%，IOPS：10%，磁盘空间：40G

```
1780, trx: 8413, 95%: 203.560, 99%: 279.322, max_rt: 451.010, 8414|441.849, 841|92.900, 839|583.340, 843|644.276
1790, trx: 8269, 95%: 204.599, 99%: 282.602, max_rt: 444.075, 8262|412.414, 827|91.551, 831|665.421, 824|616.396
1800, trx: 8395, 95%: 202.285, 99%: 255.026, max_rt: 436.136, 8404|446.292, 839|87.081, 839|609.221, 842|697.509

STOPPING THREADS........................................................................................................................................................................................................

<Raw Results>
  [0] sc:37 lt:1532893  rt:0  fl:0 avg_rt: 124.8 (5)
  [1] sc:36091 lt:1496111  rt:0  fl:0 avg_rt: 68.5 (5)
  [2] sc:105738 lt:47555  rt:0  fl:0 avg_rt: 11.4 (5)
  [3] sc:0 lt:153285  rt:0  fl:0 avg_rt: 404.6 (80)
  [4] sc:0 lt:153293  rt:0  fl:0 avg_rt: 389.5 (20)
 in 1800 sec.

<Raw Results2(sum ver.)>
  [0] sc:37  lt:1532918  rt:0  fl:0
  [1] sc:36093  lt:1496868  rt:0  fl:0
  [2] sc:105739  lt:47556  rt:0  fl:0
  [3] sc:0  lt:153297  rt:0  fl:0
  [4] sc:0  lt:153298  rt:0  fl:0

<Constraint Check> (all must be [OK])
 [transaction percentage]
        Payment: 43.47% (>=43.0%) [OK]
   Order-Status: 4.35% (>= 4.0%) [OK]
       Delivery: 4.35% (>= 4.0%) [OK]
    Stock-Level: 4.35% (>= 4.0%) [OK]
 [response time (at least 90% passed)]
      New-Order: 0.00%  [NG] *
        Payment: 2.36%  [NG] *
   Order-Status: 68.98%  [NG] *
       Delivery: 0.00%  [NG] *
    Stock-Level: 0.00%  [NG] *

<TpmC>
                 51097.668 TpmC
```


- 几轮下来，最终数据量：

```
select count(*) from customer;
    2400000
select count(*) from district;
    800    
select count(*) from history;
    5779395
select count(*) from item;
    100000
select count(*) from new_orders;
    764970
select count(*) from order_line;
    57453708
select count(*) from orders;
    5745589
select count(*) from stock;
    8000000
select count(*) from warehouse;
    80
```


## 资料

- <https://my.oschina.net/moooofly/blog/152547>
- <http://www.techug.com/post/mysql-mysqlslap.html>
- <http://jixiuf.github.io/blog/mysql%E5%8E%8B%E5%8A%9B%E6%B5%8B%E8%AF%95/>
- <http://blog.chinaunix.net/uid-25723371-id-3498970.html>
- <http://nsimple.top/archives/mysql-sysbench-tool.html>
- <https://dearhwj.gitbooks.io/itbook/content/test/performance_test_qps_tps.html>
- <https://www.hi-linux.com/posts/38534.html>