# DomeOS系统架构


---

## 架构说明

![](https://domeos-pics.bjcnc.scs.sohucs.com/架构.png)

## 组件说明

按照DomeOS各组件之间的关联关系，完整的DomeOS系统需要的组件可分为以下几部分：

**控制台组件**

* DomeOS Server: tomcat服务器，提供DomeOS的WebUI以及可供访问的API接口；

* MySQL： 存储DomeOS中项目、部署、集群、用户组等所有信息以及相关配置；

* Redis：配置多DomeOS server时，共享存储session时使用；

* Kubernetes event watcher: 每个集群需要部署一个，用于上报k8s集群的event信息，更新部署状态；

**Docker组件**

DomeOS使用docker作为容器引擎，采用flannel托管容器网络，请在使用时确保每台主机能够正常安装和使用docker及flannel。
 
* docker：容器引擎；

* flannel：基于etcd的容器网络管理工具；

* etcd：存储flannel相关信息；

* registry：私有仓库，用于存储和分发用户的所有docker镜像。

**Kubernetes组件**

DomeOS中创建的每一个集群都对应一套Kubernetes环境。一套完整的Kubernetes集群包含一台Kubernetes master和若干台Kubernetes node。为保证Kubernetes集群正常运行，每一台集群内主机上首先需要配置好Docker组件，此外，整套集群需单独部署如下组件：

* etcd：作为Kubernetes集群配置中心提供存储服务，记录所有组件的定义和状态；另外，flannel也依赖于etcd，在DomeOS提供的安装脚本中，kubernetes和flannel共用同一套etcd集群，如果有分离需求，请自行配置；

* kube2sky&skydns：提供Kubetnetes集群内DNS服务；

Kubernetes master节点需要单独配置如下组件：

* kube-apiserver

* kube-controller-manager

* kube-scheduler

* kube-proxy

Kubernetes node节点需要单独配置如下组件：

* kubelet

* kube-proxy

**监控报警组件**

DomeOS的监控系统是在小米open-falcon监控基础上修改实现的。一套完整的监控系统需要如下组件：

* agent：监控数据上报组件，需要在集群中所有node节点部署；

* transfer：监控数据转发组件；

* graph：监控数据存储组件；

* query：监控数据查询组件；

* hbs：监控心跳服务器组件；

* judge：报警判断组件；

* alarm：报警事件处理组件；

* redis：报警事件缓存队列；

* sender：报警发送组件；

* nodata：用于未上报报警的数据填充组件；

**DNS组件**

在DomeOS中，为kubernetes集群增加了DNS组件，主要用于hostname到ip的解析以及集群内node和pod通过域名访问service。

* SkyDNS：提供DNS解析；

* kube2sky:将kubernetes内信息上报到etcd中；

**WebSSH相关组件**

为实现Web端登录容器控制台，需要配置WebSSH相关组件，包括Server端与Client端：

* WebSSH Server端：完成向指定主机上的指定容器发送SSH登录请求，并在Web端模拟终端交互过程。

* WebSSH Client端：需在集群中所有node节点部署，接收SSH登录请求并完成指定容器的登录。

