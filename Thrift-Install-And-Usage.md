## Apache Thrift 安装和配置

- 官网下载：<https://thrift.apache.org/download>
- Apache 综合下载地（可以下载到旧版本）：<http://archive.apache.org/dist/thrift/>
- 一般我们建议下载 tar.gz 自己编译安装
- 安装所需的依赖等条件说明：<https://thrift.apache.org/docs/install/>
- 源码安装方式说明：<https://thrift.apache.org/docs/BuildingFromSource>
- 现在最新的版本是：0.10.0，而我选的版本是：0.9.3，因为我目前各个语言大家用的最多的还是 0.9 系列的版本


### 源码包安装方法

- 下载 0.9.3 的源码包：<http://archive.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz>
- 安装依赖：`yum install -y autoconf automake libtool cmake ncurses-devel openssl-devel lzo-devel zlib-devel gcc gcc-c++`
- 安装总流程：

```
tar zxvf thrift-0.9.3.tar.gz

cd thrift-0.9.3

./configure --without-tests

make

make install
```

- 安装成功后，看下版本：`thrift --version`


### Docker 方式直接使用

- 拉取镜像：`docker pull thrift:0.9.3`
- 现在假设我们有一个 service.thrift 的配置文件，放在 /opt 目录下：/opt/service.thrift
- 现在我们要根据这个配置文件生成 java 类文件，把这些类 java 类生成到目录：/opt/thrift/data
- 这个需要可以使用下面命令：

```
docker run -v "$PWD:/opt" thrift:0.9.3 thrift -o /opt/thrift/data --gen java /opt/service.thrift
```

- 如果你没有 service.thrift 文件也无所谓，我们现在就来创建一个（里面的内容懂不懂都无所谓）：

```
namespace java com.gitnavi.service

struct User {
  1: i32 id
  2: string username
}
 
service UserService {
  User getUser()
}
```




























