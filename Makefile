.PHONY: all clean install test dist dist-mac dist-linux dist-win

# 基本变量
PYTHON = python3
VENV = venv
BIN_DIR = bin

ifeq ($(OS),Windows_NT)
    PIP = $(VENV)\Scripts\pip
    PYINSTALLER = $(VENV)\Scripts\pyinstaller
    PYTHON_CMD = $(VENV)\Scripts\python
else
    PIP = $(VENV)/bin/pip
    PYINSTALLER = $(VENV)/bin/pyinstaller
    PYTHON_CMD = $(VENV)/bin/python
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

dist-linux: install
	mkdir -p $(BIN_DIR)
	$(PYINSTALLER) --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript --distpath $(BIN_DIR)

dist-win: install
	mkdir -p $(BIN_DIR)
	$(PYINSTALLER) --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript.exe --distpath $(BIN_DIR)

# 测试目标
test: install
	@echo "Running all tests..."
	@$(CD) test && $(MAKE) clean test

check:
	@$(CD) test/godot_test && $(MAKE) link check_only

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
	sleep 3

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

proto: py_proto go_proto test

py_proto:
	cd test/proto3; make python_out

go_proto:
	mkdir -p test/godot_test/ackend_http/proto3
	protoc --go_out=test/godot_test/backend_http/proto3 -I test/proto3/ test/proto3/*.proto
