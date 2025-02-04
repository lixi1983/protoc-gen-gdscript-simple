const GDScriptUtils = preload("res://protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://protobuf/proto/Message.gd")
const common = preload("./proto3/common.gd")

enum EnumTest {
	ENUM_TEST1 = 0,
	ENUM_TEST2 = 2,
	ENUM_TEST3 = 3,
} 
 
class MsgBase extends Message:
	var msg_field1: int = 0
	var field2 = []
	var msg_field2: String = ""
	var b_field3: bool = false
	var f_field4: float = 0.0
	var map_field5: Dictionary = {}
	var enum_field6: test.EnumTest = 0
	var sub_msg: test.SubMsg = test.SubMsg.new()
	var common_msg: common.CommonMessage = common.CommonMessage.new()
	var common_enum: common.CommonEnum = 0

	class SubMsg extends Message:
		var sub_field1: int = 0
		var sub_field2: String = ""

		func New() -> Message:
			return SubMsg.new()
 
		func MergeFrom(other : Message) -> void:
			if other is SubMsg:
				sub_field1 += other.sub_field1
				sub_field2 += other.sub_field2
 
		func SerializeToDictionary() -> Dictionary:
			var map = {}
			map["sub_field1"] = sub_field1
			map["sub_field2"] = sub_field2
			return map

		func SerializeToString(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if sub_field1 != 0:
				GDScriptUtils.encode_varint(buffer, 1)
				GDScriptUtils.encode_varint(buffer, sub_field1)
 
			if sub_field2 != "":
				GDScriptUtils.encode_varint(buffer, 2)
				GDScriptUtils.encode_string(buffer, sub_field2)
 
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
						sub_field1 = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					2:
						var value = GDScriptUtils.decode_string(data, pos, self)
						sub_field2 = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
						break
					_:
						pass

			return pos

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
			msg_field1 += other.msg_field1
			field2.append_array(other.field2.duplicate(true))
			msg_field2 += other.msg_field2
			b_field3 = other.b_field3
			f_field4 += other.f_field4
			map_field5.merge(other.map_field5)
			enum_field6 = other.enum_field6
			sub_msg.MergeFrom(other.sub_msg)
			common_msg.MergeFrom(other.common_msg)
			common_enum = other.common_enum
 
	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["msg_field1"] = msg_field1
		map["field2"] = field2
		map["msg_field2"] = msg_field2
		map["b_field3"] = b_field3
		map["f_field4"] = f_field4
		map["map_field5"] = map_field5
		map["enum_field6"] = enum_field6
		if sub_msg != null:
			map["sub_msg"] = sub_msg.SerializeToDictionary()
		if common_msg != null:
			map["common_msg"] = common_msg.SerializeToDictionary()
		map["common_enum"] = common_enum
		return map

	func SerializeToString(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if msg_field1 != 0:
			GDScriptUtils.encode_varint(buffer, 1)
			GDScriptUtils.encode_varint(buffer, msg_field1)
 
		for item in field2:
			GDScriptUtils.encode_varint(buffer, 2)
			GDScriptUtils.encode_varint(buffer, item)
 
		if msg_field2 != "":
			GDScriptUtils.encode_varint(buffer, 3)
			GDScriptUtils.encode_string(buffer, msg_field2)
 
		if b_field3 != false:
			GDScriptUtils.encode_varint(buffer, 4)
			GDScriptUtils.encode_bool(buffer, b_field3)
 
		if f_field4 != 0.0:
			GDScriptUtils.encode_varint(buffer, 5)
			GDScriptUtils.encode_float(buffer, f_field4)
 
		for key in map_field5:
			GDScriptUtils.encode_varint(buffer, 6)
			GDScriptUtils.encode_varint(buffer, key)
			GDScriptUtils.encode_string(buffer, map_field5[key])
 
		if enum_field6 != 0:
			GDScriptUtils.encode_varint(buffer, 7)
			GDScriptUtils.encode_varint(buffer, enum_field6)
 
		if sub_msg != test.SubMsg.new():
			GDScriptUtils.encode_varint(buffer, 8)
			GDScriptUtils.encode_message(buffer, sub_msg)
 
		if common_msg != common.CommonMessage.new():
			GDScriptUtils.encode_varint(buffer, 9)
			GDScriptUtils.encode_message(buffer, common_msg)
 
		if common_enum != 0:
			GDScriptUtils.encode_varint(buffer, 10)
			GDScriptUtils.encode_varint(buffer, common_enum)
 
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
					msg_field1 = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					field2.append_array([value[GDScriptUtils.VALUE_KEY]])
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
					var key_value = GDScriptUtils.decode_varint(data, pos)
					pos += key_value[GDScriptUtils.SIZE_KEY]
					var value_value = GDScriptUtils.decode_string(data, pos)
					map_field5[key_value[GDScriptUtils.VALUE_KEY]] = value_value[GDScriptUtils.VALUE_KEY]
					pos += value_value[GDScriptUtils.SIZE_KEY]
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
					break
				_:
					pass

		return pos

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "msg_field1" in data:
			msg_field1 = data["msg_field1"]
		if "field2" in data:
			field2 = data["field2"]
		if "msg_field2" in data:
			msg_field2 = data["msg_field2"]
		if "b_field3" in data:
			b_field3 = data["b_field3"]
		if "f_field4" in data:
			f_field4 = data["f_field4"]
		if "map_field5" in data:
			map_field5 = data["map_field5"]
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

# =========================================

class MsgTest extends Message:
	var common_msg: common.CommonMessage = common.CommonMessage.new()
	var common_enums = []

	func New() -> Message:
		return MsgTest.new()
 
	func MergeFrom(other : Message) -> void:
		if other is MsgTest:
			common_msg.MergeFrom(other.common_msg)
			common_enums.append_array(other.common_enums.duplicate(true))
 
	func SerializeToDictionary() -> Dictionary:
		var map = {}
		if common_msg != null:
			map["common_msg"] = common_msg.SerializeToDictionary()
		map["common_enums"] = common_enums
		return map

	func SerializeToString(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if common_msg != common.CommonMessage.new():
			GDScriptUtils.encode_varint(buffer, 1)
			GDScriptUtils.encode_message(buffer, common_msg)
 
		for item in common_enums:
			GDScriptUtils.encode_varint(buffer, 2)
			GDScriptUtils.encode_varint(buffer, item)
 
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
					var value = GDScriptUtils.decode_message(data, pos, common_msg)
					common_msg = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					common_enums.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
					break
				_:
					pass

		return pos

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "common_msg" in data:
			if data["common_msg"] != null:
				common_msg.ParseFromDictionary(data["common_msg"])
		if "common_enums" in data:
			common_enums = data["common_enums"]

# =========================================

