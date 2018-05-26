 
 
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
 
> **Docker Enterprise Edition (Docker EE)** is designed for enterprise development and IT teams who build, ship, and run business critical applications in production at scale. Docker EE is integrated, certified, and supported to provide enterprises with the most secure container platform in the industry to modernize all applications. For more information about Docker EE, including purchasing options, see Docker Enterprise Edition.
**Docker Community Edition (Docker CE)** is ideal for developers and small teams looking to get started with Docker and experimenting with container-based apps. Docker CE is available on many platforms, from desktop to cloud to server. Docker CE is available for macOS and Windows and provides a native experience to help you focus on learning Docker. You can build and share containers and automate the development pipeline all from a single environment.
Docker CE has both stable and edge channels.
    Stable builds are released once per quarter and are supported for 4 months.
    Edge builds are released once per month, and are supported for that month only. If you subscribe to the Edge channel on Linux distributions, you should also subscribe to the Stable channel.
 
 
- 官网总的安装手册：<https://docs.docker.com/engine/installation/#docker-editions>
- 官网 CentOS 安装手册：<https://docs.docker.com/engine/installation/linux/centos/>
- 目前也支持 Windows，特别是 Windows 10，直接官网一个安装包即可搞定。
- Windows 10 的 Docker 安装说明：<https://store.docker.com/editions/community/docker-ce-desktop-windows>
- 我这里选择 Docker CE 版本：
- CentOS 安装过程：
    - `sudo yum install -y yum-utils device-mapper-persistent-data lvm2`
    - 添加 repo（可能网络会很慢，有时候会报：Timeout，所以要多试几次）
    - `sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`
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
- 阿里云的服务需要注册账号，**首次使用需要设置 docker 登录密码（阿里云叫做：**修改Registry登录密码**），这个以后用私人仓库会用到。**
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
        - 那我登录这个镜像地址的方式：

```
docker login registry.cn-shenzhen.aliyuncs.com
会让我输入
Username：阿里云邮箱
password：上文提到的--Registry登录密码
```

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

 
#### 版本信息
 
- `docker version`，查看docker版本
- `docker info`，显示docker系统的信息

#### 镜像仓库
 
- `docker pull`：从仓库下载镜像到本地
    - `docker pull centos:latest`：获取 CentOS 默认版本镜像
    - `docker pull centos:7.3.1611`：获取 CentOS 7 镜像，下载大小 70M 左右，下面的操作基于此镜像
    - `docker pull centos:6.8`：获取 CentOS 6 镜像
    - `docker pull registry.cn-hangzhou.aliyuncs.com/chainone/centos7-jdk8`：获取别人做好的阿里云镜像
- `docker push`：将一个镜像 push 到 registry 仓库中
	- `docker push myapache:v1`
- `docker search`：从 registry 仓库搜索镜像
	- `docker search -s 3 centos`，参数 `-s 数字`：表示筛选出收藏数（stars值）大于等于 3 的镜像
- `docker login`：登录到一个镜像仓库。默认登录的是官网的仓库：<https://hub.docker.com>
    - 登录阿里云仓库格式：`sudo docker login --username=阿里云邮箱`
	    - 比如我是这个：`docker login --username=23333212@qq.com registry.cn-shenzhen.aliyuncs.com`，你完整的登录地址你需要访问：<https://cr.console.aliyun.com/#/imageList>，在你自己创建的仓库中去查看那份详细操作指南上的地址
        - 密码就是你首次访问：<https://cr.console.aliyun.com/#/accelerator>，弹窗出来让你设置的那个密码，如果忘记了重新设置下即可，重设地址：<https://cr.console.aliyun.com/#/imageList>，右上角有一个：修改docker登录密码。

#### 本地镜像管理

- `docker stats`：查看当前启动的容器各自占用的系统资源
	- `bin docker stats --no-stream kafkadocker_kafka_1 kafkadocker_zookeeper_1`：查看指定容器的占用资源情况
	- 更加高级的监控方式有一个软件叫做：ctop（推荐使用）：<https://github.com/bcicen/ctop>
	
