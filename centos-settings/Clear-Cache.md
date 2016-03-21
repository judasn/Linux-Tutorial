## 清除系统缓存


## 初衷

- 本身 Linux 有比较成熟的内存管理机制，但是不免也是会抽风的，有些程序在被 kill 掉之后系统内存依然没有大的变化，这时候就需要手动清除。


## 清除缓存

- 官网说明：<http://www.kernel.org/doc/Documentation/sysctl/vm.txt>
- 先查看目前系统内存使用情况：`free -m`
- 同步缓存数据到硬盘：`sync`
- 开始清理：`echo 3 > /proc/sys/vm/drop_caches`
    - 0：不清除
    - 1：清除页缓存
    - 2：清除目录项缓存与文件结点缓存
    - 3：清除所有缓存（常用）
- 再查看清除后效果：`free -m`
