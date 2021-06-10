# 负载均衡管理

---

负载均衡是负载均衡实例的集合，用来控制一组负载均衡实例的访问权限，主要用于对外暴露服务和对流量进行转发。

目前DomeOS的负载均衡分为nginx和OpenResty两种类型，其中 nginx类型主要用于创建七层（HTTP）的负载均衡，并支持高可用，DomeOS提供的默认nginx镜像支持粘性会话并内置了健康检查机制，可以及时剔除故障节点；OpenResty类型是基于nginx，其内部集成了大量的Lua库、第三方模块以及大多数依赖，用于方便搭建能够处理超高并发、扩展性极高的动态 Web 应用、Web 服务和动态网关。

