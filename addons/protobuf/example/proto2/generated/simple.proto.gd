# Package: 

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")

enum SimpleEnum {
	UNKNOWN = 3,
	VALUE1 = 1,
	VALUE2 = 2,
} 
 
class SimpleMessage extends Message:
	enum EnumDemo {
		E_UNKNOWN = 0,
		E_VALUE1 = 1,
		E_VALUE2 = 2,
	} 
 
	#1 : int32_v
	var int32_v: int = 0

	#2 : int64_v
	var int64_v: int = 0

	#3 : uint32_v
	var uint32_v: int = 0

	#4 : uint64_v
	var uint64_v: int = 0

	#5 : sint32_v
	var sint32_v: int = 0

	#6 : sint64_v
	var sint64_v: int = 0

	#7 : fixed32_v
	var fixed32_v: int = 0

	#8 : fixed64_v
	var fixed64_v: int = 0

	#9 : sfixed32_v
	var sfixed32_v: int = 0

	#10 : sfixed64_v
	var sfixed64_v: int = 0

	#11 : float_v
	var float_v: float = 0.0

	#12 : double_v
	var double_v: float = 0.0

	#13 : bool_v
	var bool_v: bool = false

	#14 : string_v
	var string_v: String = ""

	#15 : bytes_v
	var bytes_v: PackedByteArray = PackedByteArray()

	#16 : elem_v
	var elem_v: SimpleEnum = 0

	#17 : elem_vd
	var elem_vd: SimpleMessage.EnumDemo = 0


	## Init message field values to default value
	func Init() -> void:
		self.int32_v = 0
		self.int64_v = 0
		self.uint32_v = 0
		self.uint64_v = 0
		self.sint32_v = 0
		self.sint64_v = 0
		self.fixed32_v = 0
		self.fixed64_v = 0
		self.sfixed32_v = 0
		self.sfixed64_v = 0
		self.float_v = 0.0
		self.double_v = 0.0
		self.bool_v = false
		self.string_v = ""
		self.bytes_v = PackedByteArray()
		self.elem_v = 0
		self.elem_vd = 0

	## Create a new message instance
	## Returns: Message - New message instance
	func New() -> Message:
		var msg = SimpleMessage.new()
		return msg

	## Message ProtoName
	## Returns: String - ProtoName
	func ProtoName() -> String:
		return "SimpleMessage"

	func MergeFrom(other : Message) -> void:
		if other is SimpleMessage:
			self.int32_v += other.int32_v
			self.int64_v += other.int64_v
			self.uint32_v += other.uint32_v
			self.uint64_v += other.uint64_v
			self.sint32_v += other.sint32_v
			self.sint64_v += other.sint64_v
			self.fixed32_v += other.fixed32_v
			self.fixed64_v += other.fixed64_v
			self.sfixed32_v += other.sfixed32_v
			self.sfixed64_v += other.sfixed64_v
			self.float_v += other.float_v
			self.double_v += other.double_v
			self.bool_v = other.bool_v
			self.string_v += other.string_v
			self.bytes_v.append_array(other.bytes_v)
			self.elem_v = other.elem_v
			self.elem_vd = other.elem_vd
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.int32_v != 0:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, self.int32_v)
		if self.int64_v != 0:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, self.int64_v)
		if self.uint32_v != 0:
			GDScriptUtils.encode_tag(buffer, 3, 13)
			GDScriptUtils.encode_varint(buffer, self.uint32_v)
		if self.uint64_v != 0:
			GDScriptUtils.encode_tag(buffer, 4, 4)
			GDScriptUtils.encode_varint(buffer, self.uint64_v)
		if self.sint32_v != 0:
			GDScriptUtils.encode_tag(buffer, 5, 17)
			GDScriptUtils.encode_zigzag32(buffer, self.sint32_v)
		if self.sint64_v != 0:
			GDScriptUtils.encode_tag(buffer, 6, 18)
			GDScriptUtils.encode_zigzag64(buffer, self.sint64_v)
		if self.fixed32_v != 0:
			GDScriptUtils.encode_tag(buffer, 7, 7)
			GDScriptUtils.encode_int32(buffer, self.fixed32_v)
		if self.fixed64_v != 0:
			GDScriptUtils.encode_tag(buffer, 8, 6)
			GDScriptUtils.encode_int64(buffer, self.fixed64_v)
		if self.sfixed32_v != 0:
			GDScriptUtils.encode_tag(buffer, 9, 15)
			GDScriptUtils.encode_int32(buffer, self.sfixed32_v)
		if self.sfixed64_v != 0:
			GDScriptUtils.encode_tag(buffer, 10, 16)
			GDScriptUtils.encode_int64(buffer, self.sfixed64_v)
		if self.float_v != 0.0:
			GDScriptUtils.encode_tag(buffer, 11, 2)
			GDScriptUtils.encode_float(buffer, self.float_v)
		if self.double_v != 0.0:
			GDScriptUtils.encode_tag(buffer, 12, 1)
			GDScriptUtils.encode_double(buffer, self.double_v)
		if self.bool_v != false:
			GDScriptUtils.encode_tag(buffer, 13, 8)
			GDScriptUtils.encode_bool(buffer, self.bool_v)
		if self.string_v != "":
			GDScriptUtils.encode_tag(buffer, 14, 9)
			GDScriptUtils.encode_string(buffer, self.string_v)
		if len(self.bytes_v) > 0:
			GDScriptUtils.encode_tag(buffer, 15, 12)
			GDScriptUtils.encode_bytes(buffer, self.bytes_v)
		if self.elem_v != 0:
			GDScriptUtils.encode_tag(buffer, 16, 14)
			GDScriptUtils.encode_varint(buffer, self.elem_v)
		if self.elem_vd != 0:
			GDScriptUtils.encode_tag(buffer, 17, 14)
			GDScriptUtils.encode_varint(buffer, self.elem_vd)
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
					self.int32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.int64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_zigzag32(data, pos, self)
					self.sint32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var field_value = GDScriptUtils.decode_zigzag64(data, pos, self)
					self.sint64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				7:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.fixed32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				8:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.fixed64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				9:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.sfixed32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				10:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.sfixed64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				11:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.float_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				12:
					var field_value = GDScriptUtils.decode_double(data, pos, self)
					self.double_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				13:
					var field_value = GDScriptUtils.decode_bool(data, pos, self)
					self.bool_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				14:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.string_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				15:
					var field_value = GDScriptUtils.decode_bytes(data, pos, self)
					self.bytes_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				16:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.elem_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				17:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.elem_vd = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["int32_v"] = self.int32_v
		dict["int64_v"] = self.int64_v
		dict["uint32_v"] = self.uint32_v
		dict["uint64_v"] = self.uint64_v
		dict["sint32_v"] = self.sint32_v
		dict["sint64_v"] = self.sint64_v
		dict["fixed32_v"] = self.fixed32_v
		dict["fixed64_v"] = self.fixed64_v
		dict["sfixed32_v"] = self.sfixed32_v
		dict["sfixed64_v"] = self.sfixed64_v
		dict["float_v"] = self.float_v
		dict["double_v"] = self.double_v
		dict["bool_v"] = self.bool_v
		dict["string_v"] = self.string_v
		dict["bytes_v"] = self.bytes_v
		dict["elem_v"] = self.elem_v
		dict["elem_vd"] = self.elem_vd
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("int32_v"):
			self.int32_v = dict.get("int32_v")
		if dict.has("int64_v"):
			self.int64_v = dict.get("int64_v")
		if dict.has("uint32_v"):
			self.uint32_v = dict.get("uint32_v")
		if dict.has("uint64_v"):
			self.uint64_v = dict.get("uint64_v")
		if dict.has("sint32_v"):
			self.sint32_v = dict.get("sint32_v")
		if dict.has("sint64_v"):
			self.sint64_v = dict.get("sint64_v")
		if dict.has("fixed32_v"):
			self.fixed32_v = dict.get("fixed32_v")
		if dict.has("fixed64_v"):
			self.fixed64_v = dict.get("fixed64_v")
		if dict.has("sfixed32_v"):
			self.sfixed32_v = dict.get("sfixed32_v")
		if dict.has("sfixed64_v"):
			self.sfixed64_v = dict.get("sfixed64_v")
		if dict.has("float_v"):
			self.float_v = dict.get("float_v")
		if dict.has("double_v"):
			self.double_v = dict.get("double_v")
		if dict.has("bool_v"):
			self.bool_v = dict.get("bool_v")
		if dict.has("string_v"):
			self.string_v = dict.get("string_v")
		if dict.has("bytes_v"):
			self.bytes_v = dict.get("bytes_v")
		if dict.has("elem_v"):
			self.elem_v = dict.get("elem_v")
		if dict.has("elem_vd"):
			self.elem_vd = dict.get("elem_vd")

