# Mycat 安装和配置


## 部署的环境

- 系统：CentOS 6.7 / CentOS 7.4
- JDK：jdk-8u72-linux-x64.tar.gz
- Mycat：Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz
- 推荐测试机子配置：1 CPU + 2 GB RAM + Docker

## Docker 快速部署 MySQL

```
docker run --name mysql1 -p 3316:3306 -e MYSQL_ROOT_PASSWORD=root -d daocloud.io/library/mysql:5.7.13
docker run --name mysql2 -p 3326:3306 -e MYSQL_ROOT_PASSWORD=root -d daocloud.io/library/mysql:5.7.13
docker run --name mysql3 -p 3336:3306 -e MYSQL_ROOT_PASSWORD=root -d daocloud.io/library/mysql:5.7.13
```

## Mycat 安装

- 官网（页头有一个 PDF 要记得下载，这本资料写得很好）：<http://mycat.io/>
- 官网下载（官网下载地址很乱，如果哪天右边这个地址不行了，到官网加群问下吧）：<http://dl.mycat.io/>
- 项目 Github：<https://github.com/MyCATApache/Mycat-Server>
- 此时（20170122） 最新稳定版本为：**1.6**，下载下来的文件名称：**Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz**
- 安装前的准备：
	- 这台机子必须装有 JDK，并且配置好 JAVA_HOME。JDK 的安装看：<https://github.com/judasn/Linux-Tutorial/blob/master/JDK-Install.md>
- 开始安装：
	- 假设 Mycat 安装包的完整路径是：**/opt/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz**
		- 解压：`cd /opt ; tar -zxvf Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz`
		- 移动解压的目录到官方建议的目录下：`mv /opt/mycat /usr/local/`
	- 设置 Mycat 的环境变量
		- `vim /etc/profile`，添加如下内容：

``` nginx
export MYCAT_HOME=/usr/local/mycat
export PATH=$PATH:$MYCAT_HOME/bin
```

- 刷新配置：`source /etc/profile`
- 到这里就安装好了，但是先不启动，需要先去配置相应的配置文件。

## Mycat 只分库配置，并且要可预期租户数量（没有分表、读写分离、高可用）

- 请至少预留 512M 内存给 Mycat
- 使用 Mycat 这几个配置文件必定会改动到。这一个文件所代表的含义几句话说不了，还请你自己看下官网的文档，在目录：conf 下

#### server.xml 配置详解

- `server.xml`，主要用于配置系统变量、用户管理、用户权限等。
- **默认配置中有一个 TESTDB 相关的数据库用户配置，都要自己手工去掉。建议可以把配置文件中 TESTDB 相关的单词都替换成你的数据库名称（你最好能读懂各个配置）。**
- 配置用户，添加下面内容：

```xml
<!-- 定义登录mycat对的用户权限 -->  
<user name="adg_system_user">  
    <property name="password">123456</property>  
    <!-- 可访问数据库配置，多个数据库用英文逗号隔开-->  
    <property name="schemas">adg_system</property>  
    <!-- 配置是否允许只读，true 只读 -->  
    <property name="readOnly">false</property>  
    <!-- 定义限制前端整体的连接数，如果其值为0，或者不设置，则表示不限制连接数量 -->  
    <property name="benchmark">0</property>  
    <!-- 设置是否开启密码加密功能，默认为0不开启加密，为1则表示开启加密 -->  
    <property name="usingDecrypt">0</property>

    <!-- 表级 DML 权限设置（一般不建议设置） -->
    <!--
    <privileges check="false">
        <schema name="TESTDB" dml="0110" >
            <table name="tb01" dml="0000"></table>
            <table name="tb02" dml="1111"></table>
        </schema>
    </privileges>
     -->
</user>
```

- mycat 中间件的全局配置：

