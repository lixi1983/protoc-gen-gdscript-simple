# protobuf2gdscript

一个用于生成 Godot 引擎 GDScript 代码的 Protocol Buffers 编译器插件。

> **注意**：本项目完全由 [Windsurf](https://codeium.com/windsurf) 生成，这是一个支持通过自然语言交互实现快速开发的 AI 驱动型 IDE。所有代码，包括 protoc 插件、测试套件和文档，都是通过与 Windsurf 的自然语言对话创建的。

说明: 工程不能完全都是由windsurf AI实现全部功能， 有可能会在某几个问题上面循环处理， 最后必须要有人工干预 

## 特性

- 支持 Proto2 和 Proto3 语法
- 生成清晰高效的 GDScript 代码
- 处理所有 Protocol Buffers 字段类型：
  - 基本类型（int32、int64、float、string、bytes, sint, fixed32）
  - 复杂类型（嵌套消息、枚举）
  - 集合类型（repeated 字段, map）
  - 不支持特殊字段（oneof, group）
- 完整的序列化和反序列化支持
- 完全支持字段规则（required、optional、repeated）
- 优雅处理未知字段

## 安装

你可以通过以下两种方式之一来安装和使用 protobuf2gdscript：

### ：构建独立可执行文件

如果你想构建一个独立的可执行文件（不依赖 Python 环境），可以使用提供的 Makefile。注意：可执行文件需要在目标平台上构建，不支持跨平台构建。

```bash
# 在 macOS 上构建
make dist-mac

# 在 Linux 上构建
make dist-linux

# 在 Windows 上构建
make dist-win

# 自动检测当前平台并构建
make dist

# 运行测试
make test

# 清理构建文件
make clean
```

构建完成后，可执行文件将位于 `dist` 目录中：
- macOS: `protoc-gen-gdscript`
- Linux: `protoc-gen-gdscript`
- Windows: `protoc-gen-gdscript.exe`

每个平台的可执行文件只能在对应的操作系统上运行。如果需要支持多个平台，需要在每个目标平台上分别进行构建。

### 安装到系统

为了让 protoc 编译器能够找到并使用这个插件，你需要将生成的可执行文件放入系统的 PATH 目录中：

**Linux/macOS**:
```bash
# 将可执行文件复制到 /usr/local/bin（需要管理员权限）
# macOS
sudo cp dist/protoc-gen-gdscript-mac /usr/local/bin/protoc-gen-gdscript

# Linux
sudo cp dist/protoc-gen-gdscript-linux /usr/local/bin/protoc-gen-gdscript

# 添加执行权限
sudo chmod +x /usr/local/bin/protoc-gen-gdscript
```

**Windows**:
1. 创建一个新目录，例如 `C:\protoc-plugins`
2. 将 `dist/protoc-gen-gdscript.exe` 复制到该目录
3. 将该目录添加到系统的 PATH 环境变量：
   - 右键点击"此电脑" -> 属性
   - 点击"高级系统设置" -> "环境变量"
   - 在"系统变量"中找到 PATH
   - 点击"编辑" -> "新建"
   - 添加 `C:\protoc-plugins`
   - 点击"确定"保存更改

安装完成后，你可以在任何目录下使用 protoc 命令来生成 GDScript 代码。

## 使用方法

安装完成后，你可以直接通过 protoc 使用这个插件：

```bash
# 从 .proto 文件生成 GDScript 代码
protoc --gdscript_out=. your_file.proto

# 生成到指定输出目录
protoc --gdscript_out=./output your_file.proto

# 从多个 .proto 文件生成
protoc --gdscript_out=. file1.proto file2.proto

# 从指定目录的 .proto 文件生成
protoc --gdscript_out=. -I=proto_dir1 -I=proto_dir2 your_file.proto
```

示例 `.proto` 文件：

```protobuf
syntax = "proto2";  // 或 "proto3"

package example;

message Character {
    required string name = 1;
    optional int32 level = 2 [default = 1];
    repeated string items = 3;
    
    message Inventory {
        optional int32 slots = 1 [default = 10];
        repeated string items = 2;
    }
    
    optional Inventory inventory = 4;
}
```

生成的 GDScript 代码可以在你的 Godot 项目中这样使用：

```gdscript
var character = Character.new()
character.name = "Hero"
character.level = 5
character.items.append("Sword")
character.items.append("Shield")

# 序列化
var bytes = character.serialize()

# 反序列化
var new_character = Character.new()
new_character.deserialize(bytes)
```

## 环境变量

- `PROTOC_GEN_GDSCRIPT_PREFIX`: 设置生成的 GDScript 文件的导入路径前缀。默认值为 `res://protobuf/`。例如：

```bash
# 默认前缀为 "res://protobuf/"，你可以通过环境变量覆盖它：
PROTOC_GEN_GDSCRIPT_PREFIX="res://custom_path/" protoc --gdscript_out=. your_file.proto

# 生成的代码将在 preload 语句中使用指定的前缀：
const Message = preload("res://custom_path/Message.gd")
```

## 关于

本项目展示了 AI 辅助开发的强大功能。通过与 Windsurf IDE 的自然语言交互，我们实现了：

1. 设计和实现 Protocol Buffers 编译器插件
2. 处理复杂特性，如嵌套消息、枚举和各种字段类型
3. 创建针对 Proto2 和 Proto3 的全面测试套件
4. 生成清晰、高效且文档完善的代码
5. 实现健壮的序列化和反序列化功能

整个开发过程，从初始代码生成到测试和文档编写，都由 AI 引导完成，展示了现代工具如何在保持高质量标准的同时显著加快软件开发速度。

## 贡献

欢迎贡献！请随时提交 Pull Request。

## 许可证

本项目采用 MIT 许可证 - 详见 LICENSE 文件。
