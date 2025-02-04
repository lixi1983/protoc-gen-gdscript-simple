const GDScriptUtils = preload("res://protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://protobuf/proto/Message.gd")

enum CommonEnum {
	COMMON_ENUM_ZERO = 0,
	COMMON_ENUM_ONE = 1,
	COMMON_ENUM_TWO = 2,
} 
 
class CommonMessage extends Message:
	var common_field2: int = 0
	var common_field1: String = ""

	func New() -> Message:
		return CommonMessage.new()
 
	func MergeFrom(other : Message) -> void:
		if other is CommonMessage:
			common_field2 += other.common_field2
			common_field1 += other.common_field1
 
	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["common_field2"] = common_field2
		map["common_field1"] = common_field1
		return map

	func SerializeToString(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if common_field2 != 0:
			GDScriptUtils.encode_varint(buffer, 1)
			GDScriptUtils.encode_varint(buffer, common_field2)
 
		if common_field1 != "":
			GDScriptUtils.encode_varint(buffer, 2)
			GDScriptUtils.encode_string(buffer, common_field1)
 
		return buffer
 
	func ParseFromString(data: PackedByteArray) -> int:
		var size = data.size()
		var pos = 0
 
		while pos < size:
			var tag = GDScriptUtils.decode_tag(data, pos)
			var field_number = tag[GDScriptUtils.VALUE_KEY]
			pos += tag[GDScriptUtils.SIZE_KEY]
 
			match field_number:
				1:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					common_field2 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_string(data, pos, self)
					common_field1 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
					break
				_:
					pass

		return pos

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "common_field2" in data:
			common_field2 = data["common_field2"]
		if "common_field1" in data:
			common_field1 = data["common_field1"]

# =========================================

