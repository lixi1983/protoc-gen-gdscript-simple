# 检测操作系统类型
ifeq ($(OS),Windows_NT)
	GODOT = Godot.exe
    PROTOC = protoc.exe
    MKDIR = powershell -Command "New-Item -Force -ItemType Directory"
    RM = powershell -Command "Remove-Item -Recurse -Force -ErrorAction Ignore"
    FIND = dir /b /s *.proto
	SLEEP = timeout
else
	ifeq ($(UNAME_S),Linux)
		GODOT = godot
	else
		GODOT = Godot
	endif
    PROTOC = protoc
    MKDIR = mkdir -p
    RM = rm -rf
    FIND = find . -name "*.proto"
	SLEEP = sleep
endif

# 输出目录
OUT_DIR = ./generated
PROTO_GD = $(patsubst %.proto,%.proto.gd,$(wildcard *.proto))

# 默认目标
.PHONY: all
all: test

%.proto.gd: %.proto;
	-@$(MKDIR) $(OUT_DIR)
	$(PROTOC) --gdscript_out=$(OUT_DIR) -I. $<

# 测试目标
.PHONY: test
test: clean proto

# 清理目标
.PHONY: clean
clean:
	-$(RM) $(OUT_DIR)
	-$(SLEEP) 1

proto: $(PROTO_GD)

