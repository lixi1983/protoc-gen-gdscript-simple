.PHONY: all clean install test dist dist-mac dist-linux dist-win

# 基本变量
VENV = venv
BIN_DIR = bin
PIP = $(VENV)/bin/pip

# 检测操作系统类型
PLATFORM := $(shell uname -s)
ifeq ($(OS),Windows_NT)
    PLATFORM := Windows
    EXE_SUFFIX = .exe
    RM = -rmdir /s /q
    CD = cd
    PYTHON = python
else
    ifeq ($(PLATFORM),Darwin)
        EXE_SUFFIX = -mac
        PLATFORM := Darwin
    else
        EXE_SUFFIX = -linux
    endif
    RM = rm -rf
    CD = cd
    PYTHON = python
endif

# 默认目标
.DEFAULT_GOAL := help

# 虚拟环境
venv:
	$(PYTHON) -m venv $(VENV)
ifeq ($(OS),Windows_NT)
	.\venv\Scripts\activate.bat && python -m pip install --upgrade pip && python -m pip install -r requirements.txt
else
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
endif

# 构建可执行文件
dist: venv
ifeq ($(OS),Windows_NT)
	.\venv\Scripts\activate.bat && python -m PyInstaller --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript$(EXE_SUFFIX) --distpath $(BIN_DIR)
else
	$(VENV)/bin/pyinstaller --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript$(EXE_SUFFIX) --distpath $(BIN_DIR)
endif

# 平台特定构建
dist-mac: venv
	mkdir -p $(BIN_DIR)
	/$(VENV)/bin/pyinstaller --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript-mac --distpath $(BIN_DIR)

dist-linux: venv
	mkdir -p $(BIN_DIR)
	/$(VENV)/bin/pyinstaller --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript-linux --distpath $(BIN_DIR)

dist-win: venv
	mkdir -p $(BIN_DIR)
	.\venv\Scripts\activate.bat && python -m PyInstaller --onefile protoc-gen-gdscript.py --name protoc-gen-gdscript.exe --distpath $(BIN_DIR)

# 测试目标
test: venv
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
