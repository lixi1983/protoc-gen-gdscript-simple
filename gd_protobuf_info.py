import string
from google.protobuf.descriptor import Descriptor, FieldDescriptor, EnumDescriptor

class GDField:
    number: int = 0
    type_name: str = ""
    name: str = ""
    default_value: str = None
    mash_coder: str = ""
    type: int = 0

    def create(self, name: str, number: int, field_type: int, field_type_name: str, default_value: str, mash_coder: str):
        self.name = name
        self.type_name = field_type_name
        self.type = field_type
        self.number = number
        self.default_value = default_value
        self.mash_coder = mash_coder

    def field_name(self)->str:
        return self.name

    def field_number(self)->int:
        return self.number

    def field_type_name(self)->str:
        return self.type_name

    def field_define(self, indent: str, define_name: str = None, flag: int = 0)->str:
        if define_name is None:
            define_name = self.field_name()
        return f"{indent}var {define_name}: {self.field_type_name()} = {self.default_value}"

    def field_clear(self, indent: str) -> str:
        return f"{indent}self.{self.field_name()} = {self.default_value}"

    def field_merge(self, indent: str, other: str) -> str:
        return f"{indent}self.{self.field_name()} += {other}.{self.field_name()}"

    def field_encode(self, indent: str, data_buffer: str, item: str = None) -> str:
        if item is None:
            item = f"self.{self.field_name()}"
        content = f"{indent}GDScriptUtils.encode_tag({data_buffer}, {self.number}, {self.type})\n"
        content += f"{indent}GDScriptUtils.encode_{self.mash_coder}({data_buffer}, {item})"
        return content

    def field_decode(self,
                     indent: str,
                     from_buffer: str = "buffer",
                     pos: str = "pos",
                     decode_value: str = "decode_value",
                     decode_msg: str = "self",
                     field_value: str = None,) -> str:
        if field_value is None:
            field_value = f"self.{self.field_name()}"
        content = f"{indent}var {decode_value} = GDScriptUtils.decode_{self.mash_coder}({from_buffer}, {pos}, {decode_msg})\n"
        content += f"{indent}{field_value} = {decode_value}[GDScriptUtils.VALUE_KEY]\n"
        content += f"{indent}{pos} += {decode_value}[GDScriptUtils.SIZE_KEY]\n"
        return content

    def field_serialize(self, indent: str, to_buffer: str = "buffer") -> str:
        content = f"{indent}if self.{self.field_name()} != {self.default_value}:\n"
        content += self.field_encode(indent + "\t", to_buffer)
#        content += f"{indent}\tGDScriptUtils.encode_tag({to_buffer}, {self.number}, {self.field_type})\n"
#        content += f"{indent}\tGDScriptUtils.encode_{self.mash_coder}({to_buffer}, self.{self.field_name()})"

        return content

    def field_parse(self,
                    indent: str,
                    from_buffer: str = "buffer",
                    pos: str = "pos",
                    decode_value: str = "decode_value",
                    decode_msg: str = "self",
                    field_value: str = None) -> str:
#        content = f"{indent}var {decode_value} = {{}}\n"
        content = self.field_decode(indent, from_buffer, pos, decode_value, "self", field_value)
        return content

    def field_serialize_to_dictionary(self, indent: str, to_dict: str = "to_dict") -> str:
        return f"{indent}{to_dict}[\"{self.field_name()}\"] = self.{self.field_name()}"

    def field_parse_from_dictionary(self,
                                    indent: str,
                                    from_dict: str = "from_dict") -> str:
        content = f"{indent}if {from_dict}.has(\"{self.field_name()}\"):\n"
        content += f"{indent}\tself.{self.field_name()} = {from_dict}.get(\"{self.field_name()}\")"
        return content
#        content = f"{indent}{field_value} = {from_dictionary}[\"{self.field_name()}\"]\n"
#        return content

class GDBoolField(GDField):
    def field_merge(self, indent: str, other: str) -> str:
        return f"{indent}self.{self.field_name()} = {other}.{self.field_name()}"

