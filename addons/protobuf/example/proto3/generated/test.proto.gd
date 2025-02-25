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
	var field64 = []
	var msg_field2: String = ""
	var b_field3: bool = false
	var f_field4: float = 0.0
	var map_field5: Dictionary = {}
	var enum_field6: EnumTest = 0
	var sub_msg: MsgBase.SubMsg = MsgBase.SubMsg.new()
	var common_msg: common.CommonMessage = common.CommonMessage.new()
	var common_enum: common.CommonEnum = 0
	var fixed_field32: int = 0
	var fixed_field64: int = 0
	var double_field: float = 0.0
	var map_field_sub: Dictionary = {}

	class SubMsg extends Message:
		var sub_field1: int = 0
		var sub_field2: String = ""

		func New() -> Message:
			return SubMsg.new()
 
		func MergeFrom(other : Message) -> void:
			if other is SubMsg:
				sub_field1 += other.sub_field1
				sub_field2 += other.sub_field2
 
		func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if sub_field1 != 0:
				GDScriptUtils.encode_tag(buffer, 1, 5)
				GDScriptUtils.encode_varint(buffer, sub_field1)
 
			if sub_field2 != "":
				GDScriptUtils.encode_tag(buffer, 2, 9)
				GDScriptUtils.encode_string(buffer, sub_field2)
 
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
						sub_field1 = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					2:
						var value = GDScriptUtils.decode_string(data, pos, self)
						sub_field2 = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var map = {}
			map["sub_field1"] = sub_field1
			map["sub_field2"] = sub_field2
			return map

		func ParseFromDictionary(data: Dictionary) -> void:
			if data == null:
				return

			if "sub_field1" in data:
				sub_field1 = data["sub_field1"]
			if "sub_field2" in data:
				sub_field2 = data["sub_field2"]

	func New() -> Message:
		return MsgBase.new()
 
	func MergeFrom(other : Message) -> void:
		if other is MsgBase:
			msg_field32 += other.msg_field32
			field64.append_array(other.field64)
			msg_field2 += other.msg_field2
			b_field3 = other.b_field3
			f_field4 += other.f_field4
			map_field5.merge(other.map_field5)
			enum_field6 = other.enum_field6
			sub_msg.MergeFrom(other.sub_msg)
			common_msg.MergeFrom(other.common_msg)
			common_enum = other.common_enum
			fixed_field32 += other.fixed_field32
			fixed_field64 += other.fixed_field64
			double_field += other.double_field
			map_field_sub.merge(other.map_field_sub)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if msg_field32 != 0:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, msg_field32)
 
		for item in field64:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, item)
 
		if msg_field2 != "":
			GDScriptUtils.encode_tag(buffer, 3, 9)
			GDScriptUtils.encode_string(buffer, msg_field2)
 
		if b_field3 != false:
			GDScriptUtils.encode_tag(buffer, 4, 8)
			GDScriptUtils.encode_bool(buffer, b_field3)
 
		if f_field4 != 0.0:
			GDScriptUtils.encode_tag(buffer, 5, 2)
			GDScriptUtils.encode_float(buffer, f_field4)
 
		for key in map_field5:
			GDScriptUtils.encode_tag(buffer, 6, 11)
			var map_buffer = PackedByteArray()
			GDScriptUtils.encode_tag(map_buffer, 1, 5)
			GDScriptUtils.encode_varint(map_buffer, key)
			GDScriptUtils.encode_tag(map_buffer, 2, 9)
			GDScriptUtils.encode_string(map_buffer, map_field5[key])

			GDScriptUtils.encode_varint(buffer, map_buffer.size())
			buffer.append_array(map_buffer)
 
		if enum_field6 != 0:
			GDScriptUtils.encode_tag(buffer, 7, 14)
			GDScriptUtils.encode_varint(buffer, enum_field6)
 
		if sub_msg != null:
			GDScriptUtils.encode_tag(buffer, 8, 11)
			GDScriptUtils.encode_message(buffer, sub_msg)
 
		if common_msg != null:
			GDScriptUtils.encode_tag(buffer, 9, 11)
			GDScriptUtils.encode_message(buffer, common_msg)
 
		if common_enum != 0:
			GDScriptUtils.encode_tag(buffer, 10, 14)
			GDScriptUtils.encode_varint(buffer, common_enum)
 
		if fixed_field32 != 0:
			GDScriptUtils.encode_tag(buffer, 11, 7)
			GDScriptUtils.encode_int32(buffer, fixed_field32)
 
		if fixed_field64 != 0:
			GDScriptUtils.encode_tag(buffer, 12, 6)
			GDScriptUtils.encode_int64(buffer, fixed_field64)
 
		if double_field != 0.0:
			GDScriptUtils.encode_tag(buffer, 13, 1)
			GDScriptUtils.encode_double(buffer, double_field)
 
		for key in map_field_sub:
			GDScriptUtils.encode_tag(buffer, 14, 11)
			var map_buffer = PackedByteArray()
			GDScriptUtils.encode_tag(map_buffer, 1, 9)
			GDScriptUtils.encode_string(map_buffer, key)
			GDScriptUtils.encode_tag(map_buffer, 2, 11)
			GDScriptUtils.encode_message(map_buffer, map_field_sub[key])

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
					msg_field32 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos)
					field64.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_string(data, pos, self)
					msg_field2 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_bool(data, pos, self)
					b_field3 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_float(data, pos, self)
					f_field4 = value[GDScriptUtils.VALUE_KEY]
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
						map_field5[map_key] = map_value
				7:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					enum_field6 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				8:
					var value = GDScriptUtils.decode_message(data, pos, sub_msg)
					sub_msg = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				9:
					var value = GDScriptUtils.decode_message(data, pos, common_msg)
					common_msg = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				10:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					common_enum = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				11:
					var value = GDScriptUtils.decode_int32(data, pos, self)
					fixed_field32 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				12:
					var value = GDScriptUtils.decode_int64(data, pos, self)
					fixed_field64 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				13:
					var value = GDScriptUtils.decode_double(data, pos, self)
					double_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				14:
					var map_length = GDScriptUtils.decode_varint(data, pos)
					pos += map_length[GDScriptUtils.SIZE_KEY]
					var map_buff = data.slice(pos, pos+map_length[GDScriptUtils.VALUE_KEY])
					var map_pos = 0
					var map_key: String = ""
					var map_value: MsgBase.SubMsg = MsgBase.SubMsg.new()
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
								var key_value = GDScriptUtils.decode_message(map_buff, map_pos, map_value)
								map_value = key_value[GDScriptUtils.VALUE_KEY]
								map_pos += key_value[GDScriptUtils.SIZE_KEY]
							_:
								pass

					pos += map_pos
					if map_pos > 0:
						map_field_sub[map_key] = map_value
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["msg_field32"] = msg_field32
		map["field64"] = field64
		map["msg_field2"] = msg_field2
		map["b_field3"] = b_field3
		map["f_field4"] = f_field4
		if not map_field5.is_empty():
			var map_dict = {}
			for key in map_field5:
				map_dict[key] = map_field5[key]
			map["map_field5"] = map_dict
		map["enum_field6"] = enum_field6
		if sub_msg != null:
			map["sub_msg"] = sub_msg.SerializeToDictionary()
		if common_msg != null:
			map["common_msg"] = common_msg.SerializeToDictionary()
		map["common_enum"] = common_enum
		map["fixed_field32"] = fixed_field32
		map["fixed_field64"] = fixed_field64
		map["double_field"] = double_field
		if not map_field_sub.is_empty():
			var map_dict = {}
			for key in map_field_sub:
				map_dict[key] = map_field_sub[key].SerializeToDictionary()
			map["map_field_sub"] = map_dict
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "msg_field32" in data:
			msg_field32 = data["msg_field32"]
		if "field64" in data:
			field64 = data["field64"]
		if "msg_field2" in data:
			msg_field2 = data["msg_field2"]
		if "b_field3" in data:
			b_field3 = data["b_field3"]
		if "f_field4" in data:
			f_field4 = data["f_field4"]
		if "map_field5" in data:
			var map_dict = data["map_field5"]
			if map_dict != null:
				for key in map_dict:
					map_field5[key] = map_dict[key]
		if "enum_field6" in data:
			enum_field6 = data["enum_field6"]
		if "sub_msg" in data:
			if data["sub_msg"] != null:
				sub_msg.ParseFromDictionary(data["sub_msg"])
		if "common_msg" in data:
			if data["common_msg"] != null:
				common_msg.ParseFromDictionary(data["common_msg"])
		if "common_enum" in data:
			common_enum = data["common_enum"]
		if "fixed_field32" in data:
			fixed_field32 = data["fixed_field32"]
		if "fixed_field64" in data:
			fixed_field64 = data["fixed_field64"]
		if "double_field" in data:
			double_field = data["double_field"]
		if "map_field_sub" in data:
			var map_dict = data["map_field_sub"]
			if map_dict != null:
				for key in map_dict:
					var value = SubMsg.new()
					value.ParseFromDictionary(map_dict[key])
					map_field_sub[key] = value

# =========================================

class MsgTest extends Message:
	var common_msg: common.CommonMessage = common.CommonMessage.new()
	var common_enums = []

	func New() -> Message:
		return MsgTest.new()
 
	func MergeFrom(other : Message) -> void:
		if other is MsgTest:
			common_msg.MergeFrom(other.common_msg)
			common_enums.append_array(other.common_enums)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if common_msg != null:
			GDScriptUtils.encode_tag(buffer, 1, 11)
			GDScriptUtils.encode_message(buffer, common_msg)
 
		for item in common_enums:
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
					var value = GDScriptUtils.decode_message(data, pos, common_msg)
					common_msg = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos)
					common_enums.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		if common_msg != null:
			map["common_msg"] = common_msg.SerializeToDictionary()
		map["common_enums"] = common_enums
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "common_msg" in data:
			if data["common_msg"] != null:
				common_msg.ParseFromDictionary(data["common_msg"])
		if "common_enums" in data:
			common_enums = data["common_enums"]

# =========================================