```
CONTAINER ID        NAME                      CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
4532a9ee27b8        cloud-cadvisor            1.49%               53.28MiB / 3.702GiB   1.41%               13.5MB / 646MB      265MB / 0B          19
3895d5d50a5e        kafkadocker_kafka_1       1.45%               1.24GiB / 3.702GiB    33.51%              145MB / 186MB       499MB / 724MB       128
1d1a6a7c48d8        kafkadocker_zookeeper_1   0.11%               70.85MiB / 3.702GiB   1.87%               55.8MB / 33.7MB     209MB / 1.22MB      23
```

- `docker images`：显示本地所有的镜像列表
	- 关注 REPOSITORY(名称)，TAG(标签)，IMAGE ID(镜像ID)三列
- `docker images centos`：查看具体镜像情况
- `docker rmi`：删除镜像，一般删除镜像前要先删除容器，不然如果镜像有被容器调用会报错
    - `docker rmi 容器ID`：删除具体某一个镜像
    - `docker rmi 仓库:Tag`：删除具体某一个镜像
    - `docker rmi $(docker images -q)`，删除所有镜像
    - `docker rmi -f $(docker images -q)`，强制删除所有镜像
- `docker tag`：为镜像打上标签
	- `docker tag -f ubuntu:14.04 ubuntu:latest`，-f 意思是强制覆盖
	- 同一个IMAGE ID可能会有多个TAG（可能还在不同的仓库），首先你要根据这些 image names 来删除标签，当删除最后一个tag的时候就会自动删除镜像；
	- `docker rmi 仓库:Tag`，取消标签（如果是镜像的最后一个标签，则会删除这个镜像）
- `docker build`：使用 Dockerfile 创建镜像（推荐）
	- `docker build . --rm -t runoob/ubuntu:v1`，参数 `-t`，表示：-tag，打标签
	- 多次 docker build 过程中是有依赖一个缓存的过程的，一般 build 过程都有好几个 step，Docker 非常聪明，会自己判断那些没有被修改过程的 step 采用缓存。如果想要避免使用缓存，可以使用这样命令 **--no-cache**：`docker build --no-cache . --rm -t runoob/ubuntu:v1`
- `docker history`：显示生成一个镜像的历史命令，可以看出这个镜像的构建过程，包括：每一层镜像的 ID、指令
- `docker save`：将一个镜像保存为一个 tar 包，带 layers 和 tag 信息（导出一个镜像）
    - `docker save 镜像ID -o /opt/test.tar`
- `docker load`：从一个 tar 包创建一个镜像（导入一个镜像）
    - `docker load -i /opt/test.tar`


#### 容器生命周期管理
 
- `docker run`，运行镜像
    - `docker run -v /java_logs/:/opt/ -d -p 8080:80 --name myDockerNameIsGitNavi -i -t 镜像ID /bin/bash`
        - `-i -t` 分别表示保证容器中的 STDIN 开启，并分配一个伪 tty 终端进行交互，这两个是合着用。
        - `--name` 是给容器起了一个名字（如果没有主动给名字，docker 会自动给你生成一个）容器的名称规则：大小写字母、数字、下划线、圆点、中横线，用正则表达式来表达就是：[a-zA-Z0-9_*-]
        - `-d` 容器运行在后台。
        - `-p 8080:80` 表示端口映射，将宿主机的8080端口转发到容器内的80端口。（如果是 -P 参数，则表示随机映射应该端口，一般用在测试的时候）
        - `-v /java_logs/:/opt/` 表示目录挂载，/java_logs/ 是宿主机的目录，/opt/ 是容器目录
    - `docker run --rm --name myDockerNameIsGitNavi -i -t centos /bin/bash`，--rm，表示退出即删除容器，一般用在做实验测试的时候
    - `docker run --restart=always -i -t centos /bin/bash`，--restart=always 表示停止后会自动重启
    - `docker run --restart=on-failure:5 -i -t centos /bin/bash`，--restart=on-failure:5 表示停止后会自动重启，最多重启 5 次
