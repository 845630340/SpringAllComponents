# 更改docker中默认的存储方式

---

安装docker时如果不指定docker的存储方式，默认是使用devicemapper类型下的loop-lvm模式,它使用OS层面离散的文件来构建精简池(thin pool)。该模式主要是方便Docker能够简单的被”开箱即用(out-of-the-box)”而无需额外的配置。但如果是在生产环境中部署Docker，建议使用direct-lvm模式，它使用块设备构建精简池来存放镜像和容器的数据。为方便用户将默认的loop-lvm模式更改成direct-loop模式，我们提供了更改脚本。

## 脚本

更改docker存储方式的脚本如下表所示：

|文件名|说明|下载地址|
|--|--|--|
|change_to_direct_lvm_centos.sh|适用于centos|http://domeos-script.bjctc.scs.sohucs.com/change_to_direct_lvm_centos.sh|
|change_to_direct_lvm_ubuntu.sh|适用于ubuntu|http://domeos-script.bjctc.scs.sohucs.com/change_to_direct_lvm_ubuntu.sh|

**使用方式**

* 显示帮助信息

```
bash change_to_direct_lvm_centos.sh help
```

* 更改docker存储方式

在各个需要更改docker存储方式的主机节点上执行如下命令

    sudo bash change_to_direct_lvm_centos.sh [options]

**说明**

1. 由于更改了存储方式，之前主机节点上的容器和数据都将消失。
2. 更改存储方式的过程中，主机节点会临时变成不可调度，节点上的pod实例会被迁移到其他节点。
3. 请在确保当前主机已经安装了docker的情况下，执行该脚本。
4. 如果您的k8s集群不是使用DomeOS的官方脚本安装，请注意修改脚本中的K8S_INSTALL_PATH参数。

**参数说明**

```
  --api-server            kubernetes中apiserver的地址（必须）。
  --disk-parts            docker存储所用的磁盘或者分区，可以设置多个，以逗号分隔（必须）。脚本会使用这些磁盘或者分区建立物理卷，因此请确保该磁盘或者分区未被系统占用。
  --kube-node-name        主机在kubernetes集群中的节点名称，默认为主机名。
  --vg-name               逻辑卷组的名称，默认为vgdomeos。
  --pool-percent          精简池数据空间占卷组空间的百分比，默认为75%。
  --poolmeta-percent      精简池元数据空间占卷组空间的百分比，默认为5%。
  --autoextend-threshold  设置精简池数据空间自动扩容的阈值，如果精简池所用空间超过这个阈值，将按照自动扩容的百分比进行扩容，默认为80%。
  --autoextend-percent    精简池每次自动扩容时，增加的百分比，默认为10%。
  --devicemapper-fs       设置devicemapper文件系统的格式，默认为ext4。
  --lvm-graph-path        docker运行时的graph路径，不能与loop-lvm模式下的路径一样，默认为/var/lib/docker-lvm。
```


**样例**

若需要将主机节点test-150-100上的docker存储存储方式从loop-lvm模式更改为direct-loop模式，此时kubernetes集群kube-apiserver服务地址为[http://10.10.10.10:8080](http://10.10.10.10:8080)，docker存储所用的分区为/dev/sda和/dev/sdb2，则需要在主机上执行：

    sudo bash change_to_direct_lvm_centos.sh \
         --api-server 10.10.10.10:8080 \
         --disk-parts /dev/sda,/dev/sdb1

	
**验证**

通过
```docker info```
查看docker精简池信息。

```
$ sudo docker info | grep 'Pool Name'
```

如果使用默认的卷组名称，可以看到以下信息：

Pool Name: vgdomeos-thinpool

**参考**

1. Docker官方文档：https://docs.docker.com/engine/reference/commandline/dockerd/#storage-driver-options

## 问题汇总

**1. 如果执行完脚本后想回滚到以前的存储模式怎么办**

可以执行
```
$ sudo bash change_to_direct_lvm_centos.sh restore
```

