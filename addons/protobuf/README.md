# Godot Protobuf GDScript Plugin

This plugin allows you to use Protocol Buffers (protobuf) in Godot 4.x.

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

After installation, you can use the plugin with protoc:

```bash
# Generate GDScript code from your .proto file
protoc --gdscript_out=. your_file.proto

# Generate GDScript code to a specific output directory
protoc --gdscript_out=./output your_file.proto

# Generate from multiple .proto files
protoc --gdscript_out=. file1.proto file2.proto

# Generate from .proto files in specific directories
protoc --gdscript_out=. -I=proto_dir1 -I=proto_dir2 your_file.proto
```

Example `.proto` file:

```protobuf
syntax = "proto2";  // or "proto3"

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

Using the generated GDScript code:

```gdscript
var character = Character.new()
character.name = "Hero"
character.level = 5
character.add_items("Sword")
character.add_items("Shield")

# Serialize
var bytes = character.SerializeToBytes()

# Deserialize
var new_character = Character.new()
new_character.ParseFromBytes(bytes)
```

### Environment Variables

- `PROTOC_GEN_GDSCRIPT_PREFIX`: Set the import path prefix for generated GDScript files. Default value is `res://protobuf/`. For example:

```bash
# The default prefix is "res://protobuf/", you can override it:
PROTOC_GEN_GDSCRIPT_PREFIX="res://custom_path/" protoc --gdscript_out=. your_file.proto

# Generated code will use the specified prefix in preload statements:
const Message = preload("res://custom_path/Message.gd")
```

### Note 

In GDScript 4+:
- Both int and float are 16 bytes
- When serializing, int32/fixed32 protobuf fields are treated as int type, which means the high 8 bytes will be truncated
- Float fields in protobuf may have single-precision to double-precision conversion issues when deserializing
- It's recommended to use double when defining protobuf fields

## License

This plugin is distributed under the same license as the original project.
