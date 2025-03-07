# Package: common

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")

enum CommonEnum {
	COMMON_ENUM_ZERO = 0,
	COMMON_ENUM_ONE = 1,
	COMMON_ENUM_TWO = 2,
} 
 
class CommonMessage extends Message:
	#1 : common_field1
	var common_field1: int = 0

	#2 : common_sint32
	var common_sint32: int = 0

	#3 : common_field2
	var common_field2: String = ""

	#4 : common_sfixed32
	var common_sfixed32: int = 0

	#5 : common_sfixed64
	var common_sfixed64: int = 0

	#6 : common_sint64
	var common_sint64: int = 0


	## Init message field values to default value
	func Init() -> void:
		self.common_field1 = 0
		self.common_sint32 = 0
		self.common_field2 = ""
		self.common_sfixed32 = 0
		self.common_sfixed64 = 0
		self.common_sint64 = 0

	## Create a new message instance
	## Returns: Message - New message instance
	func New() -> Message:
		var msg = CommonMessage.new()
		return msg

	## Message ProtoName
	## Returns: String - ProtoName
	func ProtoName() -> String:
		return "common.CommonMessage"

	func MergeFrom(other : Message) -> void:
		if other is CommonMessage:
			self.common_field1 += other.common_field1
			self.common_sint32 += other.common_sint32
			self.common_field2 += other.common_field2
			self.common_sfixed32 += other.common_sfixed32
			self.common_sfixed64 += other.common_sfixed64
			self.common_sint64 += other.common_sint64
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.common_field1 != 0:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, self.common_field1)
		if self.common_sint32 != 0:
			GDScriptUtils.encode_tag(buffer, 2, 17)
			GDScriptUtils.encode_zigzag32(buffer, self.common_sint32)
		if self.common_field2 != "":
			GDScriptUtils.encode_tag(buffer, 3, 9)
			GDScriptUtils.encode_string(buffer, self.common_field2)
		if self.common_sfixed32 != 0:
			GDScriptUtils.encode_tag(buffer, 4, 15)
			GDScriptUtils.encode_int32(buffer, self.common_sfixed32)
		if self.common_sfixed64 != 0:
			GDScriptUtils.encode_tag(buffer, 5, 16)
			GDScriptUtils.encode_int64(buffer, self.common_sfixed64)
		if self.common_sint64 != 0:
			GDScriptUtils.encode_tag(buffer, 6, 18)
			GDScriptUtils.encode_zigzag64(buffer, self.common_sint64)
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
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.common_field1 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_zigzag32(data, pos, self)
					self.common_sint32 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.common_field2 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.common_sfixed32 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.common_sfixed64 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var field_value = GDScriptUtils.decode_zigzag64(data, pos, self)
					self.common_sint64 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["common_field1"] = self.common_field1
		dict["common_sint32"] = self.common_sint32
		dict["common_field2"] = self.common_field2
		dict["common_sfixed32"] = self.common_sfixed32
		dict["common_sfixed64"] = self.common_sfixed64
		dict["common_sint64"] = self.common_sint64
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("common_field1"):
			self.common_field1 = dict.get("common_field1")
		if dict.has("common_sint32"):
			self.common_sint32 = dict.get("common_sint32")
		if dict.has("common_field2"):
			self.common_field2 = dict.get("common_field2")
		if dict.has("common_sfixed32"):
			self.common_sfixed32 = dict.get("common_sfixed32")
		if dict.has("common_sfixed64"):
			self.common_sfixed64 = dict.get("common_sfixed64")
		if dict.has("common_sint64"):
			self.common_sint64 = dict.get("common_sint64")

# =========================================
