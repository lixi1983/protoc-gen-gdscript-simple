# protobuf2gdscript

A Protocol Buffers compiler plugin that generates GDScript code for the Godot Engine.

> **Note**: This project was entirely generated using [Windsurf](https://codeium.com/windsurf), an AI-powered IDE that enables rapid development through natural language interaction. All code, including the protoc plugin, test suites, and documentation, was created through natural language conversation with Windsurf.

## Features

- Supports both Proto2 and Proto3 syntax
- Generates clean and efficient GDScript code
- Handles all Protocol Buffers field types:
  - Basic types (int32, int64, float, string, bytes)
  - Complex types (nested messages, enums)
  - Collection types (repeated fields)
  - Special fields (oneof)
- Proper serialization and deserialization
- Full support for field rules (required, optional, repeated)
- Handles unknown fields gracefully
- Generates separate files for nested messages

## Installation

```bash
pip install protobuf2gdscript
```

## Usage

1. Define your Protocol Buffers messages in a `.proto` file:

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

2. Generate GDScript code:

```bash
protoc --gdscript_out=. your_file.proto
```

3. Use the generated code in your Godot project:

```gdscript
var character = Character.new()
character.name = "Hero"
character.level = 5
character.items.append("Sword")
character.items.append("Shield")

# Serialize
var bytes = character.serialize()

# Deserialize
var new_character = Character.new()
new_character.deserialize(bytes)
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
