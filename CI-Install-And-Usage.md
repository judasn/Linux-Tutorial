 
 
# CI 一整套服务
 
## 环境说明

- CentOS 7.3
- 两台机子（一台机子也是可以，内存至少要 8G）
	- 一台：Gitlab + Redis + Postgresql
		- 硬件推荐：内存 4G
		- 端口安排
			- Gitlab：10080
	- 一台：Nexus + Jenkins + SonarQube + Postgresql
		- 硬件推荐：内存 8G
		- 端口安排
			- SonarQube：19000
			- Nexus：18081
			- Jenkins：18080

## Gitlab + Redis + Postgresql

- 预计会使用内存：2G 左右
- 这套方案来自（部分内容根据自己情况进行了修改）：<https://github.com/sameersbn/docker-gitlab>
- 创建宿主机挂载目录：`mkdir -p /data/docker/gitlab/gitlab /data/docker/gitlab/redis /data/docker/gitlab/postgresql`
- 赋权（避免挂载的时候，一些程序需要容器中的用户的特定权限使用）：`chmod -R 777 /data/docker/gitlab/gitlab /data/docker/gitlab/redis /data/docker/gitlab/postgresql`
- 这里使用 docker-compose 的启动方式，所以需要创建 docker-compose.yml 文件：

```yaml
version: '2'

services:
  redis:
    restart: always
    image: sameersbn/redis:latest
    command:
    - --loglevel warning
    volumes:
    - /data/docker/gitlab/redis:/var/lib/redis:Z

  postgresql:
    restart: always
    image: sameersbn/postgresql:9.6-2
    volumes:
    - /data/docker/gitlab/postgresql:/var/lib/postgresql:Z
    environment:
    - DB_USER=gitlab
    - DB_PASS=password
    - DB_NAME=gitlabhq_production
    - DB_EXTENSION=pg_trgm

  gitlab:
    restart: always
    image: sameersbn/gitlab:10.4.2-1
    depends_on:
    - redis
    - postgresql
    ports:
    - "10080:80"
    - "10022:22"
    volumes:
    - /data/docker/gitlab/gitlab:/home/git/data:Z
    environment:
    - DEBUG=false

    - DB_ADAPTER=postgresql
    - DB_HOST=postgresql
    - DB_PORT=5432
    - DB_USER=gitlab
    - DB_PASS=password
    - DB_NAME=gitlabhq_production

    - REDIS_HOST=redis
    - REDIS_PORT=6379

    - TZ=Asia/Shanghai
    - GITLAB_TIMEZONE=Beijing

    - GITLAB_HTTPS=false
    - SSL_SELF_SIGNED=false

    - GITLAB_HOST=192.168.0.105
    - GITLAB_PORT=10080
    - GITLAB_SSH_PORT=10022
    - GITLAB_RELATIVE_URL_ROOT=
    - GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alphanumeric-string
    - GITLAB_SECRETS_SECRET_KEY_BASE=long-and-random-alphanumeric-string
    - GITLAB_SECRETS_OTP_KEY_BASE=long-and-random-alphanumeric-string

    - GITLAB_ROOT_PASSWORD=
    - GITLAB_ROOT_EMAIL=

    - GITLAB_NOTIFY_ON_BROKEN_BUILDS=true
    - GITLAB_NOTIFY_PUSHER=false

    - GITLAB_EMAIL=notifications@example.com
    - GITLAB_EMAIL_REPLY_TO=noreply@example.com
    - GITLAB_INCOMING_EMAIL_ADDRESS=reply@example.com

    - GITLAB_BACKUP_SCHEDULE=daily
    - GITLAB_BACKUP_TIME=01:00

    - SMTP_ENABLED=false
    - SMTP_DOMAIN=www.example.com
    - SMTP_HOST=smtp.gmail.com
    - SMTP_PORT=587
    - SMTP_USER=mailer@example.com
    - SMTP_PASS=password
    - SMTP_STARTTLS=true
    - SMTP_AUTHENTICATION=login

    - IMAP_ENABLED=false
    - IMAP_HOST=imap.gmail.com
    - IMAP_PORT=993
    - IMAP_USER=mailer@example.com
    - IMAP_PASS=password
    - IMAP_SSL=true
    - IMAP_STARTTLS=false

    - OAUTH_ENABLED=false
    - OAUTH_AUTO_SIGN_IN_WITH_PROVIDER=
    - OAUTH_ALLOW_SSO=
    - OAUTH_BLOCK_AUTO_CREATED_USERS=true
    - OAUTH_AUTO_LINK_LDAP_USER=false
    - OAUTH_AUTO_LINK_SAML_USER=false
    - OAUTH_EXTERNAL_PROVIDERS=

    - OAUTH_CAS3_LABEL=cas3
    - OAUTH_CAS3_SERVER=
    - OAUTH_CAS3_DISABLE_SSL_VERIFICATION=false
    - OAUTH_CAS3_LOGIN_URL=/cas/login
    - OAUTH_CAS3_VALIDATE_URL=/cas/p3/serviceValidate
    - OAUTH_CAS3_LOGOUT_URL=/cas/logout

    - OAUTH_GOOGLE_API_KEY=
    - OAUTH_GOOGLE_APP_SECRET=
    - OAUTH_GOOGLE_RESTRICT_DOMAIN=

    - OAUTH_FACEBOOK_API_KEY=
    - OAUTH_FACEBOOK_APP_SECRET=

    - OAUTH_TWITTER_API_KEY=
    - OAUTH_TWITTER_APP_SECRET=

    - OAUTH_GITHUB_API_KEY=
    - OAUTH_GITHUB_APP_SECRET=
    - OAUTH_GITHUB_URL=
    - OAUTH_GITHUB_VERIFY_SSL=

    - OAUTH_GITLAB_API_KEY=
    - OAUTH_GITLAB_APP_SECRET=

    - OAUTH_BITBUCKET_API_KEY=
    - OAUTH_BITBUCKET_APP_SECRET=

    - OAUTH_SAML_ASSERTION_CONSUMER_SERVICE_URL=
    - OAUTH_SAML_IDP_CERT_FINGERPRINT=
    - OAUTH_SAML_IDP_SSO_TARGET_URL=
    - OAUTH_SAML_ISSUER=
    - OAUTH_SAML_LABEL="Our SAML Provider"
    - OAUTH_SAML_NAME_IDENTIFIER_FORMAT=urn:oasis:names:tc:SAML:2.0:nameid-format:transient
    - OAUTH_SAML_GROUPS_ATTRIBUTE=
    - OAUTH_SAML_EXTERNAL_GROUPS=
    - OAUTH_SAML_ATTRIBUTE_STATEMENTS_EMAIL=
    - OAUTH_SAML_ATTRIBUTE_STATEMENTS_NAME=
    - OAUTH_SAML_ATTRIBUTE_STATEMENTS_FIRST_NAME=
    - OAUTH_SAML_ATTRIBUTE_STATEMENTS_LAST_NAME=

    - OAUTH_CROWD_SERVER_URL=
    - OAUTH_CROWD_APP_NAME=
    - OAUTH_CROWD_APP_PASSWORD=

    - OAUTH_AUTH0_CLIENT_ID=
    - OAUTH_AUTH0_CLIENT_SECRET=
    - OAUTH_AUTH0_DOMAIN=

    - OAUTH_AZURE_API_KEY=
    - OAUTH_AZURE_API_SECRET=
    - OAUTH_AZURE_TENANT_ID=
```


