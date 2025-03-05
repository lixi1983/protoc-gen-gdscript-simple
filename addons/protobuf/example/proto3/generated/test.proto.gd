# Package: 

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")
const common = preload("./common.proto.gd")

enum EnumTest {
	ENUM_TEST1 = 0,
	ENUM_TEST2 = 2,
	ENUM_TEST3 = 3,
} 
 
class MsgBase extends Message:
	#1
	var msg_field32: int = 0
	#2
	var field64: Array[int] = []
	#3
	var msg_field2: String = ""
	#4
	var b_field3: bool = false
	#5
	var f_field4: float = 0.0
	#6
	var map_field5: Dictionary = {}
	#7
	var enum_field6: EnumTest = 0
	#8
	var sub_msg: MsgBase.SubMsg = null
	#9
	var common_msg: common.CommonMessage = null
	#10
	var common_enum: common.CommonEnum = 0
	#11
	var fixed_field32: int = 0
	#12
	var fixed_field64: int = 0
	#13
	var double_field: float = 0.0
	#14
	var map_field_sub: Dictionary = {}
	class SubMsg extends Message:
		#1
		var sub_field1: int = 0
		#2
		var sub_field2: String = ""

		func Init() -> void:
			self.sub_field1 = 0
			self.sub_field2 = ""

		func New() -> Message:
			var msg = SubMsg.new()
			return msg

		func MergeFrom(other : Message) -> void:
			if other is SubMsg:
				self.sub_field1 += other.sub_field1
				self.sub_field2 += other.sub_field2
 
		func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if self.sub_field1 != 0:
				GDScriptUtils.encode_tag(buffer, 1, 5)
				GDScriptUtils.encode_varint(buffer, self.sub_field1)
			if self.sub_field2 != "":
				GDScriptUtils.encode_tag(buffer, 2, 9)
				GDScriptUtils.encode_string(buffer, self.sub_field2)
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
						self.sub_field1 = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
					2:
						var field_value = GDScriptUtils.decode_string(data, pos, self)
						self.sub_field2 = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var dict = {}
			dict["sub_field1"] = self.sub_field1
			dict["sub_field2"] = self.sub_field2
			return dict

		func ParseFromDictionary(dict: Dictionary) -> void:
			if dict == null:
				return

			if dict.has("sub_field1"):
				self.sub_field1 = dict.get("sub_field1")
			if dict.has("sub_field2"):
				self.sub_field2 = dict.get("sub_field2")


	func Init() -> void:
		self.msg_field32 = 0
		self.field64 = []
		self.msg_field2 = ""
		self.b_field3 = false
		self.f_field4 = 0.0
		self.map_field5 = {}
		self.enum_field6 = 0
		if self.sub_msg != null:			self.sub_msg.clear()
		if self.common_msg != null:			self.common_msg.clear()
		self.common_enum = 0
		self.fixed_field32 = 0
		self.fixed_field64 = 0
		self.double_field = 0.0
		self.map_field_sub = {}

	func New() -> Message:
		var msg = MsgBase.new()
		return msg

	func MergeFrom(other : Message) -> void:
		if other is MsgBase:
			self.msg_field32 += other.msg_field32
			self.field64.append_array(other.field64)
			self.msg_field2 += other.msg_field2
			self.b_field3 = other.b_field3
			self.f_field4 += other.f_field4
			self.map_field5.merge(other.map_field5)
			self.enum_field6 = other.enum_field6
			if self.sub_msg == null:
				self.sub_msg = MsgBase.SubMsg.new()
			self.sub_msg.MergeFrom(other.sub_msg)
			if self.common_msg == null:
				self.common_msg = common.CommonMessage.new()
			self.common_msg.MergeFrom(other.common_msg)
			self.common_enum = other.common_enum
			self.fixed_field32 += other.fixed_field32
			self.fixed_field64 += other.fixed_field64
			self.double_field += other.double_field
			self.map_field_sub.merge(other.map_field_sub)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.msg_field32 != 0:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, self.msg_field32)
		for item in self.field64:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, item)
		if self.msg_field2 != "":
			GDScriptUtils.encode_tag(buffer, 3, 9)
			GDScriptUtils.encode_string(buffer, self.msg_field2)
		if self.b_field3 != false:
			GDScriptUtils.encode_tag(buffer, 4, 8)
			GDScriptUtils.encode_bool(buffer, self.b_field3)
		if self.f_field4 != 0.0:
			GDScriptUtils.encode_tag(buffer, 5, 2)
			GDScriptUtils.encode_float(buffer, self.f_field4)
		for key in self.map_field5:
			var map_buff = PackedByteArray()
			var value = self.map_field5[key]
			GDScriptUtils.encode_tag(map_buff, 1, 5)
			GDScriptUtils.encode_varint(map_buff, key)
			GDScriptUtils.encode_tag(map_buff, 2, 9)
			GDScriptUtils.encode_string(map_buff, value)
			GDScriptUtils.encode_tag(buffer, 6, 11)
			GDScriptUtils.encode_varint(buffer, map_buff.size())
			buffer.append_array(map_buff)

		if self.enum_field6 != 0:
			GDScriptUtils.encode_tag(buffer, 7, 14)
			GDScriptUtils.encode_varint(buffer, self.enum_field6)
		if self.sub_msg != null:
			GDScriptUtils.encode_tag(buffer, 8, 11)
			GDScriptUtils.encode_message(buffer, self.sub_msg)
		if self.common_msg != null:
			GDScriptUtils.encode_tag(buffer, 9, 11)
			GDScriptUtils.encode_message(buffer, self.common_msg)
		if self.common_enum != 0:
			GDScriptUtils.encode_tag(buffer, 10, 14)
			GDScriptUtils.encode_varint(buffer, self.common_enum)
		if self.fixed_field32 != 0:
			GDScriptUtils.encode_tag(buffer, 11, 7)
			GDScriptUtils.encode_int32(buffer, self.fixed_field32)
		if self.fixed_field64 != 0:
			GDScriptUtils.encode_tag(buffer, 12, 6)
			GDScriptUtils.encode_int64(buffer, self.fixed_field64)
		if self.double_field != 0.0:
			GDScriptUtils.encode_tag(buffer, 13, 1)
			GDScriptUtils.encode_float(buffer, self.double_field)
		for key in self.map_field_sub:
			var map_buff = PackedByteArray()
			var value = self.map_field_sub[key]
			GDScriptUtils.encode_tag(map_buff, 1, 9)
			GDScriptUtils.encode_string(map_buff, key)
			GDScriptUtils.encode_tag(map_buff, 2, 11)
			GDScriptUtils.encode_message(map_buff, value)
			GDScriptUtils.encode_tag(buffer, 14, 11)
			GDScriptUtils.encode_varint(buffer, map_buff.size())
			buffer.append_array(map_buff)

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
					self.msg_field32 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.field64.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.msg_field2 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_bool(data, pos, self)
					self.b_field3 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.f_field4 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var map_length = GDScriptUtils.decode_varint(data, pos)
					pos += map_length[GDScriptUtils.SIZE_KEY]
					var map_buff = data.slice(pos, pos+map_length[GDScriptUtils.VALUE_KEY])
					var map_pos = 0
					var map_key: int = 0
					var map_value: String = ""
					while map_pos < map_buff.size():
						var map_tag = GDScriptUtils.decode_tag(map_buff, map_pos)
						var map_field_number = map_tag[GDScriptUtils.VALUE_KEY]
						map_pos += map_tag[GDScriptUtils.SIZE_KEY]
						match map_field_number:
							1:
								var map_key_tag = GDScriptUtils.decode_varint(map_buff, map_pos, self)
								map_key = map_key_tag[GDScriptUtils.VALUE_KEY]
								map_pos += map_key_tag[GDScriptUtils.SIZE_KEY]
							2:
								var map_value_tag = GDScriptUtils.decode_string(map_buff, map_pos, self)
								map_value = map_value_tag[GDScriptUtils.VALUE_KEY]
								map_pos += map_value_tag[GDScriptUtils.SIZE_KEY]
							_:
								pass

					pos += map_pos
					if map_pos > 0:
						self.map_field5[map_key] = map_value
				7:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.enum_field6 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				8:
					if self.sub_msg == null:
						self.sub_msg = MsgBase.SubMsg.new()
					self.sub_msg.Init()
					var field_value = GDScriptUtils.decode_message(data, pos, self.sub_msg)
					self.sub_msg = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				9:
					if self.common_msg == null:
						self.common_msg = common.CommonMessage.new()
					self.common_msg.Init()
					var field_value = GDScriptUtils.decode_message(data, pos, self.common_msg)
					self.common_msg = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				10:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.common_enum = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				11:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.fixed_field32 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				12:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.fixed_field64 = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				13:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.double_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				14:
					var map_length = GDScriptUtils.decode_varint(data, pos)
					pos += map_length[GDScriptUtils.SIZE_KEY]
					var map_buff = data.slice(pos, pos+map_length[GDScriptUtils.VALUE_KEY])
					var map_pos = 0
					var map_key: String = ""
					var map_value: MsgBase.SubMsg = MsgBase.SubMsg.new()
					while map_pos < map_buff.size():
						var map_tag = GDScriptUtils.decode_tag(map_buff, map_pos)
						var map_field_number = map_tag[GDScriptUtils.VALUE_KEY]
						map_pos += map_tag[GDScriptUtils.SIZE_KEY]
						match map_field_number:
							1:
								var map_key_tag = GDScriptUtils.decode_string(map_buff, map_pos, self)
								map_key = map_key_tag[GDScriptUtils.VALUE_KEY]
								map_pos += map_key_tag[GDScriptUtils.SIZE_KEY]
							2:
								if self.value == null:
									self.value = MsgBase.SubMsg.new()
								self.value.Init()
								var map_value_tag = GDScriptUtils.decode_message(map_buff, map_pos, self.value)
								self.value = map_value_tag[GDScriptUtils.VALUE_KEY]
								map_pos += map_value_tag[GDScriptUtils.SIZE_KEY]
							_:
								pass

					pos += map_pos
					if map_pos > 0:
						self.map_field_sub[map_key] = map_value
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["msg_field32"] = self.msg_field32
		dict["field64"] = self.field64
		dict["msg_field2"] = self.msg_field2
		dict["b_field3"] = self.b_field3
		dict["f_field4"] = self.f_field4
		dict["map_field5"] = self.map_field5
		dict["enum_field6"] = self.enum_field6
		if self.sub_msg != null:
			dict["sub_msg"] = self.sub_msg.SerializeToDictionary()
		if self.common_msg != null:
			dict["common_msg"] = self.common_msg.SerializeToDictionary()
		dict["common_enum"] = self.common_enum
		dict["fixed_field32"] = self.fixed_field32
		dict["fixed_field64"] = self.fixed_field64
		dict["double_field"] = self.double_field
		dict["map_field_sub"] = self.map_field_sub
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("msg_field32"):
			self.msg_field32 = dict.get("msg_field32")
			self.field64 = dict.get("field64")
		if dict.has("msg_field2"):
			self.msg_field2 = dict.get("msg_field2")
		if dict.has("b_field3"):
			self.b_field3 = dict.get("b_field3")
		if dict.has("f_field4"):
			self.f_field4 = dict.get("f_field4")
		if dict.has("map_field5"):
			self.map_field5 = dict.get("map_field5")
		if dict.has("enum_field6"):
			self.enum_field6 = dict.get("enum_field6")
		if dict.has("sub_msg"):
			if self.sub_msg == null:
				self.sub_msg = MsgBase.SubMsg.new()
			self.sub_msg.Init()
			self.sub_msg.ParseFromDictionary(dict.get("sub_msg"))
		else:
			self.sub_msg = null
		if dict.has("common_msg"):
			if self.common_msg == null:
				self.common_msg = common.CommonMessage.new()
			self.common_msg.Init()
			self.common_msg.ParseFromDictionary(dict.get("common_msg"))
		else:
			self.common_msg = null
		if dict.has("common_enum"):
			self.common_enum = dict.get("common_enum")
		if dict.has("fixed_field32"):
			self.fixed_field32 = dict.get("fixed_field32")
		if dict.has("fixed_field64"):
			self.fixed_field64 = dict.get("fixed_field64")
		if dict.has("double_field"):
			self.double_field = dict.get("double_field")
		if dict.has("map_field_sub"):
			self.map_field_sub = dict.get("map_field_sub")