class GDMessageField(GDField):
    def field_define(self, indent: str, define_name: str = None, flag: int = 0)->str:
        if define_name is None:
            define_name = self.field_name()
        if flag == 0:
            return f"{indent}var {define_name}: {self.field_type_name()} = {self.default_value}"
        else:
            return f"{indent}var {define_name}: {self.field_type_name()} = {self.field_type_name()}.new()"

    def field_clear(self, indent: str) -> str:
        content = f"{indent}if self.{self.field_name()} != null:"
        content += f"{indent}\tself.{self.field_name()}.clear()"
        return content

    def field_merge(self, indent: str, other: str) -> str:
        content = f"{indent}if self.{self.field_name()} == null:\n"
        content += f"{indent}\tself.{self.field_name()} = {self.field_type_name()}.new()\n"
        content += f"{indent}self.{self.field_name()}.MergeFrom({other}.{self.field_name()})"
        return content

    def field_serialize(self, indent: str, to_buffer: str = "buffer") -> str:
        content = f"{indent}if self.{self.field_name()} != null:\n"
        content += self.field_encode(indent + "\t", to_buffer, f"self.{self.field_name()}")
        return content

    def field_parse(self,
                    indent: str,
                    from_buffer: str = "buffer",
                    pos: str = "pos",
                    decode_value: str = "decode_value",
                    decode_msg: str = "self",
                    field_value: str = None) -> str:
        content = f"{indent}if self.{self.field_name()} == null:\n"
        content += f"{indent}\tself.{self.field_name()} = {self.field_type_name()}.new()\n"
        content += f"{indent}self.{self.field_name()}.Init()\n"
#        content += f"{indent}var {decode_value} = {{}}\n"
        content += self.field_decode(indent, from_buffer, pos, decode_value, f"self.{self.field_name()}")

        return content

    def field_serialize_to_dictionary(self, indent: str, to_dict: str = "to_dict") -> str:
        content = f"{indent}if self.{self.field_name()} != null:\n"
        content += f"{indent}\t{to_dict}[\"{self.field_name()}\"] = self.{self.field_name()}.SerializeToDictionary()"
        return content

    def field_parse_from_dictionary(self,
                                        indent: str,
                                        from_dict: str = "from_dict") -> str:
        content = f"{indent}if {from_dict}.has(\"{self.field_name()}\"):\n"
        content += f"{indent}\tif self.{self.field_name()} == null:\n"
        content += f"{indent}\t\tself.{self.field_name()} = {self.field_type_name()}.new()\n"
        content += f"{indent}\tself.{self.field_name()}.Init()\n"
        content += f"{indent}\tself.{self.field_name()}.ParseFromDictionary({from_dict}.get(\"{self.field_name()}\"))\n"
        content += f"{indent}else:\n"
        content += f"{indent}\tself.{self.field_name()} = null"
        return content
    #

class GDEnumField(GDField):
    def field_merge(self, indent: str, other: str) -> str:
        return f"{indent}self.{self.field_name()} = {other}.{self.name}"

class GDBytesField(GDField):
    def field_merge(self, indent: str, other: str) -> str:
        return f"{indent}self.{self.field_name()}.append_array({other}.{self.field_name()})"

    def field_serialize(self, indent: str, to_buffer: str = "buffer") -> str:
        content = f"{indent}if len(self.{self.field_name()}) > 0:\n"
        content += self.field_encode(indent + "\t", to_buffer)

        return content

class GDRepeatedField(GDField):
    sub_field: GDField = None
#    def create(self, name: str, number: int, field_type: str, default_value: str, coder: str):
#        super().create(name, number, f"Array[field_type:{field_type}]", "[]", coder)

    def create(self, name: str, number: int, field_type: int, field: GDField):
        self.sub_field = field
        super().create(name, number, field_type, f"Array[{self.sub_field.field_type_name()}]", "[]", "")

    def field_merge(self, indent: str, other: str) -> str:
        return f"{indent}self.{self.field_name()}.append_array({other}.{self.field_name()})"

