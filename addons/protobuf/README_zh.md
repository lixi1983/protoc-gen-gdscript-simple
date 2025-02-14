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
