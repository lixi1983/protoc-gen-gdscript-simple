from enum import EnumMeta
from operator import index
from pprint import isreadable
from typing import List, Optional

from google.protobuf.descriptor import FieldDescriptor as FieldDescriptorProto, EnumDescriptor, FieldDescriptor
from google.protobuf.compiler import plugin_pb2
from google.protobuf.descriptor import Descriptor as MessageType
import sys
import os

from google.protobuf.internal.well_known_types import Any


def get_field_new(field):
    """Get code to create a new instance of a field."""
    if field.label == FieldDescriptorProto.LABEL_REPEATED:
        return "[]"

    if field.type == FieldDescriptorProto.TYPE_MESSAGE:
        if field.type_name.startswith("."):
            type_name = field.type_name[1:]  # Remove leading dot
        else:
            type_name = field.type_name
            
        # Handle nested types
        parts = type_name.split(".")
        if len(parts) > 1:
            # If it's a nested type, use the new_instance method
            parent_class = parts[-2]
            nested_class = parts[-1]
            return f"{nested_class}.new()"
        else:
            return f"{type_name}.new()"
    else:
        return get_default_value(field)

def get_field_type(field):
    """Get the field type for GDScript."""
    isRepeated = field.label == FieldDescriptorProto.LABEL_REPEATED
    out = lambda t: f"Array[{t}]" if isRepeated else t

    # Handle map fields
    if field.type == FieldDescriptorProto.TYPE_MESSAGE and field.type_name:
        type_name = field.type_name
        if type_name.startswith("."):
            type_name = type_name[1:]
        parts = type_name.split(".")
        if len(parts) > 1 and parts[-1].endswith("Entry"):
            # This is likely a map field
            return "Dictionary"  # Default map types

    if field.type == FieldDescriptorProto.TYPE_MESSAGE:
        msg_type = field.type_name
        if msg_type.startswith("."):
            msg_type = msg_type[1:]  # Remove leading dot
        return out(f"{msg_type.split('.')[-1]}")
    elif field.type == FieldDescriptorProto.TYPE_STRING:
        return out("String")
    elif field.type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64]:
        return out("int")
    elif field.type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return out("float")
    elif field.type == FieldDescriptorProto.TYPE_BOOL:
        return out("bool")
    elif field.type == FieldDescriptorProto.TYPE_BYTES:
        return out("PackedByteArray")
    elif field.type == FieldDescriptorProto.TYPE_ENUM:
        return out(f"{field.type_name.split('.')[-1]}")
    else:
        return out("int")

def get_field_coder(field):
    """Get the encoder name for a field."""
    if field.type == FieldDescriptorProto.TYPE_STRING:
        return "string"
    elif field.type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64,
                       FieldDescriptorProto.TYPE_ENUM]:
        return "varint"
    elif field.type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return "float"
    elif field.type == FieldDescriptorProto.TYPE_BOOL:
        return "bool"
    elif field.type == FieldDescriptorProto.TYPE_BYTES:
        return "bytes"
    elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
        return "message"
    else:
        return "varint"

def get_serializer_method(field_type):
    if field_type == FieldDescriptorProto.TYPE_STRING:
        return "string"
    elif field_type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64,
                       FieldDescriptorProto.TYPE_ENUM]:
        return "varint"
    elif field_type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return "float"
    elif field_type == FieldDescriptorProto.TYPE_BOOL:
        return "bool"
    elif field_type == FieldDescriptorProto.TYPE_BYTES:
        return "bytes"
    elif field_type == FieldDescriptorProto.TYPE_MAP:
        return "map"
    else:
        return "varint"

def get_decoder_method(field_type):
    if field_type == FieldDescriptorProto.TYPE_STRING:
        return "string"
    elif field_type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64,
                       FieldDescriptorProto.TYPE_ENUM]:
        return "varint"
    elif field_type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return "float"
    elif field_type == FieldDescriptorProto.TYPE_BOOL:
        return "bool"
    elif field_type == FieldDescriptorProto.TYPE_BYTES:
        return "bytes"
    elif field_type == FieldDescriptorProto.TYPE_MAP:
        return "map"
    else:
        return "varint"

def get_class_name(name, package_name=None):
    """Get the class name with proper package prefix."""
    if package_name:
        return f"{package_name}_{name}".replace(".", "_")
    return name.replace(".", "_")

