# Crontab 介绍


## Crontab 安装

- 查看是否已安装：
 - CentOS：`rpm -qa | grep cron`
 - Ubuntu：`dpkg -l | grep cron`

- 安装（一般系统是集成的）：
 - CentOS 6：`sudo yum install -y vixie-cron crontabs`
 - Ubuntu：`sudo apt-get install -y cron`

## Crontab 服务器配置文件常用参数

- 配置文件介绍（记得先备份）：`sudo vim /etc/crontab`
 - 该配置格式解释：
    - ![Crontab 服务器配置文件常用参数](images/Crontab-a-1.jpg)
 - 常用例子介绍：
    - 30 21 * * * service httpd restart         #每晚的 21:30 重启 apache
    - 45 4 1,10,22 * * service httpd restart    #每月的 1、10、22 日的 4:45 重启 apache
    - 45 4 1-10 * * service httpd restart       #每月的 1 到 10 日的 4:45 重启 apache
    - */2 * * * * service httpd restart         #每隔两分钟重启 apache
    - 1-59/2 * * * * service httpd restart      #每隔两分钟重启 apache（这个比较特殊：1-59/2 这个表示过掉0分，从 1 分开始算，每隔两分执行，所以 1 分执行了，3 分执行了，5 分执行了....都是奇数进行执行。默认的 */2 都是偶数执行。）
    - 0 23-7/2 * * * service httpd restart      #晚上 11 点到早上 7 点之间，每隔 2 个小时重启 apache
    - 0-59/30 18-23 * * * service httpd restart #每天 18:00 到 23：00 之间，每隔 30 分钟重启 apache（方法一）
    - 0,30 18-23 * * * service httpd restart    #每天 18:00 到 23：00 之间，每隔 30 分钟重启 apache（方法二）
- 执行记录日志：`cd /var/log/cron`

## Crontab 资料

- <http://www.imooc.com/video/4498> 
- <http://www.centoscn.com/image-text/config/2015/0901/6096.html> 
