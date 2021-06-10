# 配置高可用K8S集群


---


## 前言


Kubernetes作为容器编排管理系统，通过Scheduler、Replication Controller等组件实现了应用层的高可用，通过service实现了pod的故障透明和负载均衡。但是针对Kubernetes集群，还需要实现各个组件和服务的高可用。下面主要介绍一下搭建高可用k8s集群的步骤和配置（以下步骤是使用非容器方式启动k8s的组件和服务）。
 

## 配置步骤


**1、k8s各个组件和服务的进程高可用配置**
在Linux系统中，我们通过Supervisor、Systemd等工具实现对服务的监控保证服务的高可用，我们的domeOS手工配置脚本中是使用Systemd的方式来启动和控制k8s的各个组件和服务的。比如kube-apiserver的服务配置：

```
echo "[Unit]
Description=kube-apiserver
 
[Service]
EnvironmentFile=/etc/sysconfig/kube-apiserver

ExecStart=$K8S_INSTALL_PATH/current/kube-apiserver $ETCD_SERVERS \\
 $SERVICE_CLUSTER_IP_RANGE \\
 $INSECURE_BIND_ADDRESS \\
 $INSECURE_PORT \\
 $KUBE_APISERVER_OPTS
Restart=always
" > /lib/systemd/system/kube-apiserver.service

```
**2、etcd的高可用配置**
由于k8s是使用etcd来存储各项配置和数据的，为了确保etcd的高可用，同时防止这些数据的丢失，我们需要使用start_etcd.sh脚本在两个及以上的node上分别启动一个etcd。

**3、master的高可用配置**
由于master里面的kube-apiserver、kube-controller、kube-scheduler等是整个k8s的核心组件，一旦发生了故障将直接导致k8s的调度、服务等不可用，为了防止master的单点故障问题，我们使用start_master_centos.sh在两个及以上的node上分别启动master的各个组件，同时注意启动apiserver时加上apiserver-count参数（master节点数量），在controller、scheduler的启动参数里面加入--leader-elect=true参数，确保同一时间仅仅有一个controller或者scheduler生效。其中在配置apiserver的ip:port时，既可以使用本机的apiserver也可以使用下面4中所配置的虚ip:port。

**4、kuber-apiserver的访问接口的负载均衡配置**
由于我们有多个master，自然有多个kube-apiserver，一些kubectl、client等都需要通过这个apiserver来访问k8s集群，为了确保api的高可用性并均衡api的访问压力，我们这里使用
keepalived v1.2.13和haproxy v1.5.14来配置api。
Keepalived的keepalived.conf配置（我们这里使用主备模式）：
主配置（从配置将master改为BACKUP即可）：

```

! Configuration File for keepalived
 
global_defs
{
  router_id  haproxy_master
}
 
vrrp_script chk_haproxy {
script "/etc/keepalived/check.sh"
interval 2
weight 2
}
 
vrrp_instance sce_master
{
  state MASTER
  interface eth0
  virtual_router_id 70
  priority 200
  advert_int 2
  smtp_alert
  authentication
   {
    auth_type PASS
    auth_pass SCEPASS
   }
  track_script {
    chk_haproxy
   }
  virtual_ipaddress
   {
    192.168.64.144/22 dev eth0 scope global
   }
}
```

Haproxy的haproxy.cfg配置(另外一台机器的配置与此相同)：

```

global
    
    log         127.0.0.1 local2
 
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon
 
    stats socket /var/lib/haproxy/stats
 

defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000
    stats uri /haproxy-stats
 
frontend  main 0.0.0.0:8080
    acl url_static       path_beg       -i /static /images /javascript /stylesheets
    acl url_static       path_end       -i .jpg .gif .png .css .js
 
    use_backend static          if url_static
    default_backend             app

backend static
    balance     roundrobin
    server      static 127.0.0.1:4331 check

backend app
    balance     roundrobin
    server  app1 192.168.65.65:8080 check
    server  app2 192.168.65.64:8080 check
    server  app3 192.168.65.62:8080 check
```
配置后的apiserver架构图

![](https://domeos-pics.bjcnc.scs.sohucs.com/k8s1.png)

**5、如果是以pod的方式启动k8s里面的一些组件或者其他服务，我们可以使用kubelet的static pod（固定pod的ip，防止漂移）。**
修改某个node节点上的/etc/sysconfig/kubelet配置文件，为kubelet进程配置一个manifests监视目录：KUBELET_OPTS=' --config=/etc/kubernetes/manifests，比如我想启动一个haproxy的static pod，我们只需要将haproxy对应的yaml文件放到这个目录下面即可。
```
apiVersion: v1
kind: Pod
metadata:
  name: haproxy-pod
spec:
  hostNetwork: true
  containers:
  - name: "haproxy"
    image: "10.31.92.146:5000/domeos/haproxy:1.6.9"
    ports:
    - containerPort: 8083
      hostPort: 8083
    volumeMounts:
    - name: "configmount"
      mountPath: /usr/local/etc/haproxy/haproxy.cfg
      readOnly: true
  volumes:
  - name: "configmount"
    hostPath:
      path: "/opt/haproxy.cfg"
```
**6、当完成k8s高可用的所有步骤后，系统的架构图如下：**

![](https://domeos-pics.bjcnc.scs.sohucs.com/k8s2.png)
