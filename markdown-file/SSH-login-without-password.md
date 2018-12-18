# SSH 免密登录

## 环境说明

- CentOS 7.3

## 关键点

- 免密登录的关键点在于理解谁登录谁。
- A 生成的公钥给 B，也给 C、D，则 A 可以直接免密 SSH 登录 B、C、D

## A 生成密钥

- 在 A 机器上输入命令：`ssh-keygen`
	- 根据提示回车，共有三次交互提示，都回车即可。
- 生成的密钥目录在：**/root/.ssh**
- 写入：`cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys`
- 测试：`ssh localhost`


## 把 A 的公钥发给 B

- 假设 B 机器的 ip：`192.168.1.105`
- 则在 A 机器上输入：`ssh-copy-id -i /root/.ssh/id_rsa.pub -p 22 root@192.168.1.105`，根据提示输入 B 机器的 root 密码，成功会有相应提示

## 测试 A 免密登录到 B

- 在 A 机器上输入命令：`ssh -p 22 root@192.168.1.105`，则会相应登录成功的提示

-------------------------------------------------------------------

## 如果是用 pem 登录的话，用 ssh-copy-id 是无法使用的

- 先保存 A 的 pub 到本地：`sz /root/.ssh/id_rsa.pub`
- 登录 B 机子：`cd /root/.ssh/`
- 如果 B 机子没有 authorized_keys 文件则创建：`touch /root/.ssh/authorized_keys`
	- 设置权限：`chmod 600 /root/.ssh/authorized_keys `
- 上传 pub 文件到 B 机子，并在 B 机子上执行：`cd /root/.ssh/ && cat id_rsa.pub >> authorized_keys`



