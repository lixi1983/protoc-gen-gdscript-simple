import string
from typing import List, Optional

from google.protobuf.descriptor import FieldDescriptor as FieldDescriptorProto, EnumDescriptor, FieldDescriptor
from google.protobuf.compiler import plugin_pb2
from google.protobuf.descriptor import Descriptor as MessageType
import sys
import os

def get_field_new(field, proto_file=None):
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
        return f"{parts[-1]}.new()"
    else:
        return get_default_value(field, proto_file)

def get_field_type(field, proto_file=None):
    """Get the GDScript type for a field."""

    if field.type == FieldDescriptorProto.TYPE_MESSAGE:
        field_type_name = real_type_name(field.type_name)
        return field_type_name
#        type_name = field.type_name
#        if type_name.startswith("."):
#            type_name = type_name[1:]
#        return type_name
#        parts = type_name.split(".")
#        return parts[-1]
    elif field.type == FieldDescriptorProto.TYPE_ENUM:
        field_type_name = real_type_name(field.type_name)
        return field_type_name
#        type_name = field.type_name

 #       if type_name.startswith("."):
 #           type_name = type_name[1:]
 #       return type_name
    elif field.type == FieldDescriptorProto.TYPE_STRING:
        return "String"
    elif field.type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64]:
        return "int"
    elif field.type == FieldDescriptorProto.TYPE_BOOL:
        return "bool"
    elif field.type == FieldDescriptorProto.TYPE_DOUBLE:
        return "float"
    elif field.type == FieldDescriptorProto.TYPE_FLOAT:
        return "float"
    elif field.type == FieldDescriptorProto.TYPE_BYTES:
        return "PackedByteArray"
    else:
        return "var"

def get_field_coder(field):
    """Get the encoder name for a field."""
    if field.type == FieldDescriptorProto.TYPE_STRING:
        return "string"
    elif field.type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
#                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_ENUM]:
        return "varint"
    elif field.type in [FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_SFIXED32]:
        return "int32"
    elif field.type in [FieldDescriptorProto.TYPE_FIXED64, FieldDescriptorProto.TYPE_SFIXED64]:
        return "int64"
    elif field.type == FieldDescriptorProto.TYPE_SINT32:
        return "zigzag32"
    elif field.type == FieldDescriptorProto.TYPE_SINT64:
        return "zigzag64"
    elif field.type == FieldDescriptorProto.TYPE_FLOAT:
        return "float"
    elif field.type ==  FieldDescriptorProto.TYPE_DOUBLE:
        return "double"
    elif field.type == FieldDescriptorProto.TYPE_BOOL:
        return "bool"
    elif field.type == FieldDescriptorProto.TYPE_BYTES:
        return "bytes"
    elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
        return "message"
    else:
        return "varint"

def get_class_name(name, package_name=None):
    """Get the class name without package prefix."""
    return name.replace(".", "_")

def get_file_name(name, package_name=None):
    """Get the file name without package prefix."""
    class_name = get_class_name(name)
    return f"{class_name}.proto.gd"

def get_message_type(message_type, package_name=None):
    """Get the message type name without package prefix."""
    return message_type.name

def get_gdscript_class_name(message_type):
    """Get the GDScript class name for a message type."""
    return message_type.name

def get_protobuf_base_path():
    """Get the base path for protobuf files from environment variable."""
    return os.getenv("GD_PROTOBUF_PATH", "res://addons/protobuf")


def get_import_path(proto_file_path: str, import_path: str) -> str:
    """获取导入文件的路径
    
    Args:
        proto_file_path: 当前 proto 文件的路径
        import_path: import 语句中的路径
        
    Returns:
        str: 导入文件的 GDScript 路径
    """
    # 获取当前 proto 文件的目录
    proto_dir = os.path.dirname(proto_file_path)
    
    # 计算导入文件的绝对路径
    import_abs_path = os.path.normpath(os.path.join(proto_dir, import_path))
    
    # 将 .proto 扩展名替换为 .proto.gd
    import_gd_path = os.path.splitext(import_abs_path)[0] + ".proto.gd"
    
    # 获取相对于当前文件的路径
    rel_path = os.path.relpath(import_gd_path, proto_dir)
    
    # 如果在同一目录下，添加 "./"
    if not rel_path.startswith('.'):
        rel_path = f"./{rel_path}"
        
    return rel_path

