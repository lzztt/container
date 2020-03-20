#!/bin/bash

##
## used by linode instance in resuce mode
## to build a minimum debian testing system
## bash build_base.sh p2.geekpush.com |& tee /tmp/build.log
##

# take first argument, or master's hostname as hostname
host="${1:-`hostname`}"
private_ip=""

DEV=/dev/sda
DIST=testing
PKGS=udev,locales,ifupdown,systemd-sysv,netbase,net-tools,cron,logrotate,procps,openssh-server,ntp


rootfs=/mnt
mirror=http://fremont.mirrors.linode.com/debian


mount $DEV $rootfs

debootstrap --variant=minbase --arch=amd64 --include=$PKGS $DIST $rootfs $mirror


echo $host > $rootfs/etc/hostname

## locale
echo 'en_US.UTF-8 UTF-8' >> $rootfs/etc/locale.gen
chroot $rootfs locale-gen en_US.UTF-8 UTF-8
chroot $rootfs update-locale LANG=en_US.UTF-8

## timezone
cat /etc/timezone
# unlink $rootfs/etc/localtime
echo 'America/Los_Angeles' > $rootfs/etc/timezone
chroot $rootfs dpkg-reconfigure -f noninteractive tzdata

## fstab
cat <<EOF > $rootfs/etc/fstab
/dev/sda    /       ext4    noatime,errors=remount-ro               0 1
tmpfs       /tmp    tmpfs   rw,nodev,nosuid,noexec,noatime,size=30% 0 0
tmpfs       /run    tmpfs   rw,nodev,nosuid,noexec,noatime,size=6%  0 0
EOF

## network
cat $rootfs/etc/network/interfaces

gateway=$(/sbin/ip route | awk '/default/ { print $3 }')
nic=$(/sbin/ip route | awk '/default/ { print $5 }')
ip=$(/sbin/ip route | awk '!/default/ && /'$nic'/ { print $NF, $1 }' | head -n 1 | sed 's! .*/!/!')

cat <<EOF > $rootfs/etc/network/interfaces
auto lo
iface lo inet loopback

auto $nic
allow-hotplug $nic
iface $nic inet static
    address $ip
    gateway $gateway
    up   ip addr add $private_ip/17 dev $nic label $nic:1
    down ip addr del $private_ip/17 dev $nic label $nic:1
EOF

## root password
password="$(dd if=/dev/urandom bs=16 count=1 2>/dev/null | base64)"
echo "root:$password" | chroot $rootfs chpasswd
echo "Root password is '$password', please change !"
echo "Please also varify NIC IP addresses"

umount $rootfs