def get_file_name(name, package_name=None):
    """Get the file name with proper package prefix."""
    class_name = get_class_name(name, package_name)
    return f"{class_name}.gd"

def get_message_type(message_type, package_name=None):
    """Get the message type name with package prefix."""
    if package_name:
        return f"{package_name}_{message_type.name}"
    return f"{message_type.name}"

def get_gdscript_class_name(message_type):
    """Get the GDScript class name for a message type."""
    return message_type.name

def get_protobuf_base_path():
    """Get the base path for protobuf files from environment variable."""
    return os.getenv("GD_PROTOBUF_PATH", "res://protobuf")


def generate_gdscript(request: plugin_pb2.CodeGeneratorRequest) -> plugin_pb2.CodeGeneratorResponse:
    """Generate GDScript code from the request."""
    response = plugin_pb2.CodeGeneratorResponse()

    for proto_file in request.proto_file:
        if proto_file.name not in request.file_to_generate:
            continue
            
        # Get the package name and create one file per proto file
        package_name = proto_file.package
        proto_file_name = os.path.splitext(os.path.basename(proto_file.name))[0]
        file_name = f"{proto_file_name}.gd"
        file = response.file.add()
        file.name = file_name
        
        # Initialize an empty content
        file.content = ""
        
        # Add imports - write line by line
        file.content += f'const GDScriptUtils = preload("{get_protobuf_base_path()}/proto/GDScriptUtils.gd")\n'
        file.content += f'const Message = preload("{get_protobuf_base_path()}/proto/Message.gd")\n\n'

        for enum_type in proto_file.enum_type:
            file.content += generate_enum_type(enum_type, "", 0)

        # Generate code for each message type
        for message_type in proto_file.message_type:
            # Skip if message type is empty
            if not message_type.name:
                continue
                
            # Generate message class line by line
            file.content += generate_message_class(message_type)
            # Add separator between message types
            file.content += "# =========================================\n\n"
            
    return response


def generate_message_class(message_type: MessageType, parent_name: Optional[str] = None,
                           indent_level: int = 0) -> str:
    """Generate a message class."""
    content = ""
    indent = "\t" * indent_level

    content += f"{indent}class {message_type.name} extends Message:\n"

    # Generate enums first
    for enum_type in message_type.enum_type:
        content += generate_enum_type(enum_type, message_type.name, indent_level + 1)

    content += generate_fields(message_type, message_type.field, indent_level + 1)

    # Generate nested types
    for nested_type in message_type.nested_type:
        if nested_type.options.map_entry:
            # This is a map field
            continue
#        if nested_type.name:
#            type_name = nested_type.type_name
#            if type_name.startswith("."):
#                type_name = type_name[1:]
#            parts = type_name.split(".")
#            if len(parts) > 1 and parts[-1].endswith("Entry"):
#                # This is a map field
#                continue

        content += generate_message_class(nested_type, message_type.name, indent_level + 1)

    # Generate serialization methods
    content += generate_serialization_methods(message_type, indent + "\t")
#    lines.extend(line for line in serialization_lines if line)

    return content


def get_message_type_key(message_type):
    """获取消息类型的唯一键"""
    if hasattr(message_type, 'full_name'):
        return message_type.full_name
    return message_type.name

def get_map_fields(message_type):
    """获取消息类型的 map 字段信息"""
    key = get_message_type_key(message_type)
    return _map_fields_cache.get(key, {})    

_map_fields_cache = {}

key_field_name = 'key_field'
value_field_name = 'value_field'
def get_field_map_info(message_type, field_number):
    """获取消息类型中指定字段编号的 map 字段信息
    
    Args:
        message_type: 消息类型
        field_number: 字段编号

    Returns:
        dict: 包含 field_name, key_field, value_field 的字典，如果不是 map 字段则返回 None
    """
    maps = get_map_fields(message_type)
    return maps.get(field_number)

def is_map_field(message_type, field_number):
    """判断字段是否是 map 类型"""
    return get_field_map_info(message_type, field_number) is not None

