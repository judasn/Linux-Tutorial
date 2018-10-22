# Glances 安装和配置

## Glances 介绍

- 相对 top、htop，它比较重，因此内容也比较多。小机子一般不建议安装。大机子一般也不建议一直开着。
- 官网：<https://nicolargo.github.io/glances/>
- 官网 Github：<https://github.com/nicolargo/glances>
- 官网文档：<https://glances.readthedocs.io/en/latest/>
- 当前（201810）最新版本为 3.0.2


## Glances Linux 安装

- `curl -L https://bit.ly/glances | /bin/bash`
- 需要 5 ~ 10 分钟左右。

## 用法

#### 本地监控

- 进入实时监控面板（默认 3 秒一次指标）：`glances`
- 每间隔 5 秒获取一次指标：`glances -t 5`
- 在控制面板中可以按快捷键进行排序、筛选

```
m : 按内存占用排序进程
p : 按进程名称排序进程
c : 按 CPU 占用率排序进程
i : 按 I/O 频率排序进程
a : 自动排序进程
d : 显示/隐藏磁盘 I/O 统计信息
f : 显示/隐藏文件系统统计信息
s : 显示/隐藏传感器统计信息
y : 显示/隐藏硬盘温度统计信息
l : 显示/隐藏日志
n : 显示/隐藏网络统计信息
x : 删除警告和严重日志
h : 显示/隐藏帮助界面
q : 退出
w : 删除警告记录
```


#### 监控远程机子

- 这里面的检控方和被监控的概念要弄清楚
- 作为服务端的机子运行（也就是被监控方）：`glances -s`
	- 假设它的 IP 为：192.168.1.44
	- 必需打开 61209 端口
- 作为客户端的机子运行（要查看被检控方的数据）：`glances -c 192.168.1.44`
	- 这时候控制台输出的内容是被监控机子的数据


## 导出数据

- 个人测试没效果，后续再看下吧。
- 官网文档：<https://glances.readthedocs.io/en/latest/search.html?q=export&check_keywords=yes&area=default>
- 导出 CSV：`glances --export-csv /tmp/glances.csv`
- 导出 JSON：`glances --export-json /tmp/glances.json`

## 资料

- <https://linux.cn/article-6882-1.html>
- <http://www.qingpingshan.com/pc/fwq/394078.html>
- <https://www.imooc.com/article/81038?block_id=tuijian_wz>
- <http://pdf.us/2018/02/28/684.html>
- <https://www.sysgeek.cn/monitor-linux-servers-glances-tool/>
- <https://www.jianshu.com/p/639581a96512>
