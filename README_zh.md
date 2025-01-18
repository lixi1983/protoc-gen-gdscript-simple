# protobuf2gdscript

一个用于生成 Godot 引擎 GDScript 代码的 Protocol Buffers 编译器插件。

## 特性

- 支持 Proto2 和 Proto3 语法
- 生成清晰高效的 GDScript 代码
- 处理所有 Protocol Buffers 字段类型：
  - 基本类型（int32、int64、float、string、bytes）
  - 复杂类型（嵌套消息、枚举）
  - 集合类型（repeated 字段）
  - 特殊字段（oneof）
- 完整的序列化和反序列化支持
- 完全支持字段规则（required、optional、repeated）
- 优雅处理未知字段
- 为嵌套消息生成独立文件

## 安装

```bash
pip install protobuf2gdscript
```

## 使用方法

1. 在 `.proto` 文件中定义你的 Protocol Buffers 消息：

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

2. 生成 GDScript 代码：

```bash
protoc --gdscript_out=. your_file.proto
```

3. 在你的 Godot 项目中使用生成的代码：

```gdscript
var character = Character.new()
character.name = "英雄"
character.level = 5
character.items.append("剑")
character.items.append("盾")

# 序列化
var bytes = character.serialize()

# 反序列化
var new_character = Character.new()
new_character.deserialize(bytes)
```

## 贡献

欢迎贡献！请随时提交 Pull Request。

## 许可证

本项目采用 MIT 许可证 - 详见 LICENSE 文件。
