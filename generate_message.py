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
        return f"test_proto2_{msg_type.split('.')[-1]}"
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
        return "[]"
    elif field.default_value:
        if field.type == FieldDescriptorProto.TYPE_STRING:
            return f'"{field.default_value}"'
        elif field.type == FieldDescriptorProto.TYPE_BOOL:
            return str(field.default_value).lower()
        elif field.type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
            return str(float(field.default_value))
        else:
            return str(field.default_value)
    elif field.type == FieldDescriptorProto.TYPE_MESSAGE:
        return "null"
    elif field.type == FieldDescriptorProto.TYPE_STRING:
        return '""'
    elif field.type in [FieldDescriptorProto.TYPE_INT32, FieldDescriptorProto.TYPE_INT64,
                       FieldDescriptorProto.TYPE_UINT32, FieldDescriptorProto.TYPE_UINT64,
                       FieldDescriptorProto.TYPE_SINT32, FieldDescriptorProto.TYPE_SINT64,
                       FieldDescriptorProto.TYPE_FIXED32, FieldDescriptorProto.TYPE_FIXED64,
                       FieldDescriptorProto.TYPE_SFIXED32, FieldDescriptorProto.TYPE_SFIXED64,
                       FieldDescriptorProto.TYPE_ENUM]:
        return "0"
    elif field.type in [FieldDescriptorProto.TYPE_FLOAT, FieldDescriptorProto.TYPE_DOUBLE]:
        return "0.0"
    elif field.type == FieldDescriptorProto.TYPE_BOOL:
        return "false"
    elif field.type == FieldDescriptorProto.TYPE_BYTES:
        return "PackedByteArray()"
    else:
        return "null"

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
        return f"test_proto2_{message_type.name}"
    return f"test_proto2_{message_type.name}"

def generate_serialize_field(field):
    """Generate serialization code for a field."""
    code = []
    field_name = field.name
    field_number = field.number
    field_type = field.type
    field_label = field.label

    # Handle repeated fields
    if field_label == FieldDescriptorProto.LABEL_REPEATED:
        code.append(f"\tif {field_name}:")
        code.append(f"\t\tfor item in {field_name}:")
        if field_type == FieldDescriptorProto.TYPE_MESSAGE:
            code.append(f"\t\t\tvar item_bytes = item.SerializeToString()")
            code.append(f"\t\t\tbytes.append_array(GDScriptUtils.encode_length_delimited(item_bytes))")
        else:
            code.append(f"\t\t\tbytes.append_array(GDScriptUtils.encode_varint({field_number}))")
            code.append(f"\t\t\tbytes.append_array(GDScriptUtils.{get_encoder_name(field_type)}(item))")
    # Handle message fields
    elif field_type == FieldDescriptorProto.TYPE_MESSAGE:
        code.append(f"\tif {field_name} != null:")
        code.append(f"\t\tvar field_bytes = {field_name}.SerializeToString()")
        code.append(f"\t\tbytes.append_array(GDScriptUtils.encode_length_delimited(field_bytes))")
    # Handle primitive fields
    else:
        default_value = get_default_value(field)
        code.append(f"\tif {field_name} != {default_value}:")
        code.append(f"\t\tbytes.append_array(GDScriptUtils.encode_varint({field_number}))")
        code.append(f"\t\tbytes.append_array(GDScriptUtils.{get_encoder_name(field_type)}({field_name}))")

    return "\n".join(code)

