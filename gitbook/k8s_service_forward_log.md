# 记录k8s中service的转发记录

---

当部署有多个副本实例时，在某些情况下，我们可能需要跟踪某次请求具体打到了某个pod实例上，为此我们提供了一个shell脚本，在不影响DomeOS中部署服务的情况下，通过添加iptables日志规则来记录service的转发路径。


为iptables添加规则，记录k8s中service的转发记录的脚本如下表所示：

|文件名|说明|下载地址|
|--|--|--|
|add_iptables_log.sh|添加日志规则|http://domeos-script.bjctc.scs.sohucs.com/add_iptables_log.sh|

**使用方式**

在各个主机节点上执行如下命令

    sudo bash add_iptables_log.sh

**脚本说明**

第一、记录iptables日志

编辑/etc/rsyslog.conf文件，添加：

```kern.*     /var/log/iptables.log```

执行systemctl restart rsyslog，确保配置生效

第二、iptables日志滚动

编辑/etc/logrotate.d/syslog文件，添加：

```
/var/log/iptables
```

第三、从宿主机外、宿主机上、容器内部访问某个service ip时，必然经过nat表的POSTROUTING链

kube-proxy通过在nat表中的PREROUTING和OUTPUT链添加规则，进而将service的ip地址改成某个pod的ip地址，同时给数据包加上了0x4000/0x4000标记，因此为了记录访问某个service时，具体打到了某个特定的pod ip可以通过如下命令在POSTROUTING链中增加一条记录LOG的规则：

```
iptables -t nat -I POSTROUTING -m comment --comment "kubernetes service portals" -m mark --mark 0x4000/0x4000 -j LOG --log-prefix "----domeos postrouting-----
"
```

第四、经过第三步仅仅能捕获到该请求最终打到某个pod上，但是缺少service ip的记录，为此需要在NAT表中的PREROUTING链和NAT表中的OUTPUT表中通过如下命令增加规则：

```
iptables -t nat -I PREROUTING -m comment --comment "kubernetes service portals" -j LOG --log-prefix "----domeos pretrouting-----"
```

```
iptables -t nat -I OUTPUT -m comment --comment "kubernetes service portals" -j LOG --log-prefix "----domeos output-----"
```

第五、iptables日志分析

根据iptables log中的DST字段（service ip）和 ID（数据包的唯一标识），可以追踪到该service最终转到了某个pod ip。例如，在宿主机上访问service ip 172.18.238.71 port 8080

```
May 16 21:31:48 IN= OUT=eth0 SRC=192.168.65.64 DST=172.18.238.71 LEN=60 TOS=0x10 PREC=0x00 TTL=64 ID=34103 DF PROTO=TCP SPT=56886 DPT=8080 WINDOW=29200 RES=0x00 SYN URGP=0
```

```
May 16 21:31:48 IN= OUT=docker0 SRC=192.168.65.64 DST=172.24.144.10 LEN=60 TOS=0x10 PREC=0x00 TTL=64 ID=34103 DF PROTO=TCP SPT=56886 DPT=8080 WINDOW=29200 RES=0x00 SYN URGP=0 MARK=0x4000
```

	
**验证**

通过```iptables -t nat -L | grep LOG```查看iptables中的LOG信息。

**注意**

该脚本目前仅在centos7上进行了测试，在其他系统上可能会执行失败，可以参照脚本自行修改。

**参考**

1. iptables官方文档：http://www.netfilter.org/projects/iptables/index.html
2. iptables架构文档：http://www.iptables.info/en/structure-of-iptables.html
3. kubernetes中proxy源码文档：https://github.com/kubernetes/kubernetes/blob/master/pkg/proxy/iptables/proxier.go
