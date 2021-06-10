# 使用公有云的服务市场安装DomeOS系统

--- 

为了帮助用户快速体验并使用DomeOS系统，我们在腾讯云的服务市场发布了快速部署DomeOS的管理模块及主机节点的虚拟机镜像。通过该镜像，用户可以方便、快捷的体验DomeOS的所有功能。

## 腾讯云

使用腾讯云的服务市场中的DomeOS虚拟机镜像来搭建一套完整的DomeOS系统，需要经过以下两个步骤：**部署管理模块**、**添加主机节点**。

如果您是一个尚未使用过DomeOS的新用户，想要快速体验一下DomeOS的所有功能，可以按照**部署管理模块**来部署一个功能全面的Demo环境，该环境已经包含了一个主机节点。

**注意：** 免费版用户当前只能使用一个集群，并且总资源限制不能超过100核CPU、1TB内存，如果超过资源限制，需要按照[添加或删除主机](tian_jia_huo_shan_chu_zhu_ji.md)中的说明删除一些主机。

### 部署管理模块

管理模块包含了DomeOS Server、Kubernetes Master节点、Kubernetes Node节点以及监控报警等组件，可以支持DomeOS的所有功能。由于管理模块非常重要，并且包含的组件较多，所以建议在配置较高的云主机上部署管理模块，推荐云主机配置CPU 4核、内存 8G 以上。

**步骤**

- 访问[腾讯云-服务市场-DomeOS镜像](https://market.qcloud.com/products/2763)，并点击“立即使用”。在购买主机流程的“选择镜像”步骤，需要在服务市场中选择“DomeOS”。
- 进入“管理中心”找到购买的云主机并点击“登录”，也可以使用SSH方式登录。
- 在云主机上执行以下命令：

    ```curl -o init_domeos.sh http://domeos-script.bjctc.scs.sohucs.com/init_domeos.sh && sudo sh init_domeos.sh```
- 执行成功后，会显示DomeOS URL链接，在浏览器中打开该链接即可访问DomeOS系统。

**默认配置**

DomeOS相关配置：

|配置名称|配置内容|
|--|--|
|版本|0.6|
|端口|8080|
|管理员账号|admin|
|管理员密码|admin|
|Redis端口|6379|

数据库相关配置：

|配置名称|配置内容|
|--|--|
|版本|MySQL 5.7|
|端口|3306|
|root密码|root-mysql-pw|
|domeos用户名|domeos|
|domeos用户密码|domeos-mysql-pw|
|数据目录|/data/domeos/mysql|

Docker相关配置：

|配置名称|配置内容|
|--|--|
|版本|1.12.3|
|Graph路径|/var/lib/docker|

Kubernetes相关配置：

|配置名称|配置内容|
|--|--|
|版本|1.4.7|
|API端口|8888|
|kubectl路径|/usr/sbin/domeos/k8s/current/kubectl|
|ETCD版本|3.1.3|
|ETCD端口|2379/2380|
|ETCD数据目录|/data/domeos/etcd-data|
|私有仓库端口|5000|
|私有仓库数据目录|/data/domeos/registry|

### 添加主机节点

**步骤**

- 进入“管理中心”找到购买的云主机并点击“登录”，也可以使用SSH方式登录。
- 登录DomeOS系统，在集群详情页面点击"添加主机"，进入如下页面：
![](https://domeos-pics.bjcnc.scs.sohucs.com/%E6%B7%BB%E5%8A%A0%E4%B8%BB%E6%9C%BA.png)

    * 选择操作系统类型：选择CentOS系统，因为腾讯云的服务市场中的DomeOS镜像目前只有CentOS版本。
    * 选择主机的工作场景：DomeOS中将集群内主机通过label做了隔离，只有有生产环境或测试环境标签的机器，才能部署实例，不指定工作场景的主机也可以被添加到集群中。
    * 为主机打上标签：用于隔离部署。
    * **主机别名（重要）**：因为腾讯云主机的主机名一般不符合DNS的命名规范，所以需要设置主机别名，否则添加主机节点时可能会出错。

- 信息填写完成后，复制5中的命令，在云主机上执行，完成添加，添加成功后，可以在DomeOS的集群详情页面进行确认。