# =========================================

class SimpleDefaultMessage extends Message:
	#1 : int32_v
	var int32_v: int = 101

	#2 : int64_v
	var int64_v: int = 102

	#3 : uint32_v
	var uint32_v: int = 103

	#4 : uint64_v
	var uint64_v: int = 104

	#5 : sint32_v
	var sint32_v: int = 105

	#6 : sint64_v
	var sint64_v: int = 106

	#7 : fixed32_v
	var fixed32_v: int = 107

	#8 : fixed64_v
	var fixed64_v: int = 108

	#9 : sfixed32_v
	var sfixed32_v: int = 109

	#10 : sfixed64_v
	var sfixed64_v: int = 110

	#11 : float_v
	var float_v: float = 11.1

	#12 : double_v
	var double_v: float = 11.2

	#13 : bool_v
	var bool_v: bool = true

	#14 : string_v
	var string_v: String = "simple_demo"

	#15 : bytes_v
	var bytes_v: PackedByteArray = PackedByteArray()

	#16 : elem_v
	var elem_v: SimpleEnum = SimpleEnum.VALUE1

	#17 : elem_vd
	var elem_vd: SimpleMessage.EnumDemo = SimpleMessage.EnumDemo.E_VALUE1


	## Init message field values to default value
	func Init() -> void:
		self.int32_v = 101
		self.int64_v = 102
		self.uint32_v = 103
		self.uint64_v = 104
		self.sint32_v = 105
		self.sint64_v = 106
		self.fixed32_v = 107
		self.fixed64_v = 108
		self.sfixed32_v = 109
		self.sfixed64_v = 110
		self.float_v = 11.1
		self.double_v = 11.2
		self.bool_v = true
		self.string_v = "simple_demo"
		self.bytes_v = PackedByteArray()
		self.elem_v = SimpleEnum.VALUE1
		self.elem_vd = SimpleMessage.EnumDemo.E_VALUE1

	## Create a new message instance
	## Returns: Message - New message instance
	func New() -> Message:
		var msg = SimpleDefaultMessage.new()
		return msg

	## Message ProtoName
	## Returns: String - ProtoName
	func ProtoName() -> String:
		return "SimpleDefaultMessage"

	func MergeFrom(other : Message) -> void:
		if other is SimpleDefaultMessage:
			self.int32_v += other.int32_v
			self.int64_v += other.int64_v
			self.uint32_v += other.uint32_v
			self.uint64_v += other.uint64_v
			self.sint32_v += other.sint32_v
			self.sint64_v += other.sint64_v
			self.fixed32_v += other.fixed32_v
			self.fixed64_v += other.fixed64_v
			self.sfixed32_v += other.sfixed32_v
			self.sfixed64_v += other.sfixed64_v
			self.float_v += other.float_v
			self.double_v += other.double_v
			self.bool_v = other.bool_v
			self.string_v += other.string_v
			self.bytes_v.append_array(other.bytes_v)
			self.elem_v = other.elem_v
			self.elem_vd = other.elem_vd
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.int32_v != 101:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, self.int32_v)
		if self.int64_v != 102:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, self.int64_v)
		if self.uint32_v != 103:
			GDScriptUtils.encode_tag(buffer, 3, 13)
			GDScriptUtils.encode_varint(buffer, self.uint32_v)
		if self.uint64_v != 104:
			GDScriptUtils.encode_tag(buffer, 4, 4)
			GDScriptUtils.encode_varint(buffer, self.uint64_v)
		if self.sint32_v != 105:
			GDScriptUtils.encode_tag(buffer, 5, 17)
			GDScriptUtils.encode_zigzag32(buffer, self.sint32_v)
		if self.sint64_v != 106:
			GDScriptUtils.encode_tag(buffer, 6, 18)
			GDScriptUtils.encode_zigzag64(buffer, self.sint64_v)
		if self.fixed32_v != 107:
			GDScriptUtils.encode_tag(buffer, 7, 7)
			GDScriptUtils.encode_int32(buffer, self.fixed32_v)
		if self.fixed64_v != 108:
			GDScriptUtils.encode_tag(buffer, 8, 6)
			GDScriptUtils.encode_int64(buffer, self.fixed64_v)
		if self.sfixed32_v != 109:
			GDScriptUtils.encode_tag(buffer, 9, 15)
			GDScriptUtils.encode_int32(buffer, self.sfixed32_v)
		if self.sfixed64_v != 110:
			GDScriptUtils.encode_tag(buffer, 10, 16)
			GDScriptUtils.encode_int64(buffer, self.sfixed64_v)
		if self.float_v != 11.1:
			GDScriptUtils.encode_tag(buffer, 11, 2)
			GDScriptUtils.encode_float(buffer, self.float_v)
		if self.double_v != 11.2:
			GDScriptUtils.encode_tag(buffer, 12, 1)
			GDScriptUtils.encode_double(buffer, self.double_v)
		if self.bool_v != true:
			GDScriptUtils.encode_tag(buffer, 13, 8)
			GDScriptUtils.encode_bool(buffer, self.bool_v)
		if self.string_v != "simple_demo":
			GDScriptUtils.encode_tag(buffer, 14, 9)
			GDScriptUtils.encode_string(buffer, self.string_v)
		if len(self.bytes_v) > 0:
			GDScriptUtils.encode_tag(buffer, 15, 12)
			GDScriptUtils.encode_bytes(buffer, self.bytes_v)
		if self.elem_v != SimpleEnum.VALUE1:
			GDScriptUtils.encode_tag(buffer, 16, 14)
			GDScriptUtils.encode_varint(buffer, self.elem_v)
		if self.elem_vd != SimpleMessage.EnumDemo.E_VALUE1:
			GDScriptUtils.encode_tag(buffer, 17, 14)
			GDScriptUtils.encode_varint(buffer, self.elem_vd)
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
					self.int32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.int64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_zigzag32(data, pos, self)
					self.sint32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var field_value = GDScriptUtils.decode_zigzag64(data, pos, self)
					self.sint64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				7:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.fixed32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				8:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.fixed64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				9:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.sfixed32_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				10:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.sfixed64_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				11:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.float_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				12:
					var field_value = GDScriptUtils.decode_double(data, pos, self)
					self.double_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				13:
					var field_value = GDScriptUtils.decode_bool(data, pos, self)
					self.bool_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				14:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.string_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				15:
					var field_value = GDScriptUtils.decode_bytes(data, pos, self)
					self.bytes_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				16:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.elem_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				17:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.elem_vd = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["int32_v"] = self.int32_v
		dict["int64_v"] = self.int64_v
		dict["uint32_v"] = self.uint32_v
		dict["uint64_v"] = self.uint64_v
		dict["sint32_v"] = self.sint32_v
		dict["sint64_v"] = self.sint64_v
		dict["fixed32_v"] = self.fixed32_v
		dict["fixed64_v"] = self.fixed64_v
		dict["sfixed32_v"] = self.sfixed32_v
		dict["sfixed64_v"] = self.sfixed64_v
		dict["float_v"] = self.float_v
		dict["double_v"] = self.double_v
		dict["bool_v"] = self.bool_v
		dict["string_v"] = self.string_v
		dict["bytes_v"] = self.bytes_v
		dict["elem_v"] = self.elem_v
		dict["elem_vd"] = self.elem_vd
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("int32_v"):
			self.int32_v = dict.get("int32_v")
		if dict.has("int64_v"):
			self.int64_v = dict.get("int64_v")
		if dict.has("uint32_v"):
			self.uint32_v = dict.get("uint32_v")
		if dict.has("uint64_v"):
			self.uint64_v = dict.get("uint64_v")
		if dict.has("sint32_v"):
			self.sint32_v = dict.get("sint32_v")
		if dict.has("sint64_v"):
			self.sint64_v = dict.get("sint64_v")
		if dict.has("fixed32_v"):
			self.fixed32_v = dict.get("fixed32_v")
		if dict.has("fixed64_v"):
			self.fixed64_v = dict.get("fixed64_v")
		if dict.has("sfixed32_v"):
			self.sfixed32_v = dict.get("sfixed32_v")
		if dict.has("sfixed64_v"):
			self.sfixed64_v = dict.get("sfixed64_v")
		if dict.has("float_v"):
			self.float_v = dict.get("float_v")
		if dict.has("double_v"):
			self.double_v = dict.get("double_v")
		if dict.has("bool_v"):
			self.bool_v = dict.get("bool_v")
		if dict.has("string_v"):
			self.string_v = dict.get("string_v")
		if dict.has("bytes_v"):
			self.bytes_v = dict.get("bytes_v")
		if dict.has("elem_v"):
			self.elem_v = dict.get("elem_v")
		if dict.has("elem_vd"):
			self.elem_vd = dict.get("elem_vd")

