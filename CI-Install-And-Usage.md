 
 
# CI 一整套服务
 
## 环境说明
 
- CentOS 7.3
- 两台机子
	- 一台：Gitlab + Redis + Postgresql
		- 端口安排
			- Gitlab：10080
	- 一台：Nexus + Jenkins + SonarQube + Postgresql
		- 端口安排
			- Nexus：8081
			- SonarQube：9000
			- Jenkins：18080

## Gitlab + Redis + Postgresql

- 创建宿主机挂载目录：`mkdir -p /data/docker/gitlab/gitlab /data/docker/gitlab/redis /data/docker/gitlab/postgresql`
- 这里使用 docker-compose 的启动方式，所以需要创建 docker-compose.yml 文件：

```yml
gitlab:
  image: sameersbn/gitlab
  ports:
    - "10022:22"
    - "10080:80"
  links:
    - gitlab-redis:redisio
    - gitlab-postgresql:postgresql
  environment:
    - GITLAB_PORT=80
    - GITLAB_SSH_PORT=22
    - GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string
    - GITLAB_SECRETS_SECRET_KEY_BASE=long-and-random-alpha-numeric-string
    - GITLAB_SECRETS_OTP_KEY_BASE=long-and-random-alpha-numeric-string
  volumes:
    - /data/docker/gitlab/gitlab:/home/git/data
  restart: always
gitlab-redis:
  image: sameersbn/redis
  volumes:
    - /data/docker/gitlab/redis:/var/lib/redis
  restart: always
gitlab-postgresql:
  image: sameersbn/postgresql:9.6
  environment:
    - DB_NAME=gitlabhq_production
    - DB_USER=gitlab
    - DB_PASS=password
    - DB_EXTENSION=pg_trgm
  volumes:
    - /data/docker/gitlab/postgresql:/var/lib/postgresql
  restart: always
```

- 启动：`docker-compose up -d`
- 浏览器访问：<http://192.168.0.105:10080>



## Nexus + Jenkins + SonarQube


- 创建宿主机挂载目录：`mkdir -p /data/docker/ci/nexus /data/docker/ci/jenkins /data/docker/ci/sonarqube /data/docker/ci/postgresql`
- 这里使用 docker-compose 的启动方式，所以需要创建 docker-compose.yml 文件：

```
version: '3'

networks:
  prodnetwork:
    driver: bridge

volumes:
  nexus-data: /data/docker/ci/nexus
  jenkins-data: /data/docker/ci/jenkins

services:
  nexus:
    build: ./docker-nexus3
    restart: always
    ports:
      - "18081:8081"
    networks:
      - prodnetwork
    volumes:
      - nexus-data:/nexus-data
  jenkins:
    build: ./jenkins
    restart: always
    ports:
      - "18080:8080"
    networks:
      - prodnetwork
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
      - jenkins-data:/var/lib/jenkins/
    depends_on:
      - nexus
      - sonar
    environment:
      - NEXUS_PORT=8081
      - SONAR_PORT=9000
      - SONAR_DB_PORT=5432
  sonardb:
    networks:
      - prodnetwork
    restart: always
    image: postgres:9.6
    ports:
      - "5432:5432"
    volumes:
      - /data/docker/ci/postgresql:/var/lib/postgresql
    environment:
     - POSTGRES_USER=sonar
     - POSTGRES_PASSWORD=sonar
  sonar:
    image: sonarqube
    restart: always
    ports:
     - "19000:9000"
     - "19092:9092"
    networks:
      - prodnetwork
    depends_on:
      - sonardb
    volumes:
      - /data/docker/ci/sonarqube:/opt/sonarqube
    environment:
     - SONARQUBE_JDBC_URL=jdbc:postgresql://sonardb:5432/sonar
     - SONARQUBE_JDBC_USERNAME=sonar
     - SONARQUBE_JDBC_PASSWORD=sonar
```















