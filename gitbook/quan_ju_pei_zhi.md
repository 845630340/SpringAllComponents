# 全局配置

---

为保证DomeOS各个模块的正常运行，完成系统安装及初始化后，需要正确合理地设定DomeOS全局配置项。以普通账户->用户名admin、密码admin登录DomeOS，点击"全局配置"即可进入全局配置页面。

注意：admin用户是整个DomeOS的系统管理员，拥有所有资源的最高权限。只有admin用户能够查看并修改全局配置，非admin用户无法改变全局配置。

## 1. 镜像构建

输入构建镜像地址，选择构建资源包。

![image](http://domeos-pics.bjcnc.scs.sohucs.com/镜像构建20210415.png)

## 2.用户认证

通常企业会有内部的LDAP服务器或者CAS服务器，用来管理公司账号。在登录管理页面上，可以选择启用LDAP或者CAS认证。启用LDAP并填写完LDAP相关配置后，该LDAP服务器管理的账号都可以登录DomeOS控制台，启用CAS并填写完CAS相关配置后，该CAS服务器管理的账号也都可以登录DomeOS控制台。如果同时启用LDAP和CAS，默认使用CAS认证方式。

**启用LDAP**

LDAP服务器地址：填写LDAP服务器地址以及端口号。

默认后缀域名：LDAP服务器可以配置后缀(suffix)。 

**启用CAS**

CAS服务器地址前缀：填写CAS服务器地址。

登录地址：login请求相对地址，需要/开头 

登出地址：logout请求相对地址，需要以/开头

![](http://domeos-pics.bjcnc.scs.sohucs.com/用户认证20210415.png)

## 3.用户管理

在DomeOS中，用户分为外部用户和本地用户，用户状态分为正常、停用、离职。

**外部用户**：通过关联LDAP服务器和CAS服务器获得，当新用户通过LDAP或者CAS方式登录到DomeOS，将自动在DomeOS系统中新增一个LDAP用户。LDAP用户的管理受LDAP服务器或者CAS服务器控制，DomeOS仅提供展示功能。LDAP用户在DomeOS上和本地用户的设定、权限等完全相同。

**本地用户**：DomeOS自身的用户。admin可以在页面上添加或删除本地用户。DomeOS中已经存在的本地用户可以通过本地账户方式登录到DomeOS系统中。

在用户管理页面中，可以看到DomeOS系统上所有的用户。admin可以编辑用户邮箱、电话、删除用户(不能删除admin本身)等，对于本地用户，admin还可以修改登录密码、以及创建一个新的本地用户账号。

![](http://domeos-pics.bjcnc.scs.sohucs.com/用户管理20210415.png)

## 4.代码仓库

DomeOS支持关联代码仓库，用于关联代码并构建项目。目前DomeOS支持关联Gitlab。您需要填写您的Gitlab地址。DomeOS支持关联多个不同的Gitlab地址，而且还支持https方式访问的Gitlab，可以跳过安全验证。与此同时，在删除Gitlab地址时，会根据工程关联情况给出明确提示。

![](https://domeos-pics.bjcnc.scs.sohucs.com/%E5%85%A8%E5%B1%80%E9%85%8D%E7%BD%AE04.png)

## 5.日志收集

用户可以启用日志收集功能，日志会存储到指定的ES服务器中，用户输入ES服务器地址、用户名和密码，然后输入Kibana代理地址，通过Kibana进行日志查看。

![image](http://domeos-pics.bjcnc.scs.sohucs.com/日志收集02.png)

## 6.报警配置

用户关注微信公众号进行报警邮箱注册与报警设置，实时接收报警邮件通知。

![image](http://domeos-pics.bjcnc.scs.sohucs.com/报警配置20210415.png)

## 7. 镜像仓库

在这里需要填写私有镜像仓库的部署地址和相应配置，以便于DomeOS执行镜像相关操作，并将新添加主机正确连接至私有镜像仓库。

**配置说明**

私有仓库地址：填写私有镜像仓库的访问地址，若私有仓库证书为自签名证书，则需要将证书信息配置到DomeOS中。

![](http://domeos-pics.bjcnc.scs.sohucs.com/镜像仓库20210415.png)

**私有仓库的token 方式认证**

使用DomeOS作为私有仓库的token auth server时，私有仓库的登录用户名密码与DomeOS的用户名密码一致，而权限则与Project的权限一致。

例如：这里DomeOS项目与私有仓库对应关系为：

项目名称-test 

私有仓库镜像位置-registryaddr:registryport/test/ 

|项目权限 | 私有仓库权限 |
| -- | -- |
| Master| push，pull，delete|
| Developer| push，pull|
|Reporter| pull|

使用DomeOS作为私有仓库的token auth server时，需要配置如下:

全局配置中，私有仓库配置栏下，需要配置，ISSUER，SERVICE，与PRIVATE KEY。

这里的ISSUER，SERVICE，PRIVATE KEY需要与私有仓库的启动参数， token-issuer，token-service，与证书对应一致。
私有仓库的配置可以参考https://github.com/docker/distribution/blob/master/docs/configuration.md
启动私有仓库时，需要额外配置REGISTRY_AUTH_TOKEN_REALM REGISTRY_AUTH_TOKEN_SERVICE REGISTRY_AUTH_TOKEN_ISSUER REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE环境变量，并挂载相应证书。
这里的REGISTRY_AUTH_TOKEN_REALM地址为http://domeos_server_addr/service/token，REGISTRY_AUTH_TOKEN_SERVICE，REGISTRY_AUTH_TOKEN_ISSUER需要与前述说明配置相同，REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE需要指定证书位置并通过-v命令挂载与PRIVATE KEY对应的证书。

## 8. 服务器

服务器地址，其他需要与DomeOS Server交互的组件通过这一地址连接DomeOS Server。

Kubernetes Manager地址：Kubernetes API-Server地址，DomeOS与Kubernetes进行交互的地址。

![](http://domeos-pics.bjcnc.scs.sohucs.com/服务器20210415.png)
