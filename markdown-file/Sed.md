# Sed 常用命令

- 轻量级流编辑器，一般用来处理文本类文件
- **sed 是非交互式的编辑器。它不会修改文件，除非使用 shell 重定向来保存结果。默认情况下，所有的输出行都被打印到屏幕上**
- **用 sed -i 会实际写入**，下面为了演示，都没加该参数，有需要可以自行添加。

## 基础例子

- 有一个文件：/opt/log4j2.properties

``` ini
status = error                                                                                                                                      
 
# log action execution errors for easier debugging
logger.action.name = org.elasticsearch.action
logger.action.level = debug
 
appender.console.type = Console
appender.console.name = console
appender.console.layout.type = PatternLayout
appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] %marker%m%n
 
appender.rolling.type = RollingFile
appender.rolling.name = rolling
appender.rolling.fileName = ${sys:es.logs}.log
appender.rolling.layout.type = PatternLayout
appender.rolling.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] %marker%.-10000m%n
appender.rolling.filePattern = ${sys:es.logs}-%d{yyyy-MM-dd}.log
appender.rolling.policies.type = Policies
appender.rolling.policies.time.type = TimeBasedTriggeringPolicy
appender.rolling.policies.time.interval = 1
appender.rolling.policies.time.modulate = true
 
rootLogger.level = info
rootLogger.appenderRef.console.ref = console
rootLogger.appenderRef.rolling.ref = rolling
```

- `p` 参数表示打印，一般配合 -n（安静模式）进行使用
	- `sed -n '7,10p' /opt/log4j2.properties`：显示第 7 ~ 10 行内容
	- `sed -n '7p' /opt/log4j2.properties`：显示第 7 行内容
- `d` 删除
	- `cat -n /opt/log4j2.properties |sed '7,10d'`：剔除 7 ~ 10 行内容，然后显示文件所有内容出来（实际文件是未删除的）
- `a` 追加
	- `cat -n /opt/log4j2.properties |sed '1a GitNavi.com'`：追加 GitNavi.com 内容（追加在下一行展示），然后显示文件所有内容出来
- `c` 替换
	- `cat -n /opt/log4j2.properties |sed '1,4c GitNavi.com'`：将 1 ~ 4 行内容替换成 GitNavi.com
- `s`： 搜索并替换
	- `sed 's/time/timeing/g' /opt/log4j2.properties`：将文件中所有 time 替换成 timeing 并展示
	- `sed 's/^#*//g' /opt/log4j2.properties`：将文件中每一行以 # 开头的都替换掉空字符并展示
	- `sed 's/^#[ ]*//g' /opt/log4j2.properties`：将文件中每一行以 # 开头的，并且后面的一个空格，都替换掉空字符并展示
	- `sed 's/^[ ]*//g' /opt/log4j2.properties`：将文件中每一行以空格开头，都替换掉空字符并展示
	- `sed 's/^[0-9][0-9]*//g' /opt/log4j2.properties`：将文件中每一行以数字开头，都替换掉空字符并展示
	- `sed '4,6s/^/#/g' /opt/log4j2.properties`：将文件中 4 ~ 6 行添加 # 开头
	- `sed '4,6s/^#//g' /opt/log4j2.properties`：将文件中 4 ~ 6 行 # 开头去掉


## 实用例子

- `ifconfig eth0 |grep 'inet addr' |sed 's/^.*addr://g' |sed 's/Bcast.*$//g'`：CentOS 6 只显示 IP
- `ifconfig ens33 |grep 'inet' |sed 's/^.*inet//g' |sed 's/netmask.*$//g' |sed -n '1p'`：CentOS 7.3 只显示 IP。先用 grep 筛选中包含 inet 的数据。
	- `s` 参数开头表示的是搜索替换，`/^.*inet` 表示从开头到 inet 之间，`//` 为空内容，`/g`，表示处理这一行所有匹配的内容。`/netmask.*$` 表示从 netmask 到这一行结束的内容




## 资料

- 《构建高可用 Linux服务器》
- <http://www.cnblogs.com/edwardlost/archive/2010/09/17/1829145.html>