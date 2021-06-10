# 配置私有镜像仓库


---

## 启动私有镜像仓库容器

虽然用户可以在自己的集群上搭建私有仓库，但往往会面临存储空间小，迁移难，风险大的问题。私有仓库存储了所有的镜像，如果私有仓库发生事故，会造成巨大损失，严重影响业务，因此建议将私有仓库对接到分布式存储系统或云存储平台。DomeOS提供了使用[搜狐云台](http://cs.sohu.com)存储镜像的方案，用稳定、安全的云存储保证镜像文件永久可用。以下仅说明使用对接搜狐云存储的私有仓库配置与启动方式，若需要创建本地存储或其他存储类型的私有仓库，可直接使用官方的registry镜像，启动过程请参考[Docker Hub官方说明](https://hub.docker.com/_/registry)。

**注意**：DomeOS目前仅支持v2版本registry，请确保部署registry版本正确。如果已经有私有仓库，可以跳过该步骤，进入下一步配置。

**镜像**

    pub.domeos.org/domeos/docker-registry-driver-sohustorage:1.1
	
**启动命令**

    sudo docker run --restart=always -d \
        -p <_registry_port>:5000 \
        -e REGISTRY_STORAGE_SCS_ACCESSKEY=<_scs_access_key> \
        -e REGISTRY_STORAGE_SCS_SECRETKEY=<_scs_secret_key> \
        -e REGISTRY_STORAGE_SCS_REGION=<_scs_region> \
        -e REGISTRY_STORAGE_SCS_BUCKET=<_scs_bucket> \
        -e REGISTRY_HTTP_SECRET=<_http_secret> \
        -e SEARCH_BACKEND=<_search_backend> \
        -e SEARCH_BACKEND_MYSQL="<_db_user>:<_db_passwd>@tcp(<_db_addr>)/<_db_database>?loc=Local&parseTime=true"
        --name private-registry \
        pub.domeos.org/domeos/docker-registry-driver-sohustorage:1.1
		
**参数说明**

    _registry_port：私有仓库对外服务端口
    _scs_access_key：搜狐云台 access key
    _scs_secret_key：搜狐云台 secret key
    _scs_region：搜狐云存储地域(bjcnc,bjctc,shctc,bjcnc-internal,bjctc-internal,shctc-internal)
    _scs_bucket：搜狐云存储桶名，要求该桶存在且可正常访问
    _http_secret：若需启动多个registry容器进行负载均衡，需要配置此环境变量，且赋予相同的值
    _search_backend：查询镜像列表的方式，可选MYSQL或LOCAL，不配置时使用默认的查询方式
    _db_user：DomeOS数据库用户
    _db_passwd：DomeOS数据库密码
    _db_addr：DomeOS数据库地址，IP:Port形式
    _db_database：DomeOS数据库名称
    
**说明** 

1. 该方式创建的私有仓库将对接到[搜狐云台](http://cs.sohu.com)上。

2. 如果私有仓库需要使用https安全访问，则需加入如下额外参数:

        -v /path/to/certs:/certs
        -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt
        -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key

   其中/path/to/certs为证书文件所在目录，registry.crt和registry.key分别为证书和秘钥文件。

**样例**

    sudo docker run -d --restart=always \
	    -p 5000:5000 \
		-e REGISTRY_STORAGE_SCS_ACCESSKEY=ABCDEFOZ2k2yT4+qxzmA6A== \
		-e REGISTRY_STORAGE_SCS_SECRETKEY=ABCDEFF8vXvt0y2f+6dIXA== \
		-e REGISTRY_STORAGE_SCS_REGION=bjcnc \
		-e REGISTRY_STORAGE_SCS_BUCKET=registry \
        -e REGISTRY_HTTP_SECRET=domeos \
        -e SEARCH_BACKEND=MYSQL \
        -e SEARCH_BACKEND_MYSQL="domeos:domeos@tcp(10.10.10.10:3306)/registry?loc=Local&parseTime=true"
		--name private-registry \
		pub.domeos.org/domeos/docker-registry-driver-sohustorage:1.1
		
**验证**

通过curl -L http://<私有仓库的服务地址>/v2/查看私有仓库的运行状态，如果显示"{}"说明正常运行，如:
	
	curl -L http://10.10.10.10:5000/v2/
    {}
	
**参考**

https://github.com/docker/distribution

