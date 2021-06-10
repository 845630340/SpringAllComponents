# 用户登录

---

通过浏览器访问DomeOS Server，有三种登录方式可选：

**LDAP登录**：通过全局配置中登录管理的LDAP账户登录。若在全局配置中指定了LDAP服务的email后缀，登录用户名可以不包含email后缀。不同企业的LDAP配置方式可能不同，此处以搜狐公司的LDAP服务器验证方式为基准开发，如有需要请自行修改相关源码。

**SSO登录**：通过全局配置中登录管理的SSO账户登录。如果要启动SSO单点登录功能，必须要填写CAS 服务器地址，此处以标准的SSO接口开发，如有需要请自行修改相关源码。

**普通账户**：通过管理员账户(初始用户名密码均为admin)或DomeOS中添加的普通用户账户登录。

![](https://domeos-gitbook.bjcnc.scs.sohucs.com/login.png)
