## 修改定时清理 /tmp 目录下的文件


## 初衷

- 默认系统是超过 30 天不访问的文件自动清除的，但是有时候硬盘用得紧可以考虑修改周期


## 设置方法

- 编辑配置文件：`vim /etc/cron.daily/tmpwatch`

``` nginx
#! /bin/sh
flags=-umc
/usr/sbin/tmpwatch "$flags" -x /tmp/.X11-unix -x /tmp/.XIM-unix \
        -x /tmp/.font-unix -x /tmp/.ICE-unix -x /tmp/.Test-unix \
        -X '/tmp/hsperfdata_*' 10d /tmp
/usr/sbin/tmpwatch "$flags" 30d /var/tmp
for d in /var/{cache/man,catman}/{cat?,X11R6/cat?,local/cat?}; do
    if [ -d "$d" ]; then
        /usr/sbin/tmpwatch "$flags" -f 30d "$d"
    fi
done
```

- 上面这句话：`/usr/sbin/tmpwatch "$flags" -f 30d "$d"`，其中 **30d** 表示 30 天表示要备删除的周期文件，该值最低为 1。
- 一般数据建议不要放在这个目录下，以免被系统误删
