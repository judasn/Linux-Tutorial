 
 
# Kubernets（K8S） 使用
 
## 环境说明
 
- CentOS 7.5（不准确地说：要求必须是 CentOS 7 64位）
- Docker

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


#### 安装准备 - Kubernetes 1.13 版本

- 推荐最低 2C2G，优先：2C4G 或以上 
- 特别说明：1.13 之前的版本，由于网络问题，需要各种设置，这里就不再多说了。1.13 之后相对就简单了点。
- 优先官网软件包：kubeadm
- 官网资料：
    - issues 入口：<https://github.com/kubernetes/kubeadm>
    - 源码入口：<https://github.com/kubernetes/kubernetes/tree/master/cmd/kubeadm>
    - 安装指导：<https://kubernetes.io/docs/setup/independent/install-kubeadm/>
    - 按官网要求做下检查：<https://kubernetes.io/docs/setup/independent/install-kubeadm/#before-you-begin>
    - 网络环境：<https://kubernetes.io/docs/setup/independent/install-kubeadm/#verify-the-mac-address-and-product-uuid-are-unique-for-every-node>
    - 端口检查：<https://kubernetes.io/docs/setup/independent/install-kubeadm/#check-required-ports>
    - **对 Docker 版本的支持，这里官网推荐的是 18.06**：<https://kubernetes.io/docs/setup/release/notes/#sig-cluster-lifecycle>
- 三大核心工具包，都需要各自安装，并且注意版本关系：
    - `kubeadm`: the command to bootstrap the cluster.
        - 集群部署、管理工具
    - `kubelet`: the component that runs on all of the machines in your cluster and does things like starting pods and containers.
        - 具体执行层面的管理 Pod 和 Docker 工具
    - `kubectl`: the command line util to talk to your cluster.
        - 操作 k8s 的命令行入口工具
- 官网插件安装过程的故障排查：<https://kubernetes.io/docs/setup/independent/troubleshooting-kubeadm/>
- 其他部署方案：
    - <https://github.com/coreos/tectonic-installer>
    - <https://github.com/kubernetes-incubator/kubespray>
    - <https://github.com/apprenda/kismatic>

#### 开始安装 - Kubernetes 1.13.3 版本

- 三台机子：
    - master-1：`192.168.0.127`
    - node-1：`192.168.0.128`
    - node-2：`192.168.0.129`
