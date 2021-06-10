# 添加或删除主机


---


## 添加主机
在DomeOS中，提供了给集群添加主机的脚本，方便地让用户将主机添加到已有kubernetes集群中。在集群详情页面点击"添加主机"，进入如下页面：

![](https://domeos-pics.bjcnc.scs.sohucs.com/%E6%B7%BB%E5%8A%A0%E4%B8%BB%E6%9C%BA.png)

* 
选择操作系统类型：DomeOS目前支持CentOS和ubuntu两种系统。
* 选择主机的工作场景：DomeOS中将集群内主机通过label做了隔离，只有有生产环境或测试
* 环境标签的机器，才能部署实例，不指定工作场景的主机也可以被添加到集群中。
* 为主机打上标签：用于隔离部署。
* 主机别名：如果主机的hostname符合DNS的命名规范，则该项不用填写。

信息填写完成后，复制5中的命令，在要添加的主机上执行，完成添加。
注意：命令中有下载脚本的步骤，如果要添加主机不能联网，请自行下载。若安装过程中出现错误，请按照脚本提示查找错误原因。


## 删除主机

DomeOS提供从集群中删除主机的功能。需要执行DomeOS官方提供的脚本，执行后主机上的kubelet、flannel、kube-proxy、docker会被停止，iptable会被清理。
删除主机脚本地址：http://domeos-script.bjctc.scs.sohucs.com/stop-k8s-node.sh