```xml
<system>
    <property name="useSqlStat">0</property>  <!-- 1为开启实时统计、0为关闭 -->
    <property name="useGlobleTableCheck">0</property>  <!-- 1为开启全加班一致性检测、0为关闭 -->

    <property name="sequnceHandlerType">2</property>
    <!--1为开启mysql压缩协议-->
    <!--<property name="useCompression">1</property>--> 
    <!--设置模拟的MySQL版本号-->
    <!--<property name="fakeMySQLVersion">5.6.20</property>-->
    <!--指定每次分配 socker direct buffer 的值，默认是4096字节-->    
    <!--<property name="processorBufferChunk">40960</property>--> 
   
    <!--指定系统可用的线程数量，默认值为机器 CPU 核心 X 每个核心运行线程的数量-->    
    <!--<property name="processors">1</property>-->
    <!--<property name="processorExecutor">32</property>-->
     
    <!--默认为type 0: DirectByteBufferPool | type 1 ByteBufferArena-->
    <property name="processorBufferPoolType">0</property>
    <!--默认是65535 64K 用于sql解析时最大文本长度 -->
    <!--<property name="maxStringLiteralLength">65535</property>-->
    <!--<property name="sequnceHandlerType">0</property>-->
    <!--<property name="backSocketNoDelay">1</property>-->
    <!--<property name="frontSocketNoDelay">1</property>-->
    <!--<property name="processorExecutor">16</property>-->
    <!--
    <property name="serverPort">8066</property> <property name="managerPort">9066</property> 
    <property name="idleTimeout">300000</property> <property name="bindIp">0.0.0.0</property> 
    <property name="frontWriteQueueSize">4096</property> <property name="processors">32</property> 
    -->
    <!--分布式事务开关，0为不过滤分布式事务，1为过滤分布式事务（如果分布式事务内只涉及全局表，则不过滤），2为不过滤分布式事务,但是记录分布式事务日志-->
    <property name="handleDistributedTransactions">0</property>

    <!--
    off heap for merge/order/group/limit      1开启   0关闭
    -->
    <property name="useOffHeapForMerge">1</property>

    <!--
        单位为m
    -->
    <property name="memoryPageSize">1m</property>

    <!--
        单位为k
    -->
    <property name="spillsFileBufferSize">1k</property>

    <property name="useStreamOutput">0</property>

    <!--
        单位为m
    -->
    <property name="systemReserveMemorySize">384m</property>


    <!--是否采用zookeeper协调切换（这里默认下载下来填写的是 true，如果你不用 zookeeper，可以改为 false）  -->
    <property name="useZKSwitch">false</property>


</system>
```

#### schema.xml 配置详解


- `schema.xml`，用于设置 Mycat 的逻辑库、表、数据节点、dataHost 等内容，分库分表、读写分离等等都是在这里进行配置的
- schema.xml 中特别注意的是分片节点的配置。如下，其中 adg_system_0000,adg_system_0001,adg_system_0002 是需要我们自己在 mysql 对应的机子上人工创建这三个空白数据库和表。