def generate_fields(
        message_type: MessageType,
        fields, ## : Any, # List[FieldDescriptor],
        indent_level: int = 0
):
    """Generate field declarations for a message type."""
    content = ""
    indent = "\t" * indent_level
    
    # 创建当前消息类型的 map 字段信息
    message_maps = {}

    for field in fields:
        field_name = field.name
        if field.type == FieldDescriptorProto.TYPE_MESSAGE and field.type_name:
            type_name = field.type_name
            if type_name.startswith("."):
                type_name = type_name[1:]
            parts = type_name.split(".")
            if len(parts) > 1 and parts[-1].endswith("Entry"):
                # 这是一个 map 字段，获取 key 和 value 的类型
                # 在 proto3 中，map 字段会被转换为一个包含 key 和 value 字段的消息类型
                # 我们需要在消息类型的嵌套类型中找到它
                map_type = None
                for nested_type in message_type.nested_type:
                    if nested_type.name == parts[-1]:
                        map_type = nested_type
                        break
                
                if map_type and len(map_type.field) >= 2:
                    key_field = map_type.field[0]   # key 是第一个字段
                    value_field = map_type.field[1] # value 是第二个字段
                    
                    # 存储 map 字段信息到当前消息的缓存中
                    message_maps[field.number] = {
                        'field_name': field_name,
                        'key_field': key_field,
                        'value_field': value_field
                    }
                
                # 生成字典字段声明
                content += f"{indent}var {field_name}: Dictionary = {{}}\n"
                continue

        default_value = get_default_value(field)

        if field.label == FieldDescriptorProto.LABEL_REPEATED:
#            content += f"{indent}var {field_name}: Array[{get_field_type(field)}] = []\n"
            content += f"{indent}var {field_name} = {default_value}\n"
        else:
            content += f"{indent}var {field_name}: {get_field_type(field)} = {default_value}\n"

    if len(content) > 0:
        content += "\n"

    # 将当前消息类型的 map 字段信息存储到全局缓存中
    if message_maps:
        _map_fields_cache[get_message_type_key(message_type)] = message_maps

    return content

def generate_enum_type(enum_type: EnumDescriptor, parent_name: Optional[str] = None, indent_level: int = 0) -> str:
    """Generate an enum class."""
    content = ""
    indent = "\t" * indent_level

    content += f"{indent}enum {enum_type.name} {{\n"

    # Generate enum values as class constants
    for value in enum_type.value:
        content += f"{indent}\t{value.name} = {value.number},\n"

    content += f"{indent}}} \n \n"  # Add empty line at end
    return content

def get_default_value(field):
    """Get the default value for a field."""
    if field.label == FieldDescriptorProto.LABEL_REPEATED:
        return '[]'
    elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
        return get_field_new(field)
    
    # Check if field has a default value set
    if hasattr(field, 'default_value') and field.default_value:
        if field.type == FieldDescriptorProto.TYPE_STRING:
            return f'"{field.default_value}"'
        elif field.type == FieldDescriptorProto.TYPE_BYTES:
            return f'PackedByteArray("{field.default_value}".to_utf8_buffer())'
        elif field.type == FieldDescriptorProto.TYPE_BOOL:
            return str(field.default_value).lower()
        elif field.type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
            return str(field.default_value)
        elif field.type == FieldDescriptorProto.TYPE_ENUM:
            return field.default_value
        elif field.type in [FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                         FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64]:
            # GDScript的整数是64位有符号整数，范围是-2^63到2^63-1
            max_value = 9223372036854775807  # 2^63-1
            try:
                value = int(field.default_value)
                return str(min(value, max_value))
            except (ValueError, TypeError):
                return '0'
        else:
            return str(field.default_value)
    
    # Return type-specific default values if no default value is set
    if field.type == FieldDescriptorProto.TYPE_ENUM:
        return "0"  # Use 0 as default for now
    elif field.type == FieldDescriptorProto.TYPE_BOOL:
        return "false"
    elif field.type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64]:
        return "0"
    elif field.type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return "0.0"
    elif field.type == FieldDescriptorProto.TYPE_STRING:
        return '""'
    elif field.type == FieldDescriptorProto.TYPE_BYTES:
        return "PackedByteArray()"
    else:
        return "null"

def generate_new_methods(message_type, indent):
    """Generate new instance methods for a message type."""
    content = ""

    # Generate New method
    content += f"{indent}func New() -> Message:\n"
    content += f"{indent}\treturn {message_type.name}.new()\n"
    content += " \n"

    return content

