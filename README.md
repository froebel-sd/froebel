IGNORE ALL OF THIS PROBABLY
===========================

froebel linux
=======

this repository is intended to contain the entire package repository and build system for froebel linux.

from within froebel, you can go to any recipe directory and type 'fbuild' to build the package, or use the 'build_all.sh' and 'build_iso_*.sh' scripts to build a full system.

you can also build froebel from systems that are not running froebel. you will need to be running in a unix-like environment with LLVM/Clang 5.0.0 or later, a GNU-compatible Make, fakeroot, and an implementation of wget.

the bootstrap will build the following tools, and install them within the bin subdirectory of this tree:

- mksh (mirbsd korn shell)
- opkg-utils
- cmake
- some other stuff probably

you can then use the scripts at the root of the directory to build a full froebel repo, a froebel iso, etc.

the build system is currently messy and does not dependency check, so building packages manually may be fraught with difficulty.

design goals
============

* be different
  * froebel is not Ubuntu. froebel is not Fedora. froebel is not Arch. froebel is not Gentoo. froebel is not Slackware. froebel is not Alpine. froebel is not Void. "xyz distro does it" is not a valid reason for doing something a certain way. "nobody else does this" might be. don't use gnu. don't use systemd. try something different.
* be free
  * if a piece of software is not considered free by the FSF, it should not be in froebel. permissive licenses are preferred over copyleft.
