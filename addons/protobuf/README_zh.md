# GDProtobuf 插件

这是一个为 Godot 4+ 实现的 Protocol Buffer 插件。该插件提供了在 GDScript 中编码和解码 Protocol Buffer 消息的工具。

## 功能特性

- 支持基本的 Protocol Buffer 数据类型
- 支持消息的编码和解码
- 支持 Wire 格式处理
- 支持嵌套消息

## 安装方法

1. 下载或克隆此仓库
2. 将 `protobuf` 文件夹复制到你的 Godot 项目的 `addons` 目录中
3. 在项目设置（Project Settings）-> 插件（Plugins）中启用此插件

## 使用方法

```gdscript
# 使用示例
const Message = preload("res://addons/protobuf/proto/Message.gd")
const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")

# 创建并编码消息
var message = Message.new()
# ... 使用 protocol buffer 工具
```

## 许可证

本插件遵循与原项目相同的许可证分发。
