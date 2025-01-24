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
        else:
            return str(field.default_value)
    
    # Return type-specific default values
    if field.type == FieldDescriptorProto.TYPE_STRING:
        return '""'
    elif field.type == FieldDescriptorProto.TYPE_BYTES:
        return 'PackedByteArray()'
    elif field.type == FieldDescriptorProto.TYPE_BOOL:
        return 'false'
    elif field.type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64]:
        return '0'
    elif field.type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return '0.0'
    elif field.type == FieldDescriptorProto.TYPE_ENUM:
        # For proto3, enum fields default to the first defined value
        # For proto2, enum fields default to the first value (0)
        return '0'
    elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
        return 'null'
    
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
        # Extract package name
        package_name = proto_file.package if proto_file.package else ""
        
        # Generate a single file for all messages in this proto file
        file_content = ""
        base_path = get_protobuf_base_path()
        
        # Add preload for Message class
        file_content = f"""const Message = preload("{base_path}/proto/Message.gd").Message

"""
        
        # Generate code for each message type
        for message_type in proto_file.message_type:
            # Skip map entry messages
            if message_type.options.map_entry:
                continue

            # Add class definition
            class_name = message_type.name
            file_content += f"""class {class_name} extends Message:

"""
            # Generate enum definitions if any
            for enum_type in message_type.enum_type:
                for value in enum_type.value:
                    file_content += f"\tconst {value.name} = {value.number}\n"
                file_content += "\n"
            
            # Generate field definitions
            for field in message_type.field:
                field_type = get_field_type(field)
                default_value = get_default_value(field)
                file_content += f"\tvar {field.name}: {field_type} = {default_value}\n"
            file_content += "\n"
            
            # Generate constructor
            file_content += "\tfunc _init() -> void:\n"
            file_content += "\t\tsuper()\n"
            file_content += "\n"
            
            # Generate serialization methods
            serialization_methods = generate_serialization_methods(message_type)
            # Indent all lines in serialization methods
            serialization_methods = "\n".join(["\t" + line for line in serialization_methods.split("\n")])
            file_content += serialization_methods
            file_content += "\n\n"

            # Generate code for nested messages
            for nested_type in message_type.nested_type:
                if not nested_type.options.map_entry:
                    file_content += generate_nested_message_class(nested_type, class_name)
                    file_content += "\n\n"
        
        # Create output file
        if file_content:
            output_file = os.path.splitext(proto_file.name)[0] + ".gd"
            file = plugin_pb2.CodeGeneratorResponse.File()
            file.name = output_file
            file.content = file_content.rstrip() + "\n"
            response.file.append(file)
    
    return response

def generate_nested_message_class(nested_type, parent_class_name):
    """Generate GDScript code for a nested message type."""
    class_name = f"{parent_class_name}_{nested_type.name}"
    content = f"""class {nested_type.name} extends Message:
"""
    
    # Generate enum definitions if any
    for enum_type in nested_type.enum_type:
        for value in enum_type.value:
            content += f"\tconst {value.name} = {value.number}\n"
        content += "\n"
    
    # Generate field definitions
    for field in nested_type.field:
        field_type = get_field_type(field)
        default_value = get_default_value(field)
        content += f"\tvar {field.name}: {field_type} = {default_value}\n"
    content += "\n"
    
    # Generate constructor
    content += "\tfunc _init() -> void:\n"
    content += "\t\tsuper()\n"
    content += "\n"
    
    # Generate serialization methods
    serialization_methods = generate_serialization_methods(nested_type)
    # Indent all lines in serialization methods
    serialization_methods = "\n".join(["\t" + line for line in serialization_methods.split("\n")])
    content += serialization_methods
    
    return content