def generate_imports(proto_file) -> str:
    """生成导入语句
    
    Args:
        proto_file: protobuf 文件描述符
        
    Returns:
        str: 导入语句
    """
    content = ""
    
    # 添加基础依赖
    content += f'const GDScriptUtils = preload("{get_protobuf_base_path()}/proto/GDScriptUtils.gd")\n'
    content += f'const Message = preload("{get_protobuf_base_path()}/proto/Message.gd")\n'
    
    # 添加导入的其他 proto 文件
    for dependency in proto_file.dependency:
        import_path = get_import_path(proto_file.name, dependency)
        content += f'const {os.path.splitext(os.path.basename(dependency))[0]} = preload("{import_path}")\n'
    
    if content:
        content += "\n"
    
    return content

package_name = ""
def real_type_name(type_full_name):
    if len(type_full_name) <= 0:
        return type_full_name

    if type_full_name[0] == '.':
        type_full_name = type_full_name[1:]

    if len(package_name) <= 0:
        return type_full_name

    # 去除包名
    return type_full_name.replace(package_name + ".", "")

def generate_gdscript(request: plugin_pb2.CodeGeneratorRequest) -> plugin_pb2.CodeGeneratorResponse:
    """Generate GDScript code from the request."""
    response = plugin_pb2.CodeGeneratorResponse()
    
    # Process each proto file
    for proto_file in request.proto_file:
        # Skip google/protobuf files
        if proto_file.name not in request.file_to_generate:
            continue
            
        # Get the package name and create one file per proto file
        global package_name
        package_name = proto_file.package

        proto_file_name = os.path.splitext(os.path.basename(proto_file.name))[0]
        file_name = f"{proto_file_name}.proto.gd"
        file = response.file.add()
        file.name = file_name
        
        # Initialize content with package name
        file.content = f"# Package: {package_name}\n\n"
        
        # Add imports
        file.content += generate_imports(proto_file)
        
        # Generate enums at file level
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
        content += generate_message_class(nested_type, message_type.name, indent_level + 1)

    # Generate Init method
    content += generate_init_method(message_type, indent + "\t")

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
            content += f"{indent}var {field_name}: Array[{get_field_type(field)}] = []\n"
#            content += f"{indent}var {field_name} = {default_value}\n"
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

def get_default_value(field, proto_file=None):
    """Get the default value for a field."""
    type_name = field.type_name
    if type_name.startswith("."):
        type_name = type_name[1:]
    type_parts = type_name

    type_parts = real_type_name(field.type_name)
#    parts = type_name.split(".")
#    type_parts = parts[-1]

    if field.label == FieldDescriptorProto.LABEL_REPEATED:
        return '[]'
    elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
        return f"null"
#        return f"{type_parts}.new()"
    
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
            return type_parts + '.' + field.default_value
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

def generate_init_method(message_type, indent):
    """Generate init method for a message type."""
    content = ""
    content += f"{indent}func Init() -> void:\n"

    if len(message_type.field) <= 0:
        content += f"{indent}\tpass"
        return

    for field in message_type.field:
        field_name = field.name
        type_name = field.type_name

        if is_map_field(message_type, field.number):
            content += f"{indent}\tself.{field_name}  = {{}}\n"
        elif field.type == FieldDescriptorProto.TYPE_MESSAGE and not field.label == FieldDescriptorProto.LABEL_REPEATED and not is_map_field(message_type, field.number):
            content += f"{indent}\tif self.{field_name} != null:\n"
            content += f"{indent}\t\tself.{field_name}.Init()\n"
        else:
            content += f"{indent}\tself.{field.name} = {get_default_value(field)}\n"
    
    content += "\n"
    return content

