# 检测操作系统类型
ifeq ($(OS),Windows_NT)
    CD = cd
    MAKE = make
else
    CD = cd
    MAKE = make
endif

# 子目录
SUBDIRS = proto2 proto3
clean_dirs=$(addprefix _clean_,$(SUBDIRS))

# 默认目标
.PHONY: all
all: test

# 测试目标
.PHONY: test
test: $(SUBDIRS)

# 子目录目标
.PHONY: $(SUBDIRS)
$(SUBDIRS):
	@echo "Testing in $@ directory..."
	$(MAKE) -C $@ test

$(clean_dirs):
	@echo "Cleaning in $@ directory..."
	$(MAKE) -C $(patsubst _clean_%, %, $@) clean

# 清理目标
.PHONY: clean
clean: $(clean_dirs)
