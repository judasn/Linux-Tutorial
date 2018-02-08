 
 
# Kubernetes 部署
 
## 环境说明

- CentOS 7.4
- 购买自阿里云普通的 ECS 华南地区（如果你是购买美国地区的服务器，则直接使用 kubespray 原项目，那些镜像地址不用修改，其他照着文档即可）
- 所有机子都是干净的不需要先安装 Docker 等其他容器相关的东西

| 机器简称 | 内网 IP 地址 | 部署软件  | 系统环境  | 硬件配置 |
|---|---|---|---|---|
| 操作机 | 172.18.243.242 | ansible | CentOS 7.4 | 1 vCPU + 2 GB |
| node1 | 172.18.243.243 | master | CentOS 7.4 | 1 vCPU + 4 GB |
| node2 | 172.18.243.244 | worker | CentOS 7.4 | 1 vCPU + 4 GB |
| node3 | 172.18.243.245 | worker | CentOS 7.4 | 1 vCPU + 4 GB |


## 所有机子都需要的环境准备

- 关闭 SELinux
	- 编辑配置文件：`vim /etc/selinux/config`
	- 把 `SELINUX=enforcing` 改为 `SELINUX=disabled`

所有节点关闭防火墙：`systemctl stop firewalld && systemctl disable firewalld`

安装自己常用的一些组件：vim zsh zip unzip lrzsz git


## 安装过程

#### 操作机安装 ansible

=================================
yum install -y epel-release
yum install -y python-pip python-netaddr ansible git
pip install --upgrade pip
pip install --upgrade Jinja2
pip install cryptography
=================================
yum install -y epel-release
yum install -y python34 python34-pip python-pip python-netaddr ansible git
yum install -y gcc libffi-devel python-devel openssl-devel


pip install wheel

下载：Jinja2 的 2.10 版本：<https://github.com/pallets/jinja/releases>
放在 /opt 根目录
Jinja2-2.10-py2.py3-none-any.whl

cd /opt && wget https://github.com/pallets/jinja/releases/download/2.10/Jinja2-2.10-py2.py3-none-any.whl

pip install /opt/Jinja2-2.10-py2.py3-none-any.whl

pip install cryptography

=================================

操作机免密码登录到其他节点

如果还不懂可以具体看我的这篇文章：[]()
ssh-keygen
ssh-copy-id -i /root/.ssh/id_rsa.pub -p 22 root@172.18.243.243
ssh-copy-id -i /root/.ssh/id_rsa.pub -p 22 root@172.18.243.244
ssh-copy-id -i /root/.ssh/id_rsa.pub -p 22 root@172.18.243.245

测试下是否可以免登陆：
ssh -p 22 root@172.18.243.243
ssh -p 22 root@172.18.243.244
ssh -p 22 root@172.18.243.245

#### 修改 kubespray 项目配置

- kubespray 项目官网：<https://github.com/kubernetes-incubator/kubespray>


在本地机子上

git clone https://github.com/kubernetes-incubator/kubespray.git

当前时间（2018-02）最新版本是：v2.4.0，所以我 checkout v2.4.0 的 tag

用 IntelliJ IDEA 打开该项目，然后批量替换：

- `gcr.io/` 替换成：`registry.cn-hangzhou.aliyuncs.com/`
- 因为 gcr.io 这个网站的本地址是：https://cloud.google.com/container-registry/，国内的环境当然就没资格上了，所以才要替换。
- 但是需要注意的是，官网的这些镜像阿里云不一定有，所以稳妥点，你最好可以去阿里云检查下的：<https://dev.aliyun.com/search.html>，或者是：<https://hub.docker.com/>

修改 /kubespray/inventory/local-tests.cfg，改为如下内容：

```
[all]
node1    ansible_host=172.18.243.243 ansible_user=root ip=172.18.243.243
node2    ansible_host=172.18.243.244 ansible_user=root ip=172.18.243.244
node3    ansible_host=172.18.243.245 ansible_user=root ip=172.18.243.245

[kube-master]
node1

[etcd]
node1

[kube-node]
node2
node3

[k8s-cluster:children]
kube-node
kube-master
```


然后把这个项目压缩成 zip 上传到操作机的 /opt 根目录上，然后解压。

然后在操作机上执行：`cd /opt/kubespray && ansible-playbook -u centos -b -i /opt/kubespray/inventory/local-tests.cfg cluster.yml`
然后会开始输出一大堆执行任务的东西，等等吧，预计需要 5 分钟左右。

然后报错：