def generate_new_methods(message_type, indent):
    """Generate new instance methods for a message type."""
    content = ""

    # Generate New method
    content += f"{indent}func New() -> Message:\n"
    content += f"{indent}\tvar msg = {message_type.name}.new()\n"
    content += f"{indent}\treturn msg\n"
    content += "\n"

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
                content += f"{indent}\t\tself.{field_name}.merge(other.{field_name})\n"
            elif field.label == FieldDescriptorProto.LABEL_REPEATED:
                content += f"{indent}\t\tself.{field_name}.append_array(other.{field_name})\n"
            elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\tif self.{field_name} == null:\n"
                content += f"{indent}\t\t\tself.{field_name} = {real_type_name(field.type_name)}.new()\n"
                content += f"{indent}\t\tself.{field_name}.MergeFrom(other.{field_name})\n"
            elif field.type in [FieldDescriptorProto.TYPE_ENUM, FieldDescriptorProto.TYPE_BOOL]:
                content += f"{indent}\t\tself.{field_name} = other.{field_name}\n"
            elif field.type == FieldDescriptorProto.TYPE_BYTES:
                content += f"{indent}\t\tself.{field_name}.append_array(other.{field_name})\n"
            else :
                content += f"{indent}\t\tself.{field_name} += other.{field_name}\n"

    content += " \n"

    return content


def generate_parse_from_string_methods(message_type, indent):
    field_msg = lambda f, v_name="": "self" if f.type != FieldDescriptorProto.TYPE_MESSAGE else v_name if v_name != "" else f.name

    def base_field_content_info(f_indent, f, decode_value="value", f_value="", pos="pos", buffer="data", is_self = True):
        field_value = f.name if f_value == "" else f_value
        msg_value = field_msg(f, f_value)
        self = "self." if is_self else ""

        content = ""

        if f.type == FieldDescriptorProto.TYPE_MESSAGE:
           content += f"{f_indent}if {self}{field_value} == null:\n"
           content += f"{f_indent}\t{self}{field_value} = {real_type_name(f.type_name)}.new()\n"
           content += f"{f_indent}else:\n"
           content += f"{f_indent}\t{self}{field_value} = {real_type_name(f.type_name)}.new()\n"
           msg_value = f"{self}{field_value}"

        content += f"{f_indent}var {decode_value} = GDScriptUtils.decode_{get_field_coder(f)}({buffer}, {pos}, {msg_value})\n"

        content += f"{f_indent}{self}{field_value} = {decode_value}[GDScriptUtils.VALUE_KEY]\n"
        content += f"{f_indent}{pos} += {decode_value}[GDScriptUtils.SIZE_KEY]\n"
        return content
#        )

    content =""
    # Generate ParseFromString method
    content += f"{indent}func ParseFromBytes(data: PackedByteArray) -> int:\n"

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
    content += " \n"
    content += f"{indent}\t\tmatch field_number:\n"

    # Parse fields
    for field in message_type.field:
        field_number = field.number
        field_name = field.name
        field_label = field.label

        content += f"{indent}\t\t\t{field_number}:\n"
        if field_label == FieldDescriptorProto.LABEL_REPEATED:
            map_info = get_field_map_info(message_type, field_number)
            if map_info is None:
       #         content += f"{indent}\t\t\t\tvar value = GDScriptUtils.decode_{get_field_coder(field)}(data, pos)\n"
                field_type = field.type
                if field_type == FieldDescriptorProto.TYPE_MESSAGE:
                    content += f"{indent}\t\t\t\tvar item_value = {get_field_type(field)}.new()\n"
                else:
                    content += f"{indent}\t\t\t\tvar item_value = {get_default_value(field)}\n"
                content += base_field_content_info(f"{indent}\t\t\t\t", field, "field_value", "item_value", "pos", "data", False)
                content += f"{indent}\t\t\t\tself.{field_name}.append(item_value)\n"
