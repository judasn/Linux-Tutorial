# Dubbo 环境安装和配置


## Dubbo-Admin 搭建

### 需要环境

- CentOS 6
- JDK 1.8（必须是 1.8）
- Tomcat 7 或 8（我测试都可以）
- Dubbo 版本：2.5.4-SNAPSHOT（当前这个版本是最新的。2.5.3 我测试是不行的）
- Dubbo-Admin 需要修改部分代码，让它支持 JDK 8，具体看文章：<https://github.com/alibaba/dubbo/issues/50>
- 最终我的 Dubbo-admin 的 pom.xml 为这样的：


``` xml
<!--
 - Copyright 1999-2011 Alibaba Group.
 -  
 - Licensed under the Apache License, Version 2.0 (the "License");
 - you may not use this file except in compliance with the License.
 - You may obtain a copy of the License at
 -  
 -      http://www.apache.org/licenses/LICENSE-2.0
 -  
 - Unless required by applicable law or agreed to in writing, software
 - distributed under the License is distributed on an "AS IS" BASIS,
 - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 - See the License for the specific language governing permissions and
 - limitations under the License.
-->
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>com.alibaba</groupId>
		<artifactId>dubbo-parent</artifactId>
		<version>2.5.4-SNAPSHOT</version>
	</parent>
	<artifactId>dubbo-admin</artifactId>
	<packaging>war</packaging>
	<name>${project.artifactId}</name>
	<description>The admin module of dubbo project</description>
	<properties>
		<wtpversion>1.5</wtpversion>
		<wtpContextName>/</wtpContextName>
		<eclipse.useProjectReferences>false</eclipse.useProjectReferences>
		<skip_maven_deploy>false</skip_maven_deploy>
	</properties>
	<dependencies>
		<dependency>
			<groupId>com.alibaba</groupId>
			<artifactId>dubbo</artifactId>
			<version>${project.parent.version}</version>
			<exclusions>
				<exclusion>
					<groupId>org.springframework</groupId>
					<artifactId>spring</artifactId>
				</exclusion>
			</exclusions>
		</dependency>
		
		<dependency>
			<groupId>com.alibaba.citrus</groupId>
			<artifactId>citrus-webx-all</artifactId>
			<version>3.1.6</version>
		</dependency>
		<dependency>
			<groupId>org.apache.velocity</groupId>
			<artifactId>velocity</artifactId>
			<version>1.7</version>
		</dependency>
		
		<dependency>
			<groupId>org.javassist</groupId>
			<artifactId>javassist</artifactId>
		</dependency>
		<dependency>
			<groupId>org.jboss.netty</groupId>
			<artifactId>netty</artifactId>
		</dependency>
		<dependency>
			<groupId>org.apache.mina</groupId>
			<artifactId>mina-core</artifactId>
		</dependency>
		<dependency>
			<groupId>org.glassfish.grizzly</groupId>
			<artifactId>grizzly-core</artifactId>
		</dependency>
		<dependency>
			<groupId>org.apache.httpcomponents</groupId>
			<artifactId>httpclient</artifactId>
		</dependency>
		<dependency>
			<groupId>com.alibaba</groupId>
			<artifactId>fastjson</artifactId>
		</dependency>
		<dependency>
			<groupId>com.thoughtworks.xstream</groupId>
			<artifactId>xstream</artifactId>
		</dependency>
		<dependency>
			<groupId>org.apache.bsf</groupId>
			<artifactId>bsf-api</artifactId>
		</dependency>
		<dependency>
			<groupId>org.apache.zookeeper</groupId>
			<artifactId>zookeeper</artifactId>
		</dependency>
		<dependency>
			<groupId>com.github.sgroschupf</groupId>
			<artifactId>zkclient</artifactId>
		</dependency>
		<dependency>
			<groupId>com.netflix.curator</groupId>
			<artifactId>curator-framework</artifactId>
		</dependency>
		<dependency>
			<groupId>com.googlecode.xmemcached</groupId>
			<artifactId>xmemcached</artifactId>
		</dependency>
		<dependency>
			<groupId>org.apache.thrift</groupId>
			<artifactId>libthrift</artifactId>
		</dependency>
		<dependency>
			<groupId>com.caucho</groupId>
			<artifactId>hessian</artifactId>
		</dependency>
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>servlet-api</artifactId>
			<scope>provided</scope>
		</dependency>
		<dependency>
			<groupId>log4j</groupId>
			<artifactId>log4j</artifactId>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-api</artifactId>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
		</dependency>
		<dependency>
			<groupId>redis.clients</groupId>
			<artifactId>jedis</artifactId>
		</dependency>
		<dependency>
			<groupId>javax.validation</groupId>
			<artifactId>validation-api</artifactId>
		</dependency>
		<dependency>
			<groupId>org.hibernate</groupId>
			<artifactId>hibernate-validator</artifactId>
		</dependency>
		<dependency>
			<groupId>javax.cache</groupId>
			<artifactId>cache-api</artifactId>
		</dependency>
	</dependencies>
	<build>
		<plugins>
			<plugin>
				<groupId>org.mortbay.jetty</groupId>
				<artifactId>maven-jetty-plugin</artifactId>
				<version>${jetty_version}</version>
				<configuration>
					<contextPath>/</contextPath>
					<scanIntervalSeconds>10</scanIntervalSeconds>
					<connectors>
						<connector implementation="org.mortbay.jetty.nio.SelectChannelConnector">
							<port>8080</port>
							<maxIdleTime>60000</maxIdleTime>
						</connector>
					</connectors>
				</configuration>
			</plugin>
		</plugins>
	</build>
</project>

```

- 部署在 Tomcat 之后，如果需要修改 zookeeper 的地址，以及默认用户的登录密码，可以在这里改：`vim /usr/program/tomcat8/webapps/ROOT/WEB-INF/dubbo.properties`
- 里面内容：

``` ini
dubbo.registry.address=zookeeper://127.0.0.1:2181
dubbo.admin.root.password=root
dubbo.admin.guest.password=guest
```

- 如果有多个节点构成的集群也可以这样写：

``` ini
dubbo.registry.address=zookeeper://192.168.1.121:2181?backup=192.168.1.111:2181,192.168.1.112:2181
dubbo.admin.root.password=root
dubbo.admin.guest.password=guest
```


## Dubbox-Admin 搭建

### 需要环境

- CentOS 6
- JDK 1.8（只测试过 1.8）
- Tomcat 7 或 8（只测试过 8）
- Dubbox 版本：dubbo-admin-2.8.4.war（fork 官网最新版本，自己编译的版本）
- 不需要修改任何 pom.xml 文件，直接就可以运行。