- 启动：`docker-compose up -d`，启动比较慢，等个 2 分钟左右。
- 浏览器访问 Gitlab：<http://192.168.0.105:10080/users/sign_in>
- Gitlab 的具体使用可以看另外文章：[Gitlab 的使用](Gitlab-Install-And-Settings.md)

## Nexus + Jenkins + SonarQube

- 预计会使用内存：4G 左右
- 创建宿主机挂载目录：`mkdir -p /data/docker/ci/nexus /data/docker/ci/jenkins /data/docker/ci/jenkins/home /data/docker/ci/sonarqube /data/docker/ci/postgresql`
- 赋权（避免挂载的时候，一些程序需要容器中的用户的特定权限使用）：`chmod -R 777 /data/docker/ci/nexus /data/docker/ci/jenkins /data/docker/ci/jenkins/home /data/docker/ci/sonarqube /data/docker/ci/postgresql`
- 下面有一个细节要特别注意：yml 里面不能有中文。还有就是 sonar 的挂载目录不能直接挂在 /opt/sonarqube 上，不然会启动不了。
- 这里使用 docker-compose 的启动方式，所以需要创建 docker-compose.yml 文件：

```yaml
version: '3'

networks:
  prodnetwork:
    driver: bridge

services:
  sonardb:
    image: postgres:9.6.6
    restart: always
    ports:
      - "5433:5432"
    networks:
      - prodnetwork
    volumes:
      - /data/docker/ci/postgresql:/var/lib/postgresql
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar
  sonar:
    image: sonarqube:6.7.1
    restart: always
    ports:
     - "19000:9000"
     - "19092:9092"
    #networks:
      #- prodnetwork
    depends_on:
      - sonardb
    volumes:
      - /data/docker/ci/sonarqube/conf:/opt/sonarqube/conf
      - /data/docker/ci/sonarqube/data:/opt/sonarqube/data
      - /data/docker/ci/sonarqube/extension:/opt/sonarqube/extensions
      - /data/docker/ci/sonarqube/bundled-plugins:/opt/sonarqube/lib/bundled-plugins
    environment:
      #- SONARQUBE_JDBC_URL=jdbc:postgresql://sonardb:5433/sonar
      - SONARQUBE_JDBC_URL=jdbc:postgresql://192.168.0.105:5433/sonar
      - SONARQUBE_JDBC_USERNAME=sonar
      - SONARQUBE_JDBC_PASSWORD=sonar
  nexus:
    image: sonatype/nexus3
    restart: always
    ports:
      - "18081:8081"
    networks:
      - prodnetwork
    volumes:
      - /data/docker/ci/nexus:/nexus-data
  jenkins:
    image: jenkins:2.60.3
    restart: always
    ports:
      - "18080:8080"
    networks:
      - prodnetwork
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
      - /data/docker/ci/jenkins:/var/lib/jenkins/
      - /data/docker/ci/jenkins/home:/var/jenkins_home
    depends_on:
      - nexus
      - sonar
    environment:
      - NEXUS_PORT=8081
      - SONAR_PORT=9000
      - SONAR_DB_PORT=5432
```

- 启动：`docker-compose up -d`，启动比较慢，等个 2 分钟左右。
- 浏览器访问 SonarQube：<http://192.168.0.105:19000>
- 浏览器访问 Nexus：<http://192.168.0.105:18081>
- 浏览器访问 Jenkins：<http://192.168.0.105:18080>