```xml
<?xml version="1.0"?>
<!DOCTYPE mycat:schema SYSTEM "schema.dtd">
<mycat:schema xmlns:mycat="http://io.mycat/">

    <!--======================================================-->

    <schema name="adg_system" checkSQLschema="false" sqlMaxLimit="100">
        <!--
        建设有下面 5 张表，至于表做啥就不需要深究，知道大体关系即可。
        adg_ads
        adg_ads_set
        adg_ads_campaign
        adg_channel
        adg_shop
        adg_shop_channel
        
        TRUNCATE TABLE `adg_ads`;
        TRUNCATE TABLE `adg_ads_set`;
        TRUNCATE TABLE `adg_ads_campaign`;
        TRUNCATE TABLE `adg_channel`;
        TRUNCATE TABLE `adg_shop`;
        TRUNCATE TABLE `adg_shop_channel`;
        -->
        
        <!--全局表 start-->
        <table name="adg_channel" primaryKey="channel_id" type="global" dataNode="dn0,dn1,dn2"/>
        <table name="adg_shop_channel" primaryKey="shop_channel_id" type="global" dataNode="dn0,dn1,dn2"/>
        <table name="adg_shop" primaryKey="shop_id" type="global" dataNode="dn0,dn1,dn2"/>
        <!--全局表 end-->

        <!--sharding-by-shop-id 为自己已定义的规则：根据店铺 ID 分库-->
        <!--父子表采用 ER 关系分片，规则是由上面的 adg_ads_campaign 表分片规则决定 -->
        <!--parentKey 为与父表建立关联关系的列名-->       
        <table name="adg_ads_campaign" primaryKey="ads_campaign_id" dataNode="dn0,dn1,dn2" rule="sharding-by-shop-id">
            <childTable name="adg_ads_set" primaryKey="ads_set_id" joinKey="shop_id" parentKey="shop_id">
                <childTable name="adg_ads" joinKey="ads_set_id" parentKey="ads_set_id"/>
            </childTable>
        </table>
    </schema>

    <!--======================================================-->

    <!-- dataNode标签定义了mycat中的数据节点，这也就是我们通常所说的数据分片，一个单独的dataNode就是一个独立的数据分片-->
    <!--1）name属性：定义数据节点的唯一名字-->
    <!--2）dataHost属性：定义该分片所属的数据库实例，属性引用自dataHost标签上定义的name属性-->
    <!--3）database属性：定义该分片所属的数据库实例上的具体数据库。-->

    <dataNode name="dn0" dataHost="mysql_host_0" database="adg_system_0000"/>
    <dataNode name="dn1" dataHost="mysql_host_1" database="adg_system_0001"/>
    <dataNode name="dn2" dataHost="mysql_host_2" database="adg_system_0002"/>

    <!--======================================================-->

    <!-- 定义数据库实例，读写分离和心跳语句-->
    <!--1)name 属性：标识唯一的dataHost-->
    <!-- 2)maxCon属性：指定每个读写实例连接池的最大连接数。内嵌writeHost、readHost标签会使用这个属性的值来实例化连接池的最大连接数-->
    <!--3)minCon属性：指定每个读写实例连接池的最小连接数。初始化连接池的大小的属性。-->
    <!--4）balance属性：负债均衡类型，有四种-->
    <!--   balance="0" : 不开启读写分离机制，所有的读操作都发送到当前可以用的writeHost上-->
    <!--   balance="1" : 全部的readHost与stand by writeHost（双主从模式下的master） 都参与select语句的负债均衡-->
    <!--   balance="2" : 所有的读操作都随机的往writeHost和readHost上分发-->
    <!--   balance="3" : 所有的读分发到readHost上，writeHost负责写-->
    <!--5）writeType属性：负载均衡目前的取值有两种：-->
    <!--   writeType="0"：所有的写操作都发送到第一个writeHost,writeHost1挂了，则切换到writeHost2上，重新恢复writeHost1后，还是以writeHost2为准-->
    <!--   writeType="1"：所有的写操作都随机的发送到配置的writeHost上，1.5版本以后不推荐使用该值。-->
    <!--6）dbType属性：制定后端后端数据的类型：mysql，oracle、mongoDB-->
    <!--7）dbDriver属性：制定后端数据库使用的Driver.目前可选的值为native和JDBC。native 支持 MySQL/MariaDB-->
    <!--8）switchType属性：默认值为1，自动切换。-->
    <!--                  -1表示不自动切换-->
    <!--                   2表示基于mysql主从同步的状态决定是否切换。-->
    <!--                  3表示基于mysql galaxy cluster 的切换机制-->
    <!--9）tempReadHostAvailable属性：如果配置了writeHost属性，下面的readHost依旧可以使用，默认为0-->
    <dataHost name="mysql_host_0" maxCon="1000" minCon="10" balance="0" writeType="0" dbType="mysql" dbDriver="native" switchType="1" slaveThreshold="100">
        <heartbeat>select user()</heartbeat>
        <writeHost host="hostM1" url="116.196.111.68:3316" user="root" password="root"/>
    </dataHost>
    
    <dataHost name="mysql_host_1" maxCon="1000" minCon="10" balance="0" writeType="0" dbType="mysql" dbDriver="native" switchType="1" slaveThreshold="100">
        <heartbeat>select user()</heartbeat>
        <writeHost host="hostM1" url="116.196.111.68:3326" user="root" password="root"/>
    </dataHost>
    
    <dataHost name="mysql_host_2" maxCon="1000" minCon="10" balance="0" writeType="0" dbType="mysql" dbDriver="native" switchType="1" slaveThreshold="100">
        <heartbeat>select user()</heartbeat>
        <writeHost host="hostM1" url="116.196.111.68:3336" user="root" password="root"/>
    </dataHost>
    
    <!--======================================================-->

</mycat:schema>
```


#### rule.xml 配置详解

