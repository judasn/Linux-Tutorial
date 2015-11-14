<h1 id="linux0">Linux 介绍</h1>

------

*   [Linux 介绍](#linux0)
    *   [Linux 这个名字](#linux1)
    *   [Linux 的发行版本](#linux2)
    *   [Linux 作用](#linux3)
    *   [推荐的发行版本](#linux4)

------

<h2 id="linux1">Linux 这个名字</h2>

Linux 的 Wiki 介绍：<http://zh.wikipedia.org/zh/Linux>

Linux 也称：`GNU/Linux`（”GNU/Linux” 英语发音：/ɡ??nu? sl?? ?l?n?ks/），而其中 GNU 的全称又是：`Gnu’s Not Unix`。

其中 GNU 放前面是有原因的，GNU 介绍：<http://zh.wikipedia.org/wiki/GNU>

对于 Linux 和 GNU/Linux 的两种叫法是有?争议，可以看下面文章：<http://zh.wikipedia.org/wiki/GNU/Linux命名爭議>

其实我们可以认为：Linux 本质是指 Linux 内核，而称 GNU/Linux 则代表这是一个系统，所以我认为 Debian 的这个叫法是合理的，但是确实有点不好念和记忆。所以普遍大家直接称作 Linux。

通过上面的全称和资料其实我们也就了解到，Linux 本质来源不是 Unix，但是它借鉴了 Unix 的设计思想，所以在系统业界上把这种和 Unix 是一致设计思想的系统归为：`类 Unix 系统`。

类 Unix 系统的介绍：<http://zh.wikipedia.org/wiki/>类Unix系统

类 Unix 系统，除了我们今天要讲的 Linux，还有大家熟知的 Mac OS X、FreeBSD（这两个是直接从 Unix 系发展过来的，所以相对 Linux 是比较地道的类 Unix 系统）

- FreeBSD介绍：<http://zh.wikipedia.org/zh/FreeBSD>
- Mac OS X介绍：<http://zh.wikipedia.org/wiki/OS_X>

<h2 id="linux2">Linux 的发行版本</h2>

Linux 的 Wiki 中有这句话：

> 通常情况下，Linux 被打包成供个人计算机和服务器使用的 Linux 发行版，一些流行的主流 Linux 发布版，包括 Debian（及其派生版本 Ubuntu、Linux Mint）、Fedora（及其相关版本 Red Hat Enterprise Linux、CentOS）和 openSUSE、ArchLinux（这个是我补充的）等。

**通过上面这句话我做了总结，我个人觉得应该这样分：**

- Fedora、RHEL、centos 是一个系，他们的区别：<http://blog.csdn.net/tianlesoftware/article/details/5420569>
- Debian、Ubuntu 是一个系的，他们的区别直接看 Ubuntu 的 Wiki 就可以得知：<http://zh.wikipedia.org/zh/Ubuntu>
- ArchLinux 自己一个系：<http://zh.wikipedia.org/wiki/Arch_Linux>
- openSUSE 自己一个系：<http://zh.wikipedia.org/wiki/OpenSUSE>

**根据用途可以再总结：**

- Fedora 系业界一般用于做服务器
- Debian 系业界一般用于桌面，移动端，TV这一类
- ArchLinux 系，很轻量的Linux，适合有一定Linux基础，并且爱折腾的人使用，用它做桌面或是服务器都行。
- OpenSuse 系，嘛，嗯…人气相对比较差，一般是服务器。

其实 Linux 的发行版本有太多了，我也只是简单说下常见的而已，具体可以看：<http://zh.wikipedia.org/wiki/Linux%E5%8F%91%E8%A1%8C%E7%89%88%E5%88%97%E8%A1%A8>

<h2 id="linux3">Linux 作用</h2>

为什么要用 Linux 系统？大家常看到的说法是这样的：

> Linux 是一个开源的，有潜力，安全，免费的操作系统

我觉得这几个点都比较虚， 特别是免费这东西，在景德镇应该算是最不值钱的东西。作为上层人来讲，我们之所以喜欢某个操作系统就是因为它可以加快的你生产效率，提高产能。我推荐 Linux 也只是因为它适合常见的编程语言做开发环境，仅此一点。

**对此我的总结就是：**

如果你是某种语言的开发者，你从事这个行业，不管你怎么学习下去，Linux 永远绕不开。从简单的各种语言开发，到后期的服务器部署，分布式，集群环境，数据库相关等，Linux 都在等着你。（P.S：微软系、美工等设计系是唯一这个总结之外的人）

在认识 Linux 作用上我以下面这边文章为结尾。Linux 和 Mac OS X 都是类 Unix 系统，所以这篇文章中基本上的理由都可以用到 Linux 上的。
为什么国外程序员爱用 Mac？<http://www.vpsee.com/2009/06/why-programmers-love-mac/>

<h2 id="linux4">推荐的发行版本</h2>

**Ubuntu：适用于开发机**

**推荐版本：Ubuntu kylin 15.10**

- Ubuntu kylin 官网：<http://cn.Ubuntu.com/desktop>
- Ubuntu 英文官网：<http://www.ubuntu.com>
- Ubuntu 中文官网：<http://www.ubuntu.org.cn>
- 网易镜像：<http://mirrors.163.com/ubuntu-releases/>
- 阿里云镜像：<http://mirrors.aliyun.com/ubuntu-releases/>
- Ubuntu kylin 15.10 **64 位**镜像地址：<http://cdimage.ubuntu.com/ubuntukylin/releases/15.10/release/ubuntukylin-15.10-desktop-amd64.iso>

**推荐理由：**

我们是要在上面做开发的，不是要把他变成生活用机的，所以你认为自己尝试安装各种中文输入法很爽吗？自己尝试让国际 Ubuntu 版变成又一个符合国情的 kylin 很爽吗？真心别折腾这些没用的东西。就像我以前说的，大学老师让 java 新手使用记事本写代码就是一种非常 shit 行为，不断地用 `cmd > javac` 难度学生会很爽？

------

**CentOS：适用于服务器机**

**推荐版本：6.7**

- CentOS 官网：<http://www.centos.org/download/>
- 网易镜像：<http://mirrors.163.com/centos/>
- 阿里云镜像：<http://mirrors.aliyun.com/centos/>
- CentOS 6.7 **64 位**镜像地址：<http://mirrors.163.com/centos/6.7/isos/x86_64/CentOS-6.7-x86_64-bin-DVD1.iso>

**推荐理由：**

用作服务器的最多