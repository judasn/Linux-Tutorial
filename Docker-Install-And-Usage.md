 
 
# Docker 使用
 
## 环境说明
 
- CentOS 7.3（不准确地说：要求必须是 CentOS 7 64位）
- 不建议在 Windows 上使用
 
## Docker 基本概念
 
- 官网：<https://www.docker.com/>
- 宿主机：安装 Docker 的那台电脑
- Docker：一个虚拟化软件，你可以认为是类似：VMware、Virtualbox
- 镜像：可以认为是类似 Windows 下的：XXXX.iso
- 容器：容器为镜像的实例，可以认为是 Virtualbox 运行 XXXX.iso 后的效果
- 官网的镜像仓库地址：<https://store.docker.com/>
- 对开发来讲总结一个最简单的说法：在 Maven 未产生的年代，jar 包要随着开发项目走到哪里跟到哪里。有了 Maven 写好 pom.xml 即可。此时的 Docker 就好比如 Maven，帮你省去了开发过程中的部署环境差异，你再也不能随便说：你的系统可以运行，我的系统就不行。现在别人连系统都帮你做好了。
- 玩法理念：单进程，一个容器最好最专注去做一个事情。虽然它可以既装 MySQL，又装 Nginx 等等，但是让一个容器只做好一件事是最合适的。
- 其他通俗解释：
 
> Docker的思想来自于集装箱，集装箱解决了什么问题？在一艘大船上，可以把货物规整的摆放起来。并且各种各样的货物被集装箱标准化了，集装箱和集装箱之间不会互相影响。那么我就不需要专门运送水果的船和专门运送化学品的船了。只要这些货物在集装箱里封装的好好的，那我就可以用一艘大船把他们都运走。
  docker就是类似的理念。现在都流行云计算了，云计算就好比大货轮。docker就是集装箱。
  1.不同的应用程序可能会有不同的应用环境，比如.net开发的网站和php开发的网站依赖的软件就不一样，如果把他们依赖的软件都安装在一个服务器上就要调试很久，而且很麻烦，还会造成一些冲突。比如IIS和Apache访问端口冲突。这个时候你就要隔离.net开发的网站和php开发的网站。常规来讲，我们可以在服务器上创建不同的虚拟机在不同的虚拟机上放置不同的应用，但是虚拟机开销比较高。docker可以实现虚拟机隔离应用环境的功能，并且开销比虚拟机小，小就意味着省钱了。
  2.你开发软件的时候用的是Ubuntu，但是运维管理的都是centos，运维在把你的软件从开发环境转移到生产环境的时候就会遇到一些Ubuntu转centos的问题，比如：有个特殊版本的数据库，只有Ubuntu支持，centos不支持，在转移的过程当中运维就得想办法解决这样的问题。这时候要是有docker你就可以把开发环境直接封装转移给运维，运维直接部署你给他的docker就可以了。而且部署速度快。
  3.在服务器负载方面，如果你单独开一个虚拟机，那么虚拟机会占用空闲内存的，docker部署的话，这些内存就会利用起来。
  总之docker就是集装箱原理。
 
- Docker 的优点：
- 持续部署与测试
 
> Docker在开发与运维的世界中具有极大的吸引力，因为它能保持跨环境的一致性。在开发与发布的生命周期中，不同的环境具有细微的不同，这些差异可能是由于不同安装包的版本和依赖关系引起的。然而，Docker可以通过确保从开发到产品发布整个过程环境的一致性来解决这个问题。
    Docker容器通过相关配置，保持容器内部所有的配置和依赖关系始终不变。最终，你可以在开发到产品发布的整个过程中使用相同的容器来确保没有任何差异或者人工干预。
    使用Docker，你还可以确保开发者不需要配置完全相同的产品环境，他们可以在他们自己的系统上通过VirtualBox建立虚拟机来运行Docker容器。Docker的魅力在于它同样可以让你在亚马逊EC2实例上运行相同的容器。如果你需要在一个产品发布周期中完成一次升级，你可以很容易地将需要变更的东西放到Docker容器中，测试它们，并且使你已经存在的容器执行相同的变更。这种灵活性就是使用Docker的一个主要好处。和标准部署与集成过程一样，Docker可以让你构建、测试和发布镜像，这个镜像可以跨多个服务器进行部署。哪怕安装一个新的安全补丁，整个过程也是一样的。你可以安装补丁，然后测试它，并且将这个补丁发布到产品中。
 
- 环境标准化和版本控制
 
> Docker容器可以在不同的开发与产品发布生命周期中确保一致性，进而标准化你的环境。除此之外，Docker容器还可以像git仓库一样，可以让你提交变更到Docker镜像中并通过不同的版本来管理它们。设想如果你因为完成了一个组件的升级而导致你整个环境都损坏了，Docker可以让你轻松地回滚到这个镜像的前一个版本。这整个过程可以在几分钟内完成，如果和虚拟机的备份或者镜像创建流程对比，那Docker算相当快的，它可以让你快速地进行复制和实现冗余。此外，启动Docker就和运行一个进程一样快。
 
- 隔离性
 