#    def field_decode(self, indent: str, from_buffer: str = "buffer", pos: str = "pos", decode_value: str = "decode_value", decode_msg: str = "self", field_from: str = "self.") -> str:
#        content = f"{indent}var {decode_value} = GDScriptUtils.decode_{self.mash_coder}({from_buffer}, {pos}, {decode_msg})\n"
#        content += f"{indent}{field_from}{self.field_name()}.append({decode_value}[GDScriptUtils.VALUE_KEY])\n"
#        content += f"{indent}{pos} += {decode_value}[GDScriptUtils.SIZE_KEY]\n"
#        return content
    def field_serialize(self, indent: str, to_buffer: str = "buffer") -> str:
        content = f"{indent}for item in self.{self.field_name()}:\n"
        content += self.sub_field.field_encode(indent + "\t", to_buffer, f"item")

        return content

    def field_parse(self,
                    indent: str,
                    from_buffer: str = "buffer",
                    pos: str = "pos",
                    decode_value: str = "decode_value",
                    decode_msg: str = "self",
                    field_value: str = None) -> str:
        content = f"{indent}var {decode_value} = GDScriptUtils.decode_{self.sub_field.mash_coder}({from_buffer}, {pos}, {decode_msg})\n"
        content += f"{indent}self.{self.field_name()}.append({decode_value}[GDScriptUtils.VALUE_KEY])\n"
        content += f"{indent}{pos} += {decode_value}[GDScriptUtils.SIZE_KEY]\n"
        return content

    def field_serialize_to_dictionary(self, indent: str, to_dict: str = "to_dict") -> str:
        if self.sub_field.type == FieldDescriptor.TYPE_MESSAGE:
            content = f"{indent}for item in self.{self.field_name()}:\n"
            content += f"{indent}\t{to_dict}[\"{self.field_name()}\"].append(item.SerializeToDictionary())\n"
            return content
        else:
           return f"{indent}{to_dict}[\"{self.field_name()}\"] = self.{self.field_name()}"

    def field_parse_from_dictionary(self,
                                        indent: str,
                                        from_dict: str = "from_dict") -> str:
        content = f"{indent}if {from_dict}.has(\"{self.field_name()}\"):\n"

        if self.sub_field.type == FieldDescriptor.TYPE_MESSAGE:
            content += f"{indent}\tvar list = {from_dict}.get(\"{self.field_name()}\")\n"
            content += f"{indent}\tfor item in list:\n"
            content += f"{indent}\t\tvar item_msg = {self.sub_field.field_type_name()}.new()\n"
            content += f"{indent}\t\titem_msg.ParseFromDictionary(item)\n"
            content += f"{indent}\t\tself.{self.field_name()}.append(item_msg)"
        else:
           return f"{indent}\tself.{self.field_name()} = {from_dict}.get(\"{self.field_name()}\")"

        return content

class GDMapField(GDField):
    key_field: GDField = None
    value_field: GDField = None
    def create(self, name: str, number: int, field_type: int, key_field: GDField, value_field: GDField):
        self.key_field = key_field
        self.value_field = value_field
#        super().create(name, number, field_type, f"Dictionary[{key_field.field_type_name()}, {value_field.field_type_name()}]", "{}", "")
        super().create(name, number, field_type, f"Dictionary", "{}", "")

    def field_merge(self, indent: str, other: str) -> str:
        return f"{indent}self.{self.field_name()}.merge({other}.{self.field_name()})"

    def field_serialize(self, indent: str, to_buffer: str = "buffer") -> str:
        map_buff: str = "map_buff"
        content = f"{indent}for key in self.{self.field_name()}:\n"
        content += f"{indent}\tvar {map_buff} = PackedByteArray()\n"
