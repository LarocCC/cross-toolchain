# ls llvm-project/compiler-rt/lib/builtins | grep -E "tf|sc|dc|tc"
BUILTINS_FILES += builtins/addtf3.c
BUILTINS_FILES += builtins/comparetf2.c
BUILTINS_FILES += builtins/divdc3.c
BUILTINS_FILES += builtins/divsc3.c
BUILTINS_FILES += builtins/divtc3.c
BUILTINS_FILES += builtins/divtf3.c
BUILTINS_FILES += builtins/extenddftf2.c
BUILTINS_FILES += builtins/extendhftf2.c
BUILTINS_FILES += builtins/extendsftf2.c
BUILTINS_FILES += builtins/extendxftf2.c
BUILTINS_FILES += builtins/fixtfdi.c
BUILTINS_FILES += builtins/fixtfsi.c
BUILTINS_FILES += builtins/fixtfti.c
BUILTINS_FILES += builtins/fixunstfdi.c
BUILTINS_FILES += builtins/fixunstfsi.c
BUILTINS_FILES += builtins/fixunstfti.c
BUILTINS_FILES += builtins/floatditf.c
BUILTINS_FILES += builtins/floatsitf.c
BUILTINS_FILES += builtins/floattitf.c
BUILTINS_FILES += builtins/floatunditf.c
BUILTINS_FILES += builtins/floatunsitf.c
BUILTINS_FILES += builtins/floatuntitf.c
BUILTINS_FILES += builtins/muldc3.c
BUILTINS_FILES += builtins/mulsc3.c
BUILTINS_FILES += builtins/multc3.c
BUILTINS_FILES += builtins/multf3.c
BUILTINS_FILES += builtins/powitf2.c
BUILTINS_FILES += builtins/subtf3.c
BUILTINS_FILES += builtins/trunctfdf2.c
BUILTINS_FILES += builtins/trunctfhf2.c
BUILTINS_FILES += builtins/trunctfsf2.c
BUILTINS_FILES += builtins/trunctfxf2.c
BUILTINS_FILES += builtins/fp_add_impl.inc
BUILTINS_FILES += builtins/fp_compare_impl.inc
BUILTINS_FILES += builtins/fp_div_impl.inc
BUILTINS_FILES += builtins/fp_extend.h
BUILTINS_FILES += builtins/fp_extend_impl.inc
BUILTINS_FILES += builtins/fp_fixint_impl.inc
BUILTINS_FILES += builtins/fp_fixuint_impl.inc
BUILTINS_FILES += builtins/fp_lib.h
BUILTINS_FILES += builtins/fp_mode.h
BUILTINS_FILES += builtins/fp_mul_impl.inc
BUILTINS_FILES += builtins/fp_trunc.h
BUILTINS_FILES += builtins/fp_trunc_impl.inc
BUILTINS_FILES += builtins/int_endianness.h
BUILTINS_FILES += builtins/int_lib.h
BUILTINS_FILES += builtins/int_math.h
BUILTINS_FILES += builtins/int_to_fp.h
BUILTINS_FILES += builtins/int_to_fp_impl.inc
BUILTINS_FILES += builtins/int_types.h
BUILTINS_FILES += builtins/int_util.h
BUILTINS_FILES += builtins/riscv/fp_mode.c

BUILTINS_SRCS = $(filter %.c,$(BUILTINS_FILES))
BUILTINS_OBJS = $(BUILTINS_SRCS:builtins/%.c=build/builtins/lib/%.o)

BUILTINS_FILE_DIRS = $(sort $(dir $(BUILTINS_FILES)))
BUILTINS_OBJ_DIRS = $(sort $(dir $(BUILTINS_OBJS)))

BUILTINS_CFLAGS = --target=$(TARGET) -march=rv64gc --sysroot $(ABS_SYSROOT) -nostdinc -isystem $(ABS_SYSROOT)/usr/include -O2

$(BUILTINS_FILE_DIRS) $(BUILTINS_OBJ_DIRS):
	mkdir -p $@

.PHONY: builtins-files
builtins-files: $(BUILTINS_FILES)
$(BUILTINS_FILES): | $(BUILTINS_FILE_DIRS)
	curl $(CURL_FLAGS) -fsSL https://github.com/llvm/llvm-project/raw/main/compiler-rt/lib/$@ -o $@

.PHONY: builtins-objs
builtins-objs: $(BUILTINS_OBJS)
$(BUILTINS_OBJS): build/builtins/lib/%.o: builtins/%.c | $(BUILTINS_OBJ_DIRS)
	$(CCACHE_CC) $(BUILTINS_CFLAGS) $< -c -o $@

.PHONY: builtins-archive
builtins-archive: build/builtins/libclang_rt.builtins-riscv64.a
build/builtins/libclang_rt.builtins-riscv64.a: $(BUILTINS_OBJS)
	rm -f $@
	$(AR) rc $@ $^
	$(RANLIB) $@
