BUSYBOX_CFLAGS = --target=$(TARGET) -march=rv64gc -nostdinc -nostdlib -O2 -isystem $(ABS_SYSROOT)/usr/include -O2 -Wno-string-plus-int
BUSYBOX_LDFLAGS = --target=$(TARGET) -march=rv64gc -nostdlib --sysroot $(ABS_SYSROOT) -fuse-ld=$(LD) -Wl,-lc,$(ABS_SYSROOT)/usr/lib/crt1.o

.PHONY: busybox-config busybox/.config
busybox-config busybox/.config:
	sed "/CONFIG_PREFIX/s@=.*@=\"$(ABS_SYSROOT)/usr\"@" \
		busybox_config > busybox/.config

.PHONY: busybox-build
busybox-build: busybox/busybox
busybox/busybox: busybox/.config
	make -C busybox \
		HOSTCC="$(CCACHE_CC)" \
		HOSTCXX="$(CCACHE_CXX)" \
		HOSTCFLAGS="-Wno-string-plus-int -Wno-self-assign" \
		HOSTCXXFLAGS="-Wno-string-plus-int -Wno-self-assign" \
		AS=$(AS) \
		CC="$(CCACHE_CC)" \
		LD="$(CCACHE_CC)" \
		AR=$(AR) \
		NM=$(NM) \
		STRIP=$(STRIP) \
		OBJCOPY=$(OBJCOPY) \
		OBJDUMP=$(OBJDUMP) \
		CFLAGS="$(BUSYBOX_CFLAGS)" \
		LDFLAGS="$(BUSYBOX_LDFLAGS)"

.PHONY: busybox-install
busybox-install: busybox/.config | $(ABS_SYSROOT)
	make -C busybox \
		HOSTCC="$(CCACHE_CC)" \
		HOSTCXX="$(CCACHE_CXX)" \
		HOSTCFLAGS="-Wno-string-plus-int -Wno-self-assign" \
		HOSTCXXFLAGS="-Wno-string-plus-int -Wno-self-assign" \
		AS=$(AS) \
		CC="$(CCACHE_CC)" \
		LD="$(CCACHE_CC)" \
		AR=$(AR) \
		NM=$(NM) \
		STRIP=$(STRIP) \
		OBJCOPY=$(OBJCOPY) \
		OBJDUMP=$(OBJDUMP) \
		CFLAGS="$(BUSYBOX_CFLAGS)" \
		LDFLAGS="$(BUSYBOX_LDFLAGS)" \
		install
