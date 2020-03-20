#!/bin/bash

##
## used by linode instance in resuce mode
## to build a minimum debian testing system
## bash build_base.sh <hostname> |& tee /tmp/build.log
##

set -eu

error_exit () { echo "Error: $1"; exit 1; }

[ "$#" -eq 2 ] || error_exit "Usage: $0 <hostname> <private_ip>"

host=$1
private_ip=$2

DEV=/dev/sda
DIST=testing
PKGS=udev,locales,ifupdown,systemd-sysv,netbase,net-tools,cron,logrotate,procps,openssh-server,ntp

ROOTFS=/mnt
MIRROR=http://fremont.mirrors.linode.com/debian
NIC_NAME=enp0s3

[ -b "$DEV" ] || error_exit "$DEV does not exist."

## keyring
echo "deb $MIRROR testing main" > /etc/apt/sources.list
apt update
apt install -y --force-yes debian-archive-keyring debootstrap


mount $DEV $ROOTFS || error_exit "Failed mount $DEV $ROOTFS."

debootstrap --variant=minbase --arch=amd64 --include=$PKGS $DIST $ROOTFS $MIRROR || error_exit 'Failed install Debian minbase.'

echo $host > $ROOTFS/etc/hostname

## locale
echo 'en_US.UTF-8 UTF-8' >> $ROOTFS/etc/locale.gen
chroot $ROOTFS locale-gen en_US.UTF-8 UTF-8
chroot $ROOTFS update-locale LANG=en_US.UTF-8

## timezone
cat /etc/timezone
# unlink $ROOTFS/etc/localtime
echo 'America/Los_Angeles' > $ROOTFS/etc/timezone
chroot $ROOTFS dpkg-reconfigure -f noninteractive tzdata

## fstab
cat <<EOF > $ROOTFS/etc/fstab
/dev/sda    /       ext4    noatime,errors=remount-ro               0 1
tmpfs       /tmp    tmpfs   rw,nodev,nosuid,noexec,noatime,size=30% 0 0
tmpfs       /run    tmpfs   rw,nodev,nosuid,noexec,noatime,size=6%  0 0
EOF

## network
cat $ROOTFS/etc/network/interfaces

gateway=$(/sbin/ip route | awk '/default/ { print $3 }')
nic=$(/sbin/ip route | awk '/default/ { print $5 }')
ip=$(/sbin/ip route | awk '!/default/ && /'$nic'/ { print $NF, $1 }' | head -n 1 | sed 's! .*/!/!')

cat <<EOF > $ROOTFS/etc/network/interfaces
auto lo
iface lo inet loopback

auto $NIC_NAME
allow-hotplug $NIC_NAME
iface $NIC_NAME inet static
    address $ip
    gateway $gateway
    up   ip addr add $private_ip/17 dev $NIC_NAME label $NIC_NAME:1
    down ip addr del $private_ip/17 dev $NIC_NAME label $NIC_NAME:1
EOF

## root password
password="$(dd if=/dev/urandom bs=16 count=1 2>/dev/null | base64)"
echo "root:$password" | chroot $ROOTFS chpasswd
echo "Root password is '$password', please change !"
echo "Please also verify NIC IP addresses"

umount $ROOTFS  || error_exit "Failed umount $ROOTFS."
