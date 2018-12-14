# 宝塔面板一键docker部署

建议使用host网络模式启动,不需要设置映射端口,自动映射宝塔面板全端口到外网 正常的bridge模式可能会造成网站后台不能获取用户真实ip地址.

通过host模式运行宝塔镜像 
> docker run -tid --name baota --net=host --privileged=true --restart always -v bt-www:/www bjking/lnmp


如果特殊情况不能使用host网络模式, 或者容器运行后不能打开面板页面请删除容器后,使用如下命令以bridge网络模式运行 
> docker run -tid --name baota -p 80:80 -p 443:443 -p 8888:8888 -p 888:888 -p 20:20 -p 21:21 --privileged=true --restart always -v bt-www:/www bjking/lnmp

删除容器命令如下 
> docker stop baota && docker rm baota

镜像运行成功后,运行如下命令(二选一即可)查看初始化后的面板登录地址和初始账号密码信息

> docker logs -f -t --tail 10 baota

> docker exec baota bt default

版本命名说明 bjking/lnmp:latest 或 bjking/lnmp 为最新版本的官方纯净安装的基础上安装nginx,mysql,php

安装完成后以后可以随时使用内置升级,升级到最新版本, 由于面板数据都保存在持久化的卷中, 即使删除容器后重新运行, 原来的面板和网站数据都能得到保留.

创建卷 
> docker volume create --name=bt-www

查看卷详细信息
> docker volume inspect bt-www

如果需要将卷目录挂载到其他目录或者硬盘，建议使用软链接挂载
> ln -S /var/lib/docker/volumes/bt-www /opt/www

每次启动容器后自动启动所有服务 如果还没有安装docker的请运行这个安装脚本

> curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

好用请收藏加星支持一下,谢谢! 其他问题和建议请联系邮箱：[mymortals@gmail.com](mailto:mymortals@gmail.com "mymortals@gmail.com")