- `docker exec`：对守护式的容器里面执行命令，方便对正在运行的容器进行维护、监控、管理
    - `docker exec -i -t 容器ID /bin/bash`，进入正在运行的 docker 容器，并启动终端交互
    - `docker exec -d 容器ID touch /opt/test.txt`，已守护式的方式进入 docker 容器，并创建一个文件
- `docker stop 容器ID`，停止容器
    - `docker stop $(docker ps -a -q)`，停止所有容器
    - `docker kill $(docker ps -q) ; docker rm $(docker ps -a -q)`，停止所有容器，并删除所有容器
- `docker start 容器ID`，重新启动已经停止的容器（重新启动，docker run 参数还是保留之前的）
- `docker restart 容器ID`，重启容器
- `docker rm`，删除容器
    - `docker rm 容器ID`，删除指定容器（该容器必须是停止的）
    - `docker rm -f 容器ID`，删除指定容器（该容器如果正在运行可以这样删除）
    - `docker rm $(docker ps -a -q)`，删除所有容器
    - `docker rm -f $(docker ps -a -q)`，强制删除所有容器
	- `docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs docker rm` 删除老的(一周前创建)容器
	- `docker kill $(docker ps -q) ; docker rm $(docker ps -a -q) ; docker rmi $(docker images -q -a)` 停止所有容器，删除所有容器，删除所有镜像
- `docker commit`，把容器打成镜像
	- `docker commit 容器ID gitnavi/docker-nodejs-test:0.1`
		- gitnavi 是你注册的 https://store.docker.com/ 的名字，如果你没有的话，那需要先注册
		- docker-nodejs-test 是你为该镜像起的名字
		- 0.1 是镜像的版本号，默认是 latest 版本
    - `docker commit -m="这是一个描述信息" --author="GitNavi" 容器ID gitnavi/docker-nodejs-test:0.1`
	    - 在提交镜像时指定更多的数据（包括标签）来详细描述所做的修改
- `docker diff 容器ID`：显示容器文件系统的前后变化
- `--link` 同一个宿主机下的不同容器的连接：
	- `docker run -it 镜像ID --link redis-name:myredis /bin/bash`
		- `redis-name` 是容器名称
		- `myredis` 是容器别名，其他容器连接它可以用这个别名来写入到自己的配置文件中
- `--network` docker 网络模式：
	- bridge 默认模式，在 docker0 的网桥上创建新网络栈，确保独立的网络环境，实现网络隔离：`docker run -it 镜像ID --network=bridge /bin/bash`
	- none 不适用网卡，无法联网：`docker run -it 镜像ID --network=none /bin/bash`
	- host 使用宿主机网络 IP、端口联网：`docker run -it 镜像ID --network=host /bin/bash`
	- 自定义-使用自己命名的网络栈，但是需要手动配置网卡、IP 信息：`docker run -it 镜像ID --network=自定义名称 /bin/bash`

#### 容器管理操作
 
- `docker ps`：列出当前所有 **正在运行** 的容器
    - `docker ps -a`：列出所有的容器（包含历史，即运行过的容器）
    - `docker ps -l`：列出最近一次启动的container
    - `docker ps -q`：列出最近一次运行的container ID
    - `docker ps -a -l`：列出最后一次运行的容器
    - `docker ps -n x`：显示最后 x 个容器，不管是正在运行或是已经停止的
