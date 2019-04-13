# MySQL 优化


- 下面说的优化基于 MySQL 5.6，理论上 5.5 之后的都算适用，具体还是要看官网

## 优秀材料

- <https://notes.diguage.com/mysql/>
- <https://mp.weixin.qq.com/s/Wc6Gw6S5xMy2DhTCrogxVQ>
- <>
- <>
- <>


## 服务状态查询

- 查看当前数据库的状态，常用的有：
	- 查看系统状态：`SHOW STATUS;`
	- 查看刚刚执行 SQL 是否有警告信息：`SHOW WARNINGS;`
	- 查看刚刚执行 SQL 是否有错误信息：`SHOW ERRORS;`
	- 查看已经连接的所有线程状况：`SHOW FULL PROCESSLIST;`
	    - 输出参数说明：<http://www.ibloger.net/article/2519.html>
	    - 可以结束某些连接：`kill id值`
	- 查看当前连接数量：`SHOW STATUS LIKE 'max_used_connections';`
	- 查看变量，在 my.cnf 中配置的变量会在这里显示：`SHOW VARIABLES;`
	- 查询慢 SQL 配置：`show variables like 'slow%';`
	    - 开启慢 SQL：`set global slow_query_log='ON'`
    - 查询慢 SQL 秒数值：` show variables like 'long%';`
        - 调整秒速值：`set long_query_time=1;`
	- 查看当前MySQL 中已经记录了多少条慢查询，前提是配置文件中开启慢查询记录了.
		- `SHOW STATUS LIKE '%slow_queries%';`
	- 查询当前MySQL中查询、更新、删除执行多少条了，可以通过这个来判断系统是侧重于读还是侧重于写，如果是写要考虑使用读写分离。
		- `SHOW STATUS LIKE '%Com_select%';`
		- `SHOW STATUS LIKE '%Com_insert%';`
		- `SHOW STATUS LIKE '%Com_update%';`
		- `SHOW STATUS LIKE '%Com_delete%';`
	- 如果 rollback 过多，说明程序肯定哪里存在问题
		- `SHOW STATUS LIKE '%Com_rollback%';`
	- 显示MySQL服务启动运行了多少时间，如果MySQL服务重启，该时间重新计算，单位秒
		- `SHOW STATUS LIKE 'uptime';`
	- 显示查询缓存的状态情况
		- `SHOW STATUS LIKE 'qcache%';`
		- PS.下面的解释，我目前不肯定是对，还要再找下资料：
			- <http://dba.stackexchange.com/questions/33811/qcache-free-memory-not-full-yet-i-get-alot-of-qcache-lowmem-prunes>
			- <https://dev.mysql.com/doc/refman/5.7/en/query-cache-status-and-maintenance.html>
			- <https://dev.mysql.com/doc/refman/5.7/en/server-status-variables.html>
			- <http://www.111cn.net/database/110/c0c88da67b9e0c6c8fabfbcd6c733523.htm>
		- 1. Qcache_free_blocks，缓存中相邻内存块的个数。数目大说明可能有碎片。如果数目比较大，可以执行： `flush query cache;` 对缓存中的碎片进行整理，从而得到一个空闲块。 
		- 2. Qcache_free_memory，缓存中的空闲内存大小。如果 Qcache_free_blocks 比较大，说明碎片严重。 如果 Qcache_free_memory 很小，说明缓存不够用了。 
		- 3. Qcache_hits，每次查询在缓存中命中时就增大该值。 
		- 4. Qcache_inserts，每次查询，如果没有从缓存中找到数据，这里会增大该值
		- 5. Qcache_lowmem_prunes，因内存不足删除缓存次数，缓存出现内存不足并且必须要进行清理, 以便为更多查询提供空间的次数。返个数字最好长时间来看；如果返个数字在不断增长，就表示可能碎片非常严重，或者缓存内存很少。 
		- 6. Qcache_not_cached # 没有进行缓存的查询的数量，通常是这些查询未被缓存或其类型不允许被缓存
		- 7. Qcache_queries_in_cache # 在当前缓存的查询（和响应）的数量。 
		- 8. Qcache_total_blocks #缓存中块的数量。