- 官网最新版本：<https://github.com/kubernetes/kubernetes/releases>
- 官网 1.13 版本的 changelog：<https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.13.md>
- **所有节点安装 Docker 18.06，并设置阿里云源** 
    - 可以参考：[点击我o(∩_∩)o ](https://github.com/judasn/Linux-Tutorial/blob/master/favorite-file/shell/install_docker_k8s_disable_firewalld_centos7-aliyun.sh)
    - 核心，查看可以安装的 Docker 列表：`yum list docker-ce --showduplicates`
- 所有节点设置 kubernetes repo 源，并安装 Kubeadm、Kubelet、Kubectl 都设置阿里云的源
- Kubeadm 初始化集群过程当中，它会下载很多的镜像，默认也是去 Google 家里下载。但是 1.13 新增了一个配置：`--image-repository` 算是救了命。

#### 安装具体流程

- 同步所有机子时间：`systemctl start chronyd.service && systemctl enable chronyd.service`
- 所有机子禁用防火墙、selinux、swap

```
systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl disable iptables.service

iptables -P FORWARD ACCEPT

setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

echo "vm.swappiness = 0" >> /etc/sysctl.conf
swapoff -a && sysctl -w vm.swappiness=0
```


- 给各自机子设置 hostname 和 hosts

```
hostnamectl --static set-hostname  k8s-master-1
hostnamectl --static set-hostname  k8s-node-1
hostnamectl --static set-hostname  k8s-node-2


vim /etc/hosts
192.168.0.127 k8s-master-1
192.168.0.128 k8s-node-1
192.168.0.129 k8s-node-2
```

- 给 master 设置免密

```
ssh-keygen -t rsa

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys


ssh localhost

ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 root@k8s-node-1（根据提示输入 k8s-node-1 密码）
ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 root@k8s-node-2（根据提示输入 k8s-node-2 密码）

ssh k8s-master-1
ssh k8s-node-1
ssh k8s-node-2
```


- 给所有机子设置 yum 源

```
vim /etc/yum.repos.d/kubernetes.repo

[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg


scp -r /etc/yum.repos.d/kubernetes.repo root@k8s-node-1:/etc/yum.repos.d/
scp -r /etc/yum.repos.d/kubernetes.repo root@k8s-node-2:/etc/yum.repos.d/
```

- 给 master 机子创建 flannel 配置文件

```
mkdir -p /etc/cni/net.d && vim /etc/cni/net.d/10-flannel.conflist

{
    "name": "cbr0",
    "plugins": [
        {
            "type": "flannel",
            "delegate": {
                "hairpinMode": true,
                "isDefaultGateway": true
            }
        },
        {
            "type": "portmap",
            "capabilities": {
                "portMappings": true
            }
        }
    ]
}
```



- 给所有机子创建配置

```
vim /etc/sysctl.d/k8s.conf

net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1
vm.swappiness=0


scp -r /etc/sysctl.d/k8s.conf root@k8s-node-1:/etc/sysctl.d/
scp -r /etc/sysctl.d/k8s.conf root@k8s-node-2:/etc/sysctl.d/

modprobe br_netfilter && sysctl -p /etc/sysctl.d/k8s.conf
```

- 给所有机子安装组件

```
yum install -y kubelet-1.13.3 kubeadm-1.13.3 kubectl-1.13.3 --disableexcludes=kubernetes
```

- 给所有机子添加一个变量

```
vim  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

最后一行添加：Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"
```


- 启动所有机子

```
systemctl enable kubelet && systemctl start kubelet

kubeadm version
kubectl version

```

- 初始化 master 节点：

```
echo 1 > /proc/sys/net/ipv4/ip_forward


kubeadm init \
--image-repository registry.cn-hangzhou.aliyuncs.com/google_containers \
--pod-network-cidr 10.244.0.0/16 \
--kubernetes-version 1.13.3 \
--ignore-preflight-errors=Swap

其中 10.244.0.0/16 是 flannel 插件固定使用的ip段，它的值取决于你准备安装哪个网络插件

这个过程会下载一些 docker 镜像，时间可能会比较久，看你网络情况。
终端会输出核心内容：
[init] Using Kubernetes version: v1.13.3
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Activating the kubelet service
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8s-master-1 localhost] and IPs [192.168.0.127 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8s-master-1 localhost] and IPs [192.168.0.127 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8s-master-1 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.0.127]
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 19.001686 seconds
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.13" in namespace kube-system with the configuration for the kubelets in the cluster
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "k8s-master-1" as an annotation
[mark-control-plane] Marking the node k8s-master-1 as control-plane by adding the label "node-role.kubernetes.io/master=''"
[mark-control-plane] Marking the node k8s-master-1 as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: 8tpo9l.jlw135r8559kaad4
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstraptoken] creating the "cluster-info" ConfigMap in the "kube-public" namespace
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join 192.168.0.127:6443 --token 8tpo9l.jlw135r8559kaad4 --discovery-token-ca-cert-hash sha256:d6594ccc1310a45cbebc45f1c93f5ac113873786365ed63efcf667c952d7d197
```

- 给 master 机子设置配置

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
```

- 在 master 上查看一些环境

```
kubeadm token list

kubectl cluster-info
```

- 给 master 安装 Flannel

```
cd /opt && wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubectl apply -f /opt/kube-flannel.yml
```

- 到 node 节点加入集群：

```
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables

kubeadm join 192.168.0.127:6443 --token 8tpo9l.jlw135r8559kaad4 --discovery-token-ca-cert-hash sha256:d6594ccc1310a45cbebc45f1c93f5ac113873786365ed63efcf667c952d7d197

这时候终端会输出：

[preflight] Running pre-flight checks
[discovery] Trying to connect to API Server "192.168.0.127:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.0.127:6443"
[discovery] Requesting info from "https://192.168.0.127:6443" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.0.127:6443"
[discovery] Successfully established connection with API Server "192.168.0.127:6443"
[join] Reading configuration from the cluster...
[join] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.13" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "k8s-node-1" as an annotation

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the master to see this node join the cluster.
```

- 如果 node 节点加入失败，可以：`kubeadm reset`，再来重新 join
- 在 master 节点上：`kubectl get cs`

```
NAME                 STATUS    MESSAGE              ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   {"health": "true"} 
结果都是 Healthy 则表示可以了，不然就得检查。必要时可以用：`kubeadm reset` 重置，重新进行集群初始化
```


- 在 master 节点上：`kubectl get nodes`

```
如果还是 NotReady，则查看错误信息：kubectl get pods --all-namespaces
其中：Pending/ContainerCreating/ImagePullBackOff 都是 Pod 没有就绪，我们可以这样查看对应 Pod 遇到了什么问题
kubectl describe pod <Pod Name> --namespace=kube-system
或者：kubectl logs <Pod Name> -n kube-system
tail -f /var/log/messages
```



#### 主要概念

- Master 节点，负责集群的调度、集群的管理
    - 常见组件：<https://kubernetes.io/docs/concepts/overview/components/>
    - kube-apiserver：API服务
    - kube-scheduler：调度
    - Kube-Controller-Manager：容器编排
    - Etcd：保存了整个集群的状态
    - Kube-proxy：负责为 Service 提供 cluster 内部的服务发现和负载均衡
    - Kube-DNS：负责为整个集群提供 DNS 服务
- node 节点，负责容器相关的处理

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


## 资料

- [如何更“优雅”地部署Kubernetes集群](https://juejin.im/entry/5a03f98d6fb9a04524054516)
- []()
- []()
- []()
- []()
- []()
- []()





