#                content += f"{indent}\t\t\t\tpos += value[GDScriptUtils.SIZE_KEY]\n"
            else:
                content += f"{indent}\t\t\t\tvar map_length = GDScriptUtils.decode_varint(data, pos)\n"
                content += f"{indent}\t\t\t\tpos += map_length[GDScriptUtils.SIZE_KEY]\n"
                content += f"{indent}\t\t\t\tvar map_buff = data.slice(pos, pos+map_length[GDScriptUtils.VALUE_KEY])\n"
                content += f"{indent}\t\t\t\tvar map_pos = 0\n"
                key_field = map_info.get(key_field_name)
                value_field = map_info.get(value_field_name)
                content += f"{indent}\t\t\t\tvar map_key: {get_field_type(key_field)} = {get_default_value(key_field)}\n"
                content += f"{indent}\t\t\t\tvar map_value: {get_field_type(value_field)} = {get_default_value(value_field)}\n"
                content += f"{indent}\t\t\t\twhile map_pos < map_buff.size():\n"
                content += f"{indent}\t\t\t\t\tvar m_tag = GDScriptUtils.decode_tag(map_buff, map_pos)\n"
                content += f"{indent}\t\t\t\t\tvar m_field_number = m_tag[GDScriptUtils.VALUE_KEY]\n"
                content += f"{indent}\t\t\t\t\tmap_pos += m_tag[GDScriptUtils.SIZE_KEY]\n"
                content += f"{indent}\t\t\t\t\tmatch m_field_number:\n"
                content += f"{indent}\t\t\t\t\t\t{key_field.number}:\n"
                content += base_field_content_info(f"{indent}\t\t\t\t\t\t\t", key_field, "key_value", "map_key", "map_pos", "map_buff", False)
                content += f"{indent}\t\t\t\t\t\t{value_field.number}:\n"
                content += base_field_content_info(f"{indent}\t\t\t\t\t\t\t", value_field, "key_value", "map_value", "map_pos", "map_buff", False)
                content += f"{indent}\t\t\t\t\t\t_:\n"
                content += f"{indent}\t\t\t\t\t\t\tpass\n"
                content += "\n"

                content += f"{indent}\t\t\t\tpos += map_pos\n"
                content += f"{indent}\t\t\t\tif map_pos > 0:\n"
                content += f"{indent}\t\t\t\t\tself.{field_name}[map_key] = map_value\n"
        else:
            content += base_field_content_info(f"{indent}\t\t\t\t", field)

    content += f"{indent}\t\t\t_:\n"
    content += f"{indent}\t\t\t\tpass\n\n"
    content += f"{indent}\treturn pos\n\n"

    return content

def generate_serialize_to_string_methods(message_type, indent):
    """Generate serialize methods for a message type."""
    base_field_content_info = lambda f_indent, f, v="", b="buffer": (
        f"{f_indent}GDScriptUtils.encode_tag({b}, {f.number}, {f.type})\n"
        f"{f_indent}GDScriptUtils.encode_{get_field_coder(f)}({b}, {v if v else 'self.' + f.name})\n"
    )

    content = ""
    content += f"{indent}func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:\n"

    for field in message_type.field:
        field_name = field.name
        field_number = field.number

        # Check if this is a map field
        map_field = get_field_map_info(message_type, field_number)
        if map_field:
            content += f"{indent}\tfor key in self.{field_name}:\n"
            content += f"{indent}\t\tGDScriptUtils.encode_tag(buffer, {field_number}, {field.type})\n"
            content += f"{indent}\t\tvar map_buffer = PackedByteArray()\n"
#            content += base_field_content_info(f"{indent}\t\t", map_field.get({key_field_name}), "key", "map_buffer")
            content += base_field_content_info(f"{indent}\t\t", map_field.get(key_field_name), "key", "map_buffer")
            content += base_field_content_info(f"{indent}\t\t", map_field.get(value_field_name), f"self.{field_name}[key]", "map_buffer")
            content += "\n"
            content += f"{indent}\t\tGDScriptUtils.encode_varint(buffer, map_buffer.size())\n"
            content += f"{indent}\t\tbuffer.append_array(map_buffer)\n"
        elif field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tfor item in self.{field_name}:\n"
            content += base_field_content_info(f"{indent}\t\t", field, "item")
        elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
            content += f"{indent}\tif self.{field_name} != null:\n"
            content += base_field_content_info(f"{indent}\t\t", field)
        else:
            content += f"{indent}\tif self.{field_name} != {get_default_value(field)}:\n"
            content += base_field_content_info(f"{indent}\t\t", field)

        content += " \n"

    content += f"{indent}\treturn buffer\n \n"
    return content

