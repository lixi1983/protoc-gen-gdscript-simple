# GDProtobuf Plugin

A Protocol Buffer implementation for Godot 4+. This plugin provides utilities for encoding and decoding Protocol Buffer messages in GDScript.

## Features

- Support for basic Protocol Buffer data types
- Encoding and decoding of messages
- Support for nested messages

## Installation

1. **Download protoc-gen-gdscript executable**:
   - Visit the [protoc-gen-gdscript-simple](https://github.com/lixi1983/protoc-gen-gdscript-simple/releases) project's Releases page
   - Download the executable corresponding to your operating system:
     - Windows: `protoc-gen-gdscript-windows-*.zip`
     - macOS: `protoc-gen-gdscript-macos-*.zip`
     - Linux: `protoc-gen-gdscript-linux-*.zip`
   - Place the executable in your system's PATH directory

2. **Install Godot plugin**:
   - Download `godot-protobuf-gdscript-plugin-*.zip` from the same Releases page
   - Unzip to your Godot project directory
   - Enable the plugin in Godot editor

3. Download or clone this repository
4. Copy the `protobuf` folder to your Godot project's `addons` directory
5. Enable the plugin in Project Settings -> Plugins

## Usage

```gdscript
# Example usage
const Message = preload("res://addons/protobuf/proto/Message.gd")
const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")

# Create and encode messages
var message = Message.new()
# ... use the protocol buffer utilities

```

## License

This plugin is distributed under the same license as the original project.
