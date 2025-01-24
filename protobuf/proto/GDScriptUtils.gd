# Generated by proto-gen-gdscript. DO NOT EDIT!

class_name GDScriptUtils extends RefCounted

static func serialize_bool(value: bool) -> PackedByteArray:
    var bytes = PackedByteArray()
    bytes.resize(4)
    bytes.encode_u32(0, 1 if value else 0)
    return bytes

static func serialize_int32(value: int) -> PackedByteArray:
    var bytes = PackedByteArray()
    bytes.resize(4)
    bytes.encode_32(0, value)
    return bytes

static func serialize_int64(value: int) -> PackedByteArray:
    var bytes = PackedByteArray()
    bytes.resize(8)
    bytes.encode_64(0, value)
    return bytes

static func serialize_uint32(value: int) -> PackedByteArray:
    var bytes = PackedByteArray()
    bytes.resize(4)
    bytes.encode_u32(0, value)
    return bytes

static func serialize_uint64(value: int) -> PackedByteArray:
    var bytes = PackedByteArray()
    bytes.resize(8)
    bytes.encode_u64(0, value)
    return bytes

static func serialize_float(value: float) -> PackedByteArray:
    var bytes = PackedByteArray()
    bytes.resize(4)
    bytes.encode_float(0, value)
    return bytes

static func serialize_double(value: float) -> PackedByteArray:
    var bytes = PackedByteArray()
    bytes.resize(8)
    bytes.encode_double(0, value)
    return bytes

static func serialize_string(value: String) -> PackedByteArray:
    var bytes = PackedByteArray()
    var str_bytes = value.to_utf8_buffer()
    var size_bytes = PackedByteArray()
    size_bytes.resize(4)
    size_bytes.encode_u32(0, str_bytes.size())
    bytes.append_array(size_bytes)
    bytes.append_array(str_bytes)
    return bytes

static func deserialize_bool(bytes: PackedByteArray, offset: int) -> bool:
    return bytes.decode_u32(offset) != 0

static func deserialize_int32(bytes: PackedByteArray, offset: int) -> int:
    return bytes.decode_32(offset)

static func deserialize_int64(bytes: PackedByteArray, offset: int) -> int:
    return bytes.decode_64(offset)

static func deserialize_uint32(bytes: PackedByteArray, offset: int) -> int:
    return bytes.decode_u32(offset)

static func deserialize_uint64(bytes: PackedByteArray, offset: int) -> int:
    return bytes.decode_u64(offset)

static func deserialize_float(bytes: PackedByteArray, offset: int) -> float:
    return bytes.decode_float(offset)

static func deserialize_double(bytes: PackedByteArray, offset: int) -> float:
    return bytes.decode_double(offset)

static func deserialize_string(bytes: PackedByteArray, offset: int) -> String:
    var size = bytes.decode_u32(offset)
    offset += 4
    var str_bytes = bytes.slice(offset, offset + size)
    return str_bytes.get_string_from_utf8()
