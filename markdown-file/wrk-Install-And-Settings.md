# wrk 安装和配置


## wrk 说明

- wrk 相对于 ab 来说最大的优点是它支持多线程，可以有更大的并发量


## 安装

- CentOS 7.4
- 官网说明：<https://github.com/wg/wrk/wiki/Installing-Wrk-on-Linux>

```
# 安装工具包的时候差不多有 90 个左右的子工具
sudo yum groupinstall 'Development Tools'
sudo yum install -y openssl-devel git
git clone --depth=1 https://github.com/wg/wrk.git wrk
cd wrk
make
# move the executable to somewhere in your PATH
sudo cp wrk /usr/local/bin
```

- 查看帮助：`wrk --help`

## 使用

- 启用 10 个线程，每个线程发起 100 个连接，持续 15 秒：`wrk -t10 -c100 -d15s http://www.baidu.com`
- 最终报告：

```
Running 15s test @ http://www.baidu.com
  10 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   208.39ms  324.00ms   1.91s    87.70%
    Req/Sec    82.68     64.81   414.00     70.60%
  11345 requests in 15.02s, 166.51MB read
  Socket errors: connect 0, read 20, write 0, timeout 59
Requests/sec:    755.26
Transfer/sec:     11.08MB
```

#### 使用 lua 脚本（发送一个 post 请求）

- 创建：`vim /opt/post-wrk.lua`

```
wrk.method = "POST"  
wrk.body   = "hms_user_id=222222&routing_key=ad.sys_user.add"  
wrk.headers["Content-Type"] = "application/x-www-form-urlencoded"
```

- 测试：`wrk -t10 -c100 -d15s --script=/opt/post-wrk.lua --latency http://127.0.0.1:9090/websocket/api/send-by-user-id`


## 其他说明

- wrk 使用的是 HTTP/1.1，缺省开启的是长连接
- 要测试短连接：`wrk -H "Connection: Close" -c 100 -d 10 http://domain/path`

## 资料

- <https://huoding.com/2017/05/31/620>
- <https://zjumty.iteye.com/blog/2221040>