- `rule.xml`，设置分片规则。
- 下面我设置一个根据店铺进行分片的规格：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mycat:rule SYSTEM "rule.dtd">
<mycat:rule xmlns:mycat="http://io.mycat/">


    <tableRule name="rule1">
        <rule>
            <columns>id</columns>
            <algorithm>func1</algorithm>
        </rule>
    </tableRule>

    <tableRule name="rule2">
        <rule>
            <columns>user_id</columns>
            <algorithm>func1</algorithm>
        </rule>
    </tableRule>

    <tableRule name="sharding-by-intfile">
        <rule>
            <columns>sharding_id</columns>
            <algorithm>hash-int</algorithm>
        </rule>
    </tableRule>
    <tableRule name="auto-sharding-long">
        <rule>
            <columns>id</columns>
            <algorithm>rang-long</algorithm>
        </rule>
    </tableRule>
    <tableRule name="mod-long">
        <rule>
            <columns>id</columns>
            <algorithm>mod-long</algorithm>
        </rule>
    </tableRule>
    <tableRule name="sharding-by-murmur">
        <rule>
            <columns>id</columns>
            <algorithm>murmur</algorithm>
        </rule>
    </tableRule>
    <tableRule name="crc32slot">
        <rule>
            <columns>id</columns>
            <algorithm>crc32slot</algorithm>
        </rule>
    </tableRule>
    <tableRule name="sharding-by-month">
        <rule>
            <columns>create_time</columns>
            <algorithm>partbymonth</algorithm>
        </rule>
    </tableRule>
    <tableRule name="latest-month-calldate">
        <rule>
            <columns>calldate</columns>
            <algorithm>latestMonth</algorithm>
        </rule>
    </tableRule>

    <tableRule name="auto-sharding-rang-mod">
        <rule>
            <columns>id</columns>
            <algorithm>rang-mod</algorithm>
        </rule>
    </tableRule>

    <tableRule name="jch">
        <rule>
            <columns>id</columns>
            <algorithm>jump-consistent-hash</algorithm>
        </rule>
    </tableRule>
    
    <!--======================== start ==============================-->

    <tableRule name="sharding-by-shop-id">
        <rule>
            <columns>shop_id</columns>
            <algorithm>by-shop-id</algorithm>
        </rule>
    </tableRule>


    <function name="by-shop-id" class="io.mycat.route.function.PartitionByFileMap">
        <property name="mapFile">sharding-by-shop-id.txt</property>
        <property name="type">1</property><!-- 默认是0，表示 Integer，非零表示 String。因为我们这里是根据 shop_id 来分，而 shop_id 在表设计的时候是 bigint 类型，值是 18 位，所以这里必须填写非零值才行。-->
        <property name="defaultNode">0</property>
    </function>
    
    <!--======================== end ==============================-->

    
    <function name="murmur" class="io.mycat.route.function.PartitionByMurmurHash">
        <property name="seed">0</property><!-- 默认是0 -->
        <property name="count">2</property><!-- 要分片的数据库节点数量，必须指定，否则没法分片 -->
        <property name="virtualBucketTimes">160</property><!-- 一个实际的数据库节点被映射为这么多虚拟节点，默认是160倍，也就是虚拟节点数是物理节点数的160倍 -->
        <!-- <property name="weightMapFile">weightMapFile</property> 节点的权重，没有指定权重的节点默认是1。以properties文件的格式填写，以从0开始到count-1的整数值也就是节点索引为key，以节点权重值为值。所有权重值必须是正整数，否则以1代替 -->
        <!-- 
           <property name="bucketMapPath">/etc/mycat/bucketMapPath</property> 
            用于测试时观察各物理节点与虚拟节点的分布情况，如果指定了这个属性，会把虚拟节点的murmur hash值与物理节点的映射按行输出到这个文件，没有默认值，如果不指定，就不会输出任何东西
         -->
    </function>

    <function name="crc32slot" class="io.mycat.route.function.PartitionByCRC32PreSlot">
        <property name="count">2</property><!-- 要分片的数据库节点数量，必须指定，否则没法分片 -->
    </function>
    
    <function name="hash-int" class="io.mycat.route.function.PartitionByFileMap">
        <property name="mapFile">partition-hash-int.txt</property>
    </function>
    
    <function name="rang-long" class="io.mycat.route.function.AutoPartitionByLong">
        <property name="mapFile">autopartition-long.txt</property>
    </function>
    
    <function name="mod-long" class="io.mycat.route.function.PartitionByMod">
        <property name="count">3</property>
    </function>

    <function name="func1" class="io.mycat.route.function.PartitionByLong">
        <property name="partitionCount">8</property>
        <property name="partitionLength">128</property>
    </function>
    
    <function name="latestMonth" class="io.mycat.route.function.LatestMonthPartion">
        <property name="splitOneDay">24</property>
    </function>
    
    <function name="partbymonth" class="io.mycat.route.function.PartitionByMonth">
        <property name="dateFormat">yyyy-MM-dd</property>
        <property name="sBeginDate">2015-01-01</property>
    </function>

    <function name="rang-mod" class="io.mycat.route.function.PartitionByRangeMod">
        <property name="mapFile">partition-range-mod.txt</property>
    </function>

    <function name="jump-consistent-hash" class="io.mycat.route.function.PartitionByJumpConsistentHash">
        <property name="totalBuckets">3</property>
    </function>

