from google.protobuf.descriptor_pb2 import FieldDescriptorProto
from google.protobuf.compiler import plugin_pb2
from google.protobuf.descriptor import FieldDescriptor
import sys
import os

def get_field_new(field):
    """Get code to create a new instance of a field."""
    if field.label == FieldDescriptorProto.LABEL_REPEATED:
        return "Array()"

    if field.type == FieldDescriptorProto.TYPE_MESSAGE:
        if field.type_name.startswith("."):
            type_name = field.type_name[1:]  # Remove leading dot
        else:
            type_name = field.type_name
            
        # Handle nested types
        parts = type_name.split(".")
        if len(parts) > 1:
            # If it's a nested type, use the new_instance method
            return f"{parts[-2]}.{parts[-1]}.new_instance(self)"
        else:
            return f"{type_name}.new()"
    else:
        return get_default_value(field)

def get_field_type(field):
    """Get the field type for GDScript."""
    if field.label == FieldDescriptorProto.LABEL_REPEATED:
        return "Array"
    elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
        msg_type = field.type_name
        if msg_type.startswith("."):
            msg_type = msg_type[1:]  # Remove leading dot
        return f"{msg_type.split('.')[-1]}"
    elif field.type == FieldDescriptorProto.TYPE_STRING:
        return "String"
    elif field.type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64,
                       FieldDescriptorProto.TYPE_ENUM]:
        return "int"
    elif field.type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return "float"
    elif field.type == FieldDescriptorProto.TYPE_BOOL:
        return "bool"
    elif field.type == FieldDescriptorProto.TYPE_BYTES:
        return "PackedByteArray"
    else:
        return "Variant"

def get_default_value(field):
    """Get the default value for a field."""
    if field.label == FieldDescriptorProto.LABEL_REPEATED:
        return '[]'
    elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
        return 'null'
    
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
    if field.type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                     FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                     FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64]:
        return '0'
    elif field.type in [FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64]:
        return '0'
    elif field.type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return '0.0'
    elif field.type == FieldDescriptorProto.TYPE_BOOL:
        return 'false'
    elif field.type == FieldDescriptorProto.TYPE_STRING:
        return '""'
    elif field.type == FieldDescriptorProto.TYPE_BYTES:
        return 'PackedByteArray()'
    elif field.type == FieldDescriptorProto.TYPE_ENUM:
        return '0'
    else:
        return 'null'

def get_field_encoder(field):
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
    else:
        return "varint"

def get_field_decoder(field):
    """Get the decoder name for a field."""
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

def generate_gdscript(request):
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
        
        # Start building content
        content = ""
        
        # Add imports
        content += f'const GDScriptUtils = preload("{get_protobuf_base_path()}/proto/GDScriptUtils.gd")\n'
        content += f'const Message = preload("{get_protobuf_base_path()}/proto/Message.gd")\n\n'
        
        # Generate code for each message type
        for message_type in proto_file.message_type:
            # Skip if message type is empty
            if not message_type.name:
                continue
                
            # Generate message class
            content += generate_message_class(message_type)
            
            # Add separator between message types
            content += "# =========================================\n\n"
            
        file.content = content
            
    return response

def generate_message_class(message_type):
    """Generate a message class."""
    content = ""
    
    # Generate nested enums first
    for enum_type in message_type.enum_type:
        content += generate_enum_class(enum_type, message_type.name)
    
    # Generate nested types
    for nested_type in message_type.nested_type:
        content += generate_message_class(nested_type)
    
    # Generate message class
    content += f"class {message_type.name} extends Message:\n"
    
    # Generate enum constants at class level
    for enum_type in message_type.enum_type:
        # Add enum class reference
 #       content += f"\tconst {enum_type.name} = preload('res://proto2/generated/complex.gd').{enum_type.name}\n"
        # Generate enum values as class constants
        for value in enum_type.value:
            content += f"\tconst {message_type.name}_{value.name} = {value.number}\n"
    if message_type.enum_type:
        content += "\n"
    
    # Generate fields
    for field in message_type.field:
        field_name = field.name
        field_type = field.type
        default_value = get_default_value(field)
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"\tvar {field_name} = []\n"
        else:
            content += f"\tvar {field_name} = {default_value}\n"
    content += "\n"
    
    # Generate _init method
    content += "\tfunc _init() -> void:\n"
    content += "\t\tsuper()\n"
    for field in message_type.field:
        field_name = field.name
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"\t\t{field_name} = []\n"
        else:
            content += f"\t\t{field_name} = {get_default_value(field)}\n"
    content += "\n"
    
    # Generate serialization methods
    content += generate_serialization_methods(message_type, "\t")
    
    return content