> Docker可以确保你的应用程序与资源是分隔开的。几个月前，Gartner发表了一篇报告，这份报告说明了运行Docker 容器进行资源隔离的效果和虚拟机（VM）管理程序一样的好，但是管理与控制方面还需要进行完善。我们考虑这样一个场景，你在你的虚拟机中运行了很多应用程序，这些应用程序包括团队协作软件（例如Confluence）、问题追踪软件（例如JIRA）、集中身份管理系统（例如Crowd）等等。由于这些软件运行在不同的端口上，所以你必须使用Apache或者Nginx来做反向代理。到目前为止，一切都很正常，但是随着你的环境向前推进，你需要在你现有的环境中配置一个内容管理系统（例如Alfresco）。这时候有个问题发生了，这个软件需要一个不同版本的Apache Tomcat，为了满足这个需求，你只能将你现有的软件迁移到另一个版本的Tomcat上，或者找到适合你现有Tomcat的内容管理系统（Alfresco）版本。对于上述场景，使用Docker就不用做这些事情了。Docker能够确保每个容器都拥有自己的资源，并且和其他容器是隔离的。你可以用不同的容器来运行使用不同堆栈的应用程序。除此之外，如果你想在服务器上直接删除一些应用程序是比较困难的，因为这样可能引发依赖关系冲突。而Docker可以帮你确保应用程序被完全清除，因为不同的应用程序运行在不同的容器上，如果你不在需要一款应用程序，那你可以简单地通过删除容器来删除这个应用程序，并且在你的宿主机操作系统上不会留下任何的临时文件或者配置文件。除了上述好处，Docker还能确保每个应用程序只使用分配给它的资源（包括CPU、内存和磁盘空间）。一个特殊的软件将不会使用你全部的可用资源，要不然这将导致性能降低，甚至让其他应用程序完全停止工作。
 
- 安全性
 
> 如上所述，Gartner也承认Docker正在快速地发展。从安全角度来看，Docker确保运行在容器中的应用程序和其他容器中的应用程序是完全分隔与隔离的，在通信流量和管理上赋予你完全的控制权。Docker容器不能窥视运行在其他容器中的进程。从体系结构角度来看，每个容器只使用着自己的资源（从进程到网络堆栈）。作为紧固安全的一种手段，Docker将宿主机操作系统上的敏感挂载点（例如/proc和/sys）作为只读挂载点，并且使用一种写时复制系统来确保容器不能读取其他容器的数据。Docker也限制了宿主机操作系统上的一些系统调用，并且和SELinux与AppArmor一起运行的很好。此外，在Docker Hub上可以使用的Docker镜像都通过数字签名来确保其可靠性。由于Docker容器是隔离的，并且资源是受限制的，所以即使你其中一个应用程序被黑，也不会影响运行在其它Docker容器上的应用程序。
 
- 多云平台
 
> Docker最大的好处之一就是可移植性。在过去的几年里，所有主流的云计算提供商，包括亚马逊AWS和谷歌的GCP，都将Docker融入到他们的平台并增加了各自的支持。Docker容器能运行在亚马逊的EC2实例、谷歌的GCP实例、Rackspace服务器或者VirtualBox这些提供主机操作系统的平台上。举例来说，如果运行在亚马逊EC2实例上的Docker容器能够很容易地移植到其他几个平台上，比如说VirtualBox，并且达到类似的一致性和功能性，那这将允许你从基础设施层中抽象出来。除了AWS和GCP，Docker在其他不同的IaaS提供商也运行的非常好，例如微软的Azure、OpenStack和可以被具有不同配置的管理者所使用的Chef、Puppet、Ansible等。
 
 
 
## Docker 安装和基本配置
 
- 主要有两个版本：
 
> Docker Enterprise Edition (Docker EE) is designed for enterprise development and IT teams who build, ship, and run business critical applications in production at scale. Docker EE is integrated, certified, and supported to provide enterprises with the most secure container platform in the industry to modernize all applications. For more information about Docker EE, including purchasing options, see Docker Enterprise Edition.
Docker Community Edition (Docker CE) is ideal for developers and small teams looking to get started with Docker and experimenting with container-based apps. Docker CE is available on many platforms, from desktop to cloud to server. Docker CE is available for macOS and Windows and provides a native experience to help you focus on learning Docker. You can build and share containers and automate the development pipeline all from a single environment.
Docker CE has both stable and edge channels.
    Stable builds are released once per quarter and are supported for 4 months.
    Edge builds are released once per month, and are supported for that month only. If you subscribe to the Edge channel on Linux distributions, you should also subscribe to the Stable channel.
 
 
- 官网总的安装手册：<https://docs.docker.com/engine/installation/#docker-editions>
- 官网 CentOS 安装手册：<https://docs.docker.com/engine/installation/linux/centos/>
 
- 我这里选择 Docker CE 版本：
- 安装过程：
    - `sudo yum install -y yum-utils`
 
    ``` bash
   ：添加 repo（可能网络会很慢，有时候会报：Timeout，所以要多试几次）
    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    ```
 
    - `sudo yum makecache fast`
    - `sudo yum install -y docker-ce`，大小：19M，速度很慢。
- 启动 Docker：`systemctl start docker.service`
- 停止 Docker：`systemctl stop docker.service`
- 查看状态：`systemctl status docker.service`
- 运行 hello world 镜像：`sudo docker run hello-world`
    - 因为是第一次使用，所以没这个镜像，需要一个下载过程，所以需要几分钟，可能还会报：Timeout。
    - 镜像自动下载好后会输出这样一段内容，表示已经正常安装并可用了：
 
    ``` bash
    Unable to find image 'hello-world:latest' locally
    latest: Pulling from library/hello-world
    78445dd45222: Pull complete
    Digest: sha256:c5515758d4c5e1e838e9cd307f6c6a0d620b5e07e6f927b07d05f6d12a1ac8d7
    Status: Downloaded newer image for hello-world:latest
 
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
 
    To generate this message, Docker took the following steps:
    1. The Docker client contacted the Docker daemon.
    2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
    4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.
 
    To try something more ambitious, you can run an Ubuntu container with:
    $ docker run -it ubuntu bash
 
    Share images, automate workflows, and more with a free Docker ID:
    https://cloud.docker.com/
 
    For more examples and ideas, visit:
    https://docs.docker.com/engine/userguide/
    ```
 
 
## 镜像加速
 
