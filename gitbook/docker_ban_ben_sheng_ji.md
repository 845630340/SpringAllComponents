# docker版本升级

---

docker作为目前最热门的容器平台，不仅与容器编排框架kubernetes紧密关联，对DomeOS而言，也是非常重要的基础技术之一。为了方便用户使用docker新版本的特性，我们提供了docker版本升级脚本，确保在不影响DomeOS中部署的服务的情况下，对Kubernetes集群的docker版本进行升级。

**注意：** 该脚本只适用于CentOS系统。

## 脚本

docker版本升级脚本如下表所示：

|文件名|说明|下载地址|
|--|--|--|
|update_docker.sh|docker版本升级脚本|http://domeos-script.bjctc.scs.sohucs.com/update_docker.sh|

**使用方式**

* 显示帮助信息

```
bash update_docker.sh help
```

* 升级docker版本

在各个需要升级docker版本的主机节点上执行如下命令

    sudo bash update_docker.sh [options]

**说明**

1. 请在确保当前主机已经安装了docker的情况下，执行该脚本。
2. docker建议使用1.10.3以上的版本，本脚本提供了1.10.3、1.12.3和1.13.1三个版本的下载和配置。
3. 如果--need-change-storage参数为true，会删除当前所有的docker storage相关的配置，如果需要保留原配置，请勿使用该脚本。
4. 升级期间，当前主机上由用户手动创建的docker容器将会停止服务，待升级完成后会被启动。

**参数说明**

```
--new-version：新的docker版本，可选值为{1.10.3，1.12.3，1.13.1}（必需）。
--api-server：kubernetes集群kube-apiserver服务地址，格式为“http://ip:port”或者“https://ip:port”（必需）。
--kube-node-name：主机在kubernetes集群中的节点名称，默认为主机名。
--old-docker-graph:原docker运行时的根路径，默认为“/var/lib/docker”。
--docker-graph：新的docker运行时的根路径，容器、本地镜像等会存储在该路径下，占用空间大，建议设置到大容量磁盘上，默认为“/data/docker”。
--need-migrate-pods:是否需要迁移实例。若该参数为true，在升级过程中，会先将当前主机上所有由kubernetes创建的实例（DaemonSet类型除外）都调度到别的主机上，期间不会有新的实例被调度到该主机上，升级完成后会恢复至原状态。默认为“true”。
--need-change-storage：是否需要改变docker数据存储路径。若该参数为true，会删除原docker-storage相关的参数，并重新配置graph路径，然后将原docker数据目录移动到新的数据目录。默认为“true”。
```

**样例**

若需要将docker升级到1.12.3版本，需要升级docker版本的主机为 10.10.150.100，主机名为test-150-100，kubernetes集群kube-apiserver服务地址为[http://10.10.10.10:8080](http://10.10.10.10:8080)，需要改变docker的数据存储目录，原docker的graph路径为/var/lib/docker，新的graph路径为/data/docker，升级过程需要将主机上通过kubernetes创建的实例都迁移走，则需要在主机上执行：

    sudo bash update_docker.sh \
        --new-version 1.12.3 \
        --api-server http://10.10.10.10:8080 \
        --kube-node-name test-150-100 \
        --old-docker-graph /var/lib/docker \
        --docker-graph /data/docker \
        --need-migrate-pods true \
        --need-change-storage true

	
**验证**

通过
```docker --version```
查看docker版本信息。
```
$ docker --version
Docker version 1.12.3, build 6b644ec
```

**参考**

1. Docker官方文档：https://docs.docker.com/
2. Docker安装包(rpm)下载地址：https://yum.dockerproject.org/repo/main/centos/7/Packages/
3. Docker安装包(deb)下载地址：https://apt.dockerproject.org/repo/pool/main/d/docker-engine/

## 问题汇总

**1. 升级失败，提示“error: jobs.batch ... not found”**

将kubernetes集群中所有处于Completed状态的Pod都删除，即可解决该问题。

**2. 升级成功后，集群出现了处于ImagePullBackOff状态的Pod**

在DomeOS系统中找到Pod对应的部署，不用修改任何配置，直接以当前配置进行一次升级即可解决该问题。
