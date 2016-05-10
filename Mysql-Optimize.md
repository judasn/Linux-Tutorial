# MySQL 优化


- 下面说的优化基于 MySQL 5.6，理论上 5.5 之后的都算试用，具体还是要看官网

## 服务状态查询

- 查看当前数据库的状态，常用的有：
	- 查看当前MySQL中已经记录了多少条慢查询，前提是配置文件中开启慢查询记录了.
		- `SHOW STATUS LIKE '%slow_queries%';`
	- 查询当前MySQL中查询、更新、删除执行多少条了，可以通过这个来判断系统是侧重于读还是侧重于写，如果是写要考虑使用读写分离。
		- `SHOW STATUS LIKE '%Com_select%';`
		- `SHOW STATUS LIKE '%Com_update%';`
		- `SHOW STATUS LIKE '%Com_delete%';`
	- 显示MySQL服务启动运行了多少时间，如果MySQL服务重启，该时间重新计算，单位秒
		- `SHOW STATUS LIKE 'uptime';`



## 查询优化

- 使用 EXPLAIN 进行 SQL 语句分析：`EXPLAIN SELECT * FROM sys_user;`
- 得到的结果有下面几列：
	- id，该列表示当前结果序号，无特殊意义，不重要
	- select_type，表示 SELECT 语句的类型，有下面几种
		- SIMPLE，表示简单查询，其中不包括连接查询和子查询
		- PRIMARY，表示主查询，或者是最外面的查询语句。比如你使用一个子查询语句，比如这条 SQL：`EXPLAIN SELECT * FROM (SELECT sys_user_id FROM sys_user WHERE sys_user_id = 1) AS temp_table;`
			- 这条 SQL 有两个结果，其中有一个结果的类型就是 PRIMARY
		- UNION，使用 UNION 的SQL是这个类型
		- DERIVED，在 SQL 中 From 后面子查询
		- SUBQUERY，子查询
		- 还有其他一些
	- table，表名或者是子查询的一个结果集
	- type，表示表的链接类型，分别有（以下的连接类型的顺序是从最佳类型到最差类型）**（这个属性重要）**：
		- 性能好：
			- system，表仅有一行，这是const类型的特列，平时不会出现，这个也可以忽略不计。
			- const，数据表最多只有一个匹配行，因为只匹配一行数据，所以很快，常用于PRIMARY KEY或者UNIQUE索引的查询，可理解为const是最优化的。
			- eq_ref，mysql手册是这样说的:"对于每个来自于前面的表的行组合，从该表中读取一行。这可能是最好的联接类型，除了const类型。它用在一个索引的所有部分被联接使用并且索引是UNIQUE(唯一键)也不是PRIMARY KEY(主键)"。eq_ref可以用于使用=比较带索引的列。
			- ref，查询条件索引既不是UNIQUE(唯一键)也不是PRIMARY KEY(主键)的情况。ref可用于=或<或>操作符的带索引的列。
			- ref_or_null，该联接类型如同ref，但是添加了MySQL可以专门搜索包含NULL值的行。在解决子查询中经常使用该联接类型的优化。
		- 性能较差：
			- index_merge，该联接类型表示使用了索引合并优化方法。在这种情况下，key列包含了使用的索引的清单，key_len包含了使用的索引的最长的关键元素。
			- unique_subquery，该类型替换了下面形式的IN子查询的ref: `value IN (SELECT primary_key FROM single_table WHERE some_expr)`。unique_subquery 是一个索引查找函数,可以完全替换子查询,效率更高。
			- index_subquery，该联接类型类似于unique_subquery。可以替换IN子查询,但只适合下列形式的子查询中的非唯一索引: `value IN (SELECT key_column FROM single_table WHERE some_expr)`
			- range，只检索给定范围的行,使用一个索引来选择行。
			- index，该联接类型与ALL相同,除了只有索引树被扫描。这通常比ALL快,因为索引文件通常比数据文件小。
		- 性能最差：
			- ALL，对于每个来自于先前的表的行组合,进行完整的表扫描。（性能最差）
	- possible_keys，指出MySQL能使用哪个索引在该表中找到行。如果该列为NULL，说明没有使用索引，可以对该列创建索引来提供性能。**（这个属性重要）**
	- key，显示MySQL实际决定使用的键(索引)。如果没有选择索引,键是NULL。**（这个属性重要）**
	- key_len，显示MySQL决定使用的键长度。如果键是NULL,则长度为NULL。注意：key_len是确定了MySQL将实际使用的索引长度。
	- ref，显示使用哪个列或常数与key一起从表中选择行。
	- rows，显示MySQL认为它执行查询时必须检查的行数。**（这个属性重要）**
	- Extra，该列包含MySQL解决查询的详细信息：
		- Distinct:MySQL发现第1个匹配行后,停止为当前的行组合搜索更多的行。
		- Not exists:MySQL能够对查询进行LEFT JOIN优化,发现1个匹配LEFT JOIN标准的行后,不再为前面的的行组合在该表内检查更多的行。
		- range checked for each record (index map: #):MySQL没有发现好的可以使用的索引,但发现如果来自前面的表的列值已知,可能部分索引可以使用。
		- Using filesort:MySQL需要额外的一次传递,以找出如何按排序顺序检索行。
		- Using index:从只使用索引树中的信息而不需要进一步搜索读取实际的行来检索表中的列信息。
		- Using temporary:为了解决查询,MySQL需要创建一个临时表来容纳结果。
		- Using where:WHERE 子句用于限制哪一个行匹配下一个表或发送到客户。
		- Using sort_union(...), Using union(...), Using intersect(...):这些函数说明如何为index_merge联接类型合并索引扫描。
		- Using index for group-by:类似于访问表的Using index方式,Using index for group-by表示MySQL发现了一个索引,可以用来查 询GROUP BY或DISTINCT查询的所有列,而不要额外搜索硬盘访问实际的表。
- 了解对索引不生效的查询情况 **（这个属性重要）**
	- 使用LIKE关键字的查询，在使用LIKE关键字进行查询的查询语句中，如果匹配字符串的第一个字符为“%”，索引不起作用。只有“%”不在第一个位置，索引才会生效。
	- 使用联合索引的查询，MySQL可以为多个字段创建索引，一个索引可以包括16个字段。对于联合索引，只有查询条件中使用了这些字段中第一个字段时，索引才会生效。
	- 使用OR关键字的查询，查询语句的查询条件中只有OR关键字，且OR前后的两个条件中的列都是索引列时，索引才会生效，否则，索引不生效。
- 子查询优化
	- MySQL从4.1版本开始支持子查询，使用子查询进行SELECT语句嵌套查询，可以一次完成很多逻辑上需要多个步骤才能完成的SQL操作。
	- 子查询虽然很灵活，但是执行效率并不高。
	- 执行子查询时，MYSQL需要创建临时表，查询完毕后再删除这些临时表，所以，子查询的速度会受到一定的影响。
	- 优化：
		- 可以使用连接查询（JOIN）代替子查询，连接查询时不需要建立临时表，其速度比子查询快。


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



## 服务器优化

- 好硬件大家都知道，这里没啥好说
- 通过优化 MySQL 的参数可以提高资源利用率，从而达到提高 MySQL 服务器性能的目的。
	- 可以看我整理的这篇文章：<https://github.com/judasn/Linux-Tutorial/blob/master/MySQL-Settings/MySQL-5.6/1G-Memory-Machine/my-for-comprehensive.cnf>


## 资料


