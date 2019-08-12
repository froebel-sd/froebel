#!/usr/bin/env mksh

touch .froebel_bootstrap

source common/colors.sh
source common/log.sh
source common/build_host.conf

mkdir -p bin

export PATH="$PATH":"$(pwd)"/bin

export FBUILD_BOOTSTRAP=yes
export FBUILD_REPO="$(pwd)"/hostpkgs
export froebelroot="$(pwd)"
export TARGET_ARCH="$(uname -m)"
fbuild="./common/fbuild_lite.sh"

log ${c_yellow}\#\# Froebel Bootstrap${c_reset}
log run by `whoami`@`hostname` on `uname -s -m -r` at `date`

ln -s "$(which clang)" "$(pwd)"/bin/llvm-gcc
ln -s "$(which clang)" "$(pwd)"/bin/cc

hostpkglist=""

if [ "$(which mksh)" == "" ]; then
	hostpkglist+="mksh "
fi
if [ "$(which bmake)" == "" ]; then
	hostpkglist+="bmake "
fi
if [ "$(which python)" == "" ]; then
	hostpkglist+="python "
fi
if [ "$(which clang-tblgen)" == "" ]; then
	hostpkglist+="clang-tblgen "
fi
if [ "$(which perl)" == "" ]; then
	hostpkglist+="perl "
fi
if [ "$(which git)" == "" ]; then
	hostpkglist+="git "
fi
#if [ "$(which ninja)" == "" ]; then
#	hostpkglist+="ninja "
#fi

for pkg in $hostpkglist; do
	"$fbuild" "$pkg"
done

for pkg in $hostpkglist; do
    for localpkg in "$FBUILD_REPO"/"$pkg"_*.pkg; do
        log "installing $localpkg to hostbins"
        tar -xzf "$localpkg" -C "$froebelroot"
    done
    rm -r $tmproot/META
done

log ${c_yellow} creating cmake toolchain file${c_reset}

