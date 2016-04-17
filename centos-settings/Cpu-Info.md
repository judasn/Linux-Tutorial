## CPU 信息分析


## 初衷

- 了解服务器的性能，以方便我们如何更好地对程序进行部署


## CPU 信息

- Demo CPU 型号：[Intel® Xeon® Processor E5-2620 v2(15M Cache, 2.10 GHz)](http://ark.intel.com/products/75789/Intel-Xeon-Processor-E5-2620-v2-15M-Cache-2_10-GHz)
- 该 CPU 显示的数据中有一项这个要注意：`Intel® Hyper-Threading Technology` 是 `Yes`。表示该 CPU 支持超线程
- `cat /proc/cpuinfo`，查看 CPU 总体信息
- `grep 'physical id' /proc/cpuinfo | sort -u | wc -l`，查看物理 CPU 个数
    - 结果：2
    - 物理 CPU：物理 CPU 也就是机器外面就能看到的一个个 CPU，每个物理 CPU 还带有单独的风扇
- `grep 'core id' /proc/cpuinfo | sort -u | wc -l`，查看每个物理 CPU 的核心数量
    - 结果：6，因为每个物理 CPU 是 6，所有 2 个物理 CPU 的总核心数量应该是：12
    - 核心数：一个核心就是一个物理线程，英特尔有个超线程技术可以把一个物理线程模拟出两个线程来用，充分发挥 CPU 性能，意思是一个核心可以有多个线程。
- `grep 'processor' /proc/cpuinfo | sort -u | wc -l`，查看 CPU 总的线程数，一般也叫做：逻辑 CPU 数量
    - 结果：24，正常情况下：CPU 的总核心数量 == CPU 线程数，但是如果该 CPU 支持超线程，那结果是：CPU 的总核心数量 X 2 == CPU 线程数
    - 线程数：线程数是一种逻辑的概念，简单地说，就是模拟出的 CPU 核心数。比如，可以通过一个 CPU 核心数模拟出 2 线程的 CPU，也就是说，这个单核心的 CPU 被模拟成了一个类似双核心 CPU 的功能。