# =========================================

class SimpleRepeatedMessage extends Message:
	#1 : int32_v
	var _int32_v: Array[int] = []
	var _int32_v_size: int = 0
	## Size of _int32_v
	func int32_v_size() -> int:
		return self._int32_v_size
	## Get _int32_v
	func int32_v() -> Array[int]:
		return self._int32_v.slice(0, self._int32_v_size)
	## Get _int32_v item 
	func get_int32_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _int32_v_size and index <= _int32_v.size():
			return self._int32_v[index - 1]
		return 0
	## Add _int32_v
	func add_int32_v(item: int) -> int:
		if self._int32_v_size >= 0 and self._int32_v_size < self._int32_v.size():
			self._int32_v[self._int32_v_size] = item
		else:
			self._int32_v.append(item)
		self._int32_v_size += 1
		return item
	## Append _int32_v
	func append_int32_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_int32_v(item)
	## Clean _int32_v 
	func clear_int32_v() -> void:
		self._int32_v_size = 0

	#2 : int64_v
	var _int64_v: Array[int] = []
	var _int64_v_size: int = 0
	## Size of _int64_v
	func int64_v_size() -> int:
		return self._int64_v_size
	## Get _int64_v
	func int64_v() -> Array[int]:
		return self._int64_v.slice(0, self._int64_v_size)
	## Get _int64_v item 
	func get_int64_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _int64_v_size and index <= _int64_v.size():
			return self._int64_v[index - 1]
		return 0
	## Add _int64_v
	func add_int64_v(item: int) -> int:
		if self._int64_v_size >= 0 and self._int64_v_size < self._int64_v.size():
			self._int64_v[self._int64_v_size] = item
		else:
			self._int64_v.append(item)
		self._int64_v_size += 1
		return item
	## Append _int64_v
	func append_int64_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_int64_v(item)
	## Clean _int64_v 
	func clear_int64_v() -> void:
		self._int64_v_size = 0

	#3 : uint32_v
	var _uint32_v: Array[int] = []
	var _uint32_v_size: int = 0
	## Size of _uint32_v
	func uint32_v_size() -> int:
		return self._uint32_v_size
	## Get _uint32_v
	func uint32_v() -> Array[int]:
		return self._uint32_v.slice(0, self._uint32_v_size)
	## Get _uint32_v item 
	func get_uint32_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _uint32_v_size and index <= _uint32_v.size():
			return self._uint32_v[index - 1]
		return 0
	## Add _uint32_v
	func add_uint32_v(item: int) -> int:
		if self._uint32_v_size >= 0 and self._uint32_v_size < self._uint32_v.size():
			self._uint32_v[self._uint32_v_size] = item
		else:
			self._uint32_v.append(item)
		self._uint32_v_size += 1
		return item
	## Append _uint32_v
	func append_uint32_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_uint32_v(item)
	## Clean _uint32_v 
	func clear_uint32_v() -> void:
		self._uint32_v_size = 0

	#4 : uint64_v
	var _uint64_v: Array[int] = []
	var _uint64_v_size: int = 0
	## Size of _uint64_v
	func uint64_v_size() -> int:
		return self._uint64_v_size
	## Get _uint64_v
	func uint64_v() -> Array[int]:
		return self._uint64_v.slice(0, self._uint64_v_size)
	## Get _uint64_v item 
	func get_uint64_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _uint64_v_size and index <= _uint64_v.size():
			return self._uint64_v[index - 1]
		return 0
	## Add _uint64_v
	func add_uint64_v(item: int) -> int:
		if self._uint64_v_size >= 0 and self._uint64_v_size < self._uint64_v.size():
			self._uint64_v[self._uint64_v_size] = item
		else:
			self._uint64_v.append(item)
		self._uint64_v_size += 1
		return item
	## Append _uint64_v
	func append_uint64_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_uint64_v(item)
	## Clean _uint64_v 
	func clear_uint64_v() -> void:
		self._uint64_v_size = 0

	#5 : sint32_v
	var _sint32_v: Array[int] = []
	var _sint32_v_size: int = 0
	## Size of _sint32_v
	func sint32_v_size() -> int:
		return self._sint32_v_size
	## Get _sint32_v
	func sint32_v() -> Array[int]:
		return self._sint32_v.slice(0, self._sint32_v_size)
	## Get _sint32_v item 
	func get_sint32_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _sint32_v_size and index <= _sint32_v.size():
			return self._sint32_v[index - 1]
		return 0
	## Add _sint32_v
	func add_sint32_v(item: int) -> int:
		if self._sint32_v_size >= 0 and self._sint32_v_size < self._sint32_v.size():
			self._sint32_v[self._sint32_v_size] = item
		else:
			self._sint32_v.append(item)
		self._sint32_v_size += 1
		return item
	## Append _sint32_v
	func append_sint32_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_sint32_v(item)
	## Clean _sint32_v 
	func clear_sint32_v() -> void:
		self._sint32_v_size = 0

	#6 : sint64_v
	var _sint64_v: Array[int] = []
	var _sint64_v_size: int = 0
	## Size of _sint64_v
	func sint64_v_size() -> int:
		return self._sint64_v_size
	## Get _sint64_v
	func sint64_v() -> Array[int]:
		return self._sint64_v.slice(0, self._sint64_v_size)
	## Get _sint64_v item 
	func get_sint64_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _sint64_v_size and index <= _sint64_v.size():
			return self._sint64_v[index - 1]
		return 0
	## Add _sint64_v
	func add_sint64_v(item: int) -> int:
		if self._sint64_v_size >= 0 and self._sint64_v_size < self._sint64_v.size():
			self._sint64_v[self._sint64_v_size] = item
		else:
			self._sint64_v.append(item)
		self._sint64_v_size += 1
		return item
	## Append _sint64_v
	func append_sint64_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_sint64_v(item)
	## Clean _sint64_v 
	func clear_sint64_v() -> void:
		self._sint64_v_size = 0

	#7 : fixed32_v
	var _fixed32_v: Array[int] = []
	var _fixed32_v_size: int = 0
	## Size of _fixed32_v
	func fixed32_v_size() -> int:
		return self._fixed32_v_size
	## Get _fixed32_v
	func fixed32_v() -> Array[int]:
		return self._fixed32_v.slice(0, self._fixed32_v_size)
	## Get _fixed32_v item 
	func get_fixed32_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _fixed32_v_size and index <= _fixed32_v.size():
			return self._fixed32_v[index - 1]
		return 0
	## Add _fixed32_v
	func add_fixed32_v(item: int) -> int:
		if self._fixed32_v_size >= 0 and self._fixed32_v_size < self._fixed32_v.size():
			self._fixed32_v[self._fixed32_v_size] = item
		else:
			self._fixed32_v.append(item)
		self._fixed32_v_size += 1
		return item
	## Append _fixed32_v
	func append_fixed32_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_fixed32_v(item)
	## Clean _fixed32_v 
	func clear_fixed32_v() -> void:
		self._fixed32_v_size = 0

	#8 : fixed64_v
	var _fixed64_v: Array[int] = []
	var _fixed64_v_size: int = 0
	## Size of _fixed64_v
	func fixed64_v_size() -> int:
		return self._fixed64_v_size
	## Get _fixed64_v
	func fixed64_v() -> Array[int]:
		return self._fixed64_v.slice(0, self._fixed64_v_size)
	## Get _fixed64_v item 
	func get_fixed64_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _fixed64_v_size and index <= _fixed64_v.size():
			return self._fixed64_v[index - 1]
		return 0
	## Add _fixed64_v
	func add_fixed64_v(item: int) -> int:
		if self._fixed64_v_size >= 0 and self._fixed64_v_size < self._fixed64_v.size():
			self._fixed64_v[self._fixed64_v_size] = item
		else:
			self._fixed64_v.append(item)
		self._fixed64_v_size += 1
		return item
	## Append _fixed64_v
	func append_fixed64_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_fixed64_v(item)
	## Clean _fixed64_v 
	func clear_fixed64_v() -> void:
		self._fixed64_v_size = 0

	#9 : sfixed32_v
	var _sfixed32_v: Array[int] = []
	var _sfixed32_v_size: int = 0
	## Size of _sfixed32_v
	func sfixed32_v_size() -> int:
		return self._sfixed32_v_size
	## Get _sfixed32_v
	func sfixed32_v() -> Array[int]:
		return self._sfixed32_v.slice(0, self._sfixed32_v_size)
	## Get _sfixed32_v item 
	func get_sfixed32_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _sfixed32_v_size and index <= _sfixed32_v.size():
			return self._sfixed32_v[index - 1]
		return 0
	## Add _sfixed32_v
	func add_sfixed32_v(item: int) -> int:
		if self._sfixed32_v_size >= 0 and self._sfixed32_v_size < self._sfixed32_v.size():
			self._sfixed32_v[self._sfixed32_v_size] = item
		else:
			self._sfixed32_v.append(item)
		self._sfixed32_v_size += 1
		return item
	## Append _sfixed32_v
	func append_sfixed32_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_sfixed32_v(item)
	## Clean _sfixed32_v 
	func clear_sfixed32_v() -> void:
		self._sfixed32_v_size = 0

	#10 : sfixed64_v
	var _sfixed64_v: Array[int] = []
	var _sfixed64_v_size: int = 0
	## Size of _sfixed64_v
	func sfixed64_v_size() -> int:
		return self._sfixed64_v_size
	## Get _sfixed64_v
	func sfixed64_v() -> Array[int]:
		return self._sfixed64_v.slice(0, self._sfixed64_v_size)
	## Get _sfixed64_v item 
	func get_sfixed64_v(index: int) -> int: # index begin from 1
		if index > 0 and index <= _sfixed64_v_size and index <= _sfixed64_v.size():
			return self._sfixed64_v[index - 1]
		return 0
	## Add _sfixed64_v
	func add_sfixed64_v(item: int) -> int:
		if self._sfixed64_v_size >= 0 and self._sfixed64_v_size < self._sfixed64_v.size():
			self._sfixed64_v[self._sfixed64_v_size] = item
		else:
			self._sfixed64_v.append(item)
		self._sfixed64_v_size += 1
		return item
	## Append _sfixed64_v
	func append_sfixed64_v(item_array: Array):
		for item in item_array:
			if item is int:
				self.add_sfixed64_v(item)
	## Clean _sfixed64_v 
	func clear_sfixed64_v() -> void:
		self._sfixed64_v_size = 0

	#11 : float_v
	var _float_v: Array[float] = []
	var _float_v_size: int = 0
	## Size of _float_v
	func float_v_size() -> int:
		return self._float_v_size
	## Get _float_v
	func float_v() -> Array[float]:
		return self._float_v.slice(0, self._float_v_size)
	## Get _float_v item 
	func get_float_v(index: int) -> float: # index begin from 1
		if index > 0 and index <= _float_v_size and index <= _float_v.size():
			return self._float_v[index - 1]
		return 0.0
	## Add _float_v
	func add_float_v(item: float) -> float:
		if self._float_v_size >= 0 and self._float_v_size < self._float_v.size():
			self._float_v[self._float_v_size] = item
		else:
			self._float_v.append(item)
		self._float_v_size += 1
		return item
	## Append _float_v
	func append_float_v(item_array: Array):
		for item in item_array:
			if item is float:
				self.add_float_v(item)
	## Clean _float_v 
	func clear_float_v() -> void:
		self._float_v_size = 0

	#12 : double_v
	var _double_v: Array[float] = []
	var _double_v_size: int = 0
	## Size of _double_v
	func double_v_size() -> int:
		return self._double_v_size
	## Get _double_v
	func double_v() -> Array[float]:
		return self._double_v.slice(0, self._double_v_size)
	## Get _double_v item 
	func get_double_v(index: int) -> float: # index begin from 1
		if index > 0 and index <= _double_v_size and index <= _double_v.size():
			return self._double_v[index - 1]
		return 0.0
	## Add _double_v
	func add_double_v(item: float) -> float:
		if self._double_v_size >= 0 and self._double_v_size < self._double_v.size():
			self._double_v[self._double_v_size] = item
		else:
			self._double_v.append(item)
		self._double_v_size += 1
		return item
	## Append _double_v
	func append_double_v(item_array: Array):
		for item in item_array:
			if item is float:
				self.add_double_v(item)
	## Clean _double_v 
	func clear_double_v() -> void:
		self._double_v_size = 0

	#13 : bool_v
	var _bool_v: Array[bool] = []
	var _bool_v_size: int = 0
	## Size of _bool_v
	func bool_v_size() -> int:
		return self._bool_v_size
	## Get _bool_v
	func bool_v() -> Array[bool]:
		return self._bool_v.slice(0, self._bool_v_size)
	## Get _bool_v item 
	func get_bool_v(index: int) -> bool: # index begin from 1
		if index > 0 and index <= _bool_v_size and index <= _bool_v.size():
			return self._bool_v[index - 1]
		return false
	## Add _bool_v
	func add_bool_v(item: bool) -> bool:
		if self._bool_v_size >= 0 and self._bool_v_size < self._bool_v.size():
			self._bool_v[self._bool_v_size] = item
		else:
			self._bool_v.append(item)
		self._bool_v_size += 1
		return item
	## Append _bool_v
	func append_bool_v(item_array: Array):
		for item in item_array:
			if item is bool:
				self.add_bool_v(item)
	## Clean _bool_v 
	func clear_bool_v() -> void:
		self._bool_v_size = 0

	#14 : string_v
	var _string_v: Array[String] = []
	var _string_v_size: int = 0
	## Size of _string_v
	func string_v_size() -> int:
		return self._string_v_size
	## Get _string_v
	func string_v() -> Array[String]:
		return self._string_v.slice(0, self._string_v_size)
	## Get _string_v item 
	func get_string_v(index: int) -> String: # index begin from 1
		if index > 0 and index <= _string_v_size and index <= _string_v.size():
			return self._string_v[index - 1]
		return ""
	## Add _string_v
	func add_string_v(item: String) -> String:
		if self._string_v_size >= 0 and self._string_v_size < self._string_v.size():
			self._string_v[self._string_v_size] = item
		else:
			self._string_v.append(item)
		self._string_v_size += 1
		return item
	## Append _string_v
	func append_string_v(item_array: Array):
		for item in item_array:
			if item is String:
				self.add_string_v(item)
	## Clean _string_v 
	func clear_string_v() -> void:
		self._string_v_size = 0

	#15 : bytes_v
	var bytes_v: PackedByteArray = PackedByteArray()

	#16 : elem_v
	var _elem_v: Array[SimpleEnum] = []
	var _elem_v_size: int = 0
	## Size of _elem_v
	func elem_v_size() -> int:
		return self._elem_v_size
	## Get _elem_v
	func elem_v() -> Array[SimpleEnum]:
		return self._elem_v.slice(0, self._elem_v_size)
	## Get _elem_v item 
	func get_elem_v(index: int) -> SimpleEnum: # index begin from 1
		if index > 0 and index <= _elem_v_size and index <= _elem_v.size():
			return self._elem_v[index - 1]
		return 0
	## Add _elem_v
	func add_elem_v(item: SimpleEnum) -> SimpleEnum:
		if self._elem_v_size >= 0 and self._elem_v_size < self._elem_v.size():
			self._elem_v[self._elem_v_size] = item
		else:
			self._elem_v.append(item)
		self._elem_v_size += 1
		return item
	## Append _elem_v
	func append_elem_v(item_array: Array):
		for item in item_array:
			if item is SimpleEnum:
				self.add_elem_v(item)
	## Clean _elem_v 
	func clear_elem_v() -> void:
		self._elem_v_size = 0

	#17 : elem_vd
	var _elem_vd: Array[SimpleMessage.EnumDemo] = []
	var _elem_vd_size: int = 0
	## Size of _elem_vd
	func elem_vd_size() -> int:
		return self._elem_vd_size
	## Get _elem_vd
	func elem_vd() -> Array[SimpleMessage.EnumDemo]:
		return self._elem_vd.slice(0, self._elem_vd_size)
	## Get _elem_vd item 
	func get_elem_vd(index: int) -> SimpleMessage.EnumDemo: # index begin from 1
		if index > 0 and index <= _elem_vd_size and index <= _elem_vd.size():
			return self._elem_vd[index - 1]
		return 0
	## Add _elem_vd
	func add_elem_vd(item: SimpleMessage.EnumDemo) -> SimpleMessage.EnumDemo:
		if self._elem_vd_size >= 0 and self._elem_vd_size < self._elem_vd.size():
			self._elem_vd[self._elem_vd_size] = item
		else:
			self._elem_vd.append(item)
		self._elem_vd_size += 1
		return item
	## Append _elem_vd
	func append_elem_vd(item_array: Array):
		for item in item_array:
			if item is SimpleMessage.EnumDemo:
				self.add_elem_vd(item)
	## Clean _elem_vd 
	func clear_elem_vd() -> void:
		self._elem_vd_size = 0


	## Init message field values to default value
	func Init() -> void:
		self.clear_int32_v
		self.clear_int64_v
		self.clear_uint32_v
		self.clear_uint64_v
		self.clear_sint32_v
		self.clear_sint64_v
		self.clear_fixed32_v
		self.clear_fixed64_v
		self.clear_sfixed32_v
		self.clear_sfixed64_v
		self.clear_float_v
		self.clear_double_v
		self.clear_bool_v
		self.clear_string_v
		self.bytes_v = PackedByteArray()
		self.clear_elem_v
		self.clear_elem_vd

	## Create a new message instance
	## Returns: Message - New message instance
	func New() -> Message:
		var msg = SimpleRepeatedMessage.new()
		return msg

	## Message ProtoName
	## Returns: String - ProtoName
	func ProtoName() -> String:
		return "SimpleRepeatedMessage"

	func MergeFrom(other : Message) -> void:
		if other is SimpleRepeatedMessage:
			self._int32_v = self._int32_v.slice(0, _int32_v_size)
			self._int32_v.append_array(other._int32_v.slice(0, other._int32_v_size))
			self._int32_v_size += other._int32_v_size
			self._int64_v = self._int64_v.slice(0, _int64_v_size)
			self._int64_v.append_array(other._int64_v.slice(0, other._int64_v_size))
			self._int64_v_size += other._int64_v_size
			self._uint32_v = self._uint32_v.slice(0, _uint32_v_size)
			self._uint32_v.append_array(other._uint32_v.slice(0, other._uint32_v_size))
			self._uint32_v_size += other._uint32_v_size
			self._uint64_v = self._uint64_v.slice(0, _uint64_v_size)
			self._uint64_v.append_array(other._uint64_v.slice(0, other._uint64_v_size))
			self._uint64_v_size += other._uint64_v_size
			self._sint32_v = self._sint32_v.slice(0, _sint32_v_size)
			self._sint32_v.append_array(other._sint32_v.slice(0, other._sint32_v_size))
			self._sint32_v_size += other._sint32_v_size
			self._sint64_v = self._sint64_v.slice(0, _sint64_v_size)
			self._sint64_v.append_array(other._sint64_v.slice(0, other._sint64_v_size))
			self._sint64_v_size += other._sint64_v_size
			self._fixed32_v = self._fixed32_v.slice(0, _fixed32_v_size)
			self._fixed32_v.append_array(other._fixed32_v.slice(0, other._fixed32_v_size))
			self._fixed32_v_size += other._fixed32_v_size
			self._fixed64_v = self._fixed64_v.slice(0, _fixed64_v_size)
			self._fixed64_v.append_array(other._fixed64_v.slice(0, other._fixed64_v_size))
			self._fixed64_v_size += other._fixed64_v_size
			self._sfixed32_v = self._sfixed32_v.slice(0, _sfixed32_v_size)
			self._sfixed32_v.append_array(other._sfixed32_v.slice(0, other._sfixed32_v_size))
			self._sfixed32_v_size += other._sfixed32_v_size
			self._sfixed64_v = self._sfixed64_v.slice(0, _sfixed64_v_size)
			self._sfixed64_v.append_array(other._sfixed64_v.slice(0, other._sfixed64_v_size))
			self._sfixed64_v_size += other._sfixed64_v_size
			self._float_v = self._float_v.slice(0, _float_v_size)
			self._float_v.append_array(other._float_v.slice(0, other._float_v_size))
			self._float_v_size += other._float_v_size
			self._double_v = self._double_v.slice(0, _double_v_size)
			self._double_v.append_array(other._double_v.slice(0, other._double_v_size))
			self._double_v_size += other._double_v_size
			self._bool_v = self._bool_v.slice(0, _bool_v_size)
			self._bool_v.append_array(other._bool_v.slice(0, other._bool_v_size))
			self._bool_v_size += other._bool_v_size
			self._string_v = self._string_v.slice(0, _string_v_size)
			self._string_v.append_array(other._string_v.slice(0, other._string_v_size))
			self._string_v_size += other._string_v_size
			self.bytes_v.append_array(other.bytes_v)
			self._elem_v = self._elem_v.slice(0, _elem_v_size)
			self._elem_v.append_array(other._elem_v.slice(0, other._elem_v_size))
			self._elem_v_size += other._elem_v_size
			self._elem_vd = self._elem_vd.slice(0, _elem_vd_size)
			self._elem_vd.append_array(other._elem_vd.slice(0, other._elem_vd_size))
			self._elem_vd_size += other._elem_vd_size
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		for item in self._int32_v:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self._int64_v:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self._uint32_v:
			GDScriptUtils.encode_tag(buffer, 3, 13)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self._uint64_v:
			GDScriptUtils.encode_tag(buffer, 4, 4)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self._sint32_v:
			GDScriptUtils.encode_tag(buffer, 5, 17)
			GDScriptUtils.encode_zigzag32(buffer, item)
		for item in self._sint64_v:
			GDScriptUtils.encode_tag(buffer, 6, 18)
			GDScriptUtils.encode_zigzag64(buffer, item)
		for item in self._fixed32_v:
			GDScriptUtils.encode_tag(buffer, 7, 7)
			GDScriptUtils.encode_int32(buffer, item)
		for item in self._fixed64_v:
			GDScriptUtils.encode_tag(buffer, 8, 6)
			GDScriptUtils.encode_int64(buffer, item)
		for item in self._sfixed32_v:
			GDScriptUtils.encode_tag(buffer, 9, 15)
			GDScriptUtils.encode_int32(buffer, item)
		for item in self._sfixed64_v:
			GDScriptUtils.encode_tag(buffer, 10, 16)
			GDScriptUtils.encode_int64(buffer, item)
		for item in self._float_v:
			GDScriptUtils.encode_tag(buffer, 11, 2)
			GDScriptUtils.encode_float(buffer, item)
		for item in self._double_v:
			GDScriptUtils.encode_tag(buffer, 12, 1)
			GDScriptUtils.encode_double(buffer, item)
		for item in self._bool_v:
			GDScriptUtils.encode_tag(buffer, 13, 8)
			GDScriptUtils.encode_bool(buffer, item)
		for item in self._string_v:
			GDScriptUtils.encode_tag(buffer, 14, 9)
			GDScriptUtils.encode_string(buffer, item)
		if len(self.bytes_v) > 0:
			GDScriptUtils.encode_tag(buffer, 15, 12)
			GDScriptUtils.encode_bytes(buffer, self.bytes_v)
		for item in self._elem_v:
			GDScriptUtils.encode_tag(buffer, 16, 14)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self._elem_vd:
			GDScriptUtils.encode_tag(buffer, 17, 14)
			GDScriptUtils.encode_varint(buffer, item)
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
					self.add_int32_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.add_int64_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.add_uint32_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.add_uint64_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_zigzag32(data, pos, self)
					self.add_sint32_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var field_value = GDScriptUtils.decode_zigzag64(data, pos, self)
					self.add_sint64_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				7:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.add_fixed32_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				8:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.add_fixed64_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				9:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.add_sfixed32_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				10:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.add_sfixed64_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				11:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.add_float_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				12:
					var field_value = GDScriptUtils.decode_double(data, pos, self)
					self.add_double_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				13:
					var field_value = GDScriptUtils.decode_bool(data, pos, self)
					self.add_bool_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				14:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.add_string_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				15:
					var field_value = GDScriptUtils.decode_bytes(data, pos, self)
					self.bytes_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				16:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.add_elem_v(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				17:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.add_elem_vd(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["int32_v"] = self._int32_v
		dict["int64_v"] = self._int64_v
		dict["uint32_v"] = self._uint32_v
		dict["uint64_v"] = self._uint64_v
		dict["sint32_v"] = self._sint32_v
		dict["sint64_v"] = self._sint64_v
		dict["fixed32_v"] = self._fixed32_v
		dict["fixed64_v"] = self._fixed64_v
		dict["sfixed32_v"] = self._sfixed32_v
		dict["sfixed64_v"] = self._sfixed64_v
		dict["float_v"] = self._float_v
		dict["double_v"] = self._double_v
		dict["bool_v"] = self._bool_v
		dict["string_v"] = self._string_v
		dict["bytes_v"] = self.bytes_v
		dict["elem_v"] = self._elem_v
		dict["elem_vd"] = self._elem_vd
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		self.clear_int32_v()
		if dict.has("int32_v"):
			var list = dict["int32_v"]
			for item in list:
				self.add_int32_v(item)
		self.clear_int64_v()
		if dict.has("int64_v"):
			var list = dict["int64_v"]
			for item in list:
				self.add_int64_v(item)
		self.clear_uint32_v()
		if dict.has("uint32_v"):
			var list = dict["uint32_v"]
			for item in list:
				self.add_uint32_v(item)
		self.clear_uint64_v()
		if dict.has("uint64_v"):
			var list = dict["uint64_v"]
			for item in list:
				self.add_uint64_v(item)
		self.clear_sint32_v()
		if dict.has("sint32_v"):
			var list = dict["sint32_v"]
			for item in list:
				self.add_sint32_v(item)
		self.clear_sint64_v()
		if dict.has("sint64_v"):
			var list = dict["sint64_v"]
			for item in list:
				self.add_sint64_v(item)
		self.clear_fixed32_v()
		if dict.has("fixed32_v"):
			var list = dict["fixed32_v"]
			for item in list:
				self.add_fixed32_v(item)
		self.clear_fixed64_v()
		if dict.has("fixed64_v"):
			var list = dict["fixed64_v"]
			for item in list:
				self.add_fixed64_v(item)
		self.clear_sfixed32_v()
		if dict.has("sfixed32_v"):
			var list = dict["sfixed32_v"]
			for item in list:
				self.add_sfixed32_v(item)
		self.clear_sfixed64_v()
		if dict.has("sfixed64_v"):
			var list = dict["sfixed64_v"]
			for item in list:
				self.add_sfixed64_v(item)
		self.clear_float_v()
		if dict.has("float_v"):
			var list = dict["float_v"]
			for item in list:
				self.add_float_v(item)
		self.clear_double_v()
		if dict.has("double_v"):
			var list = dict["double_v"]
			for item in list:
				self.add_double_v(item)
		self.clear_bool_v()
		if dict.has("bool_v"):
			var list = dict["bool_v"]
			for item in list:
				self.add_bool_v(item)
		self.clear_string_v()
		if dict.has("string_v"):
			var list = dict["string_v"]
			for item in list:
				self.add_string_v(item)
		if dict.has("bytes_v"):
			self.bytes_v = dict.get("bytes_v")
		self.clear_elem_v()
		if dict.has("elem_v"):
			var list = dict["elem_v"]
			for item in list:
				self.add_elem_v(item)
		self.clear_elem_vd()
		if dict.has("elem_vd"):
			var list = dict["elem_vd"]
			for item in list:
				self.add_elem_vd(item)

# =========================================