#        content += f"{indent}\tvar key: {self.key_field.field_type_name()} = item\n"
        content += f"{indent}\tvar value = self.{self.field_name()}[key]\n"
        content += self.key_field.field_encode(f"{indent}\t", map_buff, "key") + "\n"
        content += self.value_field.field_encode(f"{indent}\t", map_buff, "value") + "\n"
        content += f"{indent}\tGDScriptUtils.encode_tag({to_buffer}, {self.number}, {self.type})\n"
        content += f"{indent}\tGDScriptUtils.encode_varint({to_buffer}, {map_buff}.size())\n"
        content += f"{indent}\t{to_buffer}.append_array({map_buff})\n"
        return content

    def field_parse(self,
                    indent: str,
                    from_buffer: str = "buffer",
                    pos: str = "pos",
                    decode_value: str = "decode_value",
                    decode_msg: str = "self",
                    field_value: str = None) -> str:
        content = f"{indent}var map_length = GDScriptUtils.decode_varint({from_buffer}, {pos})\n"
        content += f"{indent}pos += map_length[GDScriptUtils.SIZE_KEY]\n"
        content += f"{indent}var map_buff = data.slice(pos, pos+map_length[GDScriptUtils.VALUE_KEY])\n"
        content += f"{indent}var map_pos = 0\n"
        content += f"{self.key_field.field_define(indent, "map_key", 1)}\n"
        content += f"{self.value_field.field_define(indent, "map_value", 1)}\n"
        content += f"{indent}while map_pos < map_buff.size():\n"
        content += f"{indent}\tvar map_tag = GDScriptUtils.decode_tag(map_buff, map_pos)\n"
        content += f"{indent}\tvar map_field_number = map_tag[GDScriptUtils.VALUE_KEY]\n"
        content += f"{indent}\tmap_pos += map_tag[GDScriptUtils.SIZE_KEY]\n"
        content += f"{indent}\tmatch map_field_number:\n"
        content += f"{indent}\t\t{self.key_field.number}:\n"
        content += self.key_field.field_parse(f"{indent}\t\t\t", "map_buff", "map_pos", "map_key_tag", "", "map_key")
        content += f"{indent}\t\t{self.value_field.number}:\n"
        content += self.value_field.field_parse(f"{indent}\t\t\t", "map_buff", "map_pos", "map_value_tag", "", "map_value")
        content += f"{indent}\t\t_:\n"
        content += f"{indent}\t\t\tpass\n"
        content += "\n"

        content += f"{indent}pos += map_pos\n"
        content += f"{indent}if map_pos > 0:\n"
        content += f"{indent}\tself.{self.field_name()}[map_key] = map_value\n"

        return content

class GDMessageType:
    def __init__(self, descriptor: Descriptor, package_name: str = ""):
        self.descriptor = descriptor
        self.package_name = package_name
#        self.field_dic = {}
        self.field_list = []

    def add_field(self, field: GDField):
        self.field_list.append(field)
#        self.field_dic[field.field_number()] = field

    def get_field(self, number: int)->GDField:
        for gd_field in self.field_list:
            if gd_field.field_number() == number:
                return gd_field
        return None
#        return self.field_list[number]

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
    #create_field_func = lambda f: GDMapField() if is_map else GDRepeatedField() if f.label == FieldDescriptor.LABEL_REPEATED else GDField()

    if field.type == FieldDescriptor.TYPE_MESSAGE and field.label == FieldDescriptor.LABEL_REPEATED and field.type_name:
        type_name = field.type_name
        if type_name.startswith("."):
            type_name = type_name[1:]
        parts = type_name.split(".")
        if len(parts) > 1 and parts[-1].endswith("Entry"):
            is_map = True

    gd_field: GDField = None #create_field_func(field)
    real_type = gd_msg.real_type_name(field.type_name)

    if is_map:
        map_type = None

        type_name = field.type_name
        if type_name.startswith("."):
            type_name = type_name[1:]
        parts = type_name.split(".")

        for nested_type in descriptor.nested_type:
            if nested_type.name == parts[-1]:
                map_type = nested_type
                break

        if map_type and len(map_type.field) >= 2:
            gd_field = GDMapField()
            key_field = create_gd_field(gd_msg, descriptor, map_type.field[0])
            value_field = create_gd_field(gd_msg, descriptor, map_type.field[1])
            gd_field.create(field.name, field.number, field.type, key_field, value_field)
        else:
            gd_field = GDField()
            gd_field.create(f"m_unknown_{field.name}", field.number, field.type, f"m_unknown_{map_type}", f"unknown_{na}", "unknown")
            return gd_field