# =========================================

class MsgTest extends Message:
	#1
	var common_msg: common.CommonMessage = null
	#2
	var common_enums: Array[common.CommonEnum] = []

	func Init() -> void:
		if self.common_msg != null:			self.common_msg.clear()
		self.common_enums = []

	func New() -> Message:
		var msg = MsgTest.new()
		return msg

	func MergeFrom(other : Message) -> void:
		if other is MsgTest:
			if self.common_msg == null:
				self.common_msg = common.CommonMessage.new()
			self.common_msg.MergeFrom(other.common_msg)
			self.common_enums.append_array(other.common_enums)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.common_msg != null:
			GDScriptUtils.encode_tag(buffer, 1, 11)
			GDScriptUtils.encode_message(buffer, self.common_msg)
		for item in self.common_enums:
			GDScriptUtils.encode_tag(buffer, 2, 14)
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
					if self.common_msg == null:
						self.common_msg = common.CommonMessage.new()
					self.common_msg.Init()
					var field_value = GDScriptUtils.decode_message(data, pos, self.common_msg)
					self.common_msg = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.common_enums.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		if self.common_msg != null:
			dict["common_msg"] = self.common_msg.SerializeToDictionary()
		dict["common_enums"] = self.common_enums
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("common_msg"):
			if self.common_msg == null:
				self.common_msg = common.CommonMessage.new()
			self.common_msg.Init()
			self.common_msg.ParseFromDictionary(dict.get("common_msg"))
		else:
			self.common_msg = null
			self.common_enums = dict.get("common_enums")

# =========================================

