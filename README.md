IGNORE ALL OF THIS PROBABLY
===========================

froebel linux
=======

this repository is intended to contain the entire package repository and build system for froebel linux.

from within froebel, you can go to any recipe directory and type 'fbuild' to build the package, or use the 'build_all.sh' and 'build_iso_*.sh' scripts to build a full system.

you can also build froebel from systems that are not running froebel. you will need to be running in a unix-like environment with LLVM/Clang 5.0.0 or later, a GNU-compatible Make, Cmake, fakeroot, and an implementation of wget.
also probably some other stuff.

the build system is currently messy and does not dependency check, so building packages manually may be fraught with difficulty.


building from scratch
=====================

currently, the correct way to bootstrap a "fresh" build is as follows.

first, edit common/fbuild_target.conf to match your target platform.

then, run:

    ./bootstrap

this will set up the froebel build system for cross-compiling to that platform, and build the shell used for the rest of the scripts.

once you have that, run:

    ./build_bootstrap_base.sh

this will build an extremely basic chroot tarball for the target platform with little more than a set of core utilities and an llvm/clang toolchain.
after you have this, extract the chroot on your target platform, and copy the froebel source tree somewhere within it.

then run:

    ./build_bootstrap_final.sh

this will build the remaining packages necessary for building a complete system image, and create a second tarball.
you may then either untar that on your existing chroot, or use it to create a separate chroot.

then, inside the resulting environment, you can run any of the other build*.sh scripts to build a rootfs or bootiso image.

design goals
============

* be different
  * froebel is not Ubuntu. froebel is not Fedora. froebel is not Arch. froebel is not Gentoo. froebel is not Slackware. froebel is not Alpine. froebel is not Void. "xyz distro does it" is not a valid reason for doing something a certain way. "nobody else does this" might be. don't use gnu. don't use systemd. try something different.
* be free
  * if a piece of software is not considered free by the FSF, it should not be in froebel. permissive licenses are preferred over copyleft.
