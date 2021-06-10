# kubernetes平滑升级

---

kubernetes是DomeOS重要的容器管理平台，目前kubernetes更新十分活跃，我们也积极跟随kubernetes的版本更新。为了方便用户使用kubernetes最新的稳定版功能，我们提供了kubernetes平滑升级脚本，确保在不影响服务的情况下，将kubernetes更新到最新的可用版本。

**注意：** 该升级脚本只适用于升级至kubernetes 1.5及以下的版本。

## 脚本:

   [update_k8s.sh](http://domeos-script.bjctc.scs.sohucs.com/update_k8s.sh)

### 1.参数说明：
参数1：升级类别，master或者node
参数2：版本，如1.1.7
参数3：本地升级包位置，不传此参数会自动去服务器下载
### 2.使用方法：
* 可访问外网时：    
  1. 直接执行 `curl domeos-script.bjctc.scs.sohucs.com/update_k8s.sh | sh -s master 1.1.7`
  
* 不可访问外网时：
  1. 下载update_k8s.sh脚本和升级包，升级包下载地址:
 
        [http://domeos-binpack.bjcnc.scs.sohucs.com/k8s/$version/master.tgz](http://domeos-binpack.bjcnc.scs.sohucs.com/k8s/$version/master.tgz)
        
        [http://domeos-binpack.bjcnc.scs.sohucs.com/k8s/$version/node.tgz](http://domeos-binpack.bjcnc.scs.sohucs.com/k8s/$version/node.tgz)
      
  2. 执行`sh update_k8s.sh node 1.1.7 node.tgz`

## 说明：
* 升级顺序：  
  一般建议先升级master，再升级node
* 升级脚本逻辑流程：
    1. 下载升级包，解压，校验
    2. 停止kubernetes服务
    3. 创建`/usr/sbin/domeos/k8s/$version/`文件夹，把二进制文件考到这个文件夹内，删掉`/usr/sbin/domeos/k8s/current/`，重新做软链接到上述文件夹
    4. 启动所有的kubernetes服务
* 影响范围：
  1. kubelet进程停止1分钟后该node会变成`notReady`状态，停止5分钟后该node上的pod会重新调度
  2. kubeproxy进程停止并不影响已经存在的service的服务状态，只会影响该node上相关iptables规则的创建，而且这些未能创建的规则会在kubeproxy启动后自动补上
* 升级失败应对：
  1. 自动：重新执行一下老版本的升级，如1.1.7到1.2.0升级失败，可以直接执行`curl domeos-script.bjctc.scs.sohucs.com/update_k8s.sh | sh -s master 1.1.7`
  2. 手动：老版本的kubernetes二进制文件还在`/usr/sbin/domeos/k8s/$version/`文件夹内，可以直接手动删掉`/usr/sbin/domeos/k8s/current/`并做软链接到老版本文件夹上，然后重启kubenetes的服务。    
  
     ```
     node:    
     service kubelet restart 
     service kube-proxy restart
     
     master:  
     service kube-scheduler restart
     service kube-apiserver restart
     service kube-controller restart
     service kube-proxy restart
     ```
  
