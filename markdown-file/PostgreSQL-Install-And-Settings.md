# PostgreSQL 安装和配置


## 官网

- 官网：<https://www.postgresql.org/>
    - 201906 最新版本
    - 12 beat
    - 11 release
- 官网 Docker hub：<https://hub.docker.com/_/postgres>


## Docker 安装 PostgreSQL（带挂载）

```
docker run \
	-d \
	--name pgsql \
	-p 5432:5432 \
	-e POSTGRES_USER=adg_user \
	-e POSTGRES_PASSWORD=adg123456 \
	-v ~/docker_data/pgsql/data:/var/lib/postgresql/data \
	postgres:11
```

- 连上容器：`docker exec -it pgsql /bin/bash`
	- 连上 PostgreSQL：`psql -h 127.0.0.1 -p 5432 -U adg_user`


## 资料

- <https://codeday.me/bug/20180726/203876.html>
