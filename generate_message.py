from google.protobuf.descriptor_pb2 import FieldDescriptorProto
from google.protobuf.compiler import plugin_pb2
from google.protobuf.descriptor import FieldDescriptor
import sys
import os

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

def get_encoder_name(field_type):
    """Get the encoder name for a field type."""
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

def get_decoder_name(field_type):
    """Get the decoder name for a field type."""
    if field_type == FieldDescriptorProto.TYPE_STRING:
        return "decode_string"
    elif field_type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64,
                       FieldDescriptorProto.TYPE_ENUM]:
        return "decode_varint"
    elif field_type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return "decode_float"
    elif field_type == FieldDescriptorProto.TYPE_BOOL:
        return "decode_bool"
    elif field_type == FieldDescriptorProto.TYPE_BYTES:
        return "decode_bytes"
    else:
        return "decode_varint"

def get_size_name(field_type):
    """Get the size function name for a field type."""
    if field_type == FieldDescriptorProto.TYPE_STRING:
        return "string_size"
    elif field_type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64,
                       FieldDescriptorProto.TYPE_ENUM]:
        return "varint_size"
    elif field_type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return "float_size"
    elif field_type == FieldDescriptorProto.TYPE_BOOL:
        return "bool_size"
    elif field_type == FieldDescriptorProto.TYPE_BYTES:
        return "bytes_size"
    else:
        return "varint_size"

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
        content += 'const GDScriptUtils = preload("res://protobuf/proto/GDScriptUtils.gd")\n'
        content += 'const Message = preload("res://protobuf/proto/Message.gd")\n'
        
        # Generate code for each message type
        for message_type in proto_file.message_type:
            # Skip if message type is empty
            if not message_type.name:
                continue
                
            # Add class definition
            content += f'class {message_type.name} extends Message:\n'
            
            # Add enum definitions for this message
            for enum_type in message_type.enum_type:
                for value in enum_type.value:
                    content += f"\tconst {value.name} = {value.number}\n"
            
            # Add field definitions
            for field in message_type.field:
                field_type = get_field_type(field)
                field_name = field.name
                default_value = get_default_value(field)
                content += f"\tvar {field_name}: {field_type} = {default_value}\n"
            
            # Add nested message types as inner classes
            for nested_type in message_type.nested_type:
                content += f"\tclass {nested_type.name} extends Message:\n"
                
                # Add enum definitions for nested type
                for enum_type in nested_type.enum_type:
                    for value in enum_type.value:
                        content += f"\t\tconst {value.name} = {value.number}\n"
                
                # Add field definitions for nested type
                for field in nested_type.field:
                    field_type = get_field_type(field)
                    field_name = field.name
                    default_value = get_default_value(field)
                    content += f"\t\tvar {field_name}: {field_type} = {default_value}\n"
                
                # Add constructor for nested type
                content += "\t\tfunc _init() -> void:\n"
                content += "\t\t\tpass\n"
                
                # Add serialization methods for nested type
                content += generate_serialization_methods(nested_type, indent="\t\t")
            
            # Add constructor for main class
            content += "\tfunc _init() -> void:\n"
            content += "\t\tpass\n"
            
            # Add serialization methods for main class
            content += generate_serialization_methods(message_type, indent="\t")
            
            # Add separator between message types
            content += "# =========================================\n\n"
            
        file.content = content
            
    return response

