FROM centos:latest
MAINTAINER maxshell maxowner@qq.com
COPY install_6.0.sh /home/install.sh
COPY entrypoint.sh /home/entrypoint.sh

RUN cd /home \
	&& mkdir /etc/backup/ \
	&& mv /etc/yum.repos.d/* /etc/backup/ \
	&& curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
    && yum install -y wget \
	&& mkdir -p /www/letsencrypt \
	&& ln -s /www/letsencrypt /etc/letsencrypt \
	&& mkdir /www/init.d \
	&& rm -f /etc/init.d  \
	&& ln -s /www/init.d /etc/init.d \
    && echo y | bash install.sh \
	&& bash /www/server/panel/install/install_soft.sh 1 install php 7.1 \
	&& bash /www/server/panel/install/install_soft.sh 1 install nginx 1.15 \
	&& bash /www/server/panel/install/install_soft.sh 1 install mysql 5.6 \
	&& yum clean all \
	&& rm -rf /tmp \
	&& rm -rf /www/server/nginx/src \
	&& rm -rf /www/server/mysql/mysql-test \
	&& chmod +x entrypoint.sh 
CMD /home/entrypoint.sh
VOLUME ["/www/"]
HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
