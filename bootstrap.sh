#!/bin/sh

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
fbuild='sh ./common/fbuild_lite.sh'

log ${c_yellow}\#\# Froebel Bootstrap${c_reset}
log run by `whoami`@`hostname` on `uname -s -m -r` at `date`

hostpkglist="mksh"

for pkg in $hostpkglist; do
    $fbuild $pkg
    #opkg is the first thing built, and the bootstrap recipe pre-installs itself.
    #so by the time we run this, it will already be installed.
    # opkg install 
done