#    elif field.label == FieldDescriptor.LABEL_REPEATED:
#        gd_field = GDRepeatedField()
#        gd_field.create(field.name, field.number, real_type, "[]", "")
    elif field.type == FieldDescriptor.TYPE_STRING:
        gd_field = GDField()
        default_value = default_value_func("")
        gd_field.create(field.name, field.number, field.type, "String", f"\"{default_value}\"", "string")
    elif field.type == FieldDescriptor.TYPE_BYTES:
        gd_field = GDBytesField()
        gd_field.create(field.name, field.number, field.type, "PackedByteArray", "PackedByteArray()", "bytes")
    elif field.type in [FieldDescriptor.TYPE_FLOAT, FieldDescriptor.TYPE_DOUBLE]:
        gd_field = GDField()
        default_value = default_value_func(0.0)
        gd_field.create(field.name, field.number, field.type, "float", default_value, "float" )
    elif field.type in [ FieldDescriptor.TYPE_INT32, FieldDescriptor.TYPE_UINT32,
                        FieldDescriptor.TYPE_INT64, FieldDescriptor.TYPE_UINT64]:
        gd_field = GDField()
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number, field.type, "int", default_value, "varint" )
    elif field.type in [FieldDescriptor.TYPE_SINT32]:
        gd_field = GDField()
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number, field.type, "int", default_value, "zigzag32" )
    elif field.type == FieldDescriptor.TYPE_SINT64:
        gd_field = GDField()
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number, field.type, "int", default_value, "zigzag64")
    elif field.type in [FieldDescriptor.TYPE_FIXED32, FieldDescriptor.TYPE_SFIXED32]:
        gd_field = GDField()
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number, field.type, "int", default_value, "int32" )
    elif field.type in [FieldDescriptor.TYPE_FIXED64, FieldDescriptor.TYPE_SFIXED64]:
        gd_field = GDField()
        default_value = default_value_func(0)
        gd_field.create(field.name, field.number, field.type, "int", default_value, "int64" )
    elif field.type in [FieldDescriptor.TYPE_FLOAT, FieldDescriptor.TYPE_DOUBLE]:
        gd_field = GDField()
        default_value = default_value_func(0.0)
        gd_field.create(field.name, field.number, field.type, "float", default_value, "float")
    elif field.type in [FieldDescriptor.TYPE_BOOL]:
        gd_field = GDBoolField()
        default_value = default_value_func("false")
        gd_field.create(field.name, field.number, field.type, "bool", default_value, "bool")
    elif field.type == FieldDescriptor.TYPE_ENUM:
        gd_field = GDEnumField()
        default_value = default_value_func(None)
        if default_value is not None:
            default_value = f"{real_type}.{default_value}"
        else:
            default_value = 0
        gd_field.create(field.name, field.number, field.type, real_type, default_value, "varint")
    elif field.type == FieldDescriptor.TYPE_MESSAGE:
        gd_field = GDMessageField()
        gd_field.create(field.name, field.number, field.type, real_type, "null", "message")
    else:
        gd_field.create("unknown", field.number, field.type, f"unknown_{field.type}", "unknown", "unknown")
        return gd_field


    if field.label == FieldDescriptor.LABEL_REPEATED and field.type != FieldDescriptor.TYPE_BYTES and is_map == False:
        repeated_field = GDRepeatedField()
        repeated_field.create(field.name, field.number, field.type, gd_field)
        return repeated_field

    return gd_field

def init_message_type( descriptor: Descriptor, package_name: str) -> GDMessageType:
    gd_message_type = GDMessageType(descriptor, package_name)

    for field in descriptor.field:
        gd_field = create_gd_field(gd_message_type, descriptor, field)
        if gd_field is None:
            gd_field = GDField()
            gd_field.create(field.name, field.number, f"undefine_{field.type}", "undefine", "undefine" )
        gd_message_type.add_field(gd_field)


    return gd_message_type