- 查询哪些表在被使用，是否有锁表：`SHOW OPEN TABLES WHERE In_use > 0;`
- 查询 innodb 状态（输出内容很多）：`SHOW ENGINE INNODB STATUS;`
- 锁性能状态：`SHOW STATUS LIKE  'innodb_row_lock_%';`
    - Innodb_row_lock_current_waits：当前等待锁的数量
    - Innodb_row_lock_time：系统启动到现在、锁定的总时间长度
    - Innodb_row_lock_time_avg：每次平均锁定的时间
    - Innodb_row_lock_time_max：最长一次锁定时间
    - Innodb_row_lock_waits：系统启动到现在、总共锁定次数
- 帮我们分析表，并提出建议：`select * from my_table procedure analyse();`


## 系统表

- 当前运行的所有事务：`select * from information_schema.INNODB_TRX;`
- 当前事务出现的锁：`select * from information_schema.INNODB_LOCKS;`
- 锁等待的对应关系：`select * from information_schema.INNODB_LOCK_WAITS;`


## otpimizer trace

- 作用：输入我们想要查看优化过程的查询语句，当该查询语句执行完成后，就可以到 information_schema 数据库下的OPTIMIZER_TRACE表中查看 mysql 自己帮我们的完整优化过程
- 是否打开（默认都是关闭）：`SHOW VARIABLES LIKE 'optimizer_trace';`
    - one_line的值是控制输出格式的，如果为on那么所有输出都将在一行中展示，不适合人阅读，所以我们就保持其默认值为off吧。
- 打开配置：`SET optimizer_trace="enabled=on";`
- 关闭配置：`SET optimizer_trace="enabled=off";`
- 查询优化结果：`SELECT * FROM information_schema.OPTIMIZER_TRACE;`

```
我们所说的基于成本的优化主要集中在optimize阶段，对于单表查询来说，我们主要关注optimize阶段的"rows_estimation"这个过程，这个过程深入分析了对单表查询的各种执行方案的成本；
对于多表连接查询来说，我们更多需要关注"considered_execution_plans"这个过程，这个过程里会写明各种不同的连接方式所对应的成本。
反正优化器最终会选择成本最低的那种方案来作为最终的执行计划，也就是我们使用EXPLAIN语句所展现出的那种方案。
如果有小伙伴对使用EXPLAIN语句展示出的对某个查询的执行计划很不理解，大家可以尝试使用optimizer trace功能来详细了解每一种执行方案对应的成本，相信这个功能能让大家更深入的了解MySQL查询优化器。
```



## 查询优化(EXPLAIN 查看执行计划)

- 使用 EXPLAIN 进行 SQL 语句分析：`EXPLAIN SELECT * FROM sys_user;`，效果如下：

```
id|select_type|table   |partitions|type|possible_keys|key|key_len|ref|rows|filtered|Extra|
--|-----------|--------|----------|----|-------------|---|-------|---|----|--------|-----|
 1|SIMPLE     |sys_user|          |ALL |             |   |       |   |   2|     100|     |
```

- 简单描述
    - `id`：在一个大的查询语句中每个 SELECT 关键字都对应一个唯一的id
    - `select_type`：SELECT 关键字对应的那个查询的类型
    - `table`：表名
    - `partitions`：匹配的分区信息
    - `type`：针对单表的访问方法
    - `possible_keys`：可能用到的索引
    - `key`：实际上使用的索引
    - `key_len`：实际使用到的索引长度
    - `ref`：当使用索引列等值查询时，与索引列进行等值匹配的对象信息
    - `rows`：预估的需要读取的记录条数
    - `filtered`：某个表经过搜索条件过滤后剩余记录条数的百分比
    - `Extra`：一些额外的信息
- 有多个结果的场景分析
    - 有子查询的一般都会有多个结果，id 是递增值。但是，有些场景查询优化器可能对子查询进行重写，转换为连接查询。所以有时候 id 就不是自增值。
    - 对于连接查询一般也会有多个接口，id 可能是相同值，相同值情况下，排在前面的记录表示驱动表，后面的表示被驱动表
    - UNION 场景会有 id 为 NULL 的情况，这是一个去重后临时表，合并多个结果集的临时表。但是，UNION ALL 不会有这种情况，因为这个不需要去重。
