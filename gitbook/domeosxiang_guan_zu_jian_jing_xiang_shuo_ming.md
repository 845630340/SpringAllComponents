# DomeOS相关组件镜像说明

---

DomeOS公开镜像仓库地址：pub.domeos.org

DomeOS相关组件镜像下载地址(更新于2016-11-16)：

| 组件  | 镜像地址 | github项目<br/>/官方说明 | 备注  |
| --- | --- | --- | --- |
| domeos server | pub.domeos.org/domeos<br/>/server:1.5.0  | [github地址](https://github.com/domeos/server ) | DomeOS Server镜像, 已集成WebSSH Server |
| mysql | pub.domeos.org/domeos<br/>/mysql:5.7 | [官方说明](https://www.mysql.com) | MySQL |
| mysql-init | pub.domeos.org/domeos<br/>/domeos-mysql-init:0.9 | - | 一键安装脚本的MySQL初始化 |
| etcd | pub.domeos.org/domeos<br/>/domeos-etcd:2.2.1 | - | 一键安装脚本的etcd |
| kubernetes | pub.domeos.org/domeos<br/>/kubernetes:1.4.7 | - | 一键安装脚本的kubernetes组件 |
| registry | pub.domeos.org/domeos/docker<br/>-registry-driver-sohustorage:1.1 | [github地址](https://github.com/domeos/docker-registry-driver-sohustorage) | 存储对接搜狐云台 |
| skydns | pub.domeos.org/domeos<br/>/skydns:1.5 | [github地址](https://github.com/skynetservices/skydns) | SkyDNS组件 |
| kube2sky | pub.domeos.org/domeos<br/>/kube2sky:0.4 | [github地址](https://github.com/domeos/kube2sky) | Kube2sky组件 |
| agent | pub.domeos.org/domeos<br/>/agent:2.6-supervisor | [github地址](https://github.com/domeos/agent) | 监控agent组件，已集成WebSSH Client |
| transfer | pub.domeos.org/domeos<br/>/transfer:0.0.15-supervisor | [github地址](https://github.com/open-falcon/transfer) | 监控transfer组件 |
| graph | pub.domeos.org/domeos<br/>/graph:0.5.7-supervisor | [github地址](https://github.com/open-falcon/graph) | 监控graph组件 |
| query | pub.domeos.org/domeos<br/>/query:1.5.1-supervisor | [github地址](https://github.com/open-falcon/query) | 监控query组件 |
| hbs | pub.domeos.org/domeos<br/>/hbs:1.1.0-supervisor | [github地址](https://github.com/open-falcon/hbs) | 监控hbs组件 |
| judge | pub.domeos.org/domeos<br/>/judge:2.0.3 | [github地址](https://github.com/open-falcon/judge) | 报警judge组件 |
| alarm | pub.domeos.org/domeos<br/>/alarm:1.0.1 | [github地址](https://github.com/domeos/alarm) | 报警alarm组件 |
| sender | pub.domeos.org/domeos<br/>/sender:1.0.1 | [github地址](https://github.com/domeos/sender) | 报警sender组件 |
| nodata | pub.domeos.org/domeos<br/>/nodata:0.0.8-supervisor | [github地址](https://github.com/open-falcon/nodata) | 报警nodata组件 |
| redis | pub.domeos.org/domeos<br/>/redis:3.0.7 | [官方说明](http://redis.io/) | Redis |
| webssh server | pub.domeos.org/domeos<br/>/shellinabox:1.1 | [github地址](https://github.com/domeos/shellinabox) | WebSSH Server组件 |
| webssh client | 已集成至agent镜像 | [github地址](https://github.com/domeos/dockerConnector) | WebSSH Client组件 |
| build | pub.domeos.org/domeos<br/>/build:0.4 | [github地址](https://github.com/domeos/imagebuilder) | 构建镜像 |
| rolling-update | pub.domeos.org/<br/>rolling-update:v0.1 | - | 维护RC类型部署镜像 |

