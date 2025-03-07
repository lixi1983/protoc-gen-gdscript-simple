# Godot Protobuf GDScript 插件

这个插件允许你在 Godot 4.x 中使用 Protocol Buffers（protobuf）。

## 功能特性

- 支持基本的 Protocol Buffer 数据类型
- 支持消息的编码和解码
- 支持嵌套消息

## 安装

1. **下载 protoc-gen-gdscript 执行程序**：
   - 访问 [protoc-gen-gdscript-simple](https://github.com/lixi1983/protoc-gen-gdscript-simple/releases) 项目的发布页面
   - 根据你的操作系统下载对应的执行程序：
     - Windows: `protoc-gen-gdscript-windows-*.zip`
     - macOS: `protoc-gen-gdscript-macos-*.zip`
     - Linux: `protoc-gen-gdscript-linux-*.zip`
   - 将执行程序放在系统的 PATH 目录中

2. **安装 Godot 插件**：
   - 从同一个发布页面下载 `godot-protobuf-gdscript-plugin-*.zip`
   - 解压到你的 Godot 项目目录中
   - 在 Godot 编辑器中启用插件

3. 下载或克隆此仓库
4. 将 `protobuf` 文件夹复制到你的 Godot 项目的 `addons` 目录中
5. 在项目设置 -> 插件中启用此插件

## 使用方法

安装完成后，你可以使用 protoc 来生成 GDScript 代码：

```bash
# 从 .proto 文件生成 GDScript 代码
protoc --gdscript_out=. your_file.proto

# 生成到指定的输出目录
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

使用生成的 GDScript 代码：

```gdscript
var character = Character.new()
character.name = "Hero"
character.level = 5
character.add_items("Sword")
character.add_items("Shield")

# 序列化
var bytes = character.SerializeToBytes()

# 反序列化
var new_character = Character.new()
new_character.ParseFromBytes(bytes)
```

### 环境变量

- `PROTOC_GEN_GDSCRIPT_PREFIX`: 设置生成的 GDScript 文件的导入路径前缀。默认值是 `res://protobuf/`。例如：

```bash
# 默认前缀是 "res://protobuf/"，你可以覆盖它：
PROTOC_GEN_GDSCRIPT_PREFIX="res://custom_path/" protoc --gdscript_out=. your_file.proto

# 生成的代码会在 preload 语句中使用指定的前缀：
const Message = preload("res://custom_path/Message.gd")
```

### 注意事项 ⚠️

在 GDScript 4+ 中：
- int 和 float 都是 16 字节
- 序列化时，int32/fixed32 protobuf 字段会被当作 int 类型处理，这意味着高 8 字节会被截断
- protobuf 中的 float 字段在反序列化时可能会有单精度到双精度的转换问题
- 建议在定义 protobuf 字段时使用 double

## 许可证

本插件遵循与原项目相同的许可证分发。
