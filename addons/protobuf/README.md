# GDProtobuf Plugin

A Protocol Buffer implementation for Godot 4+. This plugin provides utilities for encoding and decoding Protocol Buffer messages in GDScript.

## Features

- Support for basic Protocol Buffer data types
- Encoding and decoding of messages
- Wire format handling
- Support for nested messages

## Installation

1. Download or clone this repository
2. Copy the `protobuf` folder to your Godot project's `addons` directory
3. Enable the plugin in Project Settings -> Plugins

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