- 根据具体的描述：
	- **id**，该列表示当前结果序号
	- **select_type**，表示 SELECT 语句的类型，有下面几种
		- `SIMPLE`：表示简单查询，其中不包括 UNION 查询和子查询
		- `PRIMARY`：对于包含UNION、UNION ALL或者子查询的大查询来说，它是由几个小查询组成的，其中最左边的那个查询的select_type值就是PRIMARY
		- `UNION`：对于包含UNION或者UNION ALL的大查询来说，它是由几个小查询组成的，其中除了最左边的那个小查询以外，其余的小查询的select_type值就是UNION
		- `UNION RESULT`：MySQL选择使用临时表来完成UNION查询的去重工作，针对该临时表的查询的select_type就是UNION RESULT
		- `SUBQUERY`：如果包含子查询的查询语句不能够转为对应的semi-join的形式，并且该子查询是不相关子查询，并且查询优化器决定采用将该子查询物化的方案来执行该子查询时，该子查询的第一个SELECT关键字代表的那个查询的select_type就是SUBQUERY
		- `DEPENDENT SUBQUERY`：如果包含子查询的查询语句不能够转为对应的semi-join的形式，并且该子查询是相关子查询，则该子查询的第一个SELECT关键字代表的那个查询的select_type就是DEPENDENT SUBQUERY
		- `DEPENDENT UNION`：在包含UNION或者UNION ALL的大查询中，如果各个小查询都依赖于外层查询的话，那除了最左边的那个小查询之外，其余的小查询的select_type的值就是DEPENDENT UNION
		- `DERIVED`：对于采用物化的方式执行的包含派生表的查询，该派生表对应的子查询的select_type就是DERIVED
		- `MATERIALIZED`：当查询优化器在执行包含子查询的语句时，选择将子查询物化之后与外层查询进行连接查询时，该子查询对应的select_type属性就是MATERIALIZED
		- 还有其他一些
	- **table**，表名或者是子查询的一个结果集
	- **type**，表示表的链接类型，分别有（以下的连接类型的顺序是从最佳类型到最差类型）**（这个属性重要）**：
		- 性能好：
			- `system`：当表中只有一条记录并且该表使用的存储引擎的统计数据是精确的，比如MyISAM、Memory，那么对该表的访问方法就是system，平时不会出现，这个也可以忽略不计。
			- `const`：当我们根据主键或者唯一二级索引列与常数进行等值匹配时，对单表的访问方法就是const，常用于 PRIMARY KEY 或者 UNIQUE 索引的查询，可理解为 const 是最优化的。
			- `eq_ref`：在连接查询时，如果被驱动表是通过主键或者唯一二级索引列等值匹配的方式进行访问的（如果该主键或者唯一二级索引是联合索引的话，所有的索引列都必须进行等值比较），则对该被驱动表的访问方法就是eq_ref
			- `ref`：当通过普通的二级索引列与常量进行等值匹配时来查询某个表，那么对该表的访问方法就可能是ref。ref 可用于 = 或 < 或 > 操作符的带索引的列。
			- `ref_or_null`：当对普通二级索引进行等值匹配查询，该索引列的值也可以是NULL值时，那么对该表的访问方法就可能是ref_or_null
		- 性能较差：
			- `index_merge`：该联接类型表示使用了索引合并优化方法。在这种情况下，key 列包含了使用的索引的清单，key_len 包含了使用的索引的最长的关键元素。
			- `unique_subquery`：类似于两表连接中被驱动表的eq_ref访问方法，unique_subquery是针对在一些包含IN子查询的查询语句中，如果查询优化器决定将IN子查询转换为EXISTS子查询，而且子查询可以使用到主键进行等值匹配的话，那么该子查询执行计划的type列的值就是unique_subquery
			- `index_subquery`：index_subquery与unique_subquery类似，只不过访问子查询中的表时使用的是普通的索引
			- `range`：只检索给定范围的行, 使用一个索引来选择行。
			- `index`：该联接类型与 ALL 相同, 除了只有索引树被扫描。这通常比 ALL 快, 因为索引文件通常比数据文件小。
			    - 再一次强调，对于使用InnoDB存储引擎的表来说，二级索引的记录只包含索引列和主键列的值，而聚簇索引中包含用户定义的全部列以及一些隐藏列，所以扫描二级索引的代价比直接全表扫描，也就是扫描聚簇索引的代价更低一些
		- 性能最差：
			- `ALL`：对于每个来自于先前的表的行组合, 进行完整的表扫描。（性能最差）
	- `possible_keys`，指出 MySQL 能使用哪个索引在该表中找到行。如果该列为 NULL，说明没有使用索引，可以对该列创建索引来提供性能。**（这个属性重要）**
	    - possible_keys列中的值并不是越多越好，可能使用的索引越多，查询优化器计算查询成本时就得花费更长时间，所以如果可以的话，尽量删除那些用不到的索引。
	- `key`，显示 MySQL 实际决定使用的键 (索引)。如果没有选择索引, 键是 NULL。**（这个属性重要）**
	    - 不过有一点比较特别，就是在使用index访问方法来查询某个表时，possible_keys列是空的，而key列展示的是实际使用到的索引
	- `key_len`，表示当优化器决定使用某个索引执行查询时，该索引记录的最大长度。如果键是可以为 NULL, 则长度多 1。
	- `ref`，显示使用哪个列或常数与 key 一起从表中选择行。
	- `rows`，显示 MySQL 认为它执行查询时必须检查的行数。**（这个属性重要）**
	- `Extra`，该列包含 MySQL 解决查询的详细信息：
		- `Distinct` MySQL 发现第 1 个匹配行后, 停止为当前的行组合搜索更多的行。
		- `Not exists` 当我们使用左（外）连接时，如果WHERE子句中包含要求被驱动表的某个列等于NULL值的搜索条件，而且那个列又是不允许存储NULL值的，那么在该表的执行计划的Extra列就会提示Not exists额外信息
		- `range checked for each record (index map: #)` MySQL 没有发现好的可以使用的索引, 但发现如果来自前面的表的列值已知, 可能部分索引可以使用。
		- `Using filesort` 有一些情况下对结果集中的记录进行排序是可以使用到索引的
		    - 需要注意的是，如果查询中需要使用filesort的方式进行排序的记录非常多，那么这个过程是很耗费性能的，我们最好想办法将使用文件排序的执行方式改为使用索引进行排序。
		- `Using temporary` 在许多查询的执行过程中，MySQL可能会借助临时表来完成一些功能，比如去重、排序之类的，比如我们在执行许多包含DISTINCT、GROUP BY、UNION等子句的查询过程中，如果不能有效利用索引来完成查询，MySQL很有可能寻求通过建立内部的临时表来执行查询。如果查询中使用到了内部的临时表，在执行计划的Extra列将会显示Using temporary提示
		    - 如果我们并不想为包含GROUP BY子句的查询进行排序，需要我们显式的写上：ORDER BY NULL
		    - 执行计划中出现Using temporary并不是一个好的征兆，因为建立与维护临时表要付出很大成本的，所以我们最好能使用索引来替代掉使用临时表
		- `Using join buffer (Block Nested Loop)` 在连接查询执行过程过，当被驱动表不能有效的利用索引加快访问速度，MySQL一般会为其分配一块名叫join buffer的内存块来加快查询速度，也就是我们所讲的基于块的嵌套循环算法
		- `Using where`
		    - 当我们使用全表扫描来执行对某个表的查询，并且该语句的WHERE子句中有针对该表的搜索条件时，在Extra列中会提示上述额外信息
		    - 当使用索引访问来执行对某个表的查询，并且该语句的WHERE子句中有除了该索引包含的列之外的其他搜索条件时，在Extra列中也会提示上述额外信息
		- `Using sort_union(...), Using union(...), Using intersect(...)` 如果执行计划的Extra列出现了Using intersect(...)提示，说明准备使用Intersect索引合并的方式执行查询，括号中的...表示需要进行索引合并的索引名称；如果出现了Using union(...)提示，说明准备使用Union索引合并的方式执行查询；出现了Using sort_union(...)提示，说明准备使用Sort-Union索引合并的方式执行查询。
		- `Using index condition` 有些搜索条件中虽然出现了索引列，但却不能使用到索引
		- `Using index` 当我们的查询列表以及搜索条件中只包含属于某个索引的列，也就是在可以使用索引覆盖的情况下，在Extra列将会提示该额外信息
		- `Using index for group-by` 类似于访问表的 Using index 方式,Using index for group-by 表示 MySQL 发现了一个索引, 可以用来查 询 GROUP BY 或 DISTINCT 查询的所有列, 而不要额外搜索硬盘访问实际的表。