</mycat:rule>
```

- 还需要在 conf 新增文件 sharding-by-shop-id.txt 文件，内容是：
- 需要注意的是：

```
417454619141211000=0
417454619141211001=1
417454619141211002=2
```

- 表示 shop_id 为 417454619141211000 的时候，用 adg_system_0000 库
- 表示 shop_id 为 417454619141211001 的时候，用 adg_system_0001 库
- 表示 shop_id 为 417454619141211002 的时候，用 adg_system_0002 库
- 其中第一个库是从下表 0 开始的。

#### log4j2.xml 配置详解


- `log4j2.xml`，用于设置 Mycat 的日志输出规则，默认日志文件是输出 mycat 根目录下的 logs 目录下。


## 只分库的 demo 脚本

- 在 MySQL 实例 1 中执行如下初始化脚本：

```sql
CREATE DATABASE /*!32312 IF NOT EXISTS*/`adg_system_0000` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `adg_system_0000`;
```

- 在 MySQL 实例 2 中执行如下初始化脚本：

```sql
CREATE DATABASE /*!32312 IF NOT EXISTS*/`adg_system_0001` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `adg_system_0001`;
```

- 在 MySQL 实例 3 中执行如下初始化脚本：

```sql
CREATE DATABASE /*!32312 IF NOT EXISTS*/`adg_system_0002` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `adg_system_0002`;
```

## 其他设置

- 假设你上面的配置文件都配置好了：
	- 开放 8066 端口
		- 如果只是临时测试，可以临时关掉防火墙：`service iptables stop`
		- 不然就添加防火墙规则：
	        - 添加规则：`sudo iptables -I INPUT -p tcp -m tcp --dport 8066 -j ACCEPT`
	        - 保存规则：`sudo service iptables save`
	        - 重启 iptables：`sudo service iptables restart`
- 启动/停止/重启
	- **注意：在启动之前请一定要确保你可以用 mysql 工具连上你们的三个 mysql 和对应的数据库。有时候你连得上 mysql，但是你的账号不一定能连上这个 mysql 对应的数据库。**
	- 启动有两种，一种是后台启动，启动后看不到任何信息。一种是控制台启动，启动后进入 Mycat 的控制台界面，显示当前 Mycat 的活动信息，按 Ctrl + C 停止控制台的时候 Mycat 也跟着停止。
	- 进入 Mycat 目录：`cd /usr/local/mycat/bin`
	- 后台启动：`./mycat start && tail -300f /usr/local/mycat/logs/mycat.log`
	- 控制台启动：`./mycat console`
	- 重启：`./mycat restart`
	- 停止：`./mycat stop`
- 连接 Mycat
	- 连接 Mycat 的过程跟连接普通的 MySQL 表面上是没啥区别的，使用的命令都是一个样。但是需要注意的是，很容易出问题。对连接客户端有各种意外，目前我做了总结：
	- 连接命令：`mysql -h192.168.1.112 -uroot -p -P8066`，然后输入 mycat 的 root 用户密码（在上面介绍的 server.xml 中配置的）
	- **不建议** 的连接方式：
		- SQLyog 软件，我这边是报：*find no Route:select * from `youmeek_nav`.`nav_url` limit 0, 1000*
		- Windows 系统下使用 cmd 去连接，我这边是报：*ERROR 1105 (HY000): Unknown character set: 'gbk'*
		- MySQL-Front 软件，没用过，但是别人说是有兼容性问题
	- **建议** 的连接方式：
		- Navicat for mysql 软件
		- Linux 下的 MySQL 客户端命令行

## 使用 Navicat 连接 MyCat 测试 SQL


#### 创建表 SQL

```sql

