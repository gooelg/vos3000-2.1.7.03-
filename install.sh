#!/bin/bash
#中文-UTF8
service iptables stop
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
yum install ntp crontabs -y
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
service ntpd stop
ntpdate cn.ntp.org.cn
free=$(free -m|awk '{print $2}'|tail -1)
if  [[ "$free" < "1024" ]];then
echo "making swap..."
dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192
mkswap /mnt/swapfile
swapon /mnt/swapfile
echo "set chkconfig"
echo "/mnt/swapfile          /swap                   swap    defaults        0 0" >> /etc/fstab
fi
uname=$(uname -a|awk '{print $3}')
if  [ "$uname" == "2.6.32-696.16.1.el6.x86_64" ] || [ "$uname" == "2.6.32-696.16.2.el6.x86_64" ] || [ "$uname" == "2.6.32-696.16.3.el6.x86_64" ];then
	yum remove -y kernel kernel-firmware
	yum install -y kernel-2.6.32-696.el6.x86_64.rpm kernel-firmware-2.6.32-696.el6.noarch.rpm
	reboot
fi 
echo -e "127.0.0.1 www.linknat.com" >> /etc/hosts
echo -e "127.0.0.1 upgrade.linknat.com" >> /etc/hosts
echo -e "service mbx3000d stop" >> /etc/rc.local
yum install -y zip
yum remove -y perl-DBI mysql mysql-* 
yum remove -y perl-DBI mysql mysql-* 
sh create_user_kunshi.sh
sh create_user_kunshiweb.sh
yum install -y perl-DBI-1.40-5.i386.rpm
rpm -ivh MySQL-server-community-5.0.96-1.rhel5.x86_64.rpm
rpm -ivh MySQL-client-community-5.0.96-1.rhel5.x86_64.rpm
\cp -rf my.cnf /etc/my.cnf
chmod 644 /etc/my.cnf
service mysql restart
tar xvf apache-tomcat-7.0.82.tar.gz
mv -f apache-tomcat-7.0.82 /home/kunshiweb/base/apache-tomcat
tar -zxvf jdk-8u151-linux-x64.tar.gz
\cp -rf ./jdk1.8.0_151/ /home/kunshi/base/jdk_default
\cp -rf ./jdk1.8.0_151/ /home/kunshiweb/base/jdk_default
rpm -ivh emp-2.1.7-03.noarch.rpm
rpm -ivh vos3000-2.1.7-03.i586.rpm
rpm -ivh vos3000-web-2.1.7-03.i586.rpm
rpm -ivh vos3000-webdata-2.1.7-03.i586.rpm
rpm -ivh vos3000-webserver-2.1.7-03.i586.rpm
rpm -ivh vos3000-webexternal-2.1.7-03.i586.rpm
tar zxvf web703.tar -C /
rpm -ivh mgc-2.1.7-03.i586.rpm
rpm -ivh mbx3000-2.1.7-03.i586.rpm
rpm -ivh servermonitor-2.1.7-03.i586.rpm
rpm -ivh callservice-2.1.7-03.i586.rpm
rpm -ivh audioplayer-2.1.7-03.i586.rpm
rpm -ivh kunshi-license-2.1.7-03.i586.rpm
chmod +x MbxWatch.sh
mv MbxWatch.sh /etc/init.d/
yum install -y crontabs ntp
echo -e "01 08 * * * /sbin/reboot" >> /var/spool/cron/root
echo -e "*/1 * * * *  /sbin/service mbx3000d reparse >/dev/null" >> /var/spool/cron/root
echo -e "*/1 * * * * /etc/init.d/MbxWatch.sh >/dev/null" >> /var/spool/cron/root
echo -e "SIP_THREAD=8" >> /home/kunshi/mbx3000/etc/softswitch.conf 
chkconfig mediarecordd on
chkconfig mediaagentd on
chkconfig ntpd on
chkconfig sendmail off
chown -R kunshiweb.kunshiweb /home/kunshiweb
chown -R kunshi.kunshi /home/kunshi
./mediarecord-*.bin
./vos3000*.bin
ip add
head -2 /home/kunshi/vos3000/etc/server.conf | tail -1
cd ..
rm -rf *
echo "done"
cd /root
echo > ./.bash_history
echo > .bash_history
echo >  /root/.bash_history
history -c


