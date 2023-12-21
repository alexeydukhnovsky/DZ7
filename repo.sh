#!/bin/bash

sudo su
yum install -y \
    redhat-lsb-core \
    wget \
    rpmdevtools \
    rpm-build \
    createrepo \
    yum-utils \
    gcc

wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.2-1.el8.ngx.src.rpm
rpm -i nginx-1.20.2-1.el8.ngx.src.rpm
yes | yum-builddep /root/rpmbuild/SPECS/nginx.spec
wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1w.tar.gz -O /root/openssl-1.1.1w.tar.gz
mkdir /root/openssl-1.1.1w
tar -xvf /root/openssl-1.1.1w.tar.gz -C /root
sed -i 's@--with-ld-opt="%{WITH_LD_OPT}" @--with-ld-opt="%{WITH_LD_OPT}" \\\n    --with-openssl=/root/openssl-1.1.1w @g' /root/rpmbuild/SPECS/nginx.spec
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm
systemctl start nginx
mkdir /usr/share/nginx/html/repo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm
createrepo /usr/share/nginx/html/repo/
rm -f /etc/nginx/conf.d/default.conf
cat >> /etc/nginx/conf.d/default.conf <<EOF
server {
listen       80;
server_name  localhost;
location / {
root   /usr/share/nginx/html;
index  index.html index.htm;
autoindex on;
}
}
EOF
nginx -s reload
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://192.168.56.150/repo
gpgcheck=0
enabled=1
EOF