CREATE TABLE `adg_ads` (
  `ads_id` BIGINT(20) NOT NULL COMMENT '广告表ID',
  `ads_set_id` BIGINT(20) NOT NULL COMMENT '广告组表ID',
  `ads_title` VARCHAR(32) NOT NULL COMMENT '广告标题',
  `shop_id` BIGINT(20) NOT NULL COMMENT '店铺ID',
  `channel_id` BIGINT(20) NOT NULL COMMENT '渠道ID',
  `shop_name` VARCHAR(32) NOT NULL COMMENT '店铺名称',
  `channel_name` VARCHAR(32) NOT NULL COMMENT '渠道名称',
  PRIMARY KEY (`ads_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='广告表';


CREATE TABLE `adg_ads_set` (
  `ads_set_id` BIGINT(20) NOT NULL COMMENT '广告组表ID',
  `ads_set_title` VARCHAR(32) NOT NULL COMMENT '广告组标题',
  `ads_campaign_id` BIGINT(20) NOT NULL COMMENT '广告系列表ID',
  `shop_id` BIGINT(20) NOT NULL COMMENT '店铺ID',
  `channel_id` BIGINT(20) NOT NULL COMMENT '渠道ID',
  `shop_name` VARCHAR(32) NOT NULL COMMENT '店铺名称',
  `channel_name` VARCHAR(32) NOT NULL COMMENT '渠道名称',
  PRIMARY KEY (`ads_set_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='广告组表';


CREATE TABLE `adg_ads_campaign` (
  `ads_campaign_id` BIGINT(20) NOT NULL COMMENT '广告系列表ID',
  `ads_campaign_title` VARCHAR(32) NOT NULL COMMENT '广告系列标题',
  `shop_id` BIGINT(20) NOT NULL COMMENT '店铺ID',
  `channel_id` BIGINT(20) NOT NULL COMMENT '渠道ID',
  `shop_name` VARCHAR(32) NOT NULL COMMENT '店铺名称',
  `channel_name` VARCHAR(32) NOT NULL COMMENT '渠道名称',
  PRIMARY KEY (`ads_campaign_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='广告系列表';


CREATE TABLE `adg_channel` (
  `channel_id` BIGINT(20) NOT NULL COMMENT '渠道ID',
  `channel_name` VARCHAR(32) NOT NULL COMMENT '渠道名称',
  PRIMARY KEY (`channel_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='渠道表';


CREATE TABLE `adg_shop` (
  `shop_id` BIGINT(20) NOT NULL COMMENT '店铺ID',
  `shop_name` VARCHAR(32) NOT NULL COMMENT '店铺名称',
  PRIMARY KEY (`shop_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';


CREATE TABLE `adg_shop_channel` (
  `shop_channel_id` BIGINT(20) NOT NULL COMMENT '店铺渠道中间表ID',
  `shop_id` BIGINT(20) NOT NULL COMMENT '店铺ID',
  `channel_id` BIGINT(20) NOT NULL COMMENT '渠道ID',
  `shop_name` VARCHAR(32) NOT NULL COMMENT '店铺名称',
  `channel_name` VARCHAR(32) NOT NULL COMMENT '渠道名称',
  PRIMARY KEY (`shop_channel_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='店铺渠道中间表';
```

#### 创建数据 SQL

```sql
INSERT  INTO `adg_shop`(`shop_id`,`shop_name`) VALUES (417454619141211000,'NC站');
INSERT  INTO `adg_shop`(`shop_id`,`shop_name`) VALUES (417454619141211001,'BG站');

INSERT  INTO `adg_channel`(`channel_id`,`channel_name`) VALUES (1,'Facebook');
INSERT  INTO `adg_channel`(`channel_id`,`channel_name`) VALUES (2,'Google');
INSERT  INTO `adg_channel`(`channel_id`,`channel_name`) VALUES (3,'Twitter');

INSERT  INTO `adg_shop_channel`(`shop_channel_id`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (1,417454619141211000,1,'NC站','Facebook');
INSERT  INTO `adg_shop_channel`(`shop_channel_id`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (2,417454619141211000,2,'NC站','Google');
INSERT  INTO `adg_shop_channel`(`shop_channel_id`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (3,417454619141211001,1,'BG站','Facebook');
INSERT  INTO `adg_shop_channel`(`shop_channel_id`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (4,417454619141211001,2,'BG站','Google');

INSERT  INTO `adg_ads_campaign`(`ads_campaign_id`,`ads_campaign_title`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (1,'第1个广告系列',417454619141211000,1,'NC站','Facebook');
INSERT  INTO `adg_ads_campaign`(`ads_campaign_id`,`ads_campaign_title`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (2,'第2个广告系列',417454619141211001,2,'BG站','Google');

INSERT  INTO `adg_ads_set`(`ads_set_id`,`ads_set_title`,`ads_campaign_id`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (1,'第1个广告集',1,417454619141211000,1,'NC站','Facebook');
INSERT  INTO `adg_ads_set`(`ads_set_id`,`ads_set_title`,`ads_campaign_id`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (2,'第2个广告集',2,417454619141211001,2,'BG站','Google');

INSERT  INTO `adg_ads`(`ads_id`,`ads_set_id`,`ads_title`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (1,1,'第1个广告',417454619141211000,1,'NC站','Facebook');
INSERT  INTO `adg_ads`(`ads_id`,`ads_set_id`,`ads_title`,`shop_id`,`channel_id`,`shop_name`,`channel_name`) VALUES (2,2,'第2个广告',417454619141211001,2,'BG站','Google');
```


## mycat 正常启动的 log 内容

```log
2018-02-05 14:15:41.432  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.<init>(PhysicalDBPool.java:100)) - total resouces of dataHost mysql_host_0 is :1
2018-02-05 14:15:41.435  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.<init>(PhysicalDBPool.java:100)) - total resouces of dataHost mysql_host_2 is :1
2018-02-05 14:15:41.435  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.<init>(PhysicalDBPool.java:100)) - total resouces of dataHost mysql_host_1 is :1
2018-02-05 14:15:41.442  INFO [WrapperSimpleAppMain] (io.mycat.cache.CacheService.createLayeredPool(CacheService.java:125)) - create layer cache pool TableID2DataNodeCache of type encache ,default cache size 10000 ,default expire seconds18000
2018-02-05 14:15:41.445  INFO [WrapperSimpleAppMain] (io.mycat.cache.DefaultLayedCachePool.createChildCache(DefaultLayedCachePool.java:80)) - create child Cache: TESTDB_ORDERS for layered cache TableID2DataNodeCache, size 50000, expire seconds 18000
2018-02-05 14:15:41.597  INFO [WrapperSimpleAppMain] (io.mycat.config.classloader.DynaClassLoader.<init>(DynaClassLoader.java:34)) - dyna class load from ./catlet,and auto check for class file modified every 60 seconds
2018-02-05 14:15:41.601  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.startup(MycatServer.java:266)) - ===============================================
2018-02-05 14:15:41.602  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.startup(MycatServer.java:267)) - MyCat is ready to startup ...
2018-02-05 14:15:41.602  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.startup(MycatServer.java:279)) - Startup processors ...,total processors:1,aio thread pool size:4 each process allocated socket buffer pool  bytes ,a page size:2097152  a page's chunk number(PageSize/ChunkSize) is:512  buffer page's number is:20
2018-02-05 14:15:41.602  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.startup(MycatServer.java:280)) - sysconfig params:SystemConfig [processorBufferLocalPercent=100, frontSocketSoRcvbuf=1048576, frontSocketSoSndbuf=4194304, backSocketSoRcvbuf=4194304, backSocketSoSndbuf=1048576, frontSocketNoDelay=1, backSocketNoDelay=1, maxStringLiteralLength=65535, frontWriteQueueSize=2048, bindIp=0.0.0.0, serverPort=8066, managerPort=9066, charset=utf8mb4, processors=1, processorExecutor=4, timerExecutor=2, managerExecutor=2, idleTimeout=1800000, catletClassCheckSeconds=60, sqlExecuteTimeout=300, processorCheckPeriod=1000, dataNodeIdleCheckPeriod=300000, dataNodeHeartbeatPeriod=10000, clusterHeartbeatUser=_HEARTBEAT_USER_, clusterHeartbeatPass=_HEARTBEAT_PASS_, clusterHeartbeatPeriod=5000, clusterHeartbeatTimeout=10000, clusterHeartbeatRetry=10, txIsolation=3, parserCommentVersion=50148, sqlRecordCount=10, bufferPoolPageSize=2097152, bufferPoolChunkSize=4096, bufferPoolPageNumber=20, maxResultSet=524288, bigResultSizeSqlCount=10, bufferUsagePercent=80, flowControlRejectStrategy=0, clearBigSqLResultSetMapMs=600000, defaultMaxLimit=100, sequnceHandlerType=2, sqlInterceptor=io.mycat.server.interceptor.impl.DefaultSqlInterceptor, sqlInterceptorType=select, sqlInterceptorFile=/usr/local/mycat/logs/sql.txt, mutiNodeLimitType=0, mutiNodePatchSize=100, defaultSqlParser=druidparser, usingAIO=0, packetHeaderSize=4, maxPacketSize=16777216, mycatNodeId=1]
2018-02-05 14:15:41.667  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.startup(MycatServer.java:381)) - using nio network handler 
2018-02-05 14:15:41.681  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.startup(MycatServer.java:397)) - $_MyCatManager is started and listening on 9066
2018-02-05 14:15:41.682  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.startup(MycatServer.java:401)) - $_MyCatServer is started and listening on 8066
2018-02-05 14:15:41.682  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.startup(MycatServer.java:403)) - ===============================================
2018-02-05 14:15:41.682  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.startup(MycatServer.java:407)) - Initialize dataHost ...
2018-02-05 14:15:41.682  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.initSource(PhysicalDBPool.java:294)) - init backend myqsl source ,create connections total 10 for hostM1 index :0
2018-02-05 14:15:41.683  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.686  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.686  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.689  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.690  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.690  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.690  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.690  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.690  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.690  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0000
2018-02-05 14:15:41.834  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=1, lastTime=1517811341834, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=793, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.835  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=2, lastTime=1517811341835, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=797, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.835  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=4, lastTime=1517811341835, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=795, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.836  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=8, lastTime=1517811341836, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=796, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.836  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=7, lastTime=1517811341836, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=794, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.837  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=3, lastTime=1517811341837, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=801, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.837  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=5, lastTime=1517811341837, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=798, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.838  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=6, lastTime=1517811341838, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=799, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.840  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=10, lastTime=1517811341840, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=800, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.842  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=9, lastTime=1517811341842, user=root, schema=adg_system_0000, old shema=adg_system_0000, borrowed=true, fromSlaveDB=false, threadId=802, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3316, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:41.899  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.initSource(PhysicalDBPool.java:319)) - init result :finished 10 success 10 target count:10
2018-02-05 14:15:41.899  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.init(PhysicalDBPool.java:265)) - mysql_host_0 index:0 init success
2018-02-05 14:15:41.899  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.saveDataHostIndex(MycatServer.java:604)) - save DataHost index  mysql_host_0 cur index 0
2018-02-05 14:15:41.907  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.initSource(PhysicalDBPool.java:294)) - init backend myqsl source ,create connections total 10 for hostM1 index :0
2018-02-05 14:15:41.907  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:41.908  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:41.908  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:41.909  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:41.912  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:41.915  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:41.916  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:41.916  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:41.916  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:41.917  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0002
2018-02-05 14:15:42.021  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=12, lastTime=1517811342021, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=779, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.023  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=11, lastTime=1517811342022, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=780, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.027  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=13, lastTime=1517811342027, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=781, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.027  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=14, lastTime=1517811342027, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=782, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.030  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=17, lastTime=1517811342030, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=783, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.032  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=16, lastTime=1517811342032, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=785, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.034  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=15, lastTime=1517811342034, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=784, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.036  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=18, lastTime=1517811342036, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=786, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.043  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=19, lastTime=1517811342043, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=787, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.043  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=20, lastTime=1517811342043, user=root, schema=adg_system_0002, old shema=adg_system_0002, borrowed=true, fromSlaveDB=false, threadId=788, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3336, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.118  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.initSource(PhysicalDBPool.java:319)) - init result :finished 10 success 10 target count:10
2018-02-05 14:15:42.118  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.init(PhysicalDBPool.java:265)) - mysql_host_2 index:0 init success
2018-02-05 14:15:42.118  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.saveDataHostIndex(MycatServer.java:604)) - save DataHost index  mysql_host_2 cur index 0
2018-02-05 14:15:42.118  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.initSource(PhysicalDBPool.java:294)) - init backend myqsl source ,create connections total 10 for hostM1 index :0
2018-02-05 14:15:42.119  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.120  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.120  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.121  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.121  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.122  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.122  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.122  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.123  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.123  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDatasource.getConnection(PhysicalDatasource.java:413)) - no ilde connection in pool,create new connection for hostM1 of schema adg_system_0001
2018-02-05 14:15:42.235  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=21, lastTime=1517811342235, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=776, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.237  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=23, lastTime=1517811342237, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=777, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.239  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=26, lastTime=1517811342239, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=781, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.240  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=22, lastTime=1517811342240, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=778, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.243  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=25, lastTime=1517811342243, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=779, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.245  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=24, lastTime=1517811342245, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=780, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.249  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=29, lastTime=1517811342249, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=782, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.249  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=30, lastTime=1517811342249, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=783, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.250  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=28, lastTime=1517811342250, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=785, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.251  INFO [$_NIOREACTOR-0-RW] (io.mycat.backend.mysql.nio.handler.GetConnectionHandler.connectionAcquired(GetConnectionHandler.java:67)) - connected successfuly MySQLConnection [id=27, lastTime=1517811342251, user=root, schema=adg_system_0001, old shema=adg_system_0001, borrowed=true, fromSlaveDB=false, threadId=784, charset=latin1, txIsolation=3, autocommit=true, attachment=null, respHandler=null, host=116.196.111.68, port=3326, statusSync=null, writeQueue=0, modifiedSQLExecuted=false]
2018-02-05 14:15:42.324  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.initSource(PhysicalDBPool.java:319)) - init result :finished 10 success 10 target count:10
2018-02-05 14:15:42.324  INFO [WrapperSimpleAppMain] (io.mycat.backend.datasource.PhysicalDBPool.init(PhysicalDBPool.java:265)) - mysql_host_1 index:0 init success
2018-02-05 14:15:42.324  INFO [WrapperSimpleAppMain] (io.mycat.MycatServer.saveDataHostIndex(MycatServer.java:604)) - save DataHost index  mysql_host_1 cur index 0
```

## 使用细节

- 声明：
	- mycat 的库表这里我们称作虚拟库表
- 创建新表流程：
	- 先编辑 /conf/schema.xml 文件，增加对应的表信息
	- 把创建表 SQL 放在虚拟库上执行，则各个节点的物理库表会增加对应的表结构

## 资料

- 书：《分布式数据库架构及企业实践-基于 Mycat 中间件》
