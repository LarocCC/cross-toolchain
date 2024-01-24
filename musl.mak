MUSL_CFLAGS = --target=$(TARGET) -march=rv64gc -nostdinc -nostdlib -O2 -fuse-ld=$(LD) -L../builtins -lclang_rt.builtins-riscv64

build/musl:
	mkdir -p build/musl

.PHONY: musl-configure
musl-configure: build/musl/config.mak
build/musl/config.mak: | build/musl
	cd build/musl && ../../musl/configure \
		CC="$(CCACHE_CC)" \
		CFLAGS="$(MUSL_CFLAGS)" \
		LIBCC=" " \
		AR=$(AR) \
		RANLIB=$(RANLIB) \
		--target=$(TARGET) \
		--srcdir=../../musl \
		--prefix=/usr \
		--includedir=/usr/include \
		--syslibdir=/lib

.PHONY: musl-install-headers
musl-install-headers: musl-configure | $(ABS_SYSROOT)
	$(MAKE) -C build/musl DESTDIR="$(ABS_SYSROOT)" install-headers

.PHONY: musl-build
musl-build: bulitins-archive
	$(MAKE) -C build/musl

.PHONY: musl-install
musl-install: | $(ABS_SYSROOT)
	$(MAKE) -C build/musl DESTDIR="$(ABS_SYSROOT)" install

.PHONY: musl-clean
musl-clean:
	rm -rf build/musl
