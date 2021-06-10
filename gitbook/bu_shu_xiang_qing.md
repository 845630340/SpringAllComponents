## 部署详情

点击部署列表中部署名称或者详情图标进入该部署详情

#### 详情
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E9%83%A8%E7%BD%B2%E8%AF%A6%E6%83%85.png)
在部署的详情页面，可以在第一个tab“部署详情”中看到该部署的所有部署版本。

一个部署版本包含以下内容：

1. 部署的容器配置，包括镜像信息、拉取策略、资源配额、启动命令、挂载存储、日志收集、环境变量、配置文件、健康检查、就绪检查、自动升级、实例终止、Hosts、主机标签。
2. 部署的基本信息，包括名称、描述、类型、创建者、命名空间。

#### 新建版本
用户可在详情页点击“创建新版本”更新容器配置信息
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E6%96%B0%E5%BB%BA%E7%89%88%E6%9C%AC.png)
- 用户可自定义版本名称对版本进行区分，完成配置后点击“创建版本”完成新建。

#### 金丝雀发布（启动/升级/恢复）

随着项目代码的更新迭代，线上服务需要不断地升级，如果升级失败或者在业务上不符合要求，还需要恢复，而且在实际发布应用时，用户可能需要同时启动多个版本进行金丝雀发布。DomeOS针对这一需求对部署设计了版本系统，用户可以部署新版本进行升级，也可以选择一个旧部署版本进行恢复，还可以同时启动或者升级多个版本。

创建后的版本可通过启动/升级进行部署，点击上菜单栏中“启动”或者“升级”按钮选择需要部署的版本。
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E5%8D%87%E7%BA%A7%E9%83%A8%E7%BD%B2.png)
- 升级策略：仅在升级时有效，可以设置最大无效实例数量（maxUnavailable）用来控制不可用部署实例数量的最大值，从而在删除旧实例时保证一定数量的可用实例；最大超额实例数量（maxSurge）在部署实例个数基础之上，滚动升级时每次最多可以再启动的实例数量；实例升级时间间隔（minReadySeconds）部署实例就绪后再进行下一批部署实例更新的时间间隔。

#### 升级历史
历史升级记录可在“升级历史”中查看，用户可以选择升级到某个历史版本。
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E5%8D%87%E7%BA%A7%E5%8E%86%E5%8F%B2.png)

#### 动态修改配置文件
新增动态修改配置文件的功能，支持用户对当前版本的容器配置文件进行编辑，如果想对容器中的程序生效，需要用户的程序支持热加载。

点击当前页中“编辑”按钮即可修改
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E7%BC%96%E8%BE%91%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6.png)
完成后点击“保存”即可更新配置文件（配置文件生效时间受限与kubelet配置中的同步时间，一般是1分钟）

#### 容器日志和控制台

您可以在“实例列表”页面里看到部署正在运行的实例
![image](http://domeos-pics.bjcnc.scs.sohucs.com/实例列表20210408.png)

在日志栏点击“查看日志”，可以在新窗口查看实例内各个容器的日志。
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E5%AE%9E%E4%BE%8B%E6%97%A5%E5%BF%97.png)

此外，我们提供了Web端容器SSH登录的功能，在容器控制台栏点击"打开控制台"即可打开容器命令行，方便查看容器环境并调试应用。
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E8%BF%9B%E5%85%A5%E6%8E%A7%E5%88%B6%E5%8F%B001.png)
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E8%BF%9B%E5%85%A5%E6%8E%A7%E5%88%B6%E5%8F%B002.png)

针对一些需要重启实例的情况，在操作栏点击“重启”，即可立即重启实例。

#### 事件记录
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E4%BA%8B%E4%BB%B6%E8%AE%B0%E5%BD%95.png)
DomeOS的部署具有完整详细的事件记录，用户可以查看所有的历史操作记录以及该操作所对应的k8s事件信息。

#### 提供服务
可以在提供服务页面添加修改集群内访问和集群外访问信息，并可以看到负载均衡的转发规则信息。
![image](https://domeos-pic3.bjcnc.scs.sohucs.com/%E6%8F%90%E4%BE%9B%E6%9C%8D%E5%8A%A1.png)

#### 状态监控

可以展示某个实例在最近某时间端内的CPU与内存使用情况。

![image](http://domeos-pics.bjcnc.scs.sohucs.com/状态监控20210408.png)