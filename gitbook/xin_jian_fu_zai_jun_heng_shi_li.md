# 新建负载均衡实例

点击某个负载均衡组名称进入负载均衡组详情页，可以看到“创建负载均衡”，点击进入新建负载均衡实例页面。

![](http://domeos-pics.bjcnc.scs.sohucs.com/负载均衡实例列表20210409.png)

进入负载均衡创建页面。

![](http://domeos-pics.bjcnc.scs.sohucs.com/创建负载均衡实例20210409.png)

在新建负载均衡实例时，需要进行以下配置：

1. 名称：该名称会作为内网域名的一部分，要求符合dns命名规范。   
2. 描述：负载均衡的详情描述，默认为空，可不填。   
3. 类型：可选nginx、OpenResty两种类型，每种类型对应的运行镜像不同。
4. 所属资源包：选择资源包，镜像最终会部署到资源包里选中的主机中。
5. 版本名称模板：定义版本名称模板，生成的版本名称会根据模板自动生成。
6. 所在主机：确定镜像部署到到哪些主机上，可以配置多个主机以实现高可用。所选主机数量与启动实例个数相同。
7. 监听端口：实例启动后的监听端口。
8. 运行镜像：DomeOS提供了默认镜像，如果有特殊需求，可以根据文档说明，定制自己的镜像。DomeOS提供的默认nginx镜像使用max_fails和fail_timeout实现健康检查，默认值为max_fails=1，fail_timeout=10s。以下情况健康检查失败：连接实例错误或超时，实例无响应，实例返回的HTTP状态码为500、502、503或504。
9. 资源配额：确定镜像运行所需要的资源。
10. 日志存储：主要有三种日志存储策略：第一种是不存储日志，该类别会将日志输出到容器的控制台，日志会因 nginx 实例调度而丢失；第二种是挂载主机目录，该类别会将主机目录挂载到nginx容器内部，nginx实例调度后存储于主机目录的日志文件不会丢失；第三种是日志自动收集，该类别会将 nginx 日志通过 Flume 自动收集至 Kafka。