def generate_enum_class(enum_type, parent_name=None):
    """Generate an enum class."""
    content = ""
    
    # Generate enum class
    if parent_name:
        content += f"class {enum_type.name} extends RefCounted:\n"
        # Add reference to parent class for nested enums
        content += f"\tvar _parent = null\n"
        content += f"\tfunc get_parent() -> {parent_name}:\n"
        content += f"\t\treturn _parent\n\n"
        
        # Add static method to create a new instance
        content += f"\tstatic func new_instance(parent: {parent_name}) -> {enum_type.name}:\n"
        content += f"\t\tvar instance = {enum_type.name}.new()\n"
        content += f"\t\tinstance._parent = parent\n"
        content += f"\t\treturn instance\n\n"
    else:
        content += f"class {enum_type.name} extends RefCounted:\n"
    
    # Generate enum values
    for value in enum_type.value:
        content += f"\tconst {value.name} = {value.number}\n"
    content += "\n"
    
    return content

def generate_serialization_methods(message_type, indent):
    """Generate serialization methods for a message type."""
    content = ""
    
    # Generate SerializeToString method
    content += f"{indent}func SerializeToString() -> PackedByteArray:\n"
    content += f"{indent}\tvar bytes = PackedByteArray()\n"
    for field in message_type.field:
        field_name = field.name
        field_number = field.number
        field_type = field.type
        default_value = get_default_value(field)
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tif {field_name}:\n"
            content += f"{indent}\t\tfor item in {field_name}:\n"
            content += f"{indent}\t\t\tbytes.append_array(GDScriptUtils.encode_varint({field_number}))\n"
            if field_type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\tvar item_bytes = item.SerializeToString()\n"
                content += f"{indent}\t\t\tbytes.append_array(GDScriptUtils.encode_varint(item_bytes.size()))\n"
                content += f"{indent}\t\t\tbytes.append_array(item_bytes)\n"
            else:
                content += f"{indent}\t\t\tbytes.append_array(GDScriptUtils.{get_serializer_method(field_type)}(item))\n"
        else:
            content += f"{indent}\tif {field_name} != {default_value}:\n"
            content += f"{indent}\t\tbytes.append_array(GDScriptUtils.encode_varint({field_number}))\n"
            if field_type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\tvar item_bytes = {field_name}.SerializeToString()\n"
                content += f"{indent}\t\tbytes.append_array(GDScriptUtils.encode_varint(item_bytes.size()))\n"
                content += f"{indent}\t\tbytes.append_array(item_bytes)\n"
            else:
                content += f"{indent}\t\tbytes.append_array(GDScriptUtils.{get_serializer_method(field_type)}({field_name}))\n"
    content += f"{indent}\treturn bytes\n\n"
    
    # Generate ParseFromString method
    content += f"{indent}func ParseFromString(bytes: PackedByteArray) -> bool:\n"
    content += f"{indent}\tvar pos = 0\n"
    content += f"{indent}\twhile pos < bytes.size():\n"
    content += f"{indent}\t\tvar tag = GDScriptUtils.decode_varint(bytes, pos)\n"
    content += f"{indent}\t\tpos += GDScriptUtils.varint_size(bytes, pos)\n"
    content += f"{indent}\t\tmatch tag:\n"
    for field in message_type.field:
        field_name = field.name
        field_number = field.number
        field_type = field.type
        
        content += f"{indent}\t\t\t{field_number}:  # {field_name}\n"
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            if field_type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\t\tvar size = GDScriptUtils.decode_varint(bytes, pos)\n"
                content += f"{indent}\t\t\t\tpos += GDScriptUtils.varint_size(bytes, pos)\n"
                content += f"{indent}\t\t\t\tvar value = {get_field_new(field)}\n"
                content += f"{indent}\t\t\t\tvalue.ParseFromString(bytes.slice(pos, pos + size))\n"
                content += f"{indent}\t\t\t\tpos += size\n"
            else:
                content += f"{indent}\t\t\t\tvar value = GDScriptUtils.decode_{get_decoder_method(field_type)}(bytes, pos)\n"
                content += f"{indent}\t\t\t\tpos += GDScriptUtils.{get_decoder_method(field_type)}_size(bytes, pos)\n"
            content += f"{indent}\t\t\t\t{field_name}.append(value)\n"
        else:
            if field_type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\t\tvar size = GDScriptUtils.decode_varint(bytes, pos)\n"
                content += f"{indent}\t\t\t\tpos += GDScriptUtils.varint_size(bytes, pos)\n"
                content += f"{indent}\t\t\t\t{field_name} = {get_field_new(field)}\n"
                content += f"{indent}\t\t\t\t{field_name}.ParseFromString(bytes.slice(pos, pos + size))\n"
                content += f"{indent}\t\t\t\tpos += size\n"
            else:
                content += f"{indent}\t\t\t\t{field_name} = GDScriptUtils.decode_{get_decoder_method(field_type)}(bytes, pos)\n"
                content += f"{indent}\t\t\t\tpos += GDScriptUtils.{get_decoder_method(field_type)}_size(bytes, pos)\n"
    content += f"{indent}\treturn true\n\n"
    
    # Generate SerializeToDictionary method
    content += f"{indent}func SerializeToDictionary() -> Dictionary:\n"
    content += f"{indent}\tvar data = {{}}\n"
    for field in message_type.field:
        field_name = field.name
        field_type = field.type
        default_value = get_default_value(field)
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tif {field_name}:\n"
            content += f"{indent}\t\tdata['{field_name}'] = []\n"
            content += f"{indent}\t\tfor item in {field_name}:\n"
            if field_type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\tdata['{field_name}'].append(item.SerializeToDictionary())\n"
            else:
                content += f"{indent}\t\t\tdata['{field_name}'].append(item)\n"
        else:
            content += f"{indent}\tif {field_name} != {default_value}:\n"
            if field_type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\tdata['{field_name}'] = {field_name}.SerializeToDictionary()\n"
            else:
                content += f"{indent}\t\tdata['{field_name}'] = {field_name}\n"
    content += f"{indent}\treturn data\n\n"
    
    # Generate ParseFromDictionary method
    content += f"{indent}func ParseFromDictionary(data: Dictionary) -> bool:\n"
    for field in message_type.field:
        field_name = field.name
        field_type = field.type
        
        content += f"{indent}\tif '{field_name}' in data:\n"
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\t\tfor item_data in data['{field_name}']:\n"
            if field_type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\tvar item = {get_field_new(field)}\n"
                content += f"{indent}\t\t\titem.ParseFromDictionary(item_data)\n"
                content += f"{indent}\t\t\t{field_name}.append(item)\n"
            else:
                content += f"{indent}\t\t\t{field_name}.append(item_data)\n"
        else:
            if field_type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t{field_name} = {get_field_new(field)}\n"
                content += f"{indent}\t\t{field_name}.ParseFromDictionary(data['{field_name}'])\n"
            else:
                content += f"{indent}\t\t{field_name} = data['{field_name}']\n"
    content += f"{indent}\treturn true\n\n"
    
    # Add New method
    content += f"{indent}func New() -> Message:\n"
    content += f"{indent}\treturn self\n\n"
    
    # Add Merge method
    content += f"{indent}func Merge(other: Message) -> Message:\n"
    content += f"{indent}\tif not other is {message_type.name}:\n"
    content += f"{indent}\t\treturn self\n"
    for field in message_type.field:
        field_name = field.name
        default_value = get_default_value(field)
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tif other.{field_name}:\n"
            content += f"{indent}\t\tfor item in other.{field_name}:\n"
            content += f"{indent}\t\t\t{field_name}.append(item)\n"
        else:
            content += f"{indent}\tif other.{field_name} != {default_value}:\n"
            content += f"{indent}\t\t{field_name} = other.{field_name}\n"
    content += f"{indent}\treturn self\n\n"
    
    # Add Copy method
    content += f"{indent}func Copy() -> Message:\n"
    content += f"{indent}\tvar copy = {message_type.name}.new()\n"
    content += f"{indent}\tcopy.Merge(self)\n"
    content += f"{indent}\treturn copy\n\n"
    
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
