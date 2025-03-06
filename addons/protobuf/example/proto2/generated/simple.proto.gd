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
 
	#1
	var int32_v: int = 0
	#2
	var int64_v: int = 0
	#3
	var uint32_v: int = 0
	#4
	var uint64_v: int = 0
	#5
	var sint32_v: int = 0
	#6
	var sint64_v: int = 0
	#7
	var fixed32_v: int = 0
	#8
	var fixed64_v: int = 0
	#9
	var sfixed32_v: int = 0
	#10
	var sfixed64_v: int = 0
	#11
	var float_v: float = 0.0
	#12
	var double_v: float = 0.0
	#13
	var bool_v: bool = false
	#14
	var string_v: String = ""
	#15
	var bytes_v: PackedByteArray = PackedByteArray()
	#16
	var elem_v: SimpleEnum = 0
	#17
	var elem_vd: SimpleMessage.EnumDemo = 0

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

	func New() -> Message:
		var msg = SimpleMessage.new()
		return msg

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
	#1
	var int32_v: int = 101
	#2
	var int64_v: int = 102
	#3
	var uint32_v: int = 103
	#4
	var uint64_v: int = 104
	#5
	var sint32_v: int = 105
	#6
	var sint64_v: int = 106
	#7
	var fixed32_v: int = 107
	#8
	var fixed64_v: int = 108
	#9
	var sfixed32_v: int = 109
	#10
	var sfixed64_v: int = 110
	#11
	var float_v: float = 11.1
	#12
	var double_v: float = 11.2
	#13
	var bool_v: bool = true
	#14
	var string_v: String = "simple_demo"
	#15
	var bytes_v: PackedByteArray = PackedByteArray()
	#16
	var elem_v: SimpleEnum = SimpleEnum.VALUE1
	#17
	var elem_vd: SimpleMessage.EnumDemo = SimpleMessage.EnumDemo.E_VALUE1

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

	func New() -> Message:
		var msg = SimpleDefaultMessage.new()
		return msg

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
	#1
	var int32_v: Array[int] = []
	#2
	var int64_v: Array[int] = []
	#3
	var uint32_v: Array[int] = []
	#4
	var uint64_v: Array[int] = []
	#5
	var sint32_v: Array[int] = []
	#6
	var sint64_v: Array[int] = []
	#7
	var fixed32_v: Array[int] = []
	#8
	var fixed64_v: Array[int] = []
	#9
	var sfixed32_v: Array[int] = []
	#10
	var sfixed64_v: Array[int] = []
	#11
	var float_v: Array[float] = []
	#12
	var double_v: Array[float] = []
	#13
	var bool_v: Array[bool] = []
	#14
	var string_v: Array[String] = []
	#15
	var bytes_v: PackedByteArray = PackedByteArray()
	#16
	var elem_v: Array[SimpleEnum] = []
	#17
	var elem_vd: Array[SimpleMessage.EnumDemo] = []

	func Init() -> void:
		self.int32_v = []
		self.int64_v = []
		self.uint32_v = []
		self.uint64_v = []
		self.sint32_v = []
		self.sint64_v = []
		self.fixed32_v = []
		self.fixed64_v = []
		self.sfixed32_v = []
		self.sfixed64_v = []
		self.float_v = []
		self.double_v = []
		self.bool_v = []
		self.string_v = []
		self.bytes_v = PackedByteArray()
		self.elem_v = []
		self.elem_vd = []

	func New() -> Message:
		var msg = SimpleRepeatedMessage.new()
		return msg

	func MergeFrom(other : Message) -> void:
		if other is SimpleRepeatedMessage:
			self.int32_v.append_array(other.int32_v)
			self.int64_v.append_array(other.int64_v)
			self.uint32_v.append_array(other.uint32_v)
			self.uint64_v.append_array(other.uint64_v)
			self.sint32_v.append_array(other.sint32_v)
			self.sint64_v.append_array(other.sint64_v)
			self.fixed32_v.append_array(other.fixed32_v)
			self.fixed64_v.append_array(other.fixed64_v)
			self.sfixed32_v.append_array(other.sfixed32_v)
			self.sfixed64_v.append_array(other.sfixed64_v)
			self.float_v.append_array(other.float_v)
			self.double_v.append_array(other.double_v)
			self.bool_v.append_array(other.bool_v)
			self.string_v.append_array(other.string_v)
			self.bytes_v.append_array(other.bytes_v)
			self.elem_v.append_array(other.elem_v)
			self.elem_vd.append_array(other.elem_vd)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		for item in self.int32_v:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self.int64_v:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self.uint32_v:
			GDScriptUtils.encode_tag(buffer, 3, 13)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self.uint64_v:
			GDScriptUtils.encode_tag(buffer, 4, 4)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self.sint32_v:
			GDScriptUtils.encode_tag(buffer, 5, 17)
			GDScriptUtils.encode_zigzag32(buffer, item)
		for item in self.sint64_v:
			GDScriptUtils.encode_tag(buffer, 6, 18)
			GDScriptUtils.encode_zigzag64(buffer, item)
		for item in self.fixed32_v:
			GDScriptUtils.encode_tag(buffer, 7, 7)
			GDScriptUtils.encode_int32(buffer, item)
		for item in self.fixed64_v:
			GDScriptUtils.encode_tag(buffer, 8, 6)
			GDScriptUtils.encode_int64(buffer, item)
		for item in self.sfixed32_v:
			GDScriptUtils.encode_tag(buffer, 9, 15)
			GDScriptUtils.encode_int32(buffer, item)
		for item in self.sfixed64_v:
			GDScriptUtils.encode_tag(buffer, 10, 16)
			GDScriptUtils.encode_int64(buffer, item)
		for item in self.float_v:
			GDScriptUtils.encode_tag(buffer, 11, 2)
			GDScriptUtils.encode_float(buffer, item)
		for item in self.double_v:
			GDScriptUtils.encode_tag(buffer, 12, 1)
			GDScriptUtils.encode_double(buffer, item)
		for item in self.bool_v:
			GDScriptUtils.encode_tag(buffer, 13, 8)
			GDScriptUtils.encode_bool(buffer, item)
		for item in self.string_v:
			GDScriptUtils.encode_tag(buffer, 14, 9)
			GDScriptUtils.encode_string(buffer, item)
		if len(self.bytes_v) > 0:
			GDScriptUtils.encode_tag(buffer, 15, 12)
			GDScriptUtils.encode_bytes(buffer, self.bytes_v)
		for item in self.elem_v:
			GDScriptUtils.encode_tag(buffer, 16, 14)
			GDScriptUtils.encode_varint(buffer, item)
		for item in self.elem_vd:
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
					self.int32_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.int64_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint32_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint64_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_zigzag32(data, pos, self)
					self.sint32_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var field_value = GDScriptUtils.decode_zigzag64(data, pos, self)
					self.sint64_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				7:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.fixed32_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				8:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.fixed64_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				9:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.sfixed32_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				10:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.sfixed64_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				11:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.float_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				12:
					var field_value = GDScriptUtils.decode_double(data, pos, self)
					self.double_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				13:
					var field_value = GDScriptUtils.decode_bool(data, pos, self)
					self.bool_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				14:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.string_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				15:
					var field_value = GDScriptUtils.decode_bytes(data, pos, self)
					self.bytes_v = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				16:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.elem_v.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				17:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.elem_vd.append(field_value[GDScriptUtils.VALUE_KEY])
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

			self.int32_v = dict.get("int32_v")
			self.int64_v = dict.get("int64_v")
			self.uint32_v = dict.get("uint32_v")
			self.uint64_v = dict.get("uint64_v")
			self.sint32_v = dict.get("sint32_v")
			self.sint64_v = dict.get("sint64_v")
			self.fixed32_v = dict.get("fixed32_v")
			self.fixed64_v = dict.get("fixed64_v")
			self.sfixed32_v = dict.get("sfixed32_v")
			self.sfixed64_v = dict.get("sfixed64_v")
			self.float_v = dict.get("float_v")
			self.double_v = dict.get("double_v")
			self.bool_v = dict.get("bool_v")
			self.string_v = dict.get("string_v")
		if dict.has("bytes_v"):
			self.bytes_v = dict.get("bytes_v")
			self.elem_v = dict.get("elem_v")
			self.elem_vd = dict.get("elem_vd")

# =========================================