def generate_clone_methods(message_type, indent):
    """Generate clone methods for a message type."""
    content = ""

    # Generate Clone method
    content += f"{indent}func Clone() -> {message_type.name}:\n"
    content += f"{indent}\tvar clone = New()\n"
    content += f"{indent}\tclone.MergeFrom(self)\n"
    content += f"{indent}\treturn clone\n"
    content += " \n"

    return content

def generate_merge_methods(message_type, indent):
    """Generate merge methods for a message type."""
    content = ""

    # Generate MergeFrom method
    content += f"{indent}func MergeFrom(other : Message) -> void:\n"
    if len(message_type.field) <= 0:
        content += f"{indent}\tpass"
    else:
        content += f"{indent}\tif other is {message_type.name}:\n"
    # Serialize fields
        for field in message_type.field:
            field_name = field.name
            if is_map_field(message_type, field.number):
                content += f"{indent}\t\t{field_name}.merge(other.{field_name})\n"
            elif field.label == FieldDescriptorProto.LABEL_REPEATED:
                content += f"{indent}\t\t{field_name}.append_array(other.{field_name}.duplicate(true))\n"
            elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t{field_name}.MergeFrom(other.{field_name})\n"
            elif field.type == FieldDescriptorProto.TYPE_ENUM:
                content += f"{indent}\t\t{field_name} = other.{field_name}\n"
            elif field.type == FieldDescriptorProto.TYPE_BYTES:
                content += f"{indent}\t\t{field_name}.append_array(other.{field_name})\n"
            else :
                content += f"{indent}\t\t{field_name} += other.{field_name}\n"

    content += " \n"

    return content


def generate_parse_from_string_methods(message_type, indent):
    content =""
    # Generate ParseFromString method
    content += f"{indent}func ParseFromString(data: PackedByteArray) -> int:\n"

    if len(message_type.field) <= 0:
        content += f"{indent}\treturn 0\n"
        return content

    content += f"{indent}\tvar size = data.size()\n"
    content += f"{indent}\tvar pos = 0\n"
    content += " \n"

    content += f"{indent}\twhile pos < size:\n"
    content += f"{indent}\t\tvar tag = GDScriptUtils.decode_tag(data, pos)\n"
    content += f"{indent}\t\tvar field_number = tag[GDScriptUtils.VALUE_KEY]\n"
    content += f"{indent}\t\tpos += tag[GDScriptUtils.SIZE_KEY]\n"
    content += f"{indent}\t\tmatch field_number:\n"

    # Parse fields
    for field in message_type.field:
        field_name = field.name
        field_type = field.type
        field_number = field.number
        field_label = field.label

        content += f"{indent}\t\t\t{field_number}:\n"
        if field_label == FieldDescriptorProto.LABEL_REPEATED:
            map_info = get_field_map_info(message_type, field_number)
            if map_info is None:
                content += f"{indent}\t\t\t\tvar value = GDScriptUtils.decode_{get_field_coder(field)}(data, pos)\n"
                content += f"{indent}\t\t\t\t{field_name}.append_array([value[GDScriptUtils.VALUE_KEY]])\n"
                content += f"{indent}\t\t\t\tpos += value[GDScriptUtils.SIZE_KEY]\n"
            else:
                content += f"{indent}\t\t\t\tvar key_value = GDScriptUtils.decode_{get_field_coder(map_info.get(key_field_name))}(data, pos)\n"
                content += f"{indent}\t\t\t\tpos += key_value[GDScriptUtils.SIZE_KEY]\n"
                content += f"{indent}\t\t\t\tvar value_value = GDScriptUtils.decode_{get_field_coder(map_info.get(value_field_name))}(data, pos)\n"
                content += f"{indent}\t\t\t\t{field_name}[key_value[GDScriptUtils.VALUE_KEY]] = value_value[GDScriptUtils.VALUE_KEY]\n"
                content += f"{indent}\t\t\t\tpos += value_value[GDScriptUtils.SIZE_KEY]\n"
        else:
            content += f"{indent}\t\t\t\tvar value = GDScriptUtils.decode_{get_field_coder(field)}(data, pos)\n"
            content += f"{indent}\t\t\t\t{field_name} = value[GDScriptUtils.VALUE_KEY]\n"
            content += f"{indent}\t\t\t\tpos += value[GDScriptUtils.SIZE_KEY]\n"

    content += f"{indent}\t\t\t_:\n"
    content += f"{indent}\t\t\t\tpass\n\n"
    content += f"{indent}\treturn pos\n\n"
