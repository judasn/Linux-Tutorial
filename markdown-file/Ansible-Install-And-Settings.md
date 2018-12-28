# Ansible 安装和配置


## Ansible 说明

- Ansible 官网：<https://www.ansible.com/>
- Ansible 官网 Github：<https://github.com/ansible/ansible>
- Ansible 官网文档：<https://docs.ansible.com//>
- 简单讲：它的作用就是把写 shell 这件事变成标准化、模块化。方便更好的自动化运维

## 安装

- 官网说明：<https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html>
- CentOS：`sudo yum install -y ansible`
	- 查看版本：`ansible --version`

-------------------------------------------------------------------

## 配置基本概念

#### Ansible 基本配置文件顺序

- Ansible 执行的时候会按照以下顺序查找配置项，所以修改的时候要特别注意改的是哪个文件

```
ANSIBLE_CONFIG (环境变量)
ansible.cfg (脚本所在当前目录下)
~/.ansible.cfg (用户家目录下，默认没有)
/etc/ansible/ansible.cfg（安装后会自动生成）
```


#### 配置远程主机地址 (Ansible 称这些地址为 Inventory)

- 假设我有 3 台机子：
	- 192.168.0.223
	- 192.168.0.70
	- 192.168.0.103
- 官网对此的配置说明：<https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#hosts-and-groups>

###### 给这三台机子设置免密登录的情况（一般推荐方式）

- 编辑 Ansible 配置文件：`vim /etc/ansible/hosts`
- 添加如下内容

```
[hadoop-host]
192.168.0.223
192.168.0.70
192.168.0.103
```

- 其中 `[hadoop-host]` 表示这些主机代表的一个组名


###### 如果不设置免密，直接采用账号密码（容易泄露信息）


- 编辑 Ansible 配置文件：`vim /etc/ansible/hosts`
- 添加如下内容

```
[hadoop-host]
hadoop-master ansible_host=192.168.0.223 ansible_user=root ansible_ssh_pass=123456
hadoop-node1  ansible_host=192.168.0.70 ansible_user=root ansible_ssh_pass=123456
hadoop-node2  ansible_host=192.168.0.103 ansible_user=root ansible_ssh_pass=123456
```



## 简单使用（`ad hoc`方式）

- ad hoc 官网：<https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html>

##### 运行 Ansible

- 运行 Ansible 的 `ping` 命令，看看配置正确时输出如下：

```
sudo ansible --private-key ~/.ssh/id_rsa all -m ping
```

- 让远程所有主机都执行 `ps` 命令，输出如下

```
ansible all -a 'ps'
```

- 让远程所有 hadoop-host 组的主机都执行 `ps` 命令，输出如下

```
ansible hadoop-host -a 'ps'
```

-------------------------------------------------------------------

## Playbook 脚本方式

- 官网：<https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html>
- 一些语法：<https://docs.ansible.com/ansible/latest/modules/command_module.html>
- playbook（剧本），顾名思义，就是需要定义一个脚本或者说配置文件，然后定义好要做什么。之后 ansible 就会根据 playbook 脚本对远程主机进行操作

#### 简单脚本

- 下面脚本让所有远程主机执行 `whoami` 命令，并把结果（当前用户名）输出到 `/opt/whoami.txt` 文件
- 创建脚本文件：`vim /opt/simple-playbook.yml`

```
- hosts: all
  tasks:
    - name: whoami
      shell: 'whoami > /opt/whoami.txt'
```

- 执行命令：`ansible-playbook /opt/simple-playbook.yml`，结果如下，并且 opt 下也有文件生成

```
PLAY [all] **************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************
ok: [192.168.0.223]
ok: [192.168.0.103]
ok: [192.168.0.70]

TASK [whoami] ***********************************************************************************************************************
changed: [192.168.0.103]
changed: [192.168.0.223]
changed: [192.168.0.70]

PLAY RECAP **************************************************************************************************************************
192.168.0.103              : ok=2    changed=1    unreachable=0    failed=0
192.168.0.223              : ok=2    changed=1    unreachable=0    failed=0
192.168.0.70               : ok=2    changed=1    unreachable=0    failed=0
```

-------------------------------------------------------------------

## 平时用来测试

- 创建脚本文件：`vim /opt/test-playbook.yml`

```
- hosts: hadoop-test
  remote_user: root
  vars:
    java_install_folder: /usr/local
  tasks:
    # 按行的方式写入
    - name: Set JAVA_HOME 1
      lineinfile: 
        dest=/etc/profile
        line="JAVA_HOME={{ java_install_folder }}/jdk1.8.0_181"
    # 按块的方式写入，#{mark} 会被自动替换成：begin 和 end 字符来包裹整块内容（我这里自己定义了词语）
    - name: Set JAVA_HOME 2
      blockinfile: 
        path: /etc/profile
        marker: "#{mark} JDK ENV"
        marker_begin: "开始"
        marker_end: "结束"
        block: |
          export JAVA_HOME={{ java_install_folder }}/jdk1.8.0_181
          export PATH=$PATH:$JAVA_HOME/bin
```

