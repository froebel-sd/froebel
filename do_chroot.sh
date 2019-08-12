#!/bin/sh

echo mount proc
mount -t proc proc proc
echo mount sys
mount -t sysfs sys sys
echo mount dev
mount -t devtmpfs dev dev
echo copy resolv.conf
cp /etc/resolv.conf etc/resolv.conf
echo enter chroot
export HOME=/root
chroot . /bin/mksh -l

echo unmount pseudo-filesystems:
umount proc sys dev
echo exiting