- 只要是外国的东西在国内基本都很难有好的速度，所有就有了加速器的概念，目前国内常用的如下：
- 阿里云：<https://dev.aliyun.com/search.html>
- USTC：<https://lug.ustc.edu.cn/wiki/mirrors/help/docker>
- daocloud：<http://get.daocloud.io/>
- 网易：<https://c.163.com>
- 时速云：<https://hub.tenxcloud.com/>
- 灵雀云：<https://hub.alauda.cn/>
- 推荐优先阿里云，然后是 USTC
- 我下面的讲解也是基于阿里云加速
- 阿里云的服务需要注册账号，**首次使用需要设置 docker 登录密码，这个以后用私人仓库会用到。**
    - 注册后请访问：<https://cr.console.aliyun.com/#/accelerator>，你会看到专属的加速地址，比如我是：`https://ldhc17y9.mirror.aliyuncs.com`，所以下面文章你看到该地址都表示是这个专属地址，请记得自己更换自己的。
    - 以及教你如何使用 Docker 加速器。如果你已经安装了最新版的 Docker 你就不需要用它的脚本进行安装了。
- 最新版本的 Docker 是新增配置文件：`vim /etc/docker/daemon.json`，增加如下内容：
 
``` bash
{
  "registry-mirrors": ["https://ldhc17y9.mirror.aliyuncs.com"]
}
```
 
- `sudo systemctl daemon-reload`
- `sudo systemctl restart docker`
- 在以后的生活中如果要经常使用阿里云做为自己仓库，那你还需要做：
    - 在 ` namespace管理` 中创建属于你自己的 namespace：<https://cr.console.aliyun.com/#/namespace/index>
    - 创建镜像仓库：<https://cr.console.aliyun.com/#/imageList>
        - 创建好仓库后，点击：`管理` 进入查看仓库的更多详细信息，这里面有很多有用的信息，包括一个详细的操作指南，**这份指南等下会用到。**
        - 比如我自己创建的仓库，地址是阿里云给我们的：`registry.cn-shenzhen.aliyuncs.com/youmeek/open-hub`

# Docker 命令，最终部署 Spring Boot 项目

- 建议：初期使用的时候尽量用容器 ID / 镜像 ID。如果使用 Tag/Name 在东西多的情况下很容易混乱 还不如就用记不住但是肯定唯一的容器 ID / 镜像 ID

## 重要的基本概念

- 可以代表一个完整的镜像名有两种方式：
	- REPOSITORY(仓库):TAG(标签)
		- 其中 TAG 表面上不是必须有的，本质是 docker 帮你用 latest 来代替了。latest 这里最好翻译为默认，而不是最新。
	- IMAGE ID(镜像ID)
		- 这是一个 Docker 随机给你生成 数字+字母 的字符串

## 部署一个 Spring Boot 的 Java Web 项目为例

- 宿主机环境说明：
	- IP 地址：`http://192.168.137.128`
	- 停止了防火墙：`systemctl stop firewalld.service ; systemctl stop iptables.service`
	- 停止防火墙后重启 Docker 服务：`systemctl restart docker.service`
	- JDK（jdk-8u121-linux-x64.tar.gz）、jar 应用（spring-boot-my-demo.jar），存放宿主机位置：`/opt/setups`
	- Spring Boot 的 jar 应用中配置文件给的端口是：8080，常规情况下的访问路径：`http://127.0.0.1:8080/youmeek`
- 下载镜像：`docker pull centos:6.8`，我的 IMAGE_ID 为：`0cd976dc0a98`
- 运行镜像，实例化为一个容器：`docker run -i -t -v /opt/setups:/opt 0cd976dc0a98 /bin/bash`
	- `-v：表示需要将本地宿主机的目录挂载到容器中对应的一个目录上，格式：-v <宿主机目录>:<容器目录>，所以此时对容器此目录的操作，也是等同于对宿主机的目录的操作`
