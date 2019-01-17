# sbase version
VERSION = 0.0

# paths
PREFIX = 
MANPREFIX = $(PREFIX)/share/man

CC = clang
AR = llvm-ar
RANLIB = llvm-ranlib

# for NetBSD add -D_NETBSD_SOURCE
# -lrt might be needed on some systems
CPPFLAGS += -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=700 -D_FILE_OFFSET_BITS=64
CFLAGS   += -std=c99 -Wall -pedantic
LDFLAGS  += -s -static
