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



## 资料

- <https://my.oschina.net/moooofly/blog/152547>
- <http://www.techug.com/post/mysql-mysqlslap.html>
- <http://jixiuf.github.io/blog/mysql%E5%8E%8B%E5%8A%9B%E6%B5%8B%E8%AF%95/>
- <http://blog.chinaunix.net/uid-25723371-id-3498970.html>
