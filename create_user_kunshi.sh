#!/bin/sh
check_user_env()
{
	grep "kunshi " /etc/security/limits.conf > /dev/null 2>&1
	if [ "$?" != "0" ];then
		echo "kunshi        soft    nofile           65535"  >> /etc/security/limits.conf
		echo "kunshi        hard    nofile           65535"  >> /etc/security/limits.conf
		echo "kunshi        -       core             unlimited "  >> /etc/security/limits.conf
	fi
	if [ -f /home/kunshi/.bashrc ];then
		grep 'ulimit -n 65535' /home/kunshi/.bashrc > /dev/null 2>&1
		[ "$?" != 0 ] && { echo 'ulimit -n 65535' >> /home/kunshi/.bashrc;}
		grep 'ulimit -c unlimited' /home/kunshi/.bashrc > /dev/null 2>&1
		[ "$?" != 0 ] && { echo 'ulimit -c unlimited' >> /home/kunshi/.bashrc;}
		grep 'umask 0007' /home/kunshi/.bashrc > /dev/null 2>&1
		[ "$?" != 0 ] && { echo 'umask 0007' >> /home/kunshi/.bashrc;}
		grep 'PATH=' /home/kunshi/.bashrc > /dev/null 2>&1
		[ "$?" != 0 ] && { echo 'PATH=/sbin:/bin:/usr/sbin:/usr/bin; export PATH' >> /home/kunshi/.bashrc;}
	fi
}
check_user()
{
	chage -l kunshi > /dev/null 2>&1
	if [ "$?" = "0" ];then
		check_user_env
		return;
	fi
	groupadd -r kunshi > /dev/null 2>&1
	useradd -g kunshi -m -d /home/kunshi -s /bin/bash -r -c 'Kunshi voip' kunshi
	chage -m -1 -M -1 kunshi > /dev/null 2>&1
	chage -l kunshi > /dev/null 2>&1
	if [ "$?" != "0" ];then
		echo -e "\tCreate linux user failed"
		exit 1
	fi
	mkdir -p /home/kunshi/base
	check_user_env
}

check_user
