# DomeOS监控服务对接

---

DomeOS服务接入Hound进行监控，需要分别在DomeOS和Hound进行以下操作：

## **DomeOS端操作说明**

用户在DomeOS端需要依次完成三步操作：（1）构建集群；（2）启用集群Prometheus组件；（3）上报监控指标端口和路径。

**前提条件**  
用户需自行申请物理机，通过DomeOS将物理资源按照集群划分，与原流程一致，参考DomeOS帮助文档：[https://gitbook.domeos.sohucs.com/](https://gitbook.domeos.sohucs.com)

**启用集群Prometheus组件**  
1、开启位置：  
从菜单“DomeOS&gt;运维管理&gt;资源包&gt;集群”进入集群列表页，选择需要开启监控服务的集群，点击组件进入组件管理页。  
2、操作说明：  
组件管理页中，组件列表下方，点击创建集群Prometheus按钮进入创建页面，创建完成后列表中显示Prometheus组件，且运行状态为正在运行时开启成功，如下图：  
![](https://domeos-pic3.bjcnc.scs.sohucs.com/%E5%88%9B%E5%BB%BA%E9%9B%86%E7%BE%A4%E7%9B%91%E6%8E%A7.png)

**上报监控指标端口和路径**  
1、开启位置：  
（1）新建部署页：从菜单“DomeOS&gt;运维管理&gt;服务”进入服务列表页；选择需要开启监控的服务，点击创建部署进入版本信息页。  
（2）升级部署（新建版本）页：从菜单“DomeOS&gt;运维管理&gt;服务”进入服务列表页；选择需要开启监控的服务，点击部署名称&gt;创建新版本，进入新建版本页。  
2、操作说明：  
用户进入“版本信息”页或“新建版本”页时，点击Hound监控服务按钮，开启后填写监控指标端口和监控指标路径，即可完成Hound监控服务的开启。注：一定要先启用当前集群的Prometheus组件，才能开启具体部署的监控服务；  
（1）新建部署-版本信息页：  
![](https://domeos-pic3.bjcnc.scs.sohucs.com/%E6%96%B0%E5%BB%BA%E9%83%A8%E7%BD%B2%E7%9B%91%E6%8E%A7.png)  
（2）新建版本页：  
![](https://domeos-pic3.bjcnc.scs.sohucs.com/%E6%96%B0%E5%BB%BA%E7%89%88%E6%9C%AC%E7%9B%91%E6%8E%A7.png)

## Hound端操作说明

用户在Hound平台需要依次完成两步操作：（1）新建应用（2）监控应用；

**新建应用**  
1、开启位置：  
从菜单“Hound&gt;监控应用&gt;新建应用”进入新建应用弹窗。  
2、操作说明：  
用户进入“监控应用”页后，点击新建应用按钮，即可开始填写应用信息，“指标来源”选择DomeOS部署，选择需要监控的服务名和部署名后即可完成创建，创建完成后可在应用列表进行查看。  
![](https://domeos-pic3.bjcnc.scs.sohucs.com/hound%E6%93%8D%E4%BD%9C.png)

**监控应用**  
具体监控步骤与Hound内其他应用相同，参考Hound帮助文档：[https://docs.panther.sohurdc.com/houndjian-kong-bao-jing-3011-2014-2014/ying-yong.html。](https://docs.panther.sohurdc.com/houndjian-kong-bao-jing-3011-2014-2014/ying-yong.html)



