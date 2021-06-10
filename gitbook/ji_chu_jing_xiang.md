## 基础镜像
Docker具有分层镜像格式的特性，最底层用来构建镜像的公共镜像被称为基础镜像。

- 镜像来源

DomeOS的基础镜像可以是一个项目镜像，也可以是私有仓库中存放的其他镜像，以及第三方的镜像仓库中的镜像。因此，基础镜像并不一定存储在私有仓库中，可以是在使用时从对应的镜像仓库中获取。DomeOS中的基础镜像除了用于构建，也可直接部署。
- 详细信息

点击左侧导航栏“基础镜像”进入基础镜像模块。仅管理员可添加基础镜像，添加后即可查看使用，可根据类型进行筛选。

![image](http://domeos-pics.bjcnc.scs.sohucs.com/基础镜像列表20210406.png)
（图中为实例，不代表实际存在基础镜像）

点击任意基础镜像名称进入该基础镜像详情，可查看Markdown介绍、版本信息。
![image](https://domeos-pics2.bjcnc.scs.sohucs.com/%E5%9F%BA%E7%A1%80%E9%95%9C%E5%83%8F%E8%AF%A6%E6%83%85.png)

点击“试用”按钮选取想要试用的版本
![image](https://domeos-pics2.bjcnc.scs.sohucs.com/%E5%9F%BA%E7%A1%80%E9%95%9C%E5%83%8F%E8%AF%95%E7%94%A8.png)
![image](https://domeos-pics2.bjcnc.scs.sohucs.com/%E8%AF%95%E7%94%A8%E7%89%88%E6%9C%AC.png)
确认会跳至试用日志页面，用户可查看试用进度和结果。
![image](https://domeos-pics2.bjcnc.scs.sohucs.com/%E8%AF%95%E7%94%A8%E6%97%A5%E5%BF%97.png)
试用日志为临时文件，默认保留四个小时，之后将会失效，失效后无法查看。
