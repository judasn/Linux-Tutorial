# MySQL 测试


## mysqlslap 工具

- 工具的官网说明：<https://dev.mysql.com/doc/refman/5.5/en/mysqlslap.html>
- 对自动生成的数据进行基准测试，生成的数据库名：`mysqlslap`
    - 自动生成简单测试数据：`mysqlslap –uroot –p123456 –auto-generate-sql --auto-generate-sql-load-type=mixed --auto-generate-sql-add-autoincrement --engine=innodb --debug-info`
        - 其中：`–auto-generate-sql` 也简称：`-a`，所有看到有人这样写的时候要记得理解。
    - 自动生成复杂测试数据：`mysqlslap –uroot –p123456 –number-int-cols=7 –number-char-cols=13 –auto-generate-sql --auto-generate-sql-load-type=mixed --auto-generate-sql-add-autoincrement --engine=innodb --debug-info`
        - `–number-int-cols=7` 表示生成的表中必须有 7 个 int 类型的列
        - `–number-char-cols=13` 表示生成的表中必须有 13 个 char 类型的列
    - 对上面生成的数据开始测试：`mysqlslap -uroot -p123456 --concurrency=50,100 --number-of-queries 1000 --iterations=5 --debug-info`
        - 分别测试并发为50和100的情况，进行1000次访问(该值一般这样得出来：并发客户数×每客户查询次数)。这样的测试方法迭代5次，最终显示最大、最小、平均值
    - 测试结果含义解释：
        - Average number of XXXXXXXX：运行所有语句的平均秒数
        - Minimum number of XXXXXXXX：运行所有语句的最小秒数
        - Maximum number of XXXXXXXX：运行所有语句的最大秒数
        - Number of clients XXXXXXXX：客户端数量
        - Average number of queries per client XXXXXXXX：每个客户端运行查询的平均数
- 对自己的数据库进行测试：
    - 数据库：`youmeek_nav`
    - 简单测试语句：`mysqlslap –uroot –p123456 -create-schema=youmeek_nav –query=”SELECT * FROM nav_url;” --debug-info`
    - 复杂测试语句：假设我把有3条sql要测试，我把这三条写入到一个 test.sql 文件中，3条sql用分号隔开，文件内容为：`SELECT * FROM sys_user;SELECT * FROM nav_column;SELECT * FROM nav_url; --debug-info`
        - 那测试语句可以这样写：`mysqlslap –uroot –p123456 -create-schema=youmeek_nav –query=”/opt/test.sql” –delimiter=”;” --debug-info`
        - `–delimiter=”;”` 表示文件中不同 sql 的分隔符是什么
- 其他一些参数：
    - `--auto-generate-sql-load-type=XXX`，XXX 代表要测试的是读还是写还是两者混合，该值分别有：read,write,update,mixed，默认是 mixed
    - `--auto-generate-sql-add-autoincrement` 代表对生成的表自动添加 auto_increment 列
    - `--debug-info` 代表要额外输出 CPU 以及内存的相关信息。
    - `--only-print` 只打印测试语句而不连接数据库
## 资料

- <http://www.techug.com/post/mysql-mysqlslap.html>
- <http://jixiuf.github.io/blog/mysql%E5%8E%8B%E5%8A%9B%E6%B5%8B%E8%AF%95/>
- <http://blog.chinaunix.net/uid-25723371-id-3498970.html>
- <>