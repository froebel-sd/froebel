#!/bin/sh

cmdline="$0 $@"

source common/colors.sh

PV=$(which pv)
if [ $? = 0 ]; then
    has_pv="yes"
else
    has_pv="no"
fi

TAR=$(which bsdtar)
if [ ! $? = 0 ]; then
    TAR=$(which tar)
fi


check_var_set() {
    var=$1
    eval res="\$$var"
    if [ "$res" = "" ]; then
        log ${c_red}"error: $var not set in recipe!"
        exit 1
    else
        log $c_blue$var: $c_reset$res
    fi
}

set_default() {
    var=$1
    eval res="\$$var"
    if [ "$res" = "" ]; then
        eval $var="$2"
    fi 
}

do_fetch() {
    mkdir -p "$srcdir"
    if [ "$src" = "none" ]; then
        filename=""
        return 0
    fi

    filename=`echo $src | sed -e s/.*\\\///`
    if [ ! -f "$srcdir"/"$filename" ]; then
        echo filename is $filename
        curl "$src" -o "$srcdir"/"$filename"
    fi
}

do_unpack() {
    if [ "$filename" = "" ]; then
        return 0
    fi
    cd "$srcdir"
    case "$filename" in
        *.tar.gz)
            $TAR -xzf "$filename"
            ;;
        *.tgz)
            $TAR -xzf "$filename"
            ;;
        *.tar.xz)
            $TAR -xJf "$filename"
            ;;
        *.tar.bz2)
            $TAR -xjf "$filename"
            ;;
        *)
            log $c_red"Error unpacking: unknown filetype for $filename"$c_reset
            ;;
    esac
}

do_test() {
    echo "no tests specified for this package"
}

do_package() {
    mkdir -p $pkgdir/META/
    echo "meta = {" > $pkgdir/META/meta
    echo "  name = \"$pkgname\"," > $pkgdir/META/meta
    echo "  version = \"$pkgver-$pkgrev\"," >> $pkgdir/META/meta
    echo "  arch = \"$TARGET_ARCH\"," >> $pkgdir/META/meta
    echo "  maintainer = \"$maintainer\"," >> $pkgdir/META/meta
    echo "  description = \"$desc\"," >> $pkgdir/META/meta
    echo "  depends = {" >> $pkgdir/META/meta
    for d in $dependencies; do
        echo "      \"$d\"," >> $pkgdir/META/meta
    done
    #echo "      depends = \"$dependencies" >> $pkgdir/META/meta
    echo "  }" >> $pkgdir/META/meta
    echo "}" >> $pkgdir/META/meta
    
    if [ "$has_pv" = "yes" ]; then
        pkgsize=$(du -sk "$pkgdir" | cut -f 1)
        $TAR -cf - -C "$pkgdir" . | pv -p -s ${pkgsize}k | gzip -c > "$FBUILD_REPO"/"$pkgname"_"$pkgver"-"$pkgrev"_"$TARGET_ARCH".pkg
    else
        log "compressing package..."
        $TAR -czf "$FBUILD_REPO"/"$pkgname"_"$pkgver"-"$pkgrev"_"$TARGET_ARCH".pkg -C "$pkgdir" .
    fi
    
    rm -r $pkgdir
    rm -r $srcdir
}

set_default FBUILD_REPO `pwd`/packages
set_default TARGET_ARCH `uname -m`

mkdir -p $FBUILD_REPO

if [ ! -d recipes/$1/ ]; then
    echo -e ${c_red}"error: no recipe for $1!"
    exit 1
fi

cd recipes/$1/

source ../../common/log.sh

srcdir=`pwd`/src
pkgdir=`pwd`/pkg

function do_build() {
    echo ${c_blue}"##empty build stage"
}

function do_test() {
    echo ${c_blue}"##empty test stage"
}

function do_install() {
    echo ${c_blue}"##empty install stage"
}

function do_bootstrap_build() {
    do_build
}

function do_bootstrap_test() {
    do_test
}

function do_bootstrap_install() {
    do_install
}

function do_bootstrap_prepackage() {
    echo ${c_blue}"##empty prepackage stage"
}

function do_prepare_tmproot() {
    export tmproot="/tmp/fbuild-tmproot-`whoami`-$pkgname"

    if [ -d $tmproot ]; then
        rm -rf $tmproot
    fi

    mkdir -p $tmproot

    for pkg in $dependencies; do
        for localpkg in "$FBUILD_REPO"/"$pkg"_*.pkg; do
            log "installing $pkg to tmproot"
            #opkg -o $tmproot -V0 install $localpkg
            $TAR -xzf $localpkg -C $tmproot
        done
    done

    export FBUILD_SYSROOT="$tmproot"
    export CFLAGS="$CFLAGS --sysroot=$tmproot -isystem$tmproot/include"
    export CXXFLAGS="$CXXFLAGS --sysroot=$tmproot -isystem$tmproot/include/c++/v1 -isystem$tmproot/include"
    export LDFLAGS="$LDFLAGS --sysroot=$tmproot -L$tmproot/lib"
}

function do_cleanup_tmproot() {
    if [ -d $tmproot ]; then
        #rm -rf $tmproot
        echo 
    fi
}

function do_fakeroot() {
    export fbuild_in_fakeroot="yes"
    cd ../..
    fakeroot mksh $cmdline
    export fbuild_in_fakeroot="no"
}

function do_step() {
    step=$1
    eval step_state="\$fbuild_$step"
    if [ "$step_state" == "done" ]; then 
        return 0;
    fi
    prev=`pwd`
    export fbuild_state=$1
    export fbuild_"$1"="inprogress"
    echo "${c_green}starting $1 step${c_reset}"
    do_$1
    export fbuild_"$1"="done"
    cd $prev
}

source ./recipe
if [ "$fbuild_in_fakeroot" == "yes" ]; then
    log $c_green"entered fakeroot"
else
    log $c_yellow"## fbuild lite: building package \"$1\" for $TARGET_ARCH\n"$c_reset
    log $c_green"checking recipe..."
    check_var_set pkgname
    check_var_set pkgver
    check_var_set pkgrev
    check_var_set src
    log $c_green"ok!\n"$c_reset
fi
target="$pkgname"_"$pkgver"-"$pkgrev"_"$TARGET_ARCH".pkg

if [ -f $FBUILD_REPO/$target ]; then
    log -e $c_green"package \"$pkgname\" is already up to date!\n\n"$c_reset
    exit 0
fi

trap "echo \"${c_red}failure while building package! exiting${c_reset}\n\"; do_cleanup_tmproot; exit" ERR

#do_fetch
do_step fetch 
do_step unpack
if [ "$FBUILD_BOOTSTRAP" == "yes" ]; then
    do_step bootstrap_build 
    do_step bootstrap_test
    mkdir -p "$pkgdir"
    do_step bootstrap_install
    do_step bootstrap_prepackage
    do_step package
    echo "${c_yellow}package ${c_blue}${pkgname}${c_yellow} built successfully!${c_reset}\n"
else
    do_step prepare_tmproot
    do_step build
    do_step test
    mkdir -p "$pkgdir"
    if [ "$fbuild_in_fakeroot" == "yes" ]; then
        do_step install
    else
        do_step fakeroot
    fi
fi

if [ "$fbuild_in_fakeroot" == "yes" ]; then
    do_step package
    do_step cleanup_tmproot
    #opkg-make-index $FBUILD_REPO > $FBUILD_REPO/Packages
    echo "${c_yellow}package ${c_blue}${pkgname}${c_yellow} built successfully!${c_reset}\n"
fi

