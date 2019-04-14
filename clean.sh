#!/bin/sh

rm -r bin doc hostpkgs packages include lib man share usr build.log .froebel_bootstrap .cmake_toolchain
cd recipes

for pkg in *; do
    cd $pkg
    rm -rf pkg src build.log
    rm -rf froebel_*.tar.gz
    cd .. 
done