def generate_serialize_to_dictionary_methods(message_type, indent):
    """Generate serialize directory methods for a message type."""
    content = ""

    # Generate Serialize method
    content += f"{indent}func SerializeToDictionary() -> Dictionary:\n"
    content += f"{indent}\tvar _tmap = {{}}\n"
    
    # 分别处理每个字段
    for field in message_type.field:
        map_info = get_field_map_info(message_type, field.number)
        if map_info is not None:
            value_field = map_info.get(value_field_name)
            is_value_message = value_field.type == FieldDescriptorProto.TYPE_MESSAGE
            content += f"{indent}\tif not self.{field.name}.is_empty():\n"
            content += f"{indent}\t\tvar map_dict = {{}}\n"
            content += f"{indent}\t\tfor key in self.{field.name}:\n"
            if is_value_message:
                content += f"{indent}\t\t\tmap_dict[key] = self.{field.name}[key].SerializeToDictionary()\n"
            else:
                content += f"{indent}\t\t\tmap_dict[key] = self.{field.name}[key]\n"
            content += f"{indent}\t\t_tmap[\"{field.name}\"] = map_dict\n"
        elif field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\t_tmap[\"{field.name}\"] = self.{field.name}\n"
        elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
            content += f"{indent}\tif self.{field.name} != null:\n"
            content += f"{indent}\t\t_tmap[\"{field.name}\"] = self.{field.name}.SerializeToDictionary()\n"
        else:
            content += f"{indent}\t_tmap[\"{field.name}\"] = self.{field.name}\n"
            
    content += f"{indent}\treturn _tmap\n\n"
    return content

def generate_parse_from_dictionary_methods(message_type, indent):
    """Generate parse dictionary methods for a message type."""
    content = ""

    # Generate Parse method
    content += f"{indent}func ParseFromDictionary(_fmap: Dictionary) -> void:\n"
    content += f"{indent}\tif _fmap == null:\n"
    content += f"{indent}\t\treturn\n\n"

    for field in message_type.field:
        field_name = field.name
        map_info = get_field_map_info(message_type, field.number)
        if map_info is not None:
            value_field = map_info.get(value_field_name)
            is_value_message = value_field.type == FieldDescriptorProto.TYPE_MESSAGE
            content += f"{indent}\tif \"{field_name}\" in _fmap:\n"
            content += f"{indent}\t\tvar map_dict = _fmap[\"{field_name}\"]\n"
            content += f"{indent}\t\tif map_dict != null:\n"
            content += f"{indent}\t\t\tfor key in map_dict:\n"
            if is_value_message:
                content += f"{indent}\t\t\t\tvar value = {get_field_new(value_field)}\n"
                content += f"{indent}\t\t\t\tvalue.ParseFromDictionary(map_dict[key])\n"
                content += f"{indent}\t\t\t\tself.{field_name}[key] = value\n"
            else:
                content += f"{indent}\t\t\t\tself.{field_name}[key] = map_dict[key]\n"
        elif field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tif \"{field_name}\" in _fmap:\n"
            content += f"{indent}\t\tself.{field_name} = _fmap[\"{field_name}\"]\n"
        elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
            content += f"{indent}\tif \"{field_name}\" in _fmap:\n"
            content += f"{indent}\t\tif _fmap[\"{field_name}\"] != null:\n"
            content += f"{indent}\t\t\tself.{field_name}.ParseFromDictionary(_fmap[\"{field_name}\"])\n"
        else:
            content += f"{indent}\tif \"{field_name}\" in _fmap:\n"
            content += f"{indent}\t\tself.{field_name} = _fmap[\"{field_name}\"]\n"

    content += "\n"
    return content

def generate_serialization_methods(message_type, indent):
    """Generate serialization methods for a message type."""
    content = ""

    content += generate_new_methods(message_type, indent)
    content += generate_merge_methods(message_type, indent)

    content += generate_serialize_to_string_methods(message_type, indent)
    content += generate_parse_from_string_methods(message_type, indent)

    content += generate_serialize_to_dictionary_methods(message_type, indent)
    content += generate_parse_from_dictionary_methods(message_type, indent)

    return content

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