## 查询不走索引优化

- WHERE字句的查询条件里有不等于号（WHERE column!=…），MYSQL将无法使用索引
- 类似地，如果WHERE字句的查询条件里使用了函数（如：WHERE DAY(column)=…），MYSQL将无法使用索引
- 在JOIN操作中（需要从多个数据表提取数据时），MYSQL只有在主键和外键的数据类型相同时才能使用索引，否则即使建立了索引也不会使用
- 如果WHERE子句的查询条件里使用了比较操作符LIKE和REGEXP，MYSQL只有在搜索模板的第一个字符不是通配符的情况下才能使用索引。比如说，如果查询条件是LIKE 'abc%',MYSQL将使用索引；如果条件是LIKE '%abc'，MYSQL将不使用索引。
- 在ORDER BY操作中，MYSQL只有在排序条件不是一个查询条件表达式的情况下才使用索引。尽管如此，在涉及多个数据表的查询里，即使有索引可用，那些索引在加快ORDER BY操作方面也没什么作用。
- 如果某个数据列里包含着许多重复的值，就算为它建立了索引也不会有很好的效果。比如说，如果某个数据列里包含了净是些诸如“0/1”或“Y/N”等值，就没有必要为它创建一个索引。
- 索引有用的情况下就太多了。基本只要建立了索引，除了上面提到的索引不会使用的情况下之外，其他情况只要是使用在WHERE条件里，ORDER BY 字段，联表字段，一般都是有效的。 建立索引要的就是有效果。 不然还用它干吗？ 如果不能确定在某个字段上建立的索引是否有效果，只要实际进行测试下比较下执行时间就知道。
- 如果条件中有or(并且其中有or的条件是不带索引的)，即使其中有条件带索引也不会使用(这也是为什么尽量少用or的原因)。注意：要想使用or，又想让索引生效，只能将or条件中的每个列都加上索引
- 如果列类型是字符串，那一定要在条件中将数据使用引号引用起来,否则不使用索引
- 如果mysql估计使用全表扫描要比使用索引快,则不使用索引


