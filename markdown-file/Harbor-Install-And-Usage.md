# Harbor 安装和配置

## 环境说明

- CentOS 7.4
- IP：`192.168.0.105`
- 需要访问的机子 hosts 需要映射（如果绑定真实域名就不需要这一步了）：`192.168.0.105 harbor.gitnavi.com`
	- 直接用 IP 也是可以的，只是不用起来不美观

## 官方文档

- 安装指导：<https://github.com/goharbor/harbor/blob/master/docs/installation_guide.md>
	- 从中我们可以知道需要：[Docker、Docker Compose 环境](./Docker-Install-And-Usage.md)
- 硬件最低要求：2C + 4GB（推荐 8GB）
	- 官网有推荐配置说明：[hardware](https://github.com/goharbor/harbor/blob/master/docs/installation_guide.md#hardware)
- 下载：<https://github.com/goharbor/harbor/releases>
	- 当前（201806）最新版本：**v1.5.1**
	- 当前（201810）最新版本：**v1.5.3 和 1.6.0**
	- 分 offline 和 online 版本，推荐使用 offline
	- **v1.5.1** 下载地址：<https://storage.googleapis.com/harbor-releases/release-1.5.0/harbor-offline-installer-v1.5.1.tgz>
	- **v1.5.3** 下载地址：<https://storage.googleapis.com/harbor-releases/harbor-offline-installer-v1.5.3.tgz>


## 安装

- 切换目录：`cd /opt/setups`
- 下载：`wget https://storage.googleapis.com/harbor-releases/release-1.5.0/harbor-offline-installer-v1.5.1.tgz`
- 解压：`tar xvf harbor-offline-installer-v1.5.1.tgz`
- 移动到 /usr 目录下：`mv /opt/setups/harbor /usr/local`
- 修改配置文件：`vim /usr/local/harbor/harbor.cfg`：

```
_version = 1.5.0

# hostname 可以使用 ip、域名，不可以设置为 127.0.0.1 或 localhost
hostname = harbor.gitnavi.com

ui_url_protocol = http
max_job_workers = 50 
customize_crt = on
ssl_cert = /data/cert/server.crt
ssl_cert_key = /data/cert/server.key
secretkey_path = /data
admiral_url = NA
log_rotate_count = 50
log_rotate_size = 200M
http_proxy =
https_proxy =
no_proxy = 127.0.0.1,localhost,ui
email_identity = 
email_server = smtp.mydomain.com
email_server_port = 25
email_username = sample_admin@mydomain.com
email_password = abc
email_from = admin <sample_admin@mydomain.com>
email_ssl = false
email_insecure = false

# 启动Harbor后，管理员UI登录的密码，默认是 Harbor12345，用户名默认是：admin
harbor_admin_password = Harbor12345

auth_mode = db_auth
ldap_url = ldaps://ldap.mydomain.com
ldap_basedn = ou=people,dc=mydomain,dc=com
ldap_uid = uid 
ldap_scope = 2 
ldap_timeout = 5
ldap_verify_cert = true
ldap_group_basedn = ou=group,dc=mydomain,dc=com
ldap_group_filter = objectclass=group
ldap_group_gid = cn
ldap_group_scope = 2
self_registration = on
token_expiration = 30
project_creation_restriction = everyone
db_host = mysql
db_password = root123
db_port = 3306
db_user = root
redis_url = redis:6379
clair_db_host = postgres
clair_db_password = password
clair_db_port = 5432
clair_db_username = postgres
clair_db = postgres
uaa_endpoint = uaa.mydomain.org
uaa_clientid = id
uaa_clientsecret = secret
uaa_verify_cert = true
uaa_ca_cert = /path/to/ca.pem
registry_storage_provider_name = filesystem
registry_storage_provider_config =
```

- 安装成功会占用这些端口，所以请先做好准备，如果不想使用下面的端口需要修改：`vim /usr/local/harbor/docker-compose.yml`
	- `80`
	- `6379`
	- `3306`
	- `5000`
	- `1514`
- 后面重新启动 Harbor 也靠这个文件了：`docker-compose -f /usr/local/harbor/docker-compose.yml restart`
- 开始安装：`sh /usr/local/harbor/install.sh`，控制台输出如下（预计需要 5 ~ 10 分钟）：

```

[Step 0]: checking installation environment ...

Note: docker version: 17.12.0

Note: docker-compose version: 1.18.0

[Step 1]: loading Harbor images ...
52ef9064d2e4: Loading layer [==================================================>]  135.9MB/135.9MB
4a6862dbadda: Loading layer [==================================================>]  23.25MB/23.25MB
58b7d0c522b2: Loading layer [==================================================>]   24.4MB/24.4MB
9cd4bb748634: Loading layer [==================================================>]  7.168kB/7.168kB
c81302a14908: Loading layer [==================================================>]  10.56MB/10.56MB
7848e9ba72a3: Loading layer [==================================================>]  24.39MB/24.39MB
Loaded image: vmware/harbor-ui:v1.5.1
f1691b5a5198: Loading layer [==================================================>]  73.15MB/73.15MB
a529013c99e4: Loading layer [==================================================>]  3.584kB/3.584kB
d9b4853cff8b: Loading layer [==================================================>]  3.072kB/3.072kB
3d305073979e: Loading layer [==================================================>]  4.096kB/4.096kB
c9e17074f54a: Loading layer [==================================================>]  3.584kB/3.584kB
956055840e30: Loading layer [==================================================>]  9.728kB/9.728kB
Loaded image: vmware/harbor-log:v1.5.1
185db06a02d0: Loading layer [==================================================>]  23.25MB/23.25MB
835213979c70: Loading layer [==================================================>]   20.9MB/20.9MB
f74eeb41c1c9: Loading layer [==================================================>]   20.9MB/20.9MB
Loaded image: vmware/harbor-jobservice:v1.5.1
9bd5c7468774: Loading layer [==================================================>]  23.25MB/23.25MB
5fa6889b9a6d: Loading layer [==================================================>]   2.56kB/2.56kB
bd3ac235b209: Loading layer [==================================================>]   2.56kB/2.56kB
cb5d493833cc: Loading layer [==================================================>]  2.048kB/2.048kB
557669a074de: Loading layer [==================================================>]   22.8MB/22.8MB
f02b4f30a9ac: Loading layer [==================================================>]   22.8MB/22.8MB
Loaded image: vmware/registry-photon:v2.6.2-v1.5.1
5d3b562db23e: Loading layer [==================================================>]  23.25MB/23.25MB
8edca1b0e3b0: Loading layer [==================================================>]  12.16MB/12.16MB
ce5f11ea46c0: Loading layer [==================================================>]   17.3MB/17.3MB
93750d7ec363: Loading layer [==================================================>]  15.87kB/15.87kB
36f81937e80d: Loading layer [==================================================>]  3.072kB/3.072kB
37e5df92b624: Loading layer [==================================================>]  29.46MB/29.46MB
Loaded image: vmware/notary-server-photon:v0.5.1-v1.5.1
0a2f8f90bd3a: Loading layer [==================================================>]  401.3MB/401.3MB
41fca4deb6bf: Loading layer [==================================================>]  9.216kB/9.216kB
f2e28262e760: Loading layer [==================================================>]  9.216kB/9.216kB
68677196e356: Loading layer [==================================================>]   7.68kB/7.68kB
2b006714574e: Loading layer [==================================================>]  1.536kB/1.536kB
Loaded image: vmware/mariadb-photon:v1.5.1
a8c4992c632e: Loading layer [==================================================>]  156.3MB/156.3MB
0f37bf842677: Loading layer [==================================================>]  10.75MB/10.75MB
9f34c0cd38bf: Loading layer [==================================================>]  2.048kB/2.048kB
91ca17ca7e16: Loading layer [==================================================>]  48.13kB/48.13kB
5a7e0da65127: Loading layer [==================================================>]   10.8MB/10.8MB
Loaded image: vmware/clair-photon:v2.0.1-v1.5.1
0e782fe069e7: Loading layer [==================================================>]  23.25MB/23.25MB
67fc1e2f7009: Loading layer [==================================================>]  15.36MB/15.36MB
8db2141aa82c: Loading layer [==================================================>]  15.36MB/15.36MB
Loaded image: vmware/harbor-adminserver:v1.5.1
3f87a34f553c: Loading layer [==================================================>]  4.772MB/4.772MB
Loaded image: vmware/nginx-photon:v1.5.1
Loaded image: vmware/photon:1.0
ad58f3ddcb1b: Loading layer [==================================================>]  10.95MB/10.95MB
9b50f12509bf: Loading layer [==================================================>]   17.3MB/17.3MB
2c21090fd212: Loading layer [==================================================>]  15.87kB/15.87kB
38bec864f23e: Loading layer [==================================================>]  3.072kB/3.072kB
6e81ea7b0fa6: Loading layer [==================================================>]  28.24MB/28.24MB
Loaded image: vmware/notary-signer-photon:v0.5.1-v1.5.1
897a26fa09cb: Loading layer [==================================================>]  95.02MB/95.02MB
16e3a10a21ba: Loading layer [==================================================>]  6.656kB/6.656kB
85ecac164331: Loading layer [==================================================>]  2.048kB/2.048kB
37a2fb188706: Loading layer [==================================================>]   7.68kB/7.68kB
Loaded image: vmware/postgresql-photon:v1.5.1
bed9f52be1d1: Loading layer [==================================================>]  11.78kB/11.78kB
d731f2986f6e: Loading layer [==================================================>]   2.56kB/2.56kB
c3fde9a69f96: Loading layer [==================================================>]  3.072kB/3.072kB
Loaded image: vmware/harbor-db:v1.5.1
7844feb13ef3: Loading layer [==================================================>]  78.68MB/78.68MB
de0fd8aae388: Loading layer [==================================================>]  3.072kB/3.072kB
3f79efb720fd: Loading layer [==================================================>]   59.9kB/59.9kB
1c02f801c2e8: Loading layer [==================================================>]  61.95kB/61.95kB
Loaded image: vmware/redis-photon:v1.5.1
454c81edbd3b: Loading layer [==================================================>]  135.2MB/135.2MB
e99db1275091: Loading layer [==================================================>]  395.4MB/395.4MB
051e4ee23882: Loading layer [==================================================>]  9.216kB/9.216kB
6cca4437b6f6: Loading layer [==================================================>]  9.216kB/9.216kB
1d48fc08c8bc: Loading layer [==================================================>]   7.68kB/7.68kB
0419724fd942: Loading layer [==================================================>]  1.536kB/1.536kB
543c0c1ee18d: Loading layer [==================================================>]  655.2MB/655.2MB
4190aa7e89b8: Loading layer [==================================================>]  103.9kB/103.9kB
Loaded image: vmware/harbor-migrator:v1.5.0


[Step 2]: preparing environment ...
Generated and saved secret to file: /data/secretkey
Generated configuration file: ./common/config/nginx/nginx.conf
Generated configuration file: ./common/config/adminserver/env
Generated configuration file: ./common/config/ui/env
Generated configuration file: ./common/config/registry/config.yml
Generated configuration file: ./common/config/db/env
Generated configuration file: ./common/config/jobservice/env
Generated configuration file: ./common/config/jobservice/config.yml
Generated configuration file: ./common/config/log/logrotate.conf
Generated configuration file: ./common/config/jobservice/config.yml
Generated configuration file: ./common/config/ui/app.conf
Generated certificate, key file: ./common/config/ui/private_key.pem, cert file: ./common/config/registry/root.crt
The configuration files are ready, please use docker-compose to start the service.
Creating harbor-log ... done

[Step 3]: checking existing instance of Harbor ...

Creating registry ... done
Creating harbor-ui ... done
Creating network "harbor_harbor" with the default driver
Creating nginx ... done
Creating registry ... 
Creating harbor-adminserver ... 
Creating harbor-db ... 
Creating redis ... 
Creating harbor-ui ... 
Creating harbor-jobservice ... 
Creating nginx ... 

✔ ----Harbor has been installed and started successfully.----

Now you should be able to visit the admin portal at http://harbor.gitnavi.com. 
For more details, please visit https://github.com/vmware/harbor .
```

- 安装成功后，可以访问：<http://harbor.gitnavi.com>
	- 默认用户名：`admin`
	- 默认密码：`Harbor12345`
- docker 客户端默认是使用 https 访问 docker registry，我们默认在安装 Harbor 的时候配置文件用的时候 http，所以其他 docker 客户端需要修改
	- `vim /lib/systemd/system/docker.service`
	- 修改默认值为：`ExecStart=/usr/bin/dockerd`
	- 改为：`ExecStart=/usr/bin/dockerd --insecure-registry harbor.gitnavi.com`
	- `systemctl daemon-reload`
    - `systemctl reload docker`
    - `systemctl restart docker`
- 访问：<http://harbor.gitnavi.com/harbor/projects>，创建一个项目，比如：`youmeek`，等下需要用到。
	- 这里用 admin 用户，不再另外创建用了，但是实际使用最好新建用户。
	- `docker login -u admin -p Harbor12345 harbor.gitnavi.com`
- 给本地的一个 maven 镜像打 tag：`docker tag maven:3.3-jdk-8 harbor.gitnavi.com/youmeek/harbor-maven:3.3-jdk-8`
- push 到仓库：`docker push 182.61.19.178/demo/springboot-jenkins-docker:3`

----------------------------------------------------------------------------

## harbor.cfg 默认值


```
## Configuration file of Harbor

#This attribute is for migrator to detect the version of the .cfg file, DO NOT MODIFY!
_version = 1.5.0
#The IP address or hostname to access admin UI and registry service.
#DO NOT use localhost or 127.0.0.1, because Harbor needs to be accessed by external clients.
hostname = reg.mydomain.com

#The protocol for accessing the UI and token/notification service, by default it is http.
#It can be set to https if ssl is enabled on nginx.
ui_url_protocol = http

#Maximum number of job workers in job service  
max_job_workers = 50 

#Determine whether or not to generate certificate for the registry's token.
#If the value is on, the prepare script creates new root cert and private key 
#for generating token to access the registry. If the value is off the default key/cert will be used.
#This flag also controls the creation of the notary signer's cert.
customize_crt = on

#The path of cert and key files for nginx, they are applied only the protocol is set to https
ssl_cert = /data/cert/server.crt
ssl_cert_key = /data/cert/server.key

#The path of secretkey storage
secretkey_path = /data

#Admiral's url, comment this attribute, or set its value to NA when Harbor is standalone
admiral_url = NA

#Log files are rotated log_rotate_count times before being removed. If count is 0, old versions are removed rather than rotated.
log_rotate_count = 50
#Log files are rotated only if they grow bigger than log_rotate_size bytes. If size is followed by k, the size is assumed to be in kilobytes. 
#If the M is used, the size is in megabytes, and if G is used, the size is in gigabytes. So size 100, size 100k, size 100M and size 100G 
#are all valid.
log_rotate_size = 200M

#Config http proxy for Clair, e.g. http://my.proxy.com:3128
#Clair doesn't need to connect to harbor ui container via http proxy.
http_proxy =
https_proxy =
no_proxy = 127.0.0.1,localhost,ui

#NOTES: The properties between BEGIN INITIAL PROPERTIES and END INITIAL PROPERTIES
#only take effect in the first boot, the subsequent changes of these properties 
#should be performed on web ui

#************************BEGIN INITIAL PROPERTIES************************

#Email account settings for sending out password resetting emails.

#Email server uses the given username and password to authenticate on TLS connections to host and act as identity.
#Identity left blank to act as username.
email_identity = 

email_server = smtp.mydomain.com
email_server_port = 25
email_username = sample_admin@mydomain.com
email_password = abc
email_from = admin <sample_admin@mydomain.com>
email_ssl = false
email_insecure = false

##The initial password of Harbor admin, only works for the first time when Harbor starts. 
#It has no effect after the first launch of Harbor.
#Change the admin password from UI after launching Harbor.
harbor_admin_password = Harbor12345

##By default the auth mode is db_auth, i.e. the credentials are stored in a local database.
#Set it to ldap_auth if you want to verify a user's credentials against an LDAP server.
auth_mode = db_auth

#The url for an ldap endpoint.
ldap_url = ldaps://ldap.mydomain.com

#A user's DN who has the permission to search the LDAP/AD server. 
#If your LDAP/AD server does not support anonymous search, you should configure this DN and ldap_search_pwd.
#ldap_searchdn = uid=searchuser,ou=people,dc=mydomain,dc=com

#the password of the ldap_searchdn
#ldap_search_pwd = password

#The base DN from which to look up a user in LDAP/AD
ldap_basedn = ou=people,dc=mydomain,dc=com

#Search filter for LDAP/AD, make sure the syntax of the filter is correct.
#ldap_filter = (objectClass=person)

# The attribute used in a search to match a user, it could be uid, cn, email, sAMAccountName or other attributes depending on your LDAP/AD  
ldap_uid = uid 

#the scope to search for users, 0-LDAP_SCOPE_BASE, 1-LDAP_SCOPE_ONELEVEL, 2-LDAP_SCOPE_SUBTREE
ldap_scope = 2 

#Timeout (in seconds)  when connecting to an LDAP Server. The default value (and most reasonable) is 5 seconds.
ldap_timeout = 5

#Verify certificate from LDAP server
ldap_verify_cert = true

#The base dn from which to lookup a group in LDAP/AD
ldap_group_basedn = ou=group,dc=mydomain,dc=com

#filter to search LDAP/AD group
ldap_group_filter = objectclass=group

#The attribute used to name a LDAP/AD group, it could be cn, name
ldap_group_gid = cn

#The scope to search for ldap groups. 0-LDAP_SCOPE_BASE, 1-LDAP_SCOPE_ONELEVEL, 2-LDAP_SCOPE_SUBTREE
ldap_group_scope = 2

#Turn on or off the self-registration feature
self_registration = on

#The expiration time (in minute) of token created by token service, default is 30 minutes
token_expiration = 30

#The flag to control what users have permission to create projects
#The default value "everyone" allows everyone to creates a project. 
#Set to "adminonly" so that only admin user can create project.
project_creation_restriction = everyone

#************************END INITIAL PROPERTIES************************

#######Harbor DB configuration section#######

#The address of the Harbor database. Only need to change when using external db.
db_host = mysql

#The password for the root user of Harbor DB. Change this before any production use.
db_password = root123

#The port of Harbor database host
db_port = 3306

#The user name of Harbor database
db_user = root

##### End of Harbor DB configuration#######

#The redis server address. Only needed in HA installation.
#address:port[,weight,password,db_index]
redis_url = redis:6379

##########Clair DB configuration############

#Clair DB host address. Only change it when using an exteral DB.
clair_db_host = postgres

#The password of the Clair's postgres database. Only effective when Harbor is deployed with Clair.
#Please update it before deployment. Subsequent update will cause Clair's API server and Harbor unable to access Clair's database.
clair_db_password = password

#Clair DB connect port
clair_db_port = 5432

#Clair DB username
clair_db_username = postgres

#Clair default database
clair_db = postgres

##########End of Clair DB configuration############

#The following attributes only need to be set when auth mode is uaa_auth
uaa_endpoint = uaa.mydomain.org
uaa_clientid = id
uaa_clientsecret = secret
uaa_verify_cert = true
uaa_ca_cert = /path/to/ca.pem


### Docker Registry setting ###
#registry_storage_provider can be: filesystem, s3, gcs, azure, etc.
registry_storage_provider_name = filesystem
#registry_storage_provider_config is a comma separated "key: value" pairs, e.g. "key1: value, key2: value2".
#Refer to https://docs.docker.com/registry/configuration/#storage for all available configuration.
registry_storage_provider_config =
```


## 资料

- <https://www.ilanni.com/?p=13492>
- <https://blog.csdn.net/aixiaoyang168/article/details/73549898>
