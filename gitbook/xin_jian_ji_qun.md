# 新建集群


---

通过新建集群可以把一个kubernetes集群添加到DomeOS进行管理。
在控制台左侧导航栏点击“集群”，在页面上点击“新建集群”，进入新建集群的配置页面。

![](https://domeos-pics.bjcnc.scs.sohucs.com/%E6%96%B0%E5%BB%BA%E9%9B%86%E7%BE%A4.png)

然后填写集群的配置信息，请确保信息与启动集群时的配置一致。

![](https://domeos-pics.bjcnc.scs.sohucs.com/%E6%96%B0%E5%BB%BA%E9%9B%86%E7%BE%A401.png)

* 集群名称：用于标识集群，不能与其他集群重名，否则无法创建。
* 集群https访问：是否开启集群安全访问
* api server：kubernetes集群的api server地址，请以ip:port方式填写。
* dns服务器：该kubernetes集群的dns服务器地址，即skydns的ip。
* etcd：该集群etcd地址，请以ip:port方式填写，若为etcd集群，请将信息填写完整。
* domain：集群的域名
* 日志自动收集：该集群的日志收集组件信息，在创建部署时使用。DomeOS采用flume+kafka的方式收集日志，提供了flume镜像，kafka需用户自行配置。