- `docker top 容器ID`：显示容器的进程信息
- `docker events`：得到 docker 服务器的实时的事件
- `docker logs -f 容器ID`：查看容器日志（如果一些容器不断重启，或是自动停止，可以这样看下）
    - `docker logs 容器ID`，获取守护式容器的日志
    - `docker logs -f 容器ID`，不断监控容器日志，类似 tail -f
    - `docker logs -ft 容器ID`，在 -f 的基础上又增加 -t 表示为每条日志加上时间戳，方便调试
    - `docker logs --tail 10 容器ID`，获取日志最后 10 行
    - `docker logs --tail 0 -f 容器ID`，跟踪某个容器的最新日志而不必读取日志文件
    - `docker logs -f -t --since="2018-05-26" --tail=200 容器ID` 根据某个时间读取日志
    - `docker logs -f -t --since="2018-05-26T11:13:40" --tail=200 容器ID` 根据某个时间读取日志
    - `docker logs -f -t --since="2018-05-25T11:13:40" --until "2018-05-26T11:13:40" --tail=200 容器ID` 根据某个时间读取日志
    - `docker logs --since 10m 容器ID` 查看最近 10 分钟的日志
        - `-f` : 表示查看实时日志 
        - `-t` : 显示时间戳
        - `-since` : 显示某个开始时间的所有日志
        - `-tail=200` : 查看最后的 200 条日志
- `docker wait`，阻塞到一个容器，直到容器停止运行
- `docker export`，将容器整个文件系统导出为一个tar包，不带layers、tag等信息
- `docker port`，显示容器的端口映射
- `docker inspect 容器ID`：查看容器的全面信息，用 JSON 格式输出

```
获取容器中的 IP：docker inspect -f {{.NetworkSettings.IPAddress}} 容器ID
获取容器中的 IP：docker inspect -f {{.Volumes}} 容器ID
查看容器的挂载情况：docker inspect 容器ID | grep Mounts -A 10
```

- 下面为一个 docker inspect 后的结果示例：

```json
[
    {
        "Id": "e1dff77b99d9c8489e0a0ce68a19ec5ffe18cc5d8b8ec17086f7f7bea29aa09b",
        "Created": "2018-01-18T03:47:16.138180181Z",
        "Path": "docker-entrypoint.sh",
        "Args": [
            "--auth"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 19952,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2018-01-18T03:47:16.348568927Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:42aa46cfbd7a0d1101311defac39872b447b32295b40f9c99104ede5d02e9677",
        "ResolvConfPath": "/var/lib/docker/containers/e1dff77b99d9c8489e0a0ce68a19ec5ffe18cc5d8b8ec17086f7f7bea29aa09b/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/e1dff77b99d9c8489e0a0ce68a19ec5ffe18cc5d8b8ec17086f7f7bea29aa09b/hostname",
        "HostsPath": "/var/lib/docker/containers/e1dff77b99d9c8489e0a0ce68a19ec5ffe18cc5d8b8ec17086f7f7bea29aa09b/hosts",
        "LogPath": "/var/lib/docker/containers/e1dff77b99d9c8489e0a0ce68a19ec5ffe18cc5d8b8ec17086f7f7bea29aa09b/e1dff77b99d9c8489e0a0ce68a19ec5ffe18cc5d8b8ec17086f7f7bea29aa09b-json.log",
        "Name": "/cas-mongo",
        "RestartCount": 0,
        "Driver": "overlay",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": [
                "/data/mongo/db:/data/db"
            ],
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {
                "27017/tcp": [
                    {
                        "HostIp": "",
                        "HostPort": "27017"
                    }
                ]
            },
            "RestartPolicy": {
                "Name": "always",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "shareable",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DiskQuota": 0,
            "KernelMemory": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": 0,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay/0ab08b1f9c8f5f70cdcac2b01d9ee31de9e5a4955003567573635e8837931249/root",
                "MergedDir": "/var/lib/docker/overlay/4d6bb0d57f3f1b1dcf98c70b4bee4abf8dc110c7efa685ee5d84fe6f58c07b63/merged",
                "UpperDir": "/var/lib/docker/overlay/4d6bb0d57f3f1b1dcf98c70b4bee4abf8dc110c7efa685ee5d84fe6f58c07b63/upper",
                "WorkDir": "/var/lib/docker/overlay/4d6bb0d57f3f1b1dcf98c70b4bee4abf8dc110c7efa685ee5d84fe6f58c07b63/work"
            },
            "Name": "overlay"
        },
        "Mounts": [
            {
                "Type": "volume",
                "Name": "6cd9721ff6a2768cd20e4a0678b176fa81a5de1c7d21fe6212b50c6854196db2",
                "Source": "/var/lib/docker/volumes/6cd9721ff6a2768cd20e4a0678b176fa81a5de1c7d21fe6212b50c6854196db2/_data",
                "Destination": "/data/configdb",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            },
            {
                "Type": "bind",
                "Source": "/data/mongo/db",
                "Destination": "/data/db",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }
        ],
        "Config": {
            "Hostname": "e1dff77b99d9",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "27017/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "GOSU_VERSION=1.7",
                "GPG_KEYS=0C49F3730359A14518585931BC711F9BA15703C6",
                "MONGO_PACKAGE=mongodb-org",
                "MONGO_REPO=repo.mongodb.org",
                "MONGO_MAJOR=3.4",
                "MONGO_VERSION=3.4.10"
            ],
            "Cmd": [
                "--auth"
            ],
            "Image": "mongo:3.4",
            "Volumes": {
                "/data/configdb": {},
                "/data/db": {}
            },
            "WorkingDir": "",
            "Entrypoint": [
                "docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {}
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "7eabf418238f4d9f5fd5163fd4d173bbaea7764687a5cf40a9757d42b90ab2f9",
            "HairpinMode": false,
            "Link                                                            LocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "27017/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "27017"
                    }
                ]
            },
            "SandboxKey": "/var/run/docker/netns/7eabf418238f",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "11c8d10a4be63b4ed710add6c440adf9d090b71918d4aaa837c46258e5425b80",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "ada97659acda146fc57e15a099e430a6e97de87f6d043b91d4c3582f6ab52d47",
                    "EndpointID": "11c8d10a4be63b4ed710add6c440adf9d090b71918d4aaa837c46258e5425b80",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
```

