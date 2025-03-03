import string
from google.protobuf.descriptor import Descriptor, FieldDescriptor, EnumDescriptor

class GDField:
    number: int = 0
    field_type: str = ""
    name: str = ""
    default_value: str = None
    coder: str = ""

    def create(self, name: str, number: int, field_type: str, default_value: str, coder: str):
        self.name = name
        self.field_type = field_type
        self.number = number
        self.default_value = default_value
        self.coder = coder

    def field_name(self)->str:
        return self.name

    def field_number(self)->int:
        return self.number

    def field_define(self, indent: str)->str:
        return f"{indent}var {self.field_name()}: {self.field_type} = {self.default_value}"

    def field_clear(self) -> str:
        return f"self.{self.field_name()} = {self.default_value}"

    def field_merge(self, other: str) -> str:
        return f"self.{self.field_type} += {other}.{self.name}"

class GDRepeatedField(GDField):
    def create(self, name: str, number: int, field_type: str, default_value: str, coder: str):
        super().create(name, number, f"Array[{field_type}]", "[]", coder)

class GDMapField(GDField):
    key_field: GDField = None
    value_field: GDField = None
    def create(self, name: str, number: int, key_field: GDField, value_field: GDField):
        self.key_field = key_field
        self.value_field = value_field
        super().create(name, number, f"Dictionary[{key_field.field_name()}, {value_field.field_name()}]", "{}", "")

class GDMessageType:
    def __init__(self, descriptor: Descriptor, package_name: str = ""):
        self.descriptor = descriptor
        self.package_name = package_name
        self.field_dic = {}

    def add_field(self, field: GDField):
        self.field_dic[field.field_number()] = field

    def get_field(self, number: int)->GDField:
        return self.field_dic[number]

    def real_type_name(self, type_full_name: str)->str:
        if len(type_full_name) <= 0:
            return type_full_name

        if type_full_name[0] == '.':
            type_full_name = type_full_name[1:]

        if len(self.package_name) <= 0:
            return type_full_name

        # 去除包名
        return type_full_name.replace(self.package_name + ".", "")

def create_gd_field(gd_msg: GDMessageType, descriptor: Descriptor, field: FieldDescriptor) ->GDField:
   # default_value_func = lambda default : field.default_value if hasattr(field, 'default_value') else default
    default_value_func = lambda default : field.default_value if field.default_value  else default

    is_map: bool = False
    create_field_func = lambda f: GDMapField() if is_map else GDRepeatedField() if f.label == FieldDescriptor.LABEL_REPEATED else GDField()

    if field.type == FieldDescriptor.TYPE_MESSAGE and field.label == FieldDescriptor.LABEL_REPEATED and field.type_name:
        type_name = field.type_name
        if type_name.startswith("."):
            type_name = type_name[1:]
        parts = type_name.split(".")
        if len(parts) > 1 and parts[-1].endswith("Entry"):
            is_map = True

    gd_field = create_field_func(field)
    real_type = gd_msg.real_type_name(field.type_name)

    if is_map:
        map_type = None
        for nested_type in descriptor.nested_type:
            if nested_type.name == field.name:
                map_type = nested_type
                break

        if map_type and len(map_type.field) >= 2:
            key_field = create_gd_field(gd_msg, descriptor, map_type.field[0])
            value_field = create_gd_field(gd_msg, descriptor, map_type.field[1])
            gd_field.create(field.name, field.number, key_field, value_field)
        else:
            return None

    elif field.type in [ FieldDescriptor.TYPE_INT32, FieldDescriptor.TYPE_UINT32,
                        FieldDescriptor.TYPE_INT64, FieldDescriptor.TYPE_UINT64]:
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number, "int", default_value, "varint" )
    elif field.type in [FieldDescriptor.TYPE_SINT32]:
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number, "int", default_value, "zigzag32" )
    elif field.type == FieldDescriptor.TYPE_SINT64:
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number, "int", default_value, "zigzag64")
    elif field.type in [FieldDescriptor.TYPE_FIXED32, FieldDescriptor.TYPE_SFIXED32]:
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number,  "int", default_value, "int32" )
    elif field.type in [FieldDescriptor.TYPE_FIXED64, FieldDescriptor.TYPE_SFIXED64]:
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number,  "int", default_value, "int64" )
    elif field.type in [FieldDescriptor.TYPE_STRING]:
        default_value = default_value_func("\"\"")
        gd_field.create(field.name, field.number, "String", default_value, "string")
    elif field.type in [FieldDescriptor.TYPE_FLOAT, FieldDescriptor.TYPE_DOUBLE]:
        default_value = default_value_func(0.0)
        gd_field.create(field.name, field.number, "float", default_value, "float")
    elif field.type in [FieldDescriptor.TYPE_BOOL]:
        default_value = default_value_func("false")
        gd_field.create(field.name, field.number, "bool", default_value, "bool")
    elif field.type == FieldDescriptor.TYPE_ENUM:
#        field.enum_type.full_name
        default_value = f"{real_type}.{field.default_value}"
        gd_field.create(field.name, field.number, real_type, field.enum_type.full_name, "varint")
    elif field.type == FieldDescriptor.TYPE_MESSAGE:
        gd_field.create(field.name, field.number, real_type, "null", "message")
    elif field.type == FieldDescriptor.TYPE_BYTES:
        gd_field.create(field.name, field.number, "PackedByteArray", "[]", "bytes")
    else:
        return None

    return gd_field

def init_message_type( descriptor: Descriptor, package_name: str) -> GDMessageType:
    gd_message_type = GDMessageType(descriptor, package_name)

    for field in descriptor.field:
        gd_field = create_gd_field(gd_message_type, descriptor, field)
        if gd_field is not None:
            gd_message_type.add_field(gd_field)

    return gd_message_type
