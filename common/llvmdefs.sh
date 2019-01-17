if [ -f bin/llvm-config ]; then
    export AR=llvm-ar
    export AS=llvm-as
    export RANLIB=llvm-ranlib
    export OBJCOPY=llvm-objcopy
fi

if [ -f bin/clang ]; then
    export CC=clang
fi

if [ -f /bin/clang++ ]; then
    export CXX=clang++
fi