- 在容器里安装 Oracle JDK 8、配置 JDK 环境变量这里不多说，具体看：[JDK 安装](https://github.com/judasn/Linux-Tutorial/blob/master/JDK-Install.md)。
- 把容器中 /opt 目录下的 spring-boot-my-demo.jar 拷贝到容器的 root 目录下：`cp /opt/spring-boot-my-demo.jar /root`
- 再容器里新建脚本：`vi /root/spring-boot-run.sh`，脚本内容如下：

``` bash
#!/bin/bash
source /etc/profile
java -jar /root/spring-boot-my-demo.jar
```

- 在容器中对新建脚本增加执行权限：`chmod u+x /root/spring-boot-run.sh`
- 我们启动另外一个终端
- 查看我们刚刚运行的容器相关信息：`docker ps -a`
	- 我们看到了我们刚刚运行的容器 ID（CONTAINER ID）为：`a5d544d9b6f9`，这个下面要用到
- 基于刚刚运行的容器创建新镜像：`docker commit a5d544d9b6f9 youmeek/springboot:0.1`
	- 查看现在的镜像库：`docker images`，会发现多了一个 youmeek/springboot 新镜像，镜像 ID 为：`7024f230fef9`
- 运行新镜像，实例化为一个容器，并启动容器中刚刚写的脚本：`docker run -d -p 38080:8080 --name springBootJar 7024f230fef9 /root/spring-boot-run.sh`
    - `-d`：表示以“守护模式”执行 spring-boot-run.sh 脚本，此时 jar 中的 log 日志不会出现在输出终端上。  
    - `-p`：表示宿主机与容器的端口映射，此时将容器内部的 8080 端口映射为宿主机的 38080 端口，这样就向外界暴露了 38080 端口，可通过 Docker 网桥来访问容器内部的 8080 端口了。  
    - `--name`：表示给新实例容器取的名称，用一个有意义的名称命名即可
- 查看其实运行的容器：`docker ps -a`，可以知道我们的新容器 ID：`fd21ac056343`，名称为：`springBootJar`
- 查看这个容器的 jar 应用的 log 输出：`docker logs -f fd21ac056343`，可以看到 jar 启动后的 log 输出内容
- 通过浏览器访问容器中的应用：`http://192.168.137.128:38080/youmeek/`，可以看到 jar 应用的首页可以访问

## Docker 基本命令
 
- 官网文档：<https://docs.docker.com/engine/reference/run/>

> 镜像仓库
 
- `docker pull`：从仓库下载镜像到本地
    - `docker pull centos:latest`：获取 CentOS 默认版本镜像
    - `docker pull centos:7.3.1611`：获取 CentOS 7 镜像，下载大小 70M 左右，下面的操作基于此镜像
    - `docker pull centos:6.8`：获取 CentOS 6 镜像
    - `docker pull registry.cn-hangzhou.aliyuncs.com/chainone/centos7-jdk8`：获取别人做好的阿里云镜像
    - 其他版本标识可以查看：<https://dev.aliyun.com/detail.html?spm=5176.1972343.2.6.EuzPCT&repoId=1198>
- `docker login`：登录到一个镜像仓库。默认登录的是官网的仓库：<https://hub.docker.com>
    - 登录阿里云仓库格式：`sudo docker login --username=阿里云邮箱 你在阿里云自己添加的仓库地址`
	    - 比如我是这个：`docker login --username=363379444@qq.com registry.cn-shenzhen.aliyuncs.com`，你完整的登录地址你需要访问：<https://cr.console.aliyun.com/#/imageList>，在你自己创建的仓库中去查看那份详细操作指南上的地址
        - 密码就是你首次访问：<https://cr.console.aliyun.com/#/accelerator>，弹窗出来让你设置的那个密码，如果忘记了重新设置下即可，重设地址：<https://cr.console.aliyun.com/#/imageList>，右上角有一个：修改docker登录密码。
- `docker push` ：将一个镜像 push 到 registry 仓库中
	- `docker push myapache:v1`
- `docker search`：从 registry 仓库搜索镜像
	- `docker search -s 3 centos`，参数 `-s 数字`：表示筛选出收藏数（stars值）大于等于 3 的镜像

> 本地镜像管理

- `docker images`：显示本地所有的镜像列表
	- 关注 REPOSITORY(名称)，TAG(标签)，IMAGE ID(镜像ID)三列
- `docker images centos`：查看具体镜像情况
- `docker rmi`：删除镜像，一般删除镜像前要先删除容器，不然如果镜像有被容器调用会报错
    - `docker rmi 容器ID`：删除具体某一个镜像
    - `docker rmi 仓库:Tag`：删除具体某一个镜像
    - `docker rmi $(docker images -q)`，删除所有镜像
- `docker tag`：为镜像打上标签
	- `docker tag -f ubuntu:14.04 ubuntu:latest`，-f 意思是强制覆盖
	- 同一个IMAGE ID可能会有多个TAG（可能还在不同的仓库），首先你要根据这些 image names 来删除标签，当删除最后一个tag的时候就会自动删除镜像；
	- `docker rmi 仓库:Tag`，取消标签（如果是镜像的最后一个标签，则会删除这个镜像）
- `docker build`：使用 Dockerfile 创建镜像（推荐）
	- `docker build --rm -t runoob/ubuntu:v1 .`，参数 `-t`，表示：-tag，打标签
- `docker history`：显示生成一个镜像的历史命令
- `docker save`：将一个镜像保存为一个 tar 包，带 layers 和 tag 信息（导出一个镜像）
    - `docker save 镜像ID -o /opt/test.tar`
- `docker load`：从一个 tar 包创建一个镜像（导入一个镜像）
    - `docker load -i /opt/test.tar`


> 容器管理操作
 
- `docker ps`：列出当前所有 **正在运行** 的容器
    - `docker ps -a`：列出所有的容器（包含历史，即运行过的容器）
    - `docker ps -l`：列出最近一次启动的container
    - `docker ps -q`：列出最近一次运行的container ID
    - `docker ps -n x`：显示最后 x 个容器，不管是正在运行或是已经停止的
- `docker inspect 容器ID`：查看容器的全面信息，用 JSON 格式输出
	- 获取容器中的 IP：`docker inspect -f '{{.NetworkSettings.IPAddress}}' 容器ID`
	- 给容器重新设置 IP 和 子网掩码，需要在宿主上：`ifconfig 容器ID 192.168.200.1 netmask 255.255.255.0`
- `docker top 容器ID`：显示容器的进程信息
- `docker events`：得到 docker 服务器的实时的事件
- `docker logs -f 容器ID`：查看容器日志
    - `docker logs 容器ID`，获取守护式容器的日志
    - `docker logs -f 容器ID`，不断监控容器日志，类似 tail -f
    - `docker logs -ft 容器ID`，在 -f 的基础上又增加 -t 表示为每条日志加上时间戳，方便调试
    - `docker logs --tail 10 容器ID`，获取日志最后 10 行
    - `docker logs --tail 0 -f 容器ID`，跟踪某个容器的最新日志而不必读取日志文件
- `docker wait` ：阻塞到一个容器，直到容器停止运行
- `docker export` ：将容器整个文件系统导出为一个tar包，不带layers、tag等信息
- `docker port` ：显示容器的端口映射
 
> 容器生命周期管理
 
- `docker run`
    - `docker run --name myDockerNameIsGitNavi -i -t centos /bin/bash`，在 centos 容器下运行 shell bash。
        - `-i -t` 分别表示保证容器中的 STDIN 开启，并分配一个伪 tty 终端进行交互，这两个是合着用。
        - `--name` 是给容器起了一个名字（如果没有主动给名字，docker 会自动给你生成一个）容器的名称规则：大小写字母、数字、下划线、圆点、中横线，用正则表达式来表达就是：[a-zA-Z0-9_*-]
        - `-d` 容器运行在后台。
        - `-p 8080:80` 表示端口映射，将宿主机的8080端口转发到容器内的80端口。
    - `docker run --rm --name myDockerNameIsGitNavi -i -t centos /bin/bash`，在 centos 容器下运行 shell bash。
		- `--rm`，表示退出即删除容器，一般用在做实验测试的时候
    - `docker run --restart=always -i -t centos /bin/bash`，--restart=always 表示停止后会自动重启
    - `docker run --restart=on-failure:5 -i -t centos /bin/bash`，--restart=on-failure:5 表示停止后会自动重启，最多重启 5 次
    - `docker run -i -t -v /opt/setups/:/opt/software/ 镜像ID /bin/bash`，启动容器，并进入 shell，同时挂载宿主机和容器的目录
        - `-v：表示需要将本地哪个目录挂载到容器中，格式：-v <宿主机目录>:<容器目录>  `
    - `docker run -v /java_logs/:/opt/ -d -p 58080:8080 --name myDockerNameIsGitNavi myCustomImageName:0.1 /root/run.sh`，运行容器中 Spring Boot 应用 
	    - `-d`：表示以“守护模式”执行/root/run.sh脚本，此时 Tomcat 控制台不会出现在输出终端上。  
	    - `-p`：表示宿主机与容器的端口映射，此时将容器内部的 8080 端口映射为宿主机的 58080 端口，这样就向外界暴露了 58080 端口，可通过 Docker 网桥来访问容器内部的 8080 端口了。  
	    - `--name`：表示容器名称，用一个有意义的名称命名即可
    - `docker run -d -p 58080:8080 --name myDockerNameIsGitNavi myCustomImageName:0.1 /root/run.sh`，运行容器中 Spring Boot 应用 
- 进入容器后退出，输入：`exit` 回车
- `docker start`，重新启动已经停止的容器
    - `docker start 容器ID`
- `docker attach`：连接上正在运行中的容器, 被 attach 上去的容器必须正在运行的才可以
	- `docker attach 容器ID`：重新进入容器终端中
- `docker stop`
- `docker restart`
- `docker kill 容器ID/容器名称`，
- `docker rm`，删除容器
    - `docker rm 容器ID`，删除指定容器（该容器必须是停止的）
    - `docker rm -f 容器ID`，删除指定容器（该容器可以是正在运行的）
    - `docker rm $(docker ps -a -q)`，删除所有容器
- `docker pause/unpause`
- `docker create`
- `docker exec`：对守护式的容器里面执行命令，方便对正在运行的容器进行维护、监控、管理
    - `docker exec -i -t 容器ID/容器名称 /bin/bash`，进入正在运行的 docker 容器，并启动终端交互
    - `docker exec -d 容器ID/容器名称 touch /opt/test.txt`，已守护式的方式进入 docker 容器，并创建一个文件
- `docker stop 容器ID/容器名称`：停止容器
- `docker commit`
	把容器打成镜像sudo docker commit a6c28e3f1ec4 ryzebo/docker-nodejs-test:0.1
	    a6c28e3f1ec4 是容器的id
	    ryzebo 是你注册的https://store.docker.com/的名字，如果你没有的话，那需要先注册
	    docker-nodejs-test 是你为该镜像起的名字
	    :0.1 是镜像的版本号，默认是latest版本
	    
    在提交镜像时指定更多的数据（包括标签）来详细描述所做的修改
    sudo docker commit -m="A new custom image" --author="James Turnbull" 4aab3ce3cb76 jamtur01/apache2:webserver
- `docker cp`：从容器里向外拷贝文件或目录
	- `docker cp Name:/container_path to_path`
	- `docker cp ID:/container_path to_path`
- `docker diff`：显示容器文件系统的前后变化
 
 
 
版本信息
 
- `docker version`，查看docker版本
- `docker info`，显示docker系统的信息
 
======================================================
 
删除老的(一周前创建)容器
 
docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs docker rm
 
docker version 查看版本号
docker pull hello-world       #下载镜像
docker images                    #查看镜像
docker ps -a   #查看当前启动的容器进程
docker ps -a -l #列出最后一次运行的容器
 
docker rm 容器ID   #移除容器
 
docker ps //查看系统中运行的docker容器
docker kill [container] //删除docker容器
docker stop [container] //停止正在运行的docker容器
docker run //运行镜像，生成容器
docker images //查看系统中存在的docker镜像
docker rmi [image] //删除镜像
docker build //生成镜像
docker pull //拉取镜像
docker push //上传镜像
docker search //搜索镜像
 
 
 
运行一个镜像
docker run -i -t -p 3000:3000 ubuntu:16.04 /bin/bash
-i 显示info级别log信息
-t 显示控制台
-p 3000:3000 把容器（下面有解释）的3000端口映射到本机3000端口
 
那就是把修改后的系统再打为iso就可以了。即，把容器再打为镜像即可。
退出容器
查看容器 docker ps -a

 
查看镜像：docker images
 
 
上传镜像
 
那么镜像想要被别人使用，就要上传到镜像管理平台，即https://store.docker.com/，就像代码要放到github一样
 
下面是上传步骤：
 
    登录docker login
 
    上传docker push ryzebo/docker-nodejs-test:0.1
 
 
    此时在https://store.docker.com/搜索ryzebo/docker-nodejs-test（搜索你自己的哦），就会看到你刚刚上传的镜像了
 
 
 
创建一个要进行修改的定制容器
sudo docker run -i -t ubuntu /bin/bash
安装apache软件包
apt-get -yqq update
apt-get -y install apache2
退出当前容器
检查新创建的镜像
sudo docker images jamtur01/apache2

使用docker inspect查看新创建的镜像详细信息
sudo docker inspect jamtur01/apache2:webserver
从提交的镜像运行一个新容器
sudo docker run -t -i jamtur01/apache2:webserver /bin/bash
 
 
 
用以下命令，根据某个“容器 ID”来创建一个新的“镜像”：
docker commit 57c312bbaad1 huangyong/javaweb:0.1
docker commit 89a47b5b749e  lin_javaweb:0.1 
docker run -d -p 58080:8080 --name javaweb huangyong/javaweb:0.1 /root/run.sh
稍作解释：
    -d：表示以“守护模式”执行/root/run.sh脚本，此时 Tomcat 控制台不会出现在输出终端上。
    -p：表示宿主机与容器的端口映射，此时将容器内部的 8080 端口映射为宿主机的 58080 端口，这样就向外界暴露了 58080 端口，可通过 Docker 网桥来访问容器内部的 8080 端口了。
    --name：表示容器名称，用一个有意义的名称命名即可。
在浏览器中，输入以下地址，即可访问 Tomcat 首页：
http://192.168.65.132:58080/
 
## Dockerfile 解释





## Dockerfile 部署

- 目标：Spring Boot 应用
- CentOS 7.3
- jar 名称：skb-user-0.0.1-SNAPSHOT.jar
- 打算用的宿主机端口：9096
- Dockerfile 文件和 jar 文件存放在宿主机目录：/opt/zch
- Dockerfile 内容如下：

``` bash
FROM java:8-jre
MAINTAINER skb-user zch <gitnavi@qq.com>

ADD skb-user-0.0.1-SNAPSHOT.jar /usr/local/skb/user/

CMD ["java", "-Xmx500m", "-jar", "/usr/local/skb/user/skb-user-0.0.1-SNAPSHOT.jar", "--spring.profiles.active=test"]

EXPOSE 9096
```

- 开始构建：
	- `cd /opt/zch`
	- `docker build . --tag="skb/user:v1.0.1"`
	- `docker run -d -p 9096:9096 -v /usr/local/logs/:/opt/ --name="skbUser1.0.0" --net=host skb/user:v1.0.1`
	- 查看启动后容器列表：`docker ps`
	- jar 应用的日志是输出在容器的 /opt 目录下，因为我们上面用了挂载，所在在我们宿主机的 /usr/local/logs 目录下可以看到输出的日志
- 防火墙开放端口：
	- `firewall-cmd --zone=public --add-port=9096/tcp --permanent`
	- `firewall-cmd --reload`









 
该文件名就叫Dockerfile,注意大小写，没有后缀，否则会报错。
 
 
Dockerfile : 脚本化创建镜像
Docker-compose：脚本化批量创建容器
 
 
用dockerfile构建镜像
并不推荐使用docker commit的方法来构建镜像，相反推荐使用Dockerfile的定义文件和docker build命令来构建镜像。Dockerfile使用基于DLS语法的指令来构建一个Docker镜像，之后使用docker build命令基于该dockerfile中的指令构建一个新的镜像。步骤：（我们将创建一个包含简单web服务器的docker镜像）
 
    创建一个目录并在里面创建初始化的Dockerfile
 
    mkdir static_web
    cd static_web
    touch Dockerfile
 
    dockerfile文件内容
 
    #第一个Dockerfile
    #Version：0.0.1
    FROM ubuntu:14.04
    MAINTAINER James Turnbull "james@example.com"
    RUN apt-get update
    RUN apt-get install -y nginx
    RUN echo 'Hi, I am in your container' > /usr/share/nginx/html/index.html
    expose 80
    dockerfile指令解释
    Docker大体按照如下流程执行Dockerfile中的指令
        Docker从基础镜像运行一个容器。
        执行一条指令，对容器做出修改。
        执行类似docker commit的操作，提交一个新的镜像层。
        Docker在基于刚提交的镜像运行一个新容器。
        执行Dockerfile中的下一条指令，直到所有指令都执行完毕。
    基于dockerfile镜像构建新镜像
    执行docker build命令时，dockerfile中的指令都会被执行并且被提交，并且在该命令成功结束后返回一个新镜像。
 
    #运行Dockerfile
    cd static_web
    sudo docker build  -t="jamtur01/static_web" .
 
    使用docker build命令来构建新镜像，通过-t为新镜像设置了仓库和名称。在本例仓库为jamtur01,镜像名为static_web。建议为自己的镜像设置合适的名字以方便追踪和管理。也可以设置标签，如：
 
    sudo docker build -t="jamtur01/static_web:v1" .
 
    上面告诉docker到本地目录中去找Dockerfile文件，也可以指定一个Git仓库的源地址来指定Dockerfile的位置。
 
    sudo docker build -t="jamtur01/static_web:v1 git@github.com:jamtur01/docker-static_web
 
忽略dockerfile的构建缓存
 
sudo docker build --no-cache -t="jamtur01/static_web"
 
查看新镜像
 
sudo docker images jamtur01/static_web
 
查看镜像如何构建出来的
 
sudo docker history22d47c8cb3jkk
 
从新镜像启动一个容器
 
sudo docker run -d -p 80 --name static_web jamtur01/static_web nginx -g "daemon off;"
 
-d:说明在后台运行
-p:控制docker在运行时应该公开哪些网络端口给宿主机,-p还可以灵活的管理容器和宿主机之间的端口映射关系
 
sudo docker run -d -p 80:80 --name static_web jamtur01/static_web nginx -g "daemon off;"
sudo docker run -d -p 8080:80 --name static_web jamtur01/static_web nginx -g "daemon off;"
#端口限制在特定的IP上
sudo docker run -d -p 127.0.0.1:8080:80 --name static_web jamtur01/static_web nginx -g "daemon off;"
 
-P:可以用来对外公开在Dockerfile中EXPOSE指令中设置的所有端口
 
sudo docker run -d -P --name static_web jamtur01/static_web nginx -g "daemon off;"
 
运行一个容器时，Docker可以通过两种方法来在宿主机上分配端口。
 
    Docker可以在宿主机上随机选择一个位于49153~65535的一个比较大的端口好来映射到容器中的80端口上。
    可以在Docker宿主机中指定一个具体的端口好来映射到容器中的80端口上。
 
查看docker端口映射情况
 
sudo docker ps -l
##指定要查看映射情况的容器ID和容器的端口号
sudo docker port container_id 80
 
 
 
 
 
 
指定基础image：`FROM <image>:<tag>`
指定镜像创建者信息：MAINTAINER <name>
 
RUN
ENTRYPOINT入口点
<!--该指令的使用分为两种情况，一种是独自使用，另一种和CMD指令配合使用。
当独自使用时，如果你还使用了CMD命令且CMD是一个完整的可执行的命令，那么CMD指令和ENTRYPOINT会互相覆盖只有最后一个CMD或者ENTRYPOINT有效。
另一种用法和CMD指令配合使用来指定ENTRYPOINT的默认参数，这时CMD指令不是一个完整的可执行命令，仅仅是参数部分；
ENTRYPOINT指令只能使用JSON方式指定执行命令，而不能指定参数。-->
 
CMD
ENV <key> <value>
ENV <key1>=<value1> <key2>=<value2>
WORKDIR 指定工作目录
USER 指定当前用户
指定容器需要映射到宿主机器的端口
EXPOSE <port> [<port>...]
映射一个端口
EXPOSE port1
相应的运行容器使用的命令
docker run -p port1 image
映射多个端口
EXPOSE port1 port2 port3
相应的运行容器使用的命令
docker run -p port1 -p port2 -p port3 image
还可以指定需要映射到宿主机器上的某个端口号
docker run -p host_port1:port1 -p host_port2:port2 -p host_port3:port3 image
 
 
从src复制文件到container的dest路径
COPY <src> <dest>
ADD <src> <dest>
<src> 是相对被构建的源目录的相对路径，可以是文件或目录的路径，也可以是一个远程的文件url,如果是压缩包会被自动解压。
<dest> 是container中的绝对路径s
 
 
指定挂载点
//设置指令，使容器中的一个目录具有持久化存储数据的功能，该目录可以被容器本身使用，也可以共享给其他容器使用。
VOLUME ["<mountpoint>"]
eg:
VOLUME ["/tmp/data"]
 
 
切换目录
WORKDIR /path/to/workdir
在 /p1/p2 下执行 vim a.txt
WORKDIR /p1 WORKDIR p2 RUN vim a.txt
 
在子镜像中执行
ONBUILD <Dockerfile关键字>
 
 
创建 Dockerfile 到 push 的一个证过程：<http://www.jianshu.com/p/6cadb5b722ac>
 
docker-compose 管理多个容器
 
然后build该Dockerfile为一个镜像
docker build --rm --no-cache=true -t docker-node-test .
 
    -t 设定镜像名字 docker-node-test
    --rm 如果已存在docker-node-test镜像，则删除docker-node-test镜像
    --no-cache=true build时，禁止缓存
 
 
Dockerfile其它指令可以在官网查看https://docs.docker.com/engine/reference/builder/
 
FROM , 从一个基础镜像构建新的镜像
 
FROM ubuntu
MAINTAINER , 维护者信息
 
MAINTAINER William
ENV , 设置环境变量
 
ENV TEST 1
RUN , 非交互式运行shell命令
 
RUN apt-get -y update
 
RUN apt-get -y install nginx
ADD , 将外部文件拷贝到镜像里,src可以为url
 
ADD http://nicescale.com/  /data/nicescale.tgz
WORKDIR /path/to/workdir, 设置工作目录
 
WORKDIR /var/www
USER , 设置用户ID
 
USER nginx
VULUME <#dir>, 设置volume
 
VOLUME [‘/data’]
EXPOSE , 暴露哪些端口
 
EXPOSE 80 443
ENTRYPOINT [‘executable’, ‘param1’,’param2’]执行命令
 
ENTRYPOINT ["/usr/sbin/nginx"]
CMD [“param1”,”param2”]
 
CMD ["start"]
 
docker创建、启动container时执行的命令，如果设置了ENTRYPOINT，则CMD将作为参数
Dockerfile最佳实践
 
尽量将一些常用不变的指令放到前面
 
CMD和ENTRYPOINT尽量使用json数组方式
通过Dockerfile构建image
 
docker build csphere/nginx:1.7 .
镜像仓库Registry
 
镜像从Dockerfile build生成后，需要将镜像推送(push)到镜像仓库。企业内部都需要构建一个私有docker registry，这个registry可以看作二进制的scm，CI/CD也需要围绕registry进行。
部署registry
 
mkdir /registry
 
docker run  -p 80:5000  -e STORAGE_PATH=/registry  -v /registry:/registry  registry:2.0
推送镜像保存到仓库
 
假设192.168.1.2是registry仓库的地址：
 
docker tag  csphere/nginx:1.7 192.168.1.2/csphere/nginx:1.7
 
docker push 192.168.1.2/csphere/nginx:1.7
 
 
 
## 编排工具
 
Kubernetes
安装kubernetes，访问不了gcr.io怎么办？
http://www.datastart.cn/tech/2017/04/07/k8s-mirror.html
http://www.datastart.cn/tech/2017/02/20/k8s-deploy.html
 
Marathon
 
## 资料
 
- <https://yeasy.gitbooks.io/docker_practice/content/>
- <https://www.zhihu.com/question/28300645>
- <http://www.jianshu.com/p/8f3d508b83bd>
- <http://java.dzone.com/articles/5-key-benefits-docker-ci>
- <http://www.jianshu.com/p/6cadb5b722ac>
- <http://www.datastart.cn/tech/2016/09/28/docker-mirror.html>
- <http://www.jianshu.com/p/81291d66740f>
- <http://www.jianshu.com/p/d1f5ac9f9d4e>
- <http://www.jianshu.com/p/ae07706c419e>
- <>
- <>
- <>
- <>
 
 
======================================================
 
1.弄懂镜像的含义
2.弄懂容器的含义
    - 交互式容器：sudo docker run -it centos:6 /bin/bash
            - -it 表示创建交互式容器
    - centos:6 以仓库:Tag的形式指定镜像名称
    - /bin/bash 是容器对应的进程
    - 守护式容器：sudo docker run -d 镜像名
 
sudo docker ps 查看已经运行过容器的基本信息
sudo docker stop 容器ID，停止守护式容器
sudo service docker restart，重启 docker 服务，当修改了 docker 相关的一些配置
sudo docker rm 容器ID，删除容器

 
 
创建镜像：创建dockerfile，然后进行 build，
 
常规下，容器重启之后，容器的IP地址是会自动变的，所以一般容器互联一般不用IP，而是在启动 docker 容器的时候附加一个参数：--link=容器名:我们要给这个要连接的容器创建的别名
 
 
 
 
 
视频教程：
http://www.jikexueyuan.com/path/docker/
 
ubuntu下的安装
视频教程：http://www.jikexueyuan.com/course/832_2.html?ss=1
官网文档：http://docs.docker.com/installation/ubuntulinux/
网络文章：http://segmentfault.com/a/1190000002485231
 
1.检查内涵版本，linux内核建议是3.8以后的，Ubuntu 12.04.3及以上版本的默认内核是3.8.0 x86_64，所以ubuntu12之后的版本都不用担心
运行命令：uname -a
2.检查Device Mapper是否存在（Ubuntu 12.04 以上都装好了）
运行命令：ls -l /sys/class/misc/device-mapper，有输出内容就表示存在
 
Docker有很多种安装的选择，我们推荐您在Ubuntu下面安装，因为docker是在Ubuntu下面开发的，安装包测试比较充分，可以保证软件包的可用性。Mac, windows和其他的一些linux发行版本无法原生运行Docker，可以使用虚拟软件创建一个ubuntu的虚拟机并在里面运行docker。
 
官网说明： 支持 Ubuntu 12.04 以上版本
https://docs.docker.com/linux/step_one/
$ sudo apt-get update
$ sudo apt-get install -y curl
$ curl -fsSL https://get.docker.com/ | sh
安装后，查看下docker版本，检查是否安装成功：
$ sudo docker version
 
看docker运行状态：sudo service docker status
 
sudo docker run hello-world
这个命令会下载一个测试用的镜像并启动一个容器运行它。
 
 
去除掉sudo
在Ubuntu下，在执行Docker时，每次都要输入sudo，同时输入密码，很累人的，这里微调一下，把当前用户执行权限添加到相应的docker用户组里面。
# 添加一个新的docker用户组
sudo groupadd docker
# 添加当前用户到docker用户组里，注意这里的yongboy为ubuntu server登录用户名
sudo gpasswd -a yongboy docker
# 重启Docker后台监护进程
sudo service docker restart
# 重启之后，尝试一下，是否生效
docker version
#若还未生效，则系统重启，则生效
sudo reboot
 
 
=================================
 
帮助命令：docker --help
http://www.jingyuyun.com/article/11068.html
 
搜索镜像：docker search 镜像名
 
下载镜像
docker pull ubuntu命令，先将Ubuntu镜像下载到本地，默认使用的镜像标签是latest。
 
下载国内镜像加速：
http://dashboard.daocloud.io/mirror
http://dashboard.daocloud.io/nodes/new
拉取centos镜像：dao pull centos:6.8
 
https://help.aliyun.com/knowledge_detail/5974865.html
dockone.io/article/646
http://blog.csdn.net/bwlab/article/details/50542261
http://devdd.sinaapp.com/post-724.html
http://www.imike.me/2016/04/20/Docker%E4%B8%8B%E4%BD%BF%E7%94%A8%E9%95%9C%E5%83%8F%E5%8A%A0%E9%80%9F/
 
 
容器命名
docker run --name 容器名字 -i -t ubuntu /bin/bash
 
运行镜像：
然后再运行docker run -i -t ubuntu /bin/bash，
在镜像中安装ping工具：docker run learn/tutorial apt-get install -y ping
 
保存在镜像中的修改，变动：
http://www.docker.org.cn/book/docker/docer-save-changes-10.html
 
退出镜像：exit
docker ps -a来查看当前系统中的容器列表：
删除容器：docker rm
 
在镜像中安装SSH，方便管理：
http://www.jingyuyun.com/article/11134.html
 
 
docker 修改镜像地址
 
=================================
windows下的安装：（由于docker底层用了linux的技术，所以目前windows下的环境，其实本质也是有一个linux虚拟机，所以不建议在windows下使用）
http://www.jikexueyuan.com/course/832_3.html?ss=1
 
 
技术资料
 
docker中文官网：http://www.docker.org.cn/
中文入门课程：http://www.docker.org.cn/book/docker.html
docker学习笔记：http://www.open-open.com/lib/view/open1423703640748.html
深入浅出docker：http://www.infoq.com/cn/articles/docker-core-technology-preview
https://www.zybuluo.com/SailorXiao/note/327656