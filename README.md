# protoc-gen-gdscript-simple

A Protocol Buffers compiler plugin for generating Godot Engine GDScript code.

> **Note**: This project was initially generated with [Windsurf](https://codeium.com/windsurf), an AI-powered IDE that enables rapid development through natural language interaction. All code, including the protoc plugin, test suite, and documentation, was created through natural language conversations with Windsurf.

Note: The project cannot be entirely implemented by Windsurf AI. There might be certain issues that require iteration and human intervention.

## Features

- Support for Proto2 and Proto3 syntax
- Generates clean and efficient GDScript code
- Handles all Protocol Buffers field types:
  - Basic types (int32, int64, float, string, bytes, sint, fixed32)
  - Complex types (nested messages, enums)
  - Collection types (repeated fields, map)
  - Special fields not supported (oneof, group)
- Complete serialization and deserialization support
- Full support for field rules (required, optional, repeated)
- Graceful handling of unknown fields

Note ⚠️:
    In GDScript 4+, both int and float are 16 bytes. When serializing, int32/fixed32 protobuf fields are treated as int type, which means the high 8 bytes will be truncated.
    Float fields in protobuf may have single-precision to double-precision conversion issues when deserializing. It's recommended to use double when defining protobuf fields.

## Installation

You can install and use protobuf2gdscript in the following way:

### Building Standalone Executable

If you want to build a standalone executable (without Python environment dependency), you can use the provided Makefile. Note: The executable needs to be built on the target platform, cross-platform building is not supported.

```bash
# Build on macOS
make dist-mac

# Build on Linux
make dist-linux

# Build on Windows
make dist-win

# Auto-detect current platform and build
make dist

# Run tests
make example

# Clean build files
make clean
```

After building, the executable will be located in the `dist` directory:
- macOS: `protoc-gen-gdscript`
- Linux: `protoc-gen-gdscript`
- Windows: `protoc-gen-gdscript.exe`

Each platform's executable can only run on its corresponding operating system. If you need to support multiple platforms, you'll need to build on each target platform separately.

### System Installation

For the protoc compiler to find and use this plugin, you need to place the generated executable in your system's PATH:

**Linux/macOS**:
```bash
# Copy the executable to /usr/local/bin (requires admin privileges)
# macOS
sudo cp dist/protoc-gen-gdscript-mac /usr/local/bin/protoc-gen-gdscript

# Linux
sudo cp dist/protoc-gen-gdscript-linux /usr/local/bin/protoc-gen-gdscript

# Add execute permission
sudo chmod +x /usr/local/bin/protoc-gen-gdscript
```

**Windows**:
1. Create a new directory, e.g., `C:\protoc-plugins`
2. Copy `dist/protoc-gen-gdscript.exe` to this directory
3. Add the directory to your system's PATH environment variable:
   - Right-click "This PC" -> Properties
   - Click "Advanced system settings" -> "Environment Variables"
   - Under "System variables", find PATH
   - Click "Edit" -> "New"
   - Add `C:\protoc-plugins`
   - Click "OK" to save changes

After installation, you can use the protoc command to generate GDScript code from any directory.

## Environment Variables

- `PROTOC_GEN_GDSCRIPT_PREFIX`: Set the import path prefix for generated GDScript files. Default value is `res://protobuf/`. For example:

```bash
# The default prefix is "res://protobuf/", you can override it:
PROTOC_GEN_GDSCRIPT_PREFIX="res://custom_path/" protoc --gdscript_out=. your_file.proto

# Generated code will use the specified prefix in preload statements:
const Message = preload("res://custom_path/Message.gd")
```

## Usage

After installation, you can use the plugin directly with protoc:

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

The generated GDScript code can be used in your Godot project:

```gdscript
var character = Character.new()
character.name = "Hero"
character.level = 5
character.items.append("Sword")
character.items.append("Shield")

# Serialize
var bytes = character.SerializeToBytes()

# Deserialize
var new_character = Character.new()
new_character.ParseFromBytes(bytes)
```

## About

This project showcases the power of AI-assisted development. Through natural language interaction with Windsurf IDE, we were able to:

1. Design and implement a Protocol Buffers compiler plugin
2. Handle complex features like nested messages, enums, and various field types
3. Create comprehensive test suites for both Proto2 and Proto3
4. Generate clean, efficient, and well-documented code
5. Implement robust serialization and deserialization

The entire development process, from initial code generation to testing and documentation, was guided by AI, demonstrating how modern tools can significantly accelerate software development while maintaining high quality standards.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