def generate_parse_field(field):
    """Generate deserialization code for a field."""
    code = []
    field_name = field.name
    field_number = field.number
    field_type = field.type
    field_label = field.label

    code.append(f"\t\t\t{field_number}:  # {field_name}")

    # Handle repeated message fields
    if field_label == FieldDescriptorProto.LABEL_REPEATED and field_type == FieldDescriptorProto.TYPE_MESSAGE:
        code.append(f"\t\t\t\tvar msg = {get_message_type(field.message_type)}.new()")
        code.append(f"\t\t\t\tvar msg_bytes = GDScriptUtils.decode_length_delimited(bytes, pos)")
        code.append(f"\t\t\t\tpos += GDScriptUtils.length_delimited_size(bytes, pos)")
        code.append(f"\t\t\t\tif msg.ParseFromString(msg_bytes):")
        code.append(f"\t\t\t\t\t{field_name}.append(msg)")
    # Handle repeated primitive fields
    elif field_label == FieldDescriptorProto.LABEL_REPEATED:
        code.append(f"\t\t\t\tvar value = GDScriptUtils.{get_decoder_name(field_type)}(bytes, pos)")
        code.append(f"\t\t\t\tpos += GDScriptUtils.{get_size_name(field_type)}(bytes, pos)")
        code.append(f"\t\t\t\t{field_name}.append(value)")
    # Handle message fields
    elif field_type == FieldDescriptorProto.TYPE_MESSAGE:
        code.append(f"\t\t\t\t{field_name} = {get_message_type(field.message_type)}.new()")
        code.append(f"\t\t\t\tvar msg_bytes = GDScriptUtils.decode_length_delimited(bytes, pos)")
        code.append(f"\t\t\t\tpos += GDScriptUtils.length_delimited_size(bytes, pos)")
        code.append(f"\t\t\t\t{field_name}.ParseFromString(msg_bytes)")
    # Handle primitive fields
    else:
        code.append(f"\t\t\t\t{field_name} = GDScriptUtils.{get_decoder_name(field_type)}(bytes, pos)")
        code.append(f"\t\t\t\tpos += GDScriptUtils.{get_size_name(field_type)}(bytes, pos)")

    return "\n".join(code)

