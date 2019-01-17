# ubase version
VERSION = 0.1

# paths
PREFIX =
MANPREFIX = $(PREFIX)/share/man

CC = clang
AR = llvm-ar
RANLIB = llvm-ranlib

CPPFLAGS += -D_FILE_OFFSET_BITS=64 -D_XOPEN_SOURCE=700 -D_GNU_SOURCE
CFLAGS   += -std=c99 -Wall -pedantic
LDFLAGS  += -s -static
LDLIBS   = -lcrypt