- 执行命令：`ansible-playbook /opt/test-playbook.yml`

-------------------------------------------------------------------

## 更多 playbook 实战


#### 禁用防火墙（CentOS 7.x）


- 创建脚本文件：`vim /opt/disable-firewalld-playbook.yml`

```
- hosts: all
  remote_user: root
  tasks:
    - name: Disable SELinux at next reboot
      selinux:
        state: disabled
    - name: disable firewalld
      command: "{{ item }}"
      with_items:
         - systemctl stop firewalld
         - systemctl disable firewalld
         - setenforce 0
```



#### 基础环境（CentOS 7.x）


- 创建脚本文件：`vim /opt/install-basic-playbook.yml`

```
- hosts: all
  remote_user: root
  tasks:
    - name: Disable SELinux at next reboot
      selinux:
        state: disabled
        
    - name: disable firewalld
      command: "{{ item }}"
      with_items:
         - systemctl stop firewalld
         - systemctl disable firewalld
         - setenforce 0
         
    - name: install-basic
      command: "{{ item }}"
      with_items:
         - yum install -y zip unzip lrzsz git epel-release wget htop deltarpm
         
    - name: install-vim
      shell: "{{ item }}"
      with_items:
         - yum install -y vim
         - curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc
         
    - name: install-docker
      shell: "{{ item }}"
      with_items:
         - yum install -y yum-utils device-mapper-persistent-data lvm2
         - yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
         - yum makecache fast
         - yum install -y docker-ce
         - systemctl start docker.service
         - docker run hello-world
         
    - name: install-docker-compose
      shell: "{{ item }}"
      with_items:
         - curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
         - chmod +x /usr/local/bin/docker-compose
         - docker-compose --version
         - systemctl restart docker.service
         - systemctl enable docker.service
         
```


- 执行命令：`ansible-playbook /opt/install-basic-playbook.yml`

#### 修改 hosts


- 创建脚本文件：`vim /opt/hosts-playbook.yml`

```
- hosts: all
  remote_user: root
  tasks:
    - name: update hosts
      blockinfile: 
        path: /etc/hosts
        block: |
          192.168.0.223     linux01
          192.168.0.223     linux02
          192.168.0.223     linux03
          192.168.0.223     linux04
          192.168.0.223     linux05
```


- 执行命令：`ansible-playbook /opt/hosts-playbook.yml`



#### 部署 JDK 

- 创建脚本文件：`vim /opt/jdk8-playbook.yml`

```
- hosts: hadoop-host
  remote_user: root
  vars:
    java_install_folder: /usr/local
  tasks:
    - name: copy jdk
      copy: src=/opt/jdk-8u181-linux-x64.tar.gz dest={{ java_install_folder }}
      
    - name: tar jdk
      shell: chdir={{ java_install_folder }} tar zxf jdk-8u181-linux-x64.tar.gz
      
    - name: set JAVA_HOME
      blockinfile: 
        path: /etc/profile
        marker: "#{mark} JDK ENV"
        block: |
          JAVA_HOME={{ java_install_folder }}/jdk1.8.0_181
          JRE_HOME=$JAVA_HOME/jre
          PATH=$PATH:$JAVA_HOME/bin
          CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
          export JAVA_HOME
          export JRE_HOME
          export PATH
          export CLASSPATH
    
    - name: source profile
      shell: source /etc/profile
```


- 执行命令：`ansible-playbook /opt/jdk8-playbook.yml`



#### 部署 Hadoop 集群 

- 创建脚本文件：`vim /opt/hadoop-playbook.yml`
- 刚学 Ansible，不好动配置文件，所以就只保留环境部分的设置，其他部分自行手工~

```
- hosts: hadoop-host
  remote_user: root
  tasks:
    - name: Creates directory
      file:
        path: /data/hadoop/hdfs/name
        state: directory
    - name: Creates directory
      file:
        path: /data/hadoop/hdfs/data
        state: directory
    - name: Creates directory
      file:
        path: /data/hadoop/hdfs/tmp
        state: directory

    - name: set HADOOP_HOME
      blockinfile: 
        path: /etc/profile
        marker: "#{mark} HADOOP ENV"
        block: |
          HADOOP_HOME=/usr/local/hadoop
          PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
          export HADOOP_HOME
          export PATH
    
    - name: source profile
      shell: source /etc/profile
```


- 执行命令：`ansible-playbook /opt/hadoop-playbook.yml`





-------------------------------------------------------------------


## 资料

- [ANSIBLE模块 - shell和command区别](https://www.jianshu.com/p/081139f73613)
- <https://www.the5fire.com/ansible-guide-cn.html>
- <https://www.jianshu.com/p/62388a4fcbc6>
- <http://showme.codes/2017-06-12/ansible-introduce/>