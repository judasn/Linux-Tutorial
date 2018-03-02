# nmon 系统性能监控工具的使用


## nmon 说明

- 官网：<http://nmon.sourceforge.net/pmwiki.php>
- 分析工具 nmon analyser：<https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/Power+Systems/page/nmon_analyser>
- > nmon是一种在AIX与各种Linux操作系统上广泛使用的监控与分析工具， nmon所记录的信息是比较全面的，它能在系统运行过程中实时地捕捉系统资源的使用情况，并且能输出结果到文件中。

## 下载/安装 

- Ubuntu：`sudo apt-get install -y nmon`
- CentOS：`sudo yum install -y nmon`，前提是你已经有安装 epel 源
	- 或者使用 RPM 包：<http://pan.baidu.com/s/1hsFEoeg>
		- 安装命令：`rpm -ivh nmon-14i-8.el6.x86_64.rpm`
- 分析工具 nmon analyser：<http://pan.baidu.com/s/1pKBLXrX>

## 运行

- 实时监控：`nmon`
- 后台监控：`cd /opt ; nmon -f -s 10 -c 360`
	- 前面的 cd /opt 表示，进入 opt 目录，nmon 生成的文件是在当前目录下。
	- -f ：按标准格式输出文件名称：<hostname>_YYYYMMDD_HHMM.nmon
	- -s ：每隔n秒抽样一次，这里为10秒
	- -c ：取出多少个抽样数量，这里为360，即监控=10*360/3600=1小时
	- 该命令启动后，nmon 会在当前目录下生成监控文件，并持续写入资源数据，直至360个监控点收集完成——即监控1小时，这些操作均自动完成，无需手工干预，测试人员可以继续完成其他操作。如果想停止该监控，需要通过 `ps -ef | grep nmon` 查询进程号，然后杀掉该进程以停止监控。
- 定期监控：本质是 crontab 加上后台监控命令

## 解析监控文件

- 把 nmon 文件转换成 csv 文件：`sort localhost_120427_0922.nmon > localhost_120427_0922.csv`
- 把 csv 转换成 Excel 图表文件：
	- 打开 nmon analyser 分析工具：nmon analyser v50_2.xlsm
		- 点击 Analyse nmon data 会弹出一个弹出框，选择刚刚转换的 csv 文件，然后就会自动再转化成 excel 文件
- 导出的综合报表的参数说明：<http://www.51testing.com/html/25/15146625-3714909.html>

## 资料

- [Nmon命令行：Linux系统性能的监测利器](http://os.51cto.com/art/201406/442795.htm)
- [性能监控和分析工具--nmon](http://kumu1988.blog.51cto.com/4075018/1086256)
- [nmon以及nmon analyser 教程](http://www.xuebuyuan.com/1439800.html)