```
Thursday 08 February 2018  18:03:14 +0800 (0:00:00.038)       0:04:14.420 ***** 
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (4 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (4 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (4 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (3 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (3 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (3 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (2 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (2 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (2 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (1 retries left).
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (1 retries left).
fatal: [node1]: FAILED! => {"attempts": 4, "changed": true, "cmd": ["/usr/bin/docker", "pull", "registry.cn-hangzhou.aliyuncs.com/google_containers/cluster-proportional-autoscaler-amd64:1.1.2"], "delta": "0:00:00.413852", "end": "2018-02-08 18:03:38.396245", "msg": "non-zero return code", "rc": 1, "start": "2018-02-08 18:03:37.982393", "stderr": "Error response from daemon: repository registry.cn-hangzhou.aliyuncs.com/google_containers/cluster-proportional-autoscaler-amd64 not found: does not exist or no pull access", "stderr_lines": ["Error response from daemon: repository registry.cn-hangzhou.aliyuncs.com/google_containers/cluster-proportional-autoscaler-amd64 not found: does not exist or no pull access"], "stdout": "", "stdout_lines": []}
FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (1 retries left).
fatal: [node3]: FAILED! => {"attempts": 4, "changed": true, "cmd": ["/usr/bin/docker", "pull", "registry.cn-hangzhou.aliyuncs.com/google_containers/cluster-proportional-autoscaler-amd64:1.1.2"], "delta": "0:00:00.421977", "end": "2018-02-08 18:03:42.334875", "msg": "non-zero return code", "rc": 1, "start": "2018-02-08 18:03:41.912898", "stderr": "Error response from daemon: repository registry.cn-hangzhou.aliyuncs.com/google_containers/cluster-proportional-autoscaler-amd64 not found: does not exist or no pull access", "stderr_lines": ["Error response from daemon: repository registry.cn-hangzhou.aliyuncs.com/google_containers/cluster-proportional-autoscaler-amd64 not found: does not exist or no pull access"], "stdout": "", "stdout_lines": []}
fatal: [node2]: FAILED! => {"attempts": 4, "changed": true, "cmd": ["/usr/bin/docker", "pull", "registry.cn-hangzhou.aliyuncs.com/google_containers/cluster-proportional-autoscaler-amd64:1.1.2"], "delta": "0:00:00.390301", "end": "2018-02-08 18:03:46.246213", "msg": "non-zero return code", "rc": 1, "start": "2018-02-08 18:03:45.855912", "stderr": "Error response from daemon: repository registry.cn-hangzhou.aliyuncs.com/google_containers/cluster-proportional-autoscaler-amd64 not found: does not exist or no pull access", "stderr_lines": ["Error response from daemon: repository registry.cn-hangzhou.aliyuncs.com/google_containers/cluster-proportional-autoscaler-amd64 not found: does not exist or no pull access"], "stdout": "", "stdout_lines": []}
```

说明这个镜像在阿里云没有，所以我有在 docker 官网找了下，有一个这个：`mirrorgooglecontainers/cluster-proportional-autoscaler-amd64`

建议你可以找个有 docker 的服务器试一下：`docker pull mirrorgooglecontainers/cluster-proportional-autoscaler-amd64`，如果能下载，那就说明没问题了。
同时也发现这个 docker hub 用户是北京的，应该同道。

然后又报了下面这个错误。主要是这个脚本：/usr/local/bin/etcd-scripts/make-ssl-etcd.sh 有这个错误：$'\r': command not found
而这个脚本是来自操作机上的 /opt/kubespray/roles/etcd/files 目录

```
fatal: [node1 -> 172.18.243.243]: FAILED! => {"changed": true, "cmd": ["bash", "-x", "/usr/local/bin/etcd-scripts/make-ssl-etcd.sh", "-f", "/etc/ssl/etcd/openssl.conf", "-d", "/etc/ssl/etcd/ssl"], "delta": "0:00:00.012822", "end": "2018-02-08 18:42:09.815776", "msg": "non-zero return code", "rc": 2, "start": "2018-02-08 18:42:09.802954", "stderr": "+ $'\\r'\n/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 2: $'\\r': command not found\n+ $'\\r'\n/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 16: $'\\r': command not found\n+ set -o $'errexit\\r'\n/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 17: set: errexit\r: invalid option name\n+ set -o $'pipefail\\r'\n/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 18: set: pipefail\r: invalid option name\n/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 19: syntax error near unexpected token `$'\\r''\n/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 19: `usage()\r'", "stderr_lines": ["+ $'\\r'", "/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 2: $'\\r': command not found", "+ $'\\r'", "/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 16: $'\\r': command not found", "+ set -o $'errexit\\r'", "/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 17: set: errexit", ": invalid option name", "+ set -o $'pipefail\\r'", "/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 18: set: pipefail", ": invalid option name", "/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 19: syntax error near unexpected token `$'\\r''", "/usr/local/bin/etcd-scripts/make-ssl-etcd.sh: line 19: `usage()", "'"], "stdout": "", "stdout_lines": []}
```

我们需要操作这个机节点做这样的操作：

```
yum install -y dos2unix unix2dos

