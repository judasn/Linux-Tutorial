## CentOS 图形界面的关闭与开启


## 初衷

- 本地开多个虚拟机搞集群测试，为了节省资源，关掉图形界面更好点


## CentOS 6 设置方法

- 编辑配置文件：`vim /etc/inittab`
- 把默认值：`id:5:initdefault:`，改为：`id:3:initdefault:`
- 重启系统：`reboot`，重启后就只有 shell 界面了。
- 在 shell 界面中如果你还希望临时开启图形界面可以输入：`init 5`
- 在图形界面中如果你希望临时关闭图形界面可以输入：`init 3`


## CentOS 7 设置方法

- 关闭图形
	- `mv /etc/systemd/system/default.target /etc/systemd/system/default.target.bak`         (改名备份)
	- `ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target`      (重新软连接文本界面为启动默认值界面)
	- `systemctl reboot`                                                                                                               (重启) 

- 恢复图形界面
	- `rm -rf  /etc/systemd/system/default.target`                                                                      (移除当前配置链接)
	- `mv  /etc/systemd/system/default.target.bak /etc/systemd/system/default.target`       (恢复备份配置链接)
	- `systemctl reboot`   