#!/bin/sh
check_user_env()
{
	grep "kunshiweb " /etc/security/limits.conf > /dev/null 2>&1
	if [ "$?" != "0" ];then
		echo "kunshiweb        soft    nofile           2048"  >> /etc/security/limits.conf
		echo "kunshiweb        hard    nofile           2048"  >> /etc/security/limits.conf
		echo "kunshiweb        -       core             unlimited "  >> /etc/security/limits.conf
	fi
	if [ -f /home/kunshiweb/.bashrc ];then
		grep 'ulimit -n 2048' /home/kunshiweb/.bashrc > /dev/null 2>&1
		[ "$?" != 0 ] && { echo 'ulimit -n 2048' >> /home/kunshiweb/.bashrc;}
		grep 'ulimit -c unlimited' /home/kunshiweb/.bashrc > /dev/null 2>&1
		[ "$?" != 0 ] && { echo 'ulimit -c unlimited' >> /home/kunshiweb/.bashrc;}
		grep 'umask 0007' /home/kunshiweb/.bashrc > /dev/null 2>&1
		[ "$?" != 0 ] && { echo 'umask 0007' >> /home/kunshiweb/.bashrc;}
		grep 'PATH=' /home/kunshiweb/.bashrc > /dev/null 2>&1
		[ "$?" != 0 ] && { echo 'PATH=/sbin:/bin:/usr/sbin:/usr/bin; export PATH' >> /home/kunshiweb/.bashrc;}
	fi
}
check_user()
{
	chage -l kunshiweb > /dev/null 2>&1
	if [ "$?" = "0" ];then
		check_user_env
		return;
	fi
	groupadd -r kunshiweb > /dev/null 2>&1
	useradd -g kunshiweb -m -d /home/kunshiweb -s /bin/bash -r -c 'kunshiweb voip' kunshiweb
	chage -m -1 -M -1 kunshiweb > /dev/null 2>&1
	chage -l kunshiweb > /dev/null 2>&1
	if [ "$?" != "0" ];then
		echo -e "\tCreate linux user failed"
		exit 1
	fi
	mkdir -p /home/kunshiweb/base
	check_user_env
}
check_user
