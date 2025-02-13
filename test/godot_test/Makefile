ifeq ($(OS),Windows_NT)
	GODOT = Godot.exe
	RM = powershell -Command "Remove-Item -Recurse -Force -ErrorAction Ignore"
	RMFILE = powershell -Command "Remove-Item -Force -ErrorAction Ignore"
	LN = mklink /d
	PROTOBUF_TARGET_PATH = ..\..\addons
	PROTO2_PATH = ..\proto2\generated
	PROTO3_PATH = ..\proto3\generated
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		GODOT = godot
	else
		GODOT = Godot
	endif
	RM = rm -rf
	RMFILE = rm -f
	LN = ln -s
	PROTOBUF_TARGET_PATH = ../../addons
	PROTO2_PATH = ../proto2/generated
	PROTO3_PATH = ../proto3/generated
endif

# 获取 Godot 的绝对路径
GODOT_PATH := $(shell which $(GODOT))

link: clean
	@echo "begin link"
ifeq ($(OS),Windows_NT)
	if exist addons $(RMFILE) addons
	if exist addons $(RMFILE) proto2
	if exist addons $(RMFILE) proto3
	cmd /c mklink /d addons $(PROTOBUF_TARGET_PATH)
	cmd /c mklink /d proto2 $(PROTO2_PATH)
	cmd /c mklink /d proto3 $(PROTO3_PATH)
else
	$(RMFILE) protobuf
	$(LN) $(PROTOBUF_TARGET_PATH) addons
	$(LN) $(PROTO2_PATH) proto2 
	$(LN) $(PROTO3_PATH) proto3
endif

install:
ifneq ($(OS),Windows_NT)
	@echo "Creating symlink for godot in /usr/local/bin..."
	@if [ -n "$(GODOT_PATH)" ]; then \
		sudo $(RMFILE) /usr/local/bin/$(GODOT); \
		sudo $(LN) $(GODOT_PATH) /usr/local/bin/$(GODOT); \
		echo "Symlink created successfully."; \
	else \
		echo "Error: Cannot find godot executable."; \
		exit 1; \
	fi
else
	@echo "This command is only supported on Unix-like systems"
endif

test:

clean:
	-$(RMFILE) addons proto2 proto3

dir:
	${GODOT} --headless --script directory.gd	

check_only:
	${GODOT} --headless --script syntax_check.gd addons
#	${GODOT} --headless --script syntax_check.gd proto2
	${GODOT} --headless --script syntax_check.gd proto3

serialize:
	${GODOT} --headless --script test_logic/proto_serialize.gd

http_server:
	cd backend_http && make run

http_client:
	${GODOT} --headless --script test_logic/http_client.gd
