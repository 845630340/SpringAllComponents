# Master节点与ETCD集群迁移方案

---

Master节点与ETCD集群是kubernetes集群的两个重要组成部分。Master节点是kubernetes集群中的控制节点，负责对集群做出全局决策（例如：调度），并检测、响应集群事件。ETCD是kubernetes的数据存储中心，负责为集群提供高可用、强一致性的服务发现的数据存储。因此，对于Master节点与ETCD集群的运维工作显得尤为重要。鉴于此，我们提供了Master节点与ETCD集群的迁移方案，来帮助用户在尽可能不影响服务的情况下，迁移Master节点与ETCD集群。

## 整体方案

整体迁移方案如下：

![](https://domeos-pics.bjcnc.scs.sohucs.com/Master%E8%8A%82%E7%82%B9%E4%B8%8EETCD%E9%9B%86%E7%BE%A4%E8%BF%81%E7%A7%BB%E6%96%B9%E6%A1%88.png)

具体描述：
1. 迁移前，需要先停止DomeOS Server服务，防止对迁移过程造成影响。
2. 首先迁移部分ETCD节点，这样在迁移过程中，虽然使用全部新的ETCD集群的地址去配置Kubernetes的相关配置，但是仍然可以通过已经迁移了的部分ETCD节点使用ETCD服务。
3. 其次需要停止原Master节点上的服务，保证同一时间，只有一个master apiserver往ETCD集群写入数据，避免错误调度的情况。
4. 然后依次新建Master节点、修改所有Node节点上的相关配置文件并重启服务、滚动升级DNS服务，使整个集群使用新的master apiserver与新的ETCD集群。
5. 最后迁移完其余的ETCD节点，启动DomeOS Server服务，并更新集群信息，使得DomeOS使用新的master apiserver与新的ETCD集群来控制整个环境。

## 详细步骤

**示例环境：**

|类别|原环境|新环境|
|---|---|---|
|Master节点|10.17.33.30:8080|10.17.33.20:8080|
|ETCD集群|10.17.33.31:4012，<br>10.17.33.32:4012，<br>10.17.33.33:4012|10.17.33.21:4012，<br>10.17.33.22:4012，<br>10.17.33.23:4012|

### 1、停止DomeOS Server服务

为了防止对迁移过程造成影响，在迁移之前，需要先停止DomeOS Server服务。

### 2、迁移部分ETCD节点

为了保证kubernetes集群的正常运行，需要先迁移部分ETCD节点，保证集群服务不会中断。

**注意：**
- 建议优先迁移**非Leader**的节点，最后迁移**Leader**节点。
- 每迁移一个ETCD节点，都需要确认一下ETCD集群、Kubernetes集群及相关组件的状态是否正常，如果出现异常，需要及时回滚。

各节点的角色的查询方法如下，如果出现```isLeader=true```，则表示该节点为Leader节点。
```
$ /usr/sbin/domeos/etcd/current/etcdctl --endpoints=10.17.33.31:4012,10.17.33.32:4012,10.17.33.33:4012 member list
1765e45b18eb9b39: name=domeosEtcd1 peerURLs=http://10.17.33.32:4010 clientURLs=http://10.17.33.32:4012 isLeader=false
7732e8875338f6b9: name=domeosEtcd2 peerURLs=http://10.17.33.33:4010 clientURLs=http://10.17.33.33:4012 isLeader=false
e4b627e6bc503250: name=domeosEtcd0 peerURLs=http://10.17.33.31:4010 clientURLs=http://10.17.33.31:4012 isLeader=true
```

### 3、停止原Master节点上的服务

为了保证同一时间只有一个master apiserver往ETCD集群写入数据，避免错误调度的情况，需要先停止原Master节点上的服务。

```
systemctl stop kube-controller
systemctl stop kube-scheduler
systemctl stop kube-proxy
systemctl stop kube-apiserver
```

### 4、使用新的ETCD集群，新建Master节点

在新的机器上使用脚本创建Master节点，注意需要使用**全部新的ETCD集群**（即10.17.33.21:4012，10.17.33.22:4012，10.17.33.23:4012），而不是当前新、旧节点共存的集群，并且**保证kubernetes版本与原Master节点一致**。

请使用专门用于迁移Master节点时使用的创建脚本：[start_master_centos_for_migrate.sh](http://domeos-script.bjctc.scs.sohucs.com/start_master_centos_for_migrate.sh)，脚本使用方法请参考[创建Kubernetes集群](chuangjian_bing_tian_jia_kubernetes_ji_qun_md.md)中的start_master_centos.sh脚本的使用方法，二者唯一的区别在于，该脚本不会启动kube-scheduler与kube-controller服务，防止出现在5分钟内如果只有部分Node节点更新完配置，会触发调度机制，从而对服务造成影响的情况。

### 5、修改Node节点配置及flannel配置

修改所有Node节点上的kubernetes配置文件及flannel服务的配置文件，使其使用新的master apiserver地址，并重启kubelet、kube-proxy、flanneld服务，使改动生效。

**注意：**–etcd为**全部新的ETCD集群**（即10.17.33.21:4012，10.17.33.22:4012，10.17.33.23:4012），而不是当前新、旧节点共存的集群。

我们提供了脚本来修改配置：

|文件名|说明|下载地址|
|--|--|--|
|update_node_configs.sh|Node节点配置及flannel配置修改脚本|http://domeos-script.bjctc.scs.sohucs.com/update_node_configs.sh|

**使用方式**

* 显示帮助信息

```
bash update_node_configs.sh --help
```

* 修改Node节点配置及flannel配置

在各个需要修改配置的Node节点上执行如下命令

    sudo update_node_configs.sh [options]

**说明**

1. 可以支持只迁移Master节点或者只迁移ETCD集群，根据需要输出参数即可。
2. --etcd为**全部新的ETCD集群**（即10.17.33.21:4012，10.17.33.22:4012，10.17.33.23:4012），而不是当前新、旧节点共存的集群。
3. 如果出现了“Rollback finished”，则表示修改失败，程序已经自动回滚，回滚程序会根据备份文件来恢复修改的文件，并重启服务。

**参数说明**

```
--master：新的kube-apiserver服务地址，格式为“http://ip:port”或者“https://ip:port”。
--etcd：新的etcd服务集群地址，各地址间以逗号分隔。
```

**样例**

若新的kube-apiserver服务地址为[http://10.17.33.20:8080](http://10.17.33.20:8080)，新的ETCD集群为10.17.33.21:4012，10.17.33.22:4012，10.17.33.23:4012，则需要在主机上执行：

    sudo bash update-node-configs.sh \
        --master=http://10.17.33.20:8080 \
        --etcd=http://10.17.33.21:4012,http://10.17.33.22:4012,http://10.17.33.23:4012
	
**验证**

使用新的master apiserver地址查看集群的Node节点状态，若显示该节点的状态为"Ready"，说明配置修改成功。
```
$ /usr/sbin/domeos/k8s/current/kubectl --server 10.17.33.20:8080 get nodes
NAME           STATUS    AGE
l-33-39        Ready     3d
```

### 6、滚动升级DNS服务

在执行滚动升级前，首先需要启动新Master节点上的kube-scheduler与kube-controller服务。因此，请确保已经更新完所有Node的配置后，再启动kube-scheduler与kube-controller服务，否则可能会发送调度，对服务造成影响。

使用滚动升级，来升级kube2sky与skydns，相关yaml文件以及相关参数请参考[启动DNS服务](peizhi_dns_zu_jian_md.md)，需要修改RC的```name```、```spec.selector.version```、```spec.template.metadata.labels.version```、ETCD集群地址、master节点地址。RC的```version```（```metadata.labels.version```）改不改都可以。升级前，请先备份或记录当前DNS服务的配置。

**注意：**

- skydns.yaml中的```–machines```参数为**全部新的ETCD集群**（即10.17.33.21:4012，10.17.33.22:4012，10.17.33.23:4012），而不是当前新、旧节点共存的集群
- kube2sky RC中args下的```--etcd-server```为ETCD的服务地址，有且仅能设置一个，且必需在--machines设置的集群中，必须带" http:// "前缀
- kube2sky RC中args下的```--kube_master_url```需要改为新的master节点地址

#### （1）启动新Master节点上的kube-scheduler与kube-controller服务

```
systemctl start kube-controller
systemctl start kube-scheduler
```

#### （2）检查dns服务

如果是按照[启动DNS服务](peizhi_dns_zu_jian_md.md)来安装dns服务，则需要使用```kubectl describe```命令，来检查dns服务的```Selector```是否包含```version```标签（下面以```version=v9```为例）。

```
$ /usr/sbin/domeos/k8s/current/kubectl describe svc skydns-svc | grep Selector
Selector:               app=skydns,version=v9
```

如果包含version标签，则需要使用```kubectl edit svc/skydns-svc```命令去掉该标签，否则滚动升级过程会出现dns服务中断。
命令示例如下，然后在打开的编辑界面去掉```spec.selector```下的```version: v9```，最后保存即可。

#### （3）升级kube2sky

升级命令：

```
$ /usr/sbin/domeos/k8s/current/kubectl rolling-update kube2sky -f kube2sky-v10.yaml
```


#### （4）升级skydns

升级命令：

```
$ /usr/sbin/domeos/k8s/current/kubectl rolling-update skydns -f skydns-v10.yaml
```

skydns-v10.yaml示例如下：

```
apiVersion: v1
kind: ReplicationController
metadata:
  name: skydns-v10
  labels:
    app: skydns
    version: v10
spec:
  replicas: 1
  selector:
    app: skydns
    version: v10
  template:
    metadata:
      labels:
        app: skydns
        version: v10
    spec:
      containers:
        - name: skydns
          image: pub.domeos.org/domeos/skydns:1.5
          command:
            - "/skydns"
          args:
            - "--machines=http://192.168.56.104:4012,http://192.168.56.105:4012,http://192.168.56.106:4012"
            - "--domain=domeos.local"
            - "--addr=0.0.0.0:53"
            - "--nameservers=10.2.166.105:53,10.1.34.101:53"
          ports:
            - containerPort: 53
              name: dns-udp
              protocol: UDP
            - containerPort: 53
              name: dns-tcp
              protocol: TCP
```

验证方法请见：[启动DNS服务](peizhi_dns_zu_jian_md.md)，如果出现异常，请滚动升级到旧版本的DNS服务。

### 7、迁移其余ETCD节点

在确定kubernetes集群及服务运行正常后，需要将其余的ETCD节点迁移完。

**注意：**

每迁移一个ETCD节点后，都需要检查ETCD集群与Kubernetes集群的运行状态是否正常，如果出现异常，请及时回滚。

### 8、启动DomeOS Server服务

请参考：[配置控制台组件](peizhi_domeos_server_md.md)。

### 9、更新集群信息

#### （1）更新集群信息

登陆DomeOS，进入 运维管理-->集群-->集群设置 页面，修改apiserver与etcd。

#### （2）新建监听器

**注意：**

如果“运维管理–>集群”里没有“监听器设置”标签，说明您当前版本的DomeOS系统没有监听器功能，可以忽略这个步骤。

监听器不能升级，只能先删除，再新建：
1. 登陆DomeOS，进入 运维管理-->集群–>监听器设置–>查看详情 页面，点击“停止”按钮，等监听器停止成功后，点击“删除”按钮，将原来的监听器去掉；
2. 然后进入 运维管理-->集群–>监听器设置，点击“添加监听器”按钮，使用新的apiserver地址添加新的监听器。

