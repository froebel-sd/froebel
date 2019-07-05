#!/usr/bin/env mksh

touch .froebel_bootstrap

source common/colors.sh
source common/log.sh
source common/build_host.conf

mkdir -p bin

export PATH=`pwd`/bin:$PATH

export FBUILD_BOOTSTRAP=yes
export FBUILD_REPO=`pwd`/hostpkgs
export froebelroot=`pwd`
export TARGET_ARCH=`uname -m`
fbuild="./common/fbuild_lite.sh"

log ${c_yellow}\#\# Froebel Bootstrap${c_reset}
log run by `whoami`@`hostname` on `uname -s -m -r` at `date`

hostpkglist="mksh"

for pkg in $hostpkglist; do
    "$fbuild" "$pkg"
done

log ${c_yellow} creating cmake toolchain file${c_reset}

