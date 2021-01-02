#!/bin/sh

if [ -f chroot ]; then
    echo Error: chroot folder already exists. Please remove it and try again
    exit 1
fi

mkdir -p chroot

PV=$(which pv)
if [ $? = 0 ]; then
    pv froebel_stage0*.tar.gz | tar -xz -C chroot/
else
    echo extracting...
    tar -xzf froebel_stage0*.tar.gz -C chroot/
fi
cd chroot
echo mount proc
sudo mount -t proc proc proc
echo mount sys
sudo mount -t sysfs sys sys
echo mount dev
sudo mount -t devtmpfs dev dev
echo copy resolv.conf
sudo cp /etc/resolv.conf etc/resolv.conf
echo enter chroot
sudo chroot . /bin/mksh -l

echo unmount pseudo-filesystems:
sudo umount proc sys dev
if [ "x$NO_RM_CHROOT" = "x" ]; then
    echo remove chroot
    cd ..
    rm -rf chroot
fi
echo exiting
