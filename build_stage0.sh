#!/usr/bin/env mksh

source common/colors.sh
source common/log.sh
source common/build_target.conf

if [ -f .froebel_bootstrap ]; then
    export PATH=$PATH:"$(pwd)"/bin

    export FBUILD_BOOTSTRAP=no
    export FBUILD_REPO="$(pwd)"/packages
    export froebelroot="$(pwd)"
    fbuild="mksh $froebelroot/common/fbuild_lite.sh"
fi

log ${c_yellow}\#\# Froebel Build System${c_reset}
log run by `whoami`@`hostname` on `uname -s -m -r` at `date`

if [ "x$HOST_TRIPLE" = "x" ]; then
    export HOST_TRIPLE="$HOST_TRIPLE_GUESS"
    echo "Host triple has been guessed as ${HOST_TRIPLE}"
    echo "If this is not correct, please set this in build_target.conf"
fi

basepkgs="filesystem linux-headers musl netbsd-csu musl mksh busybox zlib libressl curl libffi ncurses libcxxabi-headers libcxx-headers compiler-rt libunwind libcxxabi libcxx llvm rhash clang-headers clang lld gmake pigz libcap fakeroot diffutils cmake"

for pkg in $basepkgs; do
    $fbuild "$pkg"
    if [ $? != 0 ]; then
        exit 1;
    fi
done

export tmproot="/tmp/fbuild-tmproot-`whoami`-microrootfs"
mkdir -p $tmproot

for pkg in $basepkgs; do
    for localpkg in "$FBUILD_REPO"/"$pkg"_*.pkg; do
        log "installing $localpkg to tmproot"
        #opkg -o $tmproot -V0 install $localpkg
        tar -xzf $localpkg -C $tmproot
    done
    rm -r $tmproot/META
done



log "archiving..."
PV=$(which pv)
if [ $? = 0 ]; then
    pkgsize=$(du -sk "$tmproot" | cut -f 1)
    tar -cf - -C $tmproot . | pv -p -s ${pkgsize}k | gzip -c > "froebel_stage0_$(date '+%Y%m%d')_${TARGET_ARCH}.tar.gz"
else
	tar -czf "froebel_stage0_$(date '+%Y%m%d')_${TARGET_ARCH}.tar.gz" -C $tmproot .
fi


log "removing tmproot..."
rm -rf $tmproot
log "done"
