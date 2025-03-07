.PHONY: all clean install test dist dist-mac dist-linux dist-win

# 基本变量
PYTHON = python
VENV = venv
BIN_DIR = bin

GODOT?=Godot.exe

ifeq ($(OS),Windows_NT)
#	GODOT = Godot.exe
    PIP = $(VENV)\Scripts\pip
    PYINSTALLER = $(VENV)\Scripts\pyinstaller
    PYTHON_CMD = $(VENV)\Scripts\python
	SLEEP = Start-Sleep -Seconds
else
#	ifeq ($(UNAME_S),Linux)
#		GODOT = godot
#	else
#		GODOT = Godot
#	endif
    PIP = $(VENV)/bin/pip
    PYINSTALLER = $(VENV)/bin/pyinstaller
    PYTHON_CMD = $(VENV)/bin/python
	SLEEP = sleep
endif

# 检测操作系统类型
PLATFORM := $(shell uname -s)
ifeq ($(OS),Windows_NT)
    PLATFORM := Windows
    EXE_SUFFIX = .exe
    RM = powershell -Command "Remove-Item -Recurse -Force -ErrorAction Ignore"
    CD = cd
else
    ifeq ($(PLATFORM),Darwin)
        EXE_SUFFIX = -mac
    else
        EXE_SUFFIX = -linux
    endif
    RM = rm -rf
    CD = cd
endif

# 默认目标
all: dist test

# 虚拟环境
$(VENV):
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	$(PIP) install pyinstaller pytest

# 安装依赖
install: $(VENV)

build: dist

# 构建目标
dist: clean install
ifeq ($(PLATFORM),Windows)
	@echo "Building for Windows..."
	$(MAKE) dist-win
else ifeq ($(PLATFORM),Darwin)
	@echo "Building for macOS..."
	$(MAKE) dist-mac
else
	@echo "Building for Linux..."
	$(MAKE) dist-linux
endif

# 平台特定构建
dist-mac: install
	mkdir -p $(BIN_DIR)
	$(PYINSTALLER) --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript --distpath $(BIN_DIR)
	$(BIN_DIR)/protoc-gen-gdscript --help

dist-linux: install
	mkdir -p $(BIN_DIR)
	$(PYINSTALLER) --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript --distpath $(BIN_DIR)
	$(BIN_DIR)/protoc-gen-gdscript --help

dist-win: install
	mkdir -p $(BIN_DIR)
	$(PYINSTALLER) --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript.exe --distpath $(BIN_DIR)
	$(BIN_DIR)\protoc-gen-gdscript.exe --help


# 测试目标
test: install
	@echo "Running all tests..."
	@$(CD) test && $(MAKE) clean test

check:
	@echo "Running all tests..."
	${GODOT} --headless --script addons/protobuf/example/syntax_check.gd addons
	@echo "Running all tests end ......"

# 清理目标
clean:
	@echo "Cleaning test directories..."
	@$(CD) test && $(MAKE) clean || true
	$(RM) $(VENV)
	$(RM) build/
	$(RM) dist/
	$(RM) $(BIN_DIR)/
	$(RM) __pycache__/
	$(RM) *.spec
	-$(SLEEP) 3

# 帮助信息
help:
	@echo "Available targets:"
	@echo "  all        - Build and run tests (default)"
	@echo "  dist       - Build platform-specific executable"
	@echo "  dist-mac   - Build macOS executable"
	@echo "  dist-linux - Build Linux executable"
	@echo "  dist-win   - Build Windows executable"
	@echo "  test       - Run all tests"
	@echo "  clean      - Clean all generated files"
	@echo "  install    - Install dependencies"
	@echo "  help       - Show this help message"

proto: go_proto test

go_proto:
	mkdir -p test/godot_test/ackend_http/proto3
	protoc --go_out=test/godot_test/backend_http/proto3 -I test/proto3/ test/proto3/*.proto

# 检查 Python 解释器
check_python:
	@echo "Using Python: $(shell which $(PYTHON))"
	@echo "Python Version: $(shell ($(PYTHON) --version))"

serialize:	proto3_serialize proto2_serialize

proto3_serialize:
	${GODOT} --headless --script addons/protobuf/example/proto3/test/proto_serialize.gd

proto2_serialize:
	${GODOT} --headless --script addons/protobuf/example/proto2/test/test_simple_message.gd
	${GODOT} --headless --script addons/protobuf/example/proto2/test/test_complex_message.gd

http_client:
	${GODOT} --headless --script addons/protobuf/example/http_client/http_client.gd

http_test:
	${MAKE} -C test run
	make http_client