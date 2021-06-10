# 一键安装

---

执行一键安装脚本，将以容器方式运行DomeOS Server、MySQL、etcd和Kubernetes master组件、监控报警组件以及dns服务相关组件，并自动在DomeOS中添加默认集群和相关全局配置，其中WebSSH功能已经集成在DomeOS Server镜像中。这一安装方式将在单机环境下部署一套最简化的DomeOS，省去了手动安装相对复杂的操作步骤，适合于快速部署和体验DomeOS的相关功能。

**安装说明**

1. 确认主机中已经安装好docker。若尚未安装，可执行

        curl get.docker.com | sh
		
   或
   
        yum install docker
		
   来安装docker，详细文档请参考[docker官方网站](https://docs.docker.com/engine/installation)。
   
2. 使用能够操作docker客户端的用户或root执行以下命令：

        curl http://dl.domeos.org/install.sh -o ./install.sh
		sh ./install.sh （ubuntu中为 bash ./install.sh）
		
3. 若安装脚本执行成功，将出现如下提示：

        [OK] DomeOS start successfully, please use browser to visit http://xx.xx.xx.xx:8080
		
   在浏览器中访问 http://xx.xx.xx.xx:8080 即可访问DomeOS，第一次登录请使用普通账户，用户名、密码均为admin。
   
**注意事项**

1. 具体参数配置信息请执行
   
        ./install.sh --help
   
   查看。
   
2. 脚本执行成功后，将在本机启动若干名称以--domeos-prefix为前缀的容器，应确保这些容器处于正常Running状态，脚本执行过程中可能会遇到各种问题，脚本中已经给出了较为详细的提示，请按照提示确认错误出现的原因。若有容器存在问题可使用docker logs命令查看日志，排查错误。

3. 一键安装脚本并未配置私有仓库，初始时也没有向集群中添加主机。启动和配置私有仓库以及向集群添加主机的方法可参考手动安装部分的相关章节。
