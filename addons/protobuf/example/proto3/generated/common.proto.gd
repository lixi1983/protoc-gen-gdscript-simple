# Package: common

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")

enum CommonEnum {
	COMMON_ENUM_ZERO = 0,
	COMMON_ENUM_ONE = 1,
	COMMON_ENUM_TWO = 2,
} 
 
class CommonMessage extends Message:
	var common_field1: int = 0
	var common_sint32: int = 0
	var common_field2: String = ""
	var common_sfixed32: int = 0
	var common_sfixed64: int = 0
	var common_sint64: int = 0

	func New() -> Message:
		return CommonMessage.new()
 
	func MergeFrom(other : Message) -> void:
		if other is CommonMessage:
			common_field1 += other.common_field1
			common_sint32 += other.common_sint32
			common_field2 += other.common_field2
			common_sfixed32 += other.common_sfixed32
			common_sfixed64 += other.common_sfixed64
			common_sint64 += other.common_sint64
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if common_field1 != 0:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, common_field1)
 
		if common_sint32 != 0:
			GDScriptUtils.encode_tag(buffer, 2, 17)
			GDScriptUtils.encode_zigzag32(buffer, common_sint32)
 
		if common_field2 != "":
			GDScriptUtils.encode_tag(buffer, 3, 9)
			GDScriptUtils.encode_string(buffer, common_field2)
 
		if common_sfixed32 != 0:
			GDScriptUtils.encode_tag(buffer, 4, 15)
			GDScriptUtils.encode_int32(buffer, common_sfixed32)
 
		if common_sfixed64 != 0:
			GDScriptUtils.encode_tag(buffer, 5, 16)
			GDScriptUtils.encode_int64(buffer, common_sfixed64)
 
		if common_sint64 != 0:
			GDScriptUtils.encode_tag(buffer, 6, 18)
			GDScriptUtils.encode_zigzag64(buffer, common_sint64)
 
		return buffer
 
	func ParseFromBytes(data: PackedByteArray) -> int:
		var size = data.size()
		var pos = 0
 
		while pos < size:
			var tag = GDScriptUtils.decode_tag(data, pos)
			var field_number = tag[GDScriptUtils.VALUE_KEY]
			pos += tag[GDScriptUtils.SIZE_KEY]
 
			match field_number:
				1:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					common_field1 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_zigzag32(data, pos, self)
					common_sint32 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_string(data, pos, self)
					common_field2 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_int32(data, pos, self)
					common_sfixed32 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_int64(data, pos, self)
					common_sfixed64 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var value = GDScriptUtils.decode_zigzag64(data, pos, self)
					common_sint64 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["common_field1"] = common_field1
		map["common_sint32"] = common_sint32
		map["common_field2"] = common_field2
		map["common_sfixed32"] = common_sfixed32
		map["common_sfixed64"] = common_sfixed64
		map["common_sint64"] = common_sint64
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "common_field1" in data:
			common_field1 = data["common_field1"]
		if "common_sint32" in data:
			common_sint32 = data["common_sint32"]
		if "common_field2" in data:
			common_field2 = data["common_field2"]
		if "common_sfixed32" in data:
			common_sfixed32 = data["common_sfixed32"]
		if "common_sfixed64" in data:
			common_sfixed64 = data["common_sfixed64"]
		if "common_sint64" in data:
			common_sint64 = data["common_sint64"]

# =========================================

