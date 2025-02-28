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
	var msg_field32: int = 0
	var field64: Array[int] = []
	var msg_field2: String = ""
	var b_field3: bool = false
	var f_field4: float = 0.0
	var map_field5: Dictionary = {}
	var enum_field6: EnumTest = 0
	var sub_msg: MsgBase.SubMsg = null
	var common_msg: common.CommonMessage = null
	var common_enum: common.CommonEnum = 0
	var fixed_field32: int = 0
	var fixed_field64: int = 0
	var double_field: float = 0.0
	var map_field_sub: Dictionary = {}

	class SubMsg extends Message:
		var sub_field1: int = 0
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
						var value = GDScriptUtils.decode_varint(data, pos, self)
						self.sub_field1 = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					2:
						var value = GDScriptUtils.decode_string(data, pos, self)
						self.sub_field2 = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var _tmap = {}
			_tmap["sub_field1"] = self.sub_field1
			_tmap["sub_field2"] = self.sub_field2
			return _tmap

		func ParseFromDictionary(_fmap: Dictionary) -> void:
			if _fmap == null:
				return

			if "sub_field1" in _fmap:
				self.sub_field1 = _fmap["sub_field1"]
			if "sub_field2" in _fmap:
				self.sub_field2 = _fmap["sub_field2"]

	func Init() -> void:
		self.msg_field32 = 0
		self.field64 = []
		self.msg_field2 = ""
		self.b_field3 = false
		self.f_field4 = 0.0
		self.map_field5  = {}
		self.enum_field6 = 0
		if self.sub_msg != null:
			self.sub_msg.Init()
		if self.common_msg != null:
			self.common_msg.Init()
		self.common_enum = 0
		self.fixed_field32 = 0
		self.fixed_field64 = 0
		self.double_field = 0.0
		self.map_field_sub  = {}

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
			GDScriptUtils.encode_tag(buffer, 6, 11)
			var map_buffer = PackedByteArray()
			GDScriptUtils.encode_tag(map_buffer, 1, 5)
			GDScriptUtils.encode_varint(map_buffer, key)
			GDScriptUtils.encode_tag(map_buffer, 2, 9)
			GDScriptUtils.encode_string(map_buffer, self.map_field5[key])

			GDScriptUtils.encode_varint(buffer, map_buffer.size())
			buffer.append_array(map_buffer)
 
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
			GDScriptUtils.encode_double(buffer, self.double_field)
 
		for key in self.map_field_sub:
			GDScriptUtils.encode_tag(buffer, 14, 11)
			var map_buffer = PackedByteArray()
			GDScriptUtils.encode_tag(map_buffer, 1, 9)
			GDScriptUtils.encode_string(map_buffer, key)
			GDScriptUtils.encode_tag(map_buffer, 2, 11)
			GDScriptUtils.encode_message(map_buffer, self.map_field_sub[key])

			GDScriptUtils.encode_varint(buffer, map_buffer.size())
			buffer.append_array(map_buffer)
 
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
					self.msg_field32 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var item_value = []
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.field64.append(item_value)
				3:
					var value = GDScriptUtils.decode_string(data, pos, self)
					self.msg_field2 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_bool(data, pos, self)
					self.b_field3 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_float(data, pos, self)
					self.f_field4 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var map_length = GDScriptUtils.decode_varint(data, pos)
					pos += map_length[GDScriptUtils.SIZE_KEY]
					var map_buff = data.slice(pos, pos+map_length[GDScriptUtils.VALUE_KEY])
					var map_pos = 0
					var map_key: int = 0
					var map_value: String = ""
					while map_pos < map_buff.size():
						var m_tag = GDScriptUtils.decode_tag(map_buff, map_pos)
						var m_field_number = m_tag[GDScriptUtils.VALUE_KEY]
						map_pos += m_tag[GDScriptUtils.SIZE_KEY]
						match m_field_number:
							1:
								var key_value = GDScriptUtils.decode_varint(map_buff, map_pos, self)
								map_key = key_value[GDScriptUtils.VALUE_KEY]
								map_pos += key_value[GDScriptUtils.SIZE_KEY]
							2:
								var key_value = GDScriptUtils.decode_string(map_buff, map_pos, self)
								map_value = key_value[GDScriptUtils.VALUE_KEY]
								map_pos += key_value[GDScriptUtils.SIZE_KEY]
							_:
								pass

					pos += map_pos
					if map_pos > 0:
						self.map_field5[map_key] = map_value
				7:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.enum_field6 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				8:
					if self.sub_msg == null:
						self.sub_msg = MsgBase.SubMsg.new()
					else:
						self.sub_msg = MsgBase.SubMsg.new()
					var value = GDScriptUtils.decode_message(data, pos, self.sub_msg)
					self.sub_msg = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				9:
					if self.common_msg == null:
						self.common_msg = common.CommonMessage.new()
					else:
						self.common_msg = common.CommonMessage.new()
					var value = GDScriptUtils.decode_message(data, pos, self.common_msg)
					self.common_msg = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				10:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.common_enum = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				11:
					var value = GDScriptUtils.decode_int32(data, pos, self)
					self.fixed_field32 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				12:
					var value = GDScriptUtils.decode_int64(data, pos, self)
					self.fixed_field64 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				13:
					var value = GDScriptUtils.decode_double(data, pos, self)
					self.double_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				14:
					var map_length = GDScriptUtils.decode_varint(data, pos)
					pos += map_length[GDScriptUtils.SIZE_KEY]
					var map_buff = data.slice(pos, pos+map_length[GDScriptUtils.VALUE_KEY])
					var map_pos = 0
					var map_key: String = ""
					var map_value: MsgBase.SubMsg = null
					while map_pos < map_buff.size():
						var m_tag = GDScriptUtils.decode_tag(map_buff, map_pos)
						var m_field_number = m_tag[GDScriptUtils.VALUE_KEY]
						map_pos += m_tag[GDScriptUtils.SIZE_KEY]
						match m_field_number:
							1:
								var key_value = GDScriptUtils.decode_string(map_buff, map_pos, self)
								map_key = key_value[GDScriptUtils.VALUE_KEY]
								map_pos += key_value[GDScriptUtils.SIZE_KEY]
							2:
								if map_value == null:
									map_value = MsgBase.SubMsg.new()
								else:
									map_value = MsgBase.SubMsg.new()
								var key_value = GDScriptUtils.decode_message(map_buff, map_pos, map_value)
								map_value = key_value[GDScriptUtils.VALUE_KEY]
								map_pos += key_value[GDScriptUtils.SIZE_KEY]
							_:
								pass

					pos += map_pos
					if map_pos > 0:
						self.map_field_sub[map_key] = map_value
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		_tmap["msg_field32"] = self.msg_field32
		_tmap["field64"] = self.field64
		_tmap["msg_field2"] = self.msg_field2
		_tmap["b_field3"] = self.b_field3
		_tmap["f_field4"] = self.f_field4
		if not self.map_field5.is_empty():
			var map_dict = {}
			for key in self.map_field5:
				map_dict[key] = self.map_field5[key]
			_tmap["map_field5"] = map_dict
		_tmap["enum_field6"] = self.enum_field6
		if self.sub_msg != null:
			_tmap["sub_msg"] = self.sub_msg.SerializeToDictionary()
		if self.common_msg != null:
			_tmap["common_msg"] = self.common_msg.SerializeToDictionary()
		_tmap["common_enum"] = self.common_enum
		_tmap["fixed_field32"] = self.fixed_field32
		_tmap["fixed_field64"] = self.fixed_field64
		_tmap["double_field"] = self.double_field
		if not self.map_field_sub.is_empty():
			var map_dict = {}
			for key in self.map_field_sub:
				map_dict[key] = self.map_field_sub[key].SerializeToDictionary()
			_tmap["map_field_sub"] = map_dict
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "msg_field32" in _fmap:
			self.msg_field32 = _fmap["msg_field32"]
		if "field64" in _fmap:
			self.field64 = _fmap["field64"]
		if "msg_field2" in _fmap:
			self.msg_field2 = _fmap["msg_field2"]
		if "b_field3" in _fmap:
			self.b_field3 = _fmap["b_field3"]
		if "f_field4" in _fmap:
			self.f_field4 = _fmap["f_field4"]
		if "map_field5" in _fmap:
			var map_dict = _fmap["map_field5"]
			if map_dict != null:
				for key in map_dict:
					self.map_field5[key] = map_dict[key]
		if "enum_field6" in _fmap:
			self.enum_field6 = _fmap["enum_field6"]
		if "sub_msg" in _fmap:
			if _fmap["sub_msg"] != null:
				self.sub_msg.ParseFromDictionary(_fmap["sub_msg"])
		if "common_msg" in _fmap:
			if _fmap["common_msg"] != null:
				self.common_msg.ParseFromDictionary(_fmap["common_msg"])
		if "common_enum" in _fmap:
			self.common_enum = _fmap["common_enum"]
		if "fixed_field32" in _fmap:
			self.fixed_field32 = _fmap["fixed_field32"]
		if "fixed_field64" in _fmap:
			self.fixed_field64 = _fmap["fixed_field64"]
		if "double_field" in _fmap:
			self.double_field = _fmap["double_field"]
		if "map_field_sub" in _fmap:
			var map_dict = _fmap["map_field_sub"]
			if map_dict != null:
				for key in map_dict:
					var value = SubMsg.new()
					value.ParseFromDictionary(map_dict[key])
					self.map_field_sub[key] = value

# =========================================

class MsgTest extends Message:
	var common_msg: common.CommonMessage = null
	var common_enums: Array[common.CommonEnum] = []

	func Init() -> void:
		if self.common_msg != null:
			self.common_msg.Init()
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
					else:
						self.common_msg = common.CommonMessage.new()
					var value = GDScriptUtils.decode_message(data, pos, self.common_msg)
					self.common_msg = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var item_value = []
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.common_enums.append(item_value)
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		if self.common_msg != null:
			_tmap["common_msg"] = self.common_msg.SerializeToDictionary()
		_tmap["common_enums"] = self.common_enums
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "common_msg" in _fmap:
			if _fmap["common_msg"] != null:
				self.common_msg.ParseFromDictionary(_fmap["common_msg"])
		if "common_enums" in _fmap:
			self.common_enums = _fmap["common_enums"]

# =========================================