## Docker 容器产生的 log 位置

- Docker 运行一段时间，如果你的容器有大量的输出信息，则这个 log 文件会非常大，所以要考虑清理。
- log 位置：`/var/lib/docker/containers/容器ID值/容器ID值-json.log`
- 可以考虑在停到容器的时候备份这个文件到其他位置，然后：`echo > 容器ID值-json.log`
- 当然，官网也提供了自动化的方案：<https://docs.docker.com/config/containers/logging/json-file/>
	- 修改 Docker 是配置文件：`vim /etc/docker/daemon.json`，（如果没有这个文件，自己新增）增加如下内容：
 
``` bash
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "5"
  }
}
```

- 如果你已经有该文件文件莱使用国内源，那修改方案应该是这样的：
 
``` bash
{
	"registry-mirrors": ["https://ldhc17y9.mirror.aliyuncs.com"],
	"log-driver": "json-file",
	"log-opts": {
		"max-size": "10m",
	    "max-file": "5"
	}
}
```

## 删除 Docker 镜像中为 none 的镜像

- Dockerfile 代码更新频繁，自然 docker build 构建同名镜像也频繁的很，产生了众多名为 none 的无用镜像


```
docker rmi $(docker images -f "dangling=true" -q)
```

## Docker daemon.json 可配置参数

- <https://docs.docker.com/engine/reference/commandline/dockerd/>


## Dockerfile 解释

- 该文件名就叫 Dockerfile，注意大小写，没有后缀，否则会报错。
- 主要由下面几个部分组成：
	- 基础镜像信息
	- 维护者/创建者信息
	- 镜像操作指令
	- 容器启动时执行执行
