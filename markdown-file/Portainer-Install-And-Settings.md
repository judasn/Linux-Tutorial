# Portainer 安装和配置、优化

## 介绍

- 官网：<https://portainer.io/>
- 官网 GitHub：<https://github.com/portainer/portainer>
- 官网文档：<https://portainer.readthedocs.io/en/stable/>

## 安装

- 创建文件夹：`mkdir -p /data/docker/portainer`
- 赋权：`chmod -R 777 /data/docker/portainer`
- 创建文件：`vim docker-compose.yml`

```
version: '3'
services:
  portainer:
    container_name: portainer
    image: portainer/portainer
    volumes:
      - /data/docker/portainer:/data
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "9000:9000"
```

- 启动：`docker-compose up -d`
- 该容器占用内存非常非常小，只有 5 M 左右。

## 对本地监控配置

- 因为 Portainer 镜像构建的时候已经配置了：`/var/run/docker.sock:/var/run/docker.sock`，所以对于跟 Portainer 同一台机子的其他容器都可以被直接监控
- 浏览器访问访问：`http://192.168.1.2:9000`
- 第一次启动会让你创建用户名和密码。第二步就是配置管理哪里的 docker 容器，我这里选择：local

## 远程监控配置

- 待完善

## 资料

- [Portainer 容器管理](https://blog.mallux.me/2017/04/13/portainer/)