cd /opt/kubespray/roles/etcd/files && dos2unix make-ssl-etcd.sh
```

然后切换到操作机重新执行刚刚的命令


```
fatal: [node2 -> 172.18.243.243]: FAILED! => {"changed": false, "cmd": "/usr/local/bin/kubernetes-scripts/make-ssl.sh -f /etc/kubernetes/openssl.conf -d /etc/kubernetes/ssl", "msg": "[Errno 2] No such file or directory", "rc": 2}


Thursday 08 February 2018  19:23:46 +0800 (0:00:00.539)       0:04:13.884 ***** 
fatal: [node1]: FAILED! => {"changed": false, "cmd": "/usr/local/bin/etcdctl --endpoints=https://172.18.243.243:2379 cluster-health | grep -q 'cluster is healthy'", "delta": "0:00:00.021278", "end": "2018-02-08 19:23:46.733967", "msg": "non-zero return code", "rc": 1, "start": "2018-02-08 19:23:46.712689", "stderr": "Error:  client: etcd cluster is unavailable or misconfigured; error #0: dial tcp 172.18.243.243:2379: getsockopt: connection refused\n\nerror #0: dial tcp 172.18.243.243:2379: getsockopt: connection refused", "stderr_lines": ["Error:  client: etcd cluster is unavailable or misconfigured; error #0: dial tcp 172.18.243.243:2379: getsockopt: connection refused", "", "error #0: dial tcp 172.18.243.243:2379: getsockopt: connection refused"], "stdout": "", "stdout_lines": []}
...ignoring

TASK [etcd : Configure | Check if member is in cluster] ***********************************************************************************************************************************************************************************************************************
Thursday 08 February 2018  19:23:46 +0800 (0:00:00.518)       0:04:14.403 ***** 
fatal: [node1]: FAILED! => {"changed": false, "cmd": "/usr/local/bin/etcdctl --no-sync --endpoints=https://172.18.243.243:2379 member list | grep -q 172.18.243.243", "delta": "0:00:00.022093", "end": "2018-02-08 19:23:47.126478", "msg": "non-zero return code", "rc": 1, "start": "2018-02-08 19:23:47.104385", "stderr": "client: etcd cluster is unavailable or misconfigured; error #0: dial tcp 172.18.243.243:2379: getsockopt: connection refused", "stderr_lines": ["client: etcd cluster is unavailable or misconfigured; error #0: dial tcp 172.18.243.243:2379: getsockopt: connection refused"], "stdout": "", "stdout_lines": []}
...ignoring

TASK [etcd : Install etcd launch script] **************************************************************************************************************************************************************************************************************************************
Thursday 08 February 2018  19:23:47 +0800 (0:00:00.333)       0:04:14.737 ***** 
changed: [node1]

```

cd /opt/kubespray/roles/kubernetes/secrets/files && dos2unix make-ssl.sh


```
fatal: [node2]: FAILED! => {"msg": "The conditional check ''Added' in gentoken_master.stdout' failed. The error was: error while evaluating conditional ('Added' in gentoken_master.stdout): Unable to look up a name or access an attribute in template string ({% if 'Added' in gentoken_master.stdout %} True {% else %} False {% endif %}).\nMake sure your variable name does not contain invalid characters like '-': argument of type 'StrictUndefined' is not iterable"}

```

```
fatal: [node1]: FAILED! => {"msg": "The conditional check '{%- set certs = {'sync': False} -%}\n{% if gen_node_certs[inventory_hostname] or\n  (not etcdcert_node.results[0].stat.exists|default(False)) or\n    (not etcdcert_node.results[1].stat.exists|default(False)) or\n      (etcdcert_node.results[1].stat.checksum|default('') != etcdcert_master.files|selectattr(\"path\", \"equalto\", etcdcert_node.results[1].stat.path)|map(attribute=\"checksum\")|first|default('')) -%}\n        {%- set _ = certs.update({'sync': True}) -%}\n{% endif %}\n{{ certs.sync }}' failed. The error was: no test named 'equalto'\n\nThe error appears to have been in '/opt/kubespray/roles/etcd/tasks/check_certs.yml': line 57, column 3, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n- name: \"Check_certs | Set 'sync_certs' to true\"\n  ^ here\n"}
ok: [node2]
ok: [node3]

```


#### 验证

SSH 连上 master 节点：ssh root@172.18.243.243
输入：`kubectl get nodes`

展示出如下信息：
NAME      STATUS                     AGE       VERSION
node1     Ready,SchedulingDisabled   1m        v1.6.1+coreos.0
node2     Ready                      1m        v1.6.1+coreos.0
node3     Ready                      1m        v1.6.1+coreos.0

## 资料

- <http://www.wisely.top/2017/05/16/kargo-ansible-kubernetes/>
- <https://github.com/wiselyman/kubespray>
- <>
- <>