def generate_serialization_methods(message_type):
    """Generate serialization methods for a message type."""
    content = """func SerializeToString() -> PackedByteArray:
\tvar bytes = PackedByteArray()

"""
    
    # Generate serialization code for each field
    for field in message_type.field:
        field_name = field.name
        default_value = get_default_value(field)
        encoder_name = get_encoder_name(field.type)
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"\tif {field_name}:\n"
            content += f"\t\tfor item in {field_name}:\n"
            content += f"\t\t\tbytes.append_array(GDScriptUtils.encode_varint({field.number}))\n"
            content += f"\t\t\tbytes.append_array(GDScriptUtils.{encoder_name}(item))\n"
        else:
            content += f"\tif {field_name} != {default_value}:\n"
            content += f"\t\tbytes.append_array(GDScriptUtils.encode_varint({field.number}))\n"
            content += f"\t\tbytes.append_array(GDScriptUtils.{encoder_name}({field_name}))\n"
    
    content += "\treturn bytes\n\n"
    
    # Generate ParseFromString method
    content += """func ParseFromString(bytes: PackedByteArray) -> bool:
\tvar pos = 0
\twhile pos < bytes.size():
\t\tvar tag = GDScriptUtils.decode_varint(bytes, pos)
\t\tpos += GDScriptUtils.varint_size(bytes, pos)
\t\tmatch tag:
"""
    
    # Generate parsing code for each field
    for field in message_type.field:
        field_name = field.name
        decoder_name = get_decoder_name(field.type)
        size_name = get_size_name(field.type)
        
        content += f"\t\t\t{field.number}:  # {field_name}\n"
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"\t\t\t\tvar value = GDScriptUtils.{decoder_name}(bytes, pos)\n"
            content += f"\t\t\t\tpos += GDScriptUtils.{size_name}(bytes, pos)\n"
            content += f"\t\t\t\t{field_name}.append(value)\n"
        else:
            content += f"\t\t\t\t{field_name} = GDScriptUtils.{decoder_name}(bytes, pos)\n"
            content += f"\t\t\t\tpos += GDScriptUtils.{size_name}(bytes, pos)\n"
    
    content += "\treturn true\n\n"
    
    # Generate dictionary serialization methods
    content += """func SerializeToDictionary() -> Dictionary:
\tvar data = {}

"""
    
    for field in message_type.field:
        field_name = field.name
        default_value = get_default_value(field)
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"\tif {field_name}:\n"
            content += f"\t\tdata['{field_name}'] = []\n"
            content += f"\t\tfor item in {field_name}:\n"
            content += f"\t\t\tdata['{field_name}'].append(item)\n"
        else:
            content += f"\tif {field_name} != {default_value}:\n"
            content += f"\t\tdata['{field_name}'] = {field_name}\n"
    
    content += "\treturn data\n\n"
    
    # Generate dictionary parsing method
    content += """func ParseFromDictionary(data: Dictionary) -> bool:

"""
    
    for field in message_type.field:
        field_name = field.name
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"\tif '{field_name}' in data:\n"
            content += f"\t\tfor item_data in data['{field_name}']:\n"
            content += f"\t\t\t{field_name}.append(item_data)\n"
        else:
            content += f"\tif '{field_name}' in data:\n"
            content += f"\t\t{field_name} = data['{field_name}']\n"
    
    content += "\treturn true\n\n"
    
    # Add New method
    content += """func New() -> Message:
\treturn new()

"""
    
    # Add Merge method
    content += """func Merge(other: Message) -> void:

"""
    
    for field in message_type.field:
        field_name = field.name
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            content += f"\tif other.{field_name}:\n"
            content += f"\t\t{field_name}.append_array(other.{field_name})\n"
        else:
            content += f"\tif other.{field_name} != {get_default_value(field)}:\n"
            content += f"\t\t{field_name} = other.{field_name}\n"
    
    content += "\n"
    
    # Add Copy method
    content += """func Copy() -> Message:
\tvar copy = New()
\tvar data = SerializeToDictionary()
\tcopy.ParseFromDictionary(data)
\treturn copy
"""
    
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

if __name__ == "__main__":
    main()
