#!/usr/bin/env python3

import sys
import argparse
from google.protobuf.compiler import plugin_pb2
from generate_message import generate_gdscript

def print_help():
    help_text = """
protoc-gen-gdscript - Protocol Buffers GDScript Code Generator

USAGE:
    protoc --gdscript_out=<OUT_DIR> [--plugin=protoc-gen-gdscript] <PROTO_FILES>

OPTIONS:
    --gdscript_out=<OUT_DIR>   Specify the output directory for generated GDScript files
    --plugin=<PLUGIN_PATH>     Specify the plugin path (optional)

EXAMPLE:
    protoc --gdscript_out=./generated -I. message.proto

DESCRIPTION:
    This is a protoc plugin that converts Protocol Buffers definitions to GDScript code.
    The generated GDScript files will have a .proto.gd extension and include all necessary
    serialization and deserialization methods.

NOTES:
    - Generated files will have the .proto.gd extension
    - Each .proto file will generate a corresponding .proto.gd file
    - Generated classes will inherit from the protobuf/proto/Message base class
    """
    print(help_text, file=sys.stderr)
    sys.exit(0)

def main():
    """Main function"""
    # Check for --help argument
    if len(sys.argv) > 1 and sys.argv[1] in ['--help', '-h']:
        print_help()

    try:
        # Read request from standard input
        data = sys.stdin.buffer.read()
        request: plugin_pb2.CodeGeneratorRequest = plugin_pb2.CodeGeneratorRequest()
        request.ParseFromString(data)
        
        print("Starting GDScript code generator...", file=sys.stderr)

        # Generate code
        response = generate_gdscript(request)
        
        print("end GDScript code generator...", file=sys.stderr)
        
        # Write response
        sys.stdout.buffer.write(response.SerializeToString())
        return 0
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        response = plugin_pb2.CodeGeneratorResponse()
        response.error = str(e)
        sys.stdout.buffer.write(response.SerializeToString())
        return 1

if __name__ == "__main__":
    sys.exit(main())
