# 检测操作系统类型
ifeq ($(OS),Windows_NT)
    CD = cd
    MAKE = make
    SLEEP = timeout 
else
    CD = cd
    MAKE = make
    SLEEP = sleep
endif

# 子目录
SUBDIRS = proto2 proto3 #godot_test
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
	-@$(SLEEP) 1
	@echo "=============== Testing in $@ directory... ==============="
	$(MAKE) -C $@ test

$(clean_dirs):
	@echo "================ Cleaning in $@ directory.. ===============:"
	$(MAKE) -C $(patsubst _clean_%, %, $@) clean

# 清理目标
.PHONY: clean
clean: $(clean_dirs)