#    content += " \n"

    return content

def generate_serialize_to_string_methods(message_type, indent):
    """Generate serialize methods for a message type."""
    content = ""
    content += f"{indent}func SerializeToString(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:\n"
#    content += f"{indent}\tvar buffer = PackedByteArray()\n \n"

    for field in message_type.field:
        field_name = field.name
        field_number = field.number

        # Check if this is a map field
        map_field = get_field_map_info(message_type, field_number)
        if map_field:
            content += f"{indent}\tfor key in {field_name}:\n"
            content += f"{indent}\t\tGDScriptUtils.encode_varint(buffer, {field_number})\n"
            content += f"{indent}\t\tGDScriptUtils.encode_{get_field_coder(map_field.get('key_field'))}(buffer, key)\n"
            content += f"{indent}\t\tGDScriptUtils.encode_{get_field_coder(map_field.get('value_field'))}(buffer, {field_name}[key])\n"
        elif field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tfor item in {field_name}:\n"
            content += f"{indent}\t\tGDScriptUtils.encode_varint(buffer, {field_number})\n"
            content += f"{indent}\t\tGDScriptUtils.encode_{get_field_coder(field)}(buffer, item)\n"
        elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
            content += f"{indent}\tif {field_name}:\n"
            content += f"{indent}\t\tGDScriptUtils.encode_varint(buffer, {field_number})\n"
            content += f"{indent}\t\t{field_name}.SerializeToString(buffer)\n"
        else:
            content += f"{indent}\tif {field_name} != {get_default_value(field)}:\n"
            content += f"{indent}\t\tGDScriptUtils.encode_varint(buffer, {field_number})\n"
            content += f"{indent}\t\tGDScriptUtils.encode_{get_field_coder(field)}(buffer, {field_name})\n"

        content += " \n"

    content += f"{indent}\treturn buffer\n \n"
    return content

def generate_serialize_dictionary_methods(message_type, indent):
    """Generate serialize directory methods for a message type."""
    content = ""

    # Generate Serialize method
    content += f"{indent}func SerializeToDictionary() -> Dictionary:\n"
    content += f"{indent}\tvar map = {{\n"
    for field in message_type.field:
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\t\t\"{field.name}\": {field.name},\n"
        elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
            content += f"{indent}\t\tif {field.name}:\n"
            content += f"{indent}\t\t\t\"{field.name}\": {field.name}.SerializeToDictionary(),\n"
        else:
            content += f"{indent}\t\t\"{field.name}\": {field.name},\n"
    content += f"{indent}\t}}\n"
    content += f"{indent}\treturn map\n\n"
    return content

def generate_parse_dictionary_methods(message_type, indent):
    """Generate parse dictionary methods for a message type."""

def generate_serialization_methods(message_type, indent):
    """Generate serialization methods for a message type."""
    content = ""

    content += generate_new_methods(message_type, indent)
    content += generate_merge_methods(message_type, indent)
 #   content += generate_clone_methods(message_type, indent)
    content += generate_serialize_dictionary_methods(message_type, indent)
    content += generate_serialize_to_string_methods(message_type, indent)
    content += generate_parse_from_string_methods(message_type, indent)

    # 移除对 generate_message_class 的调用，避免循环依赖
#    for nested_type in message_type.nested_type:
#       content += generate_serialization_methods(nested_type, indent + "\t")

    return content
  #  return ' \n'.join(lines)

def main():
    """Main entry point."""
    try:
        print("Starting GDScript code generator...", file=sys.stderr)

        # Read request message from stdin
        data = sys.stdin.buffer.read()
        request = plugin_pb2.CodeGeneratorRequest()
        request.ParseFromString(data)

        # Generate code and get response
        response = generate_gdscript(request)

        # Write response message to stdout
        sys.stdout.buffer.write(response.SerializeToString())

        print("end GDScript code generator...", file=sys.stderr)
    except Exception as e:
        print(f"Error: {str(e)}", file=sys.stderr)
        sys.exit(1)

#if __name__ == "__main__":
#    main()
