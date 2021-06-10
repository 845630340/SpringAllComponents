# 配置控制台组件

---

## 配置并启动MySQL

DomeOS的相关数据均存储在Mysql中，可自行选择使用容器或非容器方式启动MySQL，Mysql成功启动后需创建DomeOS所需数据库和表结构。

**操作步骤**

1. 下载Github中DomeOS Server项目DomeOS/src/main/resources/目录下的mysql-initialize.sh和所有sql文件至本地目录；

2. 设置如下环境变量\(要创建数据库，用户需要有root权限\)：

   ```
    MYSQL_HOST: MySQL服务地址
    MYSQL_PORT: MySQL服务端口
    MYSQL_USERNAME: 用于登录MySQL服务器的用户名
    MYSQL_PASSWORD: 用于登录MySQL服务器的密码
   ```

3. 执行脚本mysql-initialize.sh，将在MySQL中创建domeos、graph、portal三个数据库以及相关数据表，并向数据表中插入初始数据，建立管理员账户\(初始用户名和密码均为admin\)。


**注意事项**

为保证DomeOS各组件正确连接数据库，需确保数据库给flannel中配置的IP段\(容器的IP地址段\)以及启动Kubernetes master时设置的--service-cluster-ip-range地址段授权，且与连接数据库相关的防火墙配置正确。

## 配置并启动DomeOS Server

可自行选择使用容器或非容器方式启动DomeOS Server。

* 非容器方式

**源码**

Github中DomeOS Server项目\([https://github.com/domeos/server/](https://github.com/domeos/server/)\)

**说明**

1. 代码下载后，执行

   ```
    mvn package -DskipTests
   ```

   进行编译打包，maven版本为3.2.2及以上，jdk 1.7及以上。

2. 编译打包后须设置如下环境变量，再启动:

   ```
    MYSQL_HOST: MySQL服务地址，必须配置。
    MYSQL_PORT: MySQL服务端口，必须配置。
    MYSQL_USERNAME: 用于登录MySQL服务器的用户名，必须配置。
    MYSQL_PASSWORD: 用于登录MySQL服务器的密码。必须配置。
    MYSQL_DB: DomeOS使用的数据库名，若使用mysql-initialize.sh进行MySQL的初始化，此数据库名应为"domeos"，必须配置。
    SHIRO_REDIS_HOST: DomeOS使用的redis服务地址（可选）
    SHIRO_REDIS_PORT: redis服务端口（可选）
    SHIRO_REDIS_PASSWORD: redis服务密码（可选）
   ```

3. 以非容器形式启动DomeOS Server时，需要单独启动WebSSH Server，具体启动方式见"配置WebSSH组件"章节。DomeOS v0.5版本后，使用springboot内置tomcat启动服务，启动脚本参考：

   ```
    #/bin/bash

    export MYSQL_HOST=10.16.54.11
    export MYSQL_USERNAME=domeos
    export MYSQL_PASSWORD=domeos-mysql-pw
    export MYSQL_PORT=3306
    export MYSQL_DB=domeos
    export SHIRO_REDIS_HOST=redis.sohu.com
    export SHIRO_REDIS_PORT=6379
    export SHIRO_REDIS_PASSWORD=domeos-redis-pw

    nohup java -jar -Dserver.port=8080 DomeOS.war >/dev/null 2>&1 &
   ```

启动成功后可通过浏览器访问DomeOS进行验证。

DomeOS server日志位于DomeOS.war所在目录的log文件夹下，按天切分。

* 容器方式

**镜像**

pub.domeos.org/domeos/server:1.6.0

**启动命令**

```
sudo docker run -d --restart=always \
    --name <_domeos_server_name> \
    -p <_domeos_server_port>:8080 \
    -e MYSQL_HOST=<_mysql_host> \
    -e MYSQL_PORT=<_mysql_port> \
    -e MYSQL_USERNAME=<_mysql_username> \
    -e MYSQL_PASSWORD=<_mysql_password> \
    -e MYSQL_DB=<_mysql_db> \
    [-e SHIRO_REDIS_HOST=<_shiro_redis_host> -e SHIRO_REDIS_PASSWORD=<_shiro_redis_password> -e SHIRO_REDIS_PORT=<_shiro_redis_port>\]
    pub.domeos.org/domeos/server:1.6.0
```

**参数说明**

```
_domeos_server_name: 容器的名字
_domeos_server_port: DomeOS Server的服务端口
_mysql_host: MySQL服务地址
_mysql_port: MySQL服务端口
_mysql_username: 用于登录MySQL服务器的用户名
_mysql_password: 用于登录MySQL服务器的密码
_mysql_db: DomeOS使用的数据库名，若使用mysql-initialize.sh进行MySQL的初始化，此数据库名应为"domeos"
_shiro_redis_host: redis服务地址（可选）
_shiro_redis_password: redis服务password（可选）
_shiro_redis_port: redis服务端口（可选）
```

**样例**

```
sudo docker run -d --restart=always \
    --name domeos_server \
    -p 8080:8080 \
    -e MYSQL_HOST=10.10.10.10 \
    -e MYSQL_PORT=3306 \
    -e MYSQL_USERNAME=root \
    -e MYSQL_PASSWORD=mypassword \
    -e MYSQL_DB=domeos \
    pub.domeos.org/domeos/server:1.6.0
```

**注意事项**

镜像启动时设置了--restart-always，请根据实际需求进行配置。   
DomeOS v0.5支持通过redis缓存用户session信息，通过环境变量配置，如果未配置则使用ehcache缓存session信息。

## 验证

在浏览器中访问DomeOS Server地址，将会进入DomeOS登录界面：

![](https://domeos-gitbook.bjcnc.scs.sohucs.com/login.png)

选择普通账户登录，输入初始用户名admin和初始密码admin，点击登录即可进入DomeOS主界面。