def generate_message_class(message_type, package_name=None):
    """Generate GDScript code for a message class."""
    # Get the message name with package prefix
    message_name = get_message_type(message_type, package_name)
    
    # Generate class code
    code = f"""class {message_name}:
\textends RefCounted

"""
    
    # Add enums
    for enum_type in message_type.enum_type:
        code += f"\t# {enum_type.name} enum\n"
        for enum_value in enum_type.value:
            code += f"\tconst {enum_value.name} = {enum_value.number}\n"
        code += "\n"
    
    # Add fields
    for field in message_type.field:
        field_type = get_field_type(field)
        default_value = get_default_value(field)
        comment = f"# {field_type}" if field_type in ["Dictionary", "Array"] else ""
        code += f"var {field.name}: {field_type} = {default_value} {comment}\n"
    
    code += """
func _init() -> void:
\tpass

"""
    
    # Add serialization method
    code += """func SerializeToString() -> PackedByteArray:
\tvar bytes = PackedByteArray()
"""
    
    for field in message_type.field:
        field_type = get_field_type(field)
        default_value = get_default_value(field)
        
        if field.label == FieldDescriptorProto.LABEL_REPEATED:
            code += f"\tif {field.name}:\n"
            code += "\t\tfor item in {0}:\n".format(field.name)
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                code += "\t\t\tvar item_bytes = item.SerializeToString()\n"
                code += f"\t\t\tbytes.append_array(GDScriptUtils.encode_length_delimited(item_bytes))\n"
            else:
                code += f"\t\t\tbytes.append_array(GDScriptUtils.encode_varint({field.number}))\n"
                code += "\t\t\tbytes.append_array(GDScriptUtils.encode_{0}(item))\n".format(
                    get_encoder_name(field.type))
        else:
            code += f"\tif {field.name} != {default_value}:\n"
            code += f"\t\tbytes.append_array(GDScriptUtils.encode_varint({field.number}))\n"
            if field.type == FieldDescriptorProto.TYPE_MESSAGE:
                code += f"\t\tvar field_bytes = {field.name}.SerializeToString()\n"
                code += "\t\tbytes.append_array(GDScriptUtils.encode_length_delimited(field_bytes))\n"
            else:
                code += "\t\tbytes.append_array(GDScriptUtils.encode_{0}({1}))\n".format(
                    get_encoder_name(field.type), field.name)
    
    code += "\treturn bytes\n\n"
    
    # Add deserialization method
    code += """func ParseFromString(bytes: PackedByteArray) -> bool:
\tvar pos = 0
\twhile pos < bytes.size():
\t\tvar tag = GDScriptUtils.decode_varint(bytes, pos)
\t\tpos += GDScriptUtils.varint_size(bytes, pos)
\t\tmatch tag:
"""
    
    for field in message_type.field:
        field_type = get_field_type(field)
        code += f"\t\t\t{field.number}:  # {field.name}\n"
        
        if field.type == FieldDescriptorProto.TYPE_MESSAGE:
            msg_type = ""
            if field.type_name.startswith("."):
                msg_type = field.type_name[1:]  # Remove leading dot
            else:
                msg_type = field.type_name
            msg_type = f"test_proto2_{msg_type.split('.')[-1]}"
            
            if field.label == FieldDescriptorProto.LABEL_REPEATED:
                code += f"\t\t\t\tvar msg = {msg_type}.new()\n"
                code += "\t\t\t\tvar msg_bytes = GDScriptUtils.decode_length_delimited(bytes, pos)\n"
                code += "\t\t\t\tpos += GDScriptUtils.length_delimited_size(bytes, pos)\n"
                code += f"\t\t\t\tif msg.ParseFromString(msg_bytes):\n"
                code += f"\t\t\t\t\t{field.name}.append(msg)\n"
            else:
                code += f"\t\t\t\t{field.name} = {msg_type}.new()\n"
                code += "\t\t\t\tvar msg_bytes = GDScriptUtils.decode_length_delimited(bytes, pos)\n"
                code += "\t\t\t\tpos += GDScriptUtils.length_delimited_size(bytes, pos)\n"
                code += f"\t\t\t\t{field.name}.ParseFromString(msg_bytes)\n"
        else:
            decoder = get_decoder_name(field.type)
            size = get_size_name(field.type)
            if field.label == FieldDescriptorProto.LABEL_REPEATED:
                code += f"\t\t\t\tvar value = GDScriptUtils.{decoder}(bytes, pos)\n"
                code += f"\t\t\t\tpos += GDScriptUtils.{size}(bytes, pos)\n"
                code += f"\t\t\t\t{field.name}.append(value)\n"
            else:
                code += f"\t\t\t\t{field.name} = GDScriptUtils.{decoder}(bytes, pos)\n"
                code += f"\t\t\t\tpos += GDScriptUtils.{size}(bytes, pos)\n"
    
    code += "\treturn true"
    return code

def generate_gdscript(request):
    """Generate GDScript code from the request."""
    response = plugin_pb2.CodeGeneratorResponse()
    
    for proto_file in request.proto_file:
        print(f"Processing proto file: {proto_file.name}", file=sys.stderr)
        
        try:
            # Get package name
            package_name = None
            if hasattr(proto_file, 'package') and proto_file.package:
                package_name = proto_file.package
            
            # Generate a single GDScript file for all messages in this proto file
            file_content = ""
            
            # Process each message type
            for message_type in proto_file.message_type:
                # Skip map entry messages
                if message_type.options.map_entry:
                    continue
                
                # Generate code for this message and its nested messages
                file_content += generate_message_class(message_type, package_name)
                file_content += "\n\n"
                
                # Process nested messages
                for nested_type in message_type.nested_type:
                    if not nested_type.options.map_entry:
                        file_content += generate_message_class(nested_type, package_name)
                        file_content += "\n\n"
            
            # Create the output file
            if file_content:
                file = plugin_pb2.CodeGeneratorResponse.File()
                base_name = os.path.splitext(os.path.basename(proto_file.name))[0]
                file.name = f"{base_name}.gd"
                file.content = file_content.rstrip() + "\n"
                response.file.append(file)
                
        except Exception as e:
            print(f"Error processing proto file {proto_file.name}: {e}", file=sys.stderr)
            import traceback
            traceback.print_exc(file=sys.stderr)
            response.error = str(e)
            return response
    
    return response
