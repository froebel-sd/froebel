froebel linux
=======

**warning: this may not be completely up to date.
take this information with a grain of salt.**

this repository is intended to contain the package repository and build system for froebel linux.

from within froebel, it is intended that you will be able to use the "fbuild" command to build any package in the tree.
this is not yet implemented.

you can also build froebel from systems that are not running froebel. 
for this, you will need:
* a unix-like environment
* llvm/clang 5.0.0 or later (8.0.0 *highly* recommended)
* gnu make
* cmake
* fakeroot
* curl
* mksh
optionally, you will also need:
* clang-tblgen
* python
* perl
* bmake

if you do not have the optional dependencies fbuild will attempt to build them for you. this does not work perfectly.

the build system is currently messy and does not properly dependency check, so building packages manually may be fraught with difficulty.

building from scratch
=====================

currently, the correct way to bootstrap a "fresh" build is as follows.

first, edit common/fbuild_target.conf to match your target platform.

then, run:

    ./bootstrap

this will set up the froebel build system for cross-compiling to that platform, and attempt to build any optional dependencies
that you do not have.

then, run:

    ./build_bootstrap_base.sh

this will build an extremely basic chroot tarball for the target platform with little more than a set of core utilities and an llvm/clang toolchain.
after you have this, extract the chroot on your target platform, and copy the froebel source tree somewhere within it.

if you run:

    ./build_bootstrap_final.sh

this will build the remaining packages necessary for building a complete system image, and create a second tarball.
you may then either untar that on your existing chroot, or use it to create a separate chroot.

any packages that are in final but not in base are **not** guaranteed to cross compile properly and may require
being built within a froebel chroot.

design goals
============

* be different
  * froebel is not Ubuntu. froebel is not Fedora. froebel is not Arch. froebel is not Gentoo. froebel is not Slackware. froebel is not Alpine. froebel is not Void. "xyz distro does it" is not a valid reason for doing something a certain way. "nobody else does this" might be. don't use gnu. don't use systemd. try something different.
* be free
  * if a piece of software is not considered free by the FSF, it should not be in froebel. permissive licenses are preferred over copyleft.
