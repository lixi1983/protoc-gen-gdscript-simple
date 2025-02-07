# 检测操作系统类型
ifeq ($(OS),Windows_NT)
    PROTOC = protoc.exe
    MKDIR = mkdir
    RM = powershell -Command "Remove-Item -Recurse -Force -ErrorAction Ignore"
    FIND = dir /b /s *.proto
	SLEEP = Start-Sleep -Seconds
else
    PROTOC = protoc
    MKDIR = mkdir -p
    RM = rm -rf
    FIND = find . -name "*.proto"
	SLEEP = sleep
endif

# 输出目录
OUT_DIR = ./generated

# 默认目标
.PHONY: all
all: test

# 测试目标
.PHONY: test
test: clean
	$(MKDIR) $(OUT_DIR)
ifeq ($(OS),Windows_NT)
	@for /f "tokens=*" %%i in ('$(FIND)') do @( \
		$(PROTOC) --gdscript_out=$(OUT_DIR) -I. "%%i" \
	)
else
	@for proto in $$($(FIND)); do \
		$(PROTOC) --gdscript_out=$(OUT_DIR) -I. $$proto; \
	done
endif

# 清理目标
.PHONY: clean
clean:
	-@$(RM) $(OUT_DIR)
	-$(SLEEP) 1