def generate_serialization_methods(message_type, indent=""):
    """Generate serialization methods for a message type."""
    content = f"{indent}func SerializeToString() -> PackedByteArray:\n"
    content += f"{indent}\tvar bytes = PackedByteArray()\n"
    
    # Generate serialization code for each field
    for field in message_type.field:
        field_name = field.name
        default_value = get_default_value(field)
        encoder_name = get_encoder_name(field.type)
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tif {field_name}:\n"
            content += f"{indent}\t\tfor item in {field_name}:\n"
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\tif item != null:\n"
                content += f"{indent}\t\t\t\tbytes.append_array(GDScriptUtils.encode_varint({field.number}))\n"
                content += f"{indent}\t\t\t\tvar item_bytes = item.SerializeToString()\n"
                content += f"{indent}\t\t\t\tbytes.append_array(GDScriptUtils.encode_varint(item_bytes.size()))\n"
                content += f"{indent}\t\t\t\tbytes.append_array(item_bytes)\n"
            else:
                content += f"{indent}\t\t\tbytes.append_array(GDScriptUtils.encode_varint({field.number}))\n"
                content += f"{indent}\t\t\tbytes.append_array(GDScriptUtils.{encoder_name}(item))\n"
        else:
            content += f"{indent}\tif {field_name} != {default_value}:\n"
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\tif {field_name} != null:\n"
                content += f"{indent}\t\t\tbytes.append_array(GDScriptUtils.encode_varint({field.number}))\n"
                content += f"{indent}\t\t\tvar field_bytes = {field_name}.SerializeToString()\n"
                content += f"{indent}\t\t\tbytes.append_array(GDScriptUtils.encode_varint(field_bytes.size()))\n"
                content += f"{indent}\t\t\tbytes.append_array(field_bytes)\n"
            else:
                content += f"{indent}\t\tbytes.append_array(GDScriptUtils.encode_varint({field.number}))\n"
                content += f"{indent}\t\tbytes.append_array(GDScriptUtils.{encoder_name}({field_name}))\n"
    
    content += f"{indent}\treturn bytes\n\n"
    
    # Generate ParseFromString method
    content += f"{indent}func ParseFromString(bytes: PackedByteArray) -> bool:\n"
    content += f"{indent}\tvar pos = 0\n"
    content += f"{indent}\twhile pos < bytes.size():\n"
    content += f"{indent}\t\tvar tag = GDScriptUtils.decode_varint(bytes, pos)\n"
    content += f"{indent}\t\tpos += GDScriptUtils.varint_size(bytes, pos)\n"
    content += f"{indent}\t\tmatch tag:\n"
    
    # Generate parsing code for each field
    for field in message_type.field:
        field_name = field.name
        decoder_name = get_decoder_name(field.type)
        size_name = get_size_name(field.type)
        
        content += f"{indent}\t\t\t{field.number}:  # {field_name}\n"
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\t\tvar size = GDScriptUtils.decode_varint(bytes, pos)\n"
                content += f"{indent}\t\t\t\tpos += GDScriptUtils.varint_size(bytes, pos)\n"
                content += f"{indent}\t\t\t\tvar item = {field.type_name.split('.')[-1]}.new()\n"
                content += f"{indent}\t\t\t\tvar item_bytes = bytes.slice(pos, pos + size)\n"
                content += f"{indent}\t\t\t\titem.ParseFromString(item_bytes)\n"
                content += f"{indent}\t\t\t\tpos += size\n"
                content += f"{indent}\t\t\t\t{field_name}.append(item)\n"
            else:
                content += f"{indent}\t\t\t\tvar value = GDScriptUtils.{decoder_name}(bytes, pos)\n"
                content += f"{indent}\t\t\t\tpos += GDScriptUtils.{size_name}(bytes, pos)\n"
                content += f"{indent}\t\t\t\t{field_name}.append(value)\n"
        else:
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\t\tvar size = GDScriptUtils.decode_varint(bytes, pos)\n"
                content += f"{indent}\t\t\t\tpos += GDScriptUtils.varint_size(bytes, pos)\n"
                content += f"{indent}\t\t\t\t{field_name} = {field.type_name.split('.')[-1]}.new()\n"
                content += f"{indent}\t\t\t\tvar field_bytes = bytes.slice(pos, pos + size)\n"
                content += f"{indent}\t\t\t\t{field_name}.ParseFromString(field_bytes)\n"
                content += f"{indent}\t\t\t\tpos += size\n"
            else:
                content += f"{indent}\t\t\t\t{field_name} = GDScriptUtils.{decoder_name}(bytes, pos)\n"
                content += f"{indent}\t\t\t\tpos += GDScriptUtils.{size_name}(bytes, pos)\n"
    
    content += f"{indent}\treturn true\n\n"
    
    # Generate dictionary serialization methods
    content += f"{indent}func SerializeToDictionary() -> Dictionary:\n"
    content += f"{indent}\tvar data = {{}}\n"
    
    for field in message_type.field:
        field_name = field.name
        default_value = get_default_value(field)
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tif {field_name}:\n"
            content += f"{indent}\t\tdata['{field_name}'] = []\n"
            content += f"{indent}\t\tfor item in {field_name}:\n"
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\tif item != null:\n"
                content += f"{indent}\t\t\t\tdata['{field_name}'].append(item.SerializeToDictionary())\n"
            else:
                content += f"{indent}\t\t\tdata['{field_name}'].append(item)\n"
        else:
            content += f"{indent}\tif {field_name} != {default_value}:\n"
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\tif {field_name} != null:\n"
                content += f"{indent}\t\t\tdata['{field_name}'] = {field_name}.SerializeToDictionary()\n"
            else:
                content += f"{indent}\t\tdata['{field_name}'] = {field_name}\n"
    
    content += f"{indent}\treturn data\n\n"
    
    # Generate dictionary parsing method
    content += f"{indent}func ParseFromDictionary(data: Dictionary) -> bool:\n"
    
    for field in message_type.field:
        field_name = field.name
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tif '{field_name}' in data:\n"
            content += f"{indent}\t\tfor item_data in data['{field_name}']:\n"
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\tvar item = {field.type_name.split('.')[-1]}.new()\n"
                content += f"{indent}\t\t\titem.ParseFromDictionary(item_data)\n"
                content += f"{indent}\t\t\t{field_name}.append(item)\n"
            else:
                content += f"{indent}\t\t\t{field_name}.append(item_data)\n"
        else:
            content += f"{indent}\tif '{field_name}' in data:\n"
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t{field_name} = {field.type_name.split('.')[-1]}.new()\n"
                content += f"{indent}\t\t{field_name}.ParseFromDictionary(data['{field_name}'])\n"
            else:
                content += f"{indent}\t\t{field_name} = data['{field_name}']\n"
    
    content += f"{indent}\treturn true\n\n"
    
    # Add New method
    content += f"{indent}func New() -> {message_type.name}:\n"
    content += f"{indent}\treturn {message_type.name}.new()\n\n"
    
    # Add Merge method
    content += f"{indent}func Merge(other: Message) -> void:\n"
    
    for field in message_type.field:
        field_name = field.name
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"{indent}\tif other.{field_name}:\n"
            content += f"{indent}\t\tfor item in other.{field_name}:\n"
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\t\t\tif item != null:\n"
                content += f"{indent}\t\t\t\tvar new_item = {field.type_name.split('.')[-1]}.new()\n"
                content += f"{indent}\t\t\t\tnew_item.Merge(item)\n"
                content += f"{indent}\t\t\t\t{field_name}.append(new_item)\n"
            else:
                content += f"{indent}\t\t\t{field_name}.append(item)\n"
        else:
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                content += f"{indent}\tif other.{field_name} != null:\n"
                content += f"{indent}\t\tif {field_name} == null:\n"
                content += f"{indent}\t\t\t{field_name} = {field.type_name.split('.')[-1]}.new()\n"
                content += f"{indent}\t\t{field_name}.Merge(other.{field_name})\n"
            else:
                content += f"{indent}\tif other.{field_name} != {get_default_value(field)}:\n"
                content += f"{indent}\t\t{field_name} = other.{field_name}\n"
    
    content += "\n"
    
    # Add Copy method
    content += f"{indent}func Copy() -> {message_type.name}:\n"
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