## 子查询优化

- MySQL 从 4.1 版本开始支持子查询，使用子查询进行 SELECT 语句嵌套查询，可以一次完成很多逻辑上需要多个步骤才能完成的 SQL 操作。
- 子查询虽然很灵活，但是执行效率并不高。
- 执行子查询时，MYSQL 需要创建临时表，查询完毕后再删除这些临时表，所以，子查询的速度会受到一定的影响。
- 优化：
    - 可以使用连接查询（JOIN）代替子查询，连接查询时不需要建立临时表，其速度比子查询快。

## 其他查询优化

- 关联查询过程
    - 确保 ON 或者 using子句中的列上有索引
    - 确保任何的 groupby 和 orderby 中的表达式只涉及到一个表中的列。
- count()函数优化
    - count()函数有一点需要特别注意：它是不统计值为NULL的字段的！所以：不能指定查询结果的某一列，来统计结果行数。即 count(xx column) 不太好。
    - 如果想要统计结果集，就使用 count(*)，性能也会很好。
- 分页查询（数据偏移量大的场景）
    - 不允许跳页，只能上一页或者下一页
    - 使用 where 加上上一页 ID 作为条件(具体要看 explain 分析效果)：`select xxx,xxx from test_table where id < '上页id分界值' order by id desc limit 20;`

## 创表原则

- 所有字段均定义为 NOT NULL ，除非你真的想存 Null。因为表内默认值 Null 过多会影响优化器选择执行计划


## 建立索引原则

- 使用区分度高的列作为索引，字段不重复的比例，区分度越高，索引树的分叉也就越多，一次性找到的概率也就越高。
- 尽量使用字段长度小的列作为索引
- 使用数据类型简单的列（int 型，固定长度）
- 选用 NOT NULL 的列。在MySQL中，含有空值的列很难进行查询优化，因为它们使得索引、索引的统计信息以及比较运算更加复杂。你应该用0、一个特殊的值或者一个空串代替空值。
- 尽量的扩展索引，不要新建索引。比如表中已经有a的索引，现在要加(a,b)的索引，那么只需要修改原来的索引即可。这样也可避免索引重复。



## 数据库结构优化

- 将字段很多的表分解成多个表
	- 对于字段较多的表，如果有些字段的使用频率很低，可以将这些字段分离出来形成新表。
	- 因为当一个表的数据量很大时，会由于使用频率低的字段的存在而变慢。
- 增加中间表
	- 对于需要经常联合查询的表，可以建立中间表以提高查询效率。
	- 通过建立中间表，将需要通过联合查询的数据插入到中间表中，然后将原来的联合查询改为对中间表的查询。
