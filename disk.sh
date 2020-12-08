#!/bin/bash
#中文-UTF8
fdisk -l
echo "请输入要挂载的硬盘："
read -p "硬盘：" all
echo "请输入要挂载的目录："
read -p "目录：" ll
mkdir $ll
echo "n
p
1


w
" | fdisk $all

kk="${all}1"
mkfs.ext4 $kk
mount $kk $ll
echo "挂载成功!!!"
echo "$kk $ll ext4 defaults 0 0">>/etc/fstab
df -h
echo "检测是否有挂载!!!"

chmod 777 $ll


