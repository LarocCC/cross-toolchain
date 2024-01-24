CCACHE = ccache
CC = clang
CXX = clang++
CCACHE_CC = $(strip $(CCACHE) $(CC))
CCACHE_CXX = $(strip $(CCACHE) $(CXX))
LD = lld
AR = llvm-ar
NM = llvm-nm
STRIP = llvm-strip
RANLIB = llvm-ranlib
OBJCOPY = llvm-objcopy
OBJDUMP = llvm-objdump

SYSROOT = build/sysroot
ABS_SYSROOT = $(shell realpath $(SYSROOT))

TARGET = riscv64-unknown-linux-musl

.PHONY: sysroot
sysroot: $(ABS_SYSROOT) musl-install busybox-install

$(ABS_SYSROOT):
	mkdir -p $@

include musl.mak
include builtins.mak
include busybox.mak

.PHONY: clean
clean:
	rm -rf build