- 增加冗余字段
	- 设计数据表时应尽量遵循范式理论的规约，尽可能的减少冗余字段，让数据库设计看起来精致、优雅。但是，合理的加入冗余字段可以提高查询速度。



## 插入数据的优化（适用于 InnoDB）

- 插入数据时，影响插入速度的主要是索引、唯一性校验、一次插入的数据条数等。
- 开发环境情况下的考虑：
	- 开发场景中，如果需要初始化数据，导入数据等一些操作，而且是开发人员进行处理的，可以考虑在插入数据之前，先禁用整张表的索引，
		- 禁用索引使用 SQL：`ALTER TABLE table_name DISABLE KEYS;`
		- 当导入完数据之后，重新让MySQL创建索引，并开启索引：`ALTER TABLE table_name ENABLE KEYS;`
	- 如果表中有字段是有唯一性约束的，可以先禁用，然后在开启：
		- 禁用唯一性检查的语句：`SET UNIQUE_CHECKS = 0;`
		- 开启唯一性检查的语句：`SET UNIQUE_CHECKS = 1;`
	- 禁用外键检查（建议还是少量用外键，而是采用代码逻辑来处理）
		- 插入数据之前执行禁止对外键的检查，数据插入完成后再恢复，可以提供插入速度。
		- 禁用：`SET foreign_key_checks = 0;`
		- 开启：`SET foreign_key_checks = 1;`
	- 使用批量插入数据
	- 禁止自动提交
		- 插入数据之前执行禁止事务的自动提交，数据插入完成后再恢复，可以提供插入速度。
		- 禁用：`SET autocommit = 0;`
		- 开启：`SET autocommit = 1;`
		- 插入数据之前执行禁止对外键的检查，数据插入完成后再恢复
        - 禁用：`SET foreign_key_checks = 0;`
        - 开启：`SET foreign_key_checks = 1;`


## 服务器优化

- 好硬件大家都知道，这里没啥好说，如果是 MySQL 单独一台机子，那机子内存可以考虑分配 60%~70% 给 MySQL
- 通过优化 MySQL 的参数可以提高资源利用率，从而达到提高 MySQL 服务器性能的目的。
	- 可以看我整理的这篇文章：<https://github.com/judasn/Linux-Tutorial/blob/master/MySQL-Settings/MySQL-5.6/1G-Memory-Machine/my-for-comprehensive.cnf>
- 由于 binlog 日志的读写频繁，可以考虑在 my.cnf 中配置，指定这个 binlog 日志到一个 SSD 硬盘上。


## 锁相关

InnoDB支持事务；InnoDB 采用了行级锁。也就是你需要修改哪行，就可以只锁定哪行。
在 Mysql 中，行级锁并不是直接锁记录，而是锁索引。索引分为主键索引和非主键索引两种，如果一条sql 语句操作了主键索引，Mysql 就会锁定这条主键索引；如果一条语句操作了非主键索引，MySQL会先锁定该非主键索引，再锁定相关的主键索引。
InnoDB 行锁是通过给索引项加锁实现的，如果没有索引，InnoDB 会通过隐藏的聚簇索引来对记录加锁。也就是说：如果不通过索引条件检索数据，那么InnoDB将对表中所有数据加锁，实际效果跟表锁一样。因为没有了索引，找到某一条记录就得扫描全表，要扫描全表，就得锁定表。


数据库的增删改操作默认都会加排他锁，而查询不会加任何锁。

排他锁：对某一资源加排他锁，自身可以进行增删改查，其他人无法进行任何操作。语法为：
select * from table for update;

共享锁：对某一资源加共享锁，自身可以读该资源，其他人也可以读该资源（也可以再继续加共享锁，即 共享锁可多个共存），但无法修改。
要想修改就必须等所有共享锁都释放完之后。语法为：
select * from table lock in share mode;



## 资料

- <https://my.oschina.net/jsan/blog/653697>
- <https://blog.imdst.com/mysql-5-6-pei-zhi-you-hua/>
- <https://mp.weixin.qq.com/s/qCRfxIr1RoHd9i8-Hk8iuQ>
- <https://yancg.cn/detail?id=3>
- <https://www.jianshu.com/p/1ab3cd5551b9>
- <http://blog.brucefeng.info/post/mysql-index-query?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io>
- <https://juejin.im/book/5bffcbc9f265da614b11b731>
- <>
- <>
- <>
- <>
- <>