- 注释符号：`# 这是一段注释说明`
- 常用指令关键字：
	- `FROM`，基础镜像信息
	- `MAINTAINER`，维护者/创建者信息
	- `ADD`，添加文件。如果添加的文件是类似 tar.gz 压缩包，会自动解压。
		- 特别注意的是：ADD 文件到镜像的地址如果是目录，则需要最后保留斜杠，比如：`ADD test.tar.gz /opt/shell/`。不是斜杠结尾会认为是文件。
		- 添加文件格式：`ADD test.sh /opt/shell/test.sh`
		- 添加压缩包并解压格式：`ADD test.tar.gz /opt/shell/`，该压缩包会自动解压在 /opt/shell 目录下
	- `COPY`，类似 ADD，只是 COPY 只是复制文件，不会做类似解压压缩包这种行为。
		- `COPY /opt/conf/ /etc/` 把宿主机的 /opt/conf 下文件复制到镜像的 /etc 目录下。
	- `WORKDIR`，设置工作目录，可以理解为类似 cd 命令，表示现在在某个目录路径，然后下面的 CMD、ENTRYPOINT 操作都是基于此目录
	- `VOLUME`，目录挂载
	- `EXPOSE`，暴露端口
	- `USER`，指定该镜像以什么用户去运行，也可以用这个来指定：`docker run -u root`。不指定默认是 root
	- `ENV`，定义环境变量，该变量可以在后续的任何 RUN 指令中使用，使用方式：$HOME_DIR。在 docker run 的时候可以该方式来覆盖变量值 `docker run -e “HOME_DIR=/opt”`
	- `RUN`，执行命令并创建新的镜像层，RUN 经常用于安装软件包
	- `CMD`，执行命令，并且一个 Dockerfile 只能有一条 CMD，有多条的情况下最后一条有效。在一种场景下 CMD 命令无效：docker run 的时候也指定了相同命令，则 docker run 命令优先级最高
	- `ENTRYPOINT`，配置容器启动时运行的命令，不会被 docker run 指令覆盖，并且 docker run 的指令可以作为参数传递到 ENTRYPOINT 中。要覆盖 ENTRYPOINT 命令也是有办法的：docker run --entrypoint 方式。Dockerfile 同时有 CMD 和 ENTRYPOINT 的时候，CMD 的指令是作为参数传递给 ENTRYPOINT 使用。
		- 特别注意：RUN、CMD 和 ENTRYPOINT 这三个 Dockerfile 指令看上去很类似，很容易混淆。
		- 最佳实战：[来源](https://www.ibm.com/developerworks/community/blogs/132cfa78-44b0-4376-85d0-d3096cd30d3f/entry/RUN_vs_CMD_vs_ENTRYPOINT_%E6%AF%8F%E5%A4%A95%E5%88%86%E9%92%9F%E7%8E%A9%E8%BD%AC_Docker_%E5%AE%B9%E5%99%A8%E6%8A%80%E6%9C%AF_17?lang=en_us)
			- 使用 RUN 指令安装应用和软件包，构建镜像。
			- 如果 Docker 镜像的用途是运行应用程序或服务，比如运行一个 MySQL，应该优先使用 Exec 格式的 ENTRYPOINT 指令。CMD 可为 ENTRYPOINT 提供额外的默认参数，同时可利用 docker run 命令行替换默认参数。
			- 如果想为容器设置默认的启动命令，可使用 CMD 指令。用户可在 docker run 命令行中替换此默认命令。


## Dockerfile 部署 Spring Boot 应用

- jar 名称：skb-user-0.0.1-SNAPSHOT.jar
- 打算用的宿主机端口：9096
- Dockerfile 文件和 jar 文件存放在宿主机目录：/opt/zch
- Dockerfile 内容如下：

``` bash
FROM java:8-jre
MAINTAINER skb-user zch <gitnavi@qq.com>

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD skb-user-0.0.1-SNAPSHOT.jar /usr/local/skb/user/

CMD ["java", "-Xmx500m", "-jar", "/usr/local/skb/user/skb-user-0.0.1-SNAPSHOT.jar", "--spring.profiles.active=test"]

EXPOSE 9096
```

- 开始构建：
	- `cd /opt/zch`
	- `docker build . --tag="skb/user:v1.0.1"`
		- 因为 build 过程中会有多层镜像 step 过程，所以如果 build 过程中失败，那解决办法的思路是找到 step 失败的上一层，成功的 step 中镜像 ID。然后 docker run 该镜像 ID，手工操作，看报什么错误，然后就比较清晰得了解错误情况了。
	- `docker run -d -p 9096:9096 -v /usr/local/logs/:/opt/ --name="skbUser1.0.0" skb/user:v1.0.1`
	- 查看启动后容器列表：`docker ps`
	- jar 应用的日志是输出在容器的 /opt 目录下，因为我们上面用了挂载，所在在我们宿主机的 /usr/local/logs 目录下可以看到输出的日志
- 防火墙开放端口：
	- `firewall-cmd --zone=public --add-port=9096/tcp --permanent`
	- `firewall-cmd --reload`
- 解释：

```
# 是为了解决容器的时区和宿主机不一致问题
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
```


## Docker Compose

- Docker Compose 主要用于定义和运行多个 Docker 容器的工具，这样可以快速运行一套分布式系统
	- 容器之间是有依赖关系，比如我一个 Java web 系统依赖 DB 容器、Redis 容器，必须这些依赖容器先运行起来。
- 一个文件：docker-compose.yml
- 一个命令：docker-compose up
- 官网安装说明：<https://docs.docker.com/compose/install/#install-compose>
- 安装方法：

```
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

```

- 检查是否安装成功：`docker-compose --version`，输出：`docker-compose version 1.18.0, build 8dd22a9`
- 常用命令：
	- 运行：`docker-compose up -d`
	- 停止运行：`docker-compose down`
	- 查看容器：`docker-compose ps`
	- 删除停止的服务容器：`docker-compose rm`

## Docker Swarm

- Docker Swarm 是一个 Docker 集群管理工具

## Kubernetes

- 目前流行的容器编排系统
- 简称：K8S
- 官网：<https://kubernetes.io/>
- 主要解决几个问题：
	- `调度`
	- `生命周期及健康状况`
	- `服务发现`
	- `监控`
	- `认证`
	- `容器聚合`
- 主要角色：Master、Node

#### 主要概念

- `Pods`

```
创建，调度以及管理的最小单元
共存的一组容器的集合
容器共享PID，网络，IPC以及UTS命名空间
容器共享存储卷
短暂存在
```

- `Volumes`

```
数据持久化
Pod中容器共享数据
生命周期
支持多种类型的数据卷 – emptyDir, hostpath, gcePersistentDisk, awsElasticBlockStore, nfs, iscsi, glusterfs, secrets
```

- `Labels`

```
用以标示对象（如Pod）的key/value对
组织并选择对象子集
```

- `Replication Controllers`

```
确保在任一时刻运行指定数目的Pod
容器重新调度
规模调整
在线升级
多发布版本跟踪
```

- `Services`

```
抽象一系列Pod并定义其访问规则
固定IP地址和DNS域名
通过环境变量和DNS发现服务
负载均衡
外部服务 – ClusterIP, NodePort, LoadBalancer
```


#### 主要组成模块

- `etcd`

```
高可用的Key/Value存储
只有apiserver有读写权限
使用etcd集群确保数据可靠性
```

- `apiserver`

```
Kubernetes系统入口， REST
认证
授权
访问控制
服务帐号
资源限制
```

- `kube-scheduler`

```
资源需求
服务需求
硬件/软件/策略限制
关联性和非关联性
数据本地化
```

- `kube-controller-manager`

```
Replication controller
Endpoint controller
Namespace controller
Serviceaccount controller
```

- `kubelet`

```
节点管理器
确保调度到本节点的Pod的运行和健康
```

- `kube-proxy`

```
Pod网络代理
TCP/UDP请求转发
负载均衡（Round Robin）
```

- `服务发现`

```
环境变量
DNS – kube2sky， etcd，skydns
```

- `网络`

```
容器间互相通信
节点和容器间互相通信
每个Pod使用一个全局唯一的IP
```

- `高可用`

```
kubelet保证每一个master节点的服务正常运行
系统监控程序确保kubelet正常运行
Etcd集群
多个apiserver进行负载均衡
Master选举确保kube-scheduler和kube-controller-manager高可用
```

## Harbor 镜像私有仓库

- 官网：<http://vmware.github.io/harbor/>

## 资料

- 书籍：《第一本 Docker 书》






















