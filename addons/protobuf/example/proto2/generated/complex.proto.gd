# Package: 

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")

class ComplexMessage extends Message:
	enum Status {
		UNKNOWN = 0,
		ACTIVE = 1,
		INACTIVE = 2,
		PENDING = 3,
	} 
 
	var int_field: int = 0
	var long_field: int = 1000000
	var bool_field: bool = true
	var float_field: float = 3.14
	var string_field: String = "hello"
	var bytes_field: PackedByteArray = PackedByteArray()
	var status: ComplexMessage.Status = ComplexMessage.Status.UNKNOWN
	var nested_messages = []
	var name: String = ""
	var id: int = 0
	var message: ComplexMessage.NestedMessage = ComplexMessage.NestedMessage.new()
	var status_list = []

	class NestedMessage extends Message:
		var id: String = ""
		var value: int = 0
		var deep: ComplexMessage.NestedMessage.DeepNested = ComplexMessage.NestedMessage.DeepNested.new()

		class DeepNested extends Message:
			var data: String = ""
			var numbers = []

			func New() -> Message:
				return DeepNested.new()
 
			func MergeFrom(other : Message) -> void:
				if other is DeepNested:
					data += other.data
					numbers.append_array(other.numbers)
 
			func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
				if data != "":
					GDScriptUtils.encode_tag(buffer, 1, 9)
					GDScriptUtils.encode_string(buffer, data)
 
				for item in numbers:
					GDScriptUtils.encode_tag(buffer, 2, 5)
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
							var value = GDScriptUtils.decode_string(data, pos, self)
							data = value[GDScriptUtils.VALUE_KEY]
							pos += value[GDScriptUtils.SIZE_KEY]
						2:
							var value = GDScriptUtils.decode_varint(data, pos)
							numbers.append_array([value[GDScriptUtils.VALUE_KEY]])
							pos += value[GDScriptUtils.SIZE_KEY]
						_:
							pass

				return pos

			func SerializeToDictionary() -> Dictionary:
				var map = {}
				map["data"] = data
				map["numbers"] = numbers
				return map

			func ParseFromDictionary(data: Dictionary) -> void:
				if data == null:
					return

				if "data" in data:
					data = data["data"]
				if "numbers" in data:
					numbers = data["numbers"]

		func New() -> Message:
			return NestedMessage.new()
 
		func MergeFrom(other : Message) -> void:
			if other is NestedMessage:
				id += other.id
				value += other.value
				deep.MergeFrom(other.deep)
 
		func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if id != "":
				GDScriptUtils.encode_tag(buffer, 1, 9)
				GDScriptUtils.encode_string(buffer, id)
 
			if value != 0:
				GDScriptUtils.encode_tag(buffer, 2, 5)
				GDScriptUtils.encode_varint(buffer, value)
 
			if deep != null:
				GDScriptUtils.encode_tag(buffer, 3, 11)
				GDScriptUtils.encode_message(buffer, deep)
 
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
						var value = GDScriptUtils.decode_string(data, pos, self)
						id = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					2:
						var value = GDScriptUtils.decode_varint(data, pos, self)
						value = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					3:
						var value = GDScriptUtils.decode_message(data, pos, deep)
						deep = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var map = {}
			map["id"] = id
			map["value"] = value
			if deep != null:
				map["deep"] = deep.SerializeToDictionary()
			return map

		func ParseFromDictionary(data: Dictionary) -> void:
			if data == null:
				return

			if "id" in data:
				id = data["id"]
			if "value" in data:
				value = data["value"]
			if "deep" in data:
				if data["deep"] != null:
					deep.ParseFromDictionary(data["deep"])

	func New() -> Message:
		return ComplexMessage.new()
 
	func MergeFrom(other : Message) -> void:
		if other is ComplexMessage:
			int_field += other.int_field
			long_field += other.long_field
			bool_field = other.bool_field
			float_field += other.float_field
			string_field += other.string_field
			bytes_field.append_array(other.bytes_field)
			status = other.status
			nested_messages.append_array(other.nested_messages)
			name += other.name
			id += other.id
			message.MergeFrom(other.message)
			status_list.append_array(other.status_list)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if int_field != 0:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, int_field)
 
		if long_field != 1000000:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, long_field)
 
		if bool_field != true:
			GDScriptUtils.encode_tag(buffer, 3, 8)
			GDScriptUtils.encode_bool(buffer, bool_field)
 
		if float_field != 3.14:
			GDScriptUtils.encode_tag(buffer, 4, 2)
			GDScriptUtils.encode_float(buffer, float_field)
 
		if string_field != "hello":
			GDScriptUtils.encode_tag(buffer, 5, 9)
			GDScriptUtils.encode_string(buffer, string_field)
 
		if bytes_field != PackedByteArray():
			GDScriptUtils.encode_tag(buffer, 6, 12)
			GDScriptUtils.encode_bytes(buffer, bytes_field)
 
		if status != ComplexMessage.Status.UNKNOWN:
			GDScriptUtils.encode_tag(buffer, 7, 14)
			GDScriptUtils.encode_varint(buffer, status)
 
		for item in nested_messages:
			GDScriptUtils.encode_tag(buffer, 8, 11)
			GDScriptUtils.encode_message(buffer, item)
 
		if name != "":
			GDScriptUtils.encode_tag(buffer, 11, 9)
			GDScriptUtils.encode_string(buffer, name)
 
		if id != 0:
			GDScriptUtils.encode_tag(buffer, 12, 5)
			GDScriptUtils.encode_varint(buffer, id)
 
		if message != null:
			GDScriptUtils.encode_tag(buffer, 13, 11)
			GDScriptUtils.encode_message(buffer, message)
 
		for item in status_list:
			GDScriptUtils.encode_tag(buffer, 14, 14)
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
					var value = GDScriptUtils.decode_varint(data, pos, self)
					int_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					long_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_bool(data, pos, self)
					bool_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_float(data, pos, self)
					float_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_string(data, pos, self)
					string_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var value = GDScriptUtils.decode_bytes(data, pos, self)
					bytes_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				7:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					status = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				8:
					var value = GDScriptUtils.decode_message(data, pos)
					nested_messages.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				11:
					var value = GDScriptUtils.decode_string(data, pos, self)
					name = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				12:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					id = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				13:
					var value = GDScriptUtils.decode_message(data, pos, message)
					message = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				14:
					var value = GDScriptUtils.decode_varint(data, pos)
					status_list.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["int_field"] = int_field
		map["long_field"] = long_field
		map["bool_field"] = bool_field
		map["float_field"] = float_field
		map["string_field"] = string_field
		map["bytes_field"] = bytes_field
		map["status"] = status
		map["nested_messages"] = nested_messages
		map["name"] = name
		map["id"] = id
		if message != null:
			map["message"] = message.SerializeToDictionary()
		map["status_list"] = status_list
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "int_field" in data:
			int_field = data["int_field"]
		if "long_field" in data:
			long_field = data["long_field"]
		if "bool_field" in data:
			bool_field = data["bool_field"]
		if "float_field" in data:
			float_field = data["float_field"]
		if "string_field" in data:
			string_field = data["string_field"]
		if "bytes_field" in data:
			bytes_field = data["bytes_field"]
		if "status" in data:
			status = data["status"]
		if "nested_messages" in data:
			nested_messages = data["nested_messages"]
		if "name" in data:
			name = data["name"]
		if "id" in data:
			id = data["id"]
		if "message" in data:
			if data["message"] != null:
				message.ParseFromDictionary(data["message"])
		if "status_list" in data:
			status_list = data["status_list"]

# =========================================

class TreeNode extends Message:
	var value: String = ""
	var children = []
	var parent: TreeNode = TreeNode.new()

	func New() -> Message:
		return TreeNode.new()
 
	func MergeFrom(other : Message) -> void:
		if other is TreeNode:
			value += other.value
			children.append_array(other.children)
			parent.MergeFrom(other.parent)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if value != "":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, value)
 
		for item in children:
			GDScriptUtils.encode_tag(buffer, 2, 11)
			GDScriptUtils.encode_message(buffer, item)
 
		if parent != null:
			GDScriptUtils.encode_tag(buffer, 3, 11)
			GDScriptUtils.encode_message(buffer, parent)
 
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
					var value = GDScriptUtils.decode_string(data, pos, self)
					value = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_message(data, pos)
					children.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_message(data, pos, parent)
					parent = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["value"] = value
		map["children"] = children
		if parent != null:
			map["parent"] = parent.SerializeToDictionary()
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "value" in data:
			value = data["value"]
		if "children" in data:
			children = data["children"]
		if "parent" in data:
			if data["parent"] != null:
				parent.ParseFromDictionary(data["parent"])

# =========================================

class NumberTypes extends Message:
	var int32_field: int = -42
	var int64_field: int = -9223372036854775808
	var uint32_field: int = 4294967295
	var uint64_field: int = 9223372036854775807
	var sint32_field: int = -2147483648
	var sint64_field: int = -9223372036854775808
	var fixed32_field: int = 4294967295
	var fixed64_field: int = 9223372036854775807
	var sfixed32_field: int = -2147483648
	var sfixed64_field: int = -9223372036854775808
	var float_field: float = 3.40282347e+38
	var double_field: float = 2.2250738585072014e-308

	func New() -> Message:
		return NumberTypes.new()
 
	func MergeFrom(other : Message) -> void:
		if other is NumberTypes:
			int32_field += other.int32_field
			int64_field += other.int64_field
			uint32_field += other.uint32_field
			uint64_field += other.uint64_field
			sint32_field += other.sint32_field
			sint64_field += other.sint64_field
			fixed32_field += other.fixed32_field
			fixed64_field += other.fixed64_field
			sfixed32_field += other.sfixed32_field
			sfixed64_field += other.sfixed64_field
			float_field += other.float_field
			double_field += other.double_field
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if int32_field != -42:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, int32_field)
 
		if int64_field != -9223372036854775808:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, int64_field)
 
		if uint32_field != 4294967295:
			GDScriptUtils.encode_tag(buffer, 3, 13)
			GDScriptUtils.encode_varint(buffer, uint32_field)
 
		if uint64_field != 9223372036854775807:
			GDScriptUtils.encode_tag(buffer, 4, 4)
			GDScriptUtils.encode_varint(buffer, uint64_field)
 
		if sint32_field != -2147483648:
			GDScriptUtils.encode_tag(buffer, 5, 17)
			GDScriptUtils.encode_zigzag32(buffer, sint32_field)
 
		if sint64_field != -9223372036854775808:
			GDScriptUtils.encode_tag(buffer, 6, 18)
			GDScriptUtils.encode_zigzag64(buffer, sint64_field)
 
		if fixed32_field != 4294967295:
			GDScriptUtils.encode_tag(buffer, 7, 7)
			GDScriptUtils.encode_int32(buffer, fixed32_field)
 
		if fixed64_field != 9223372036854775807:
			GDScriptUtils.encode_tag(buffer, 8, 6)
			GDScriptUtils.encode_int64(buffer, fixed64_field)
 
		if sfixed32_field != -2147483648:
			GDScriptUtils.encode_tag(buffer, 9, 15)
			GDScriptUtils.encode_int32(buffer, sfixed32_field)
 
		if sfixed64_field != -9223372036854775808:
			GDScriptUtils.encode_tag(buffer, 10, 16)
			GDScriptUtils.encode_int64(buffer, sfixed64_field)
 
		if float_field != 3.40282347e+38:
			GDScriptUtils.encode_tag(buffer, 11, 2)
			GDScriptUtils.encode_float(buffer, float_field)
 
		if double_field != 2.2250738585072014e-308:
			GDScriptUtils.encode_tag(buffer, 12, 1)
			GDScriptUtils.encode_double(buffer, double_field)
 
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
					int32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					int64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					uint32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					uint64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_zigzag32(data, pos, self)
					sint32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var value = GDScriptUtils.decode_zigzag64(data, pos, self)
					sint64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				7:
					var value = GDScriptUtils.decode_int32(data, pos, self)
					fixed32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				8:
					var value = GDScriptUtils.decode_int64(data, pos, self)
					fixed64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				9:
					var value = GDScriptUtils.decode_int32(data, pos, self)
					sfixed32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				10:
					var value = GDScriptUtils.decode_int64(data, pos, self)
					sfixed64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				11:
					var value = GDScriptUtils.decode_float(data, pos, self)
					float_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				12:
					var value = GDScriptUtils.decode_double(data, pos, self)
					double_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["int32_field"] = int32_field
		map["int64_field"] = int64_field
		map["uint32_field"] = uint32_field
		map["uint64_field"] = uint64_field
		map["sint32_field"] = sint32_field
		map["sint64_field"] = sint64_field
		map["fixed32_field"] = fixed32_field
		map["fixed64_field"] = fixed64_field
		map["sfixed32_field"] = sfixed32_field
		map["sfixed64_field"] = sfixed64_field
		map["float_field"] = float_field
		map["double_field"] = double_field
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "int32_field" in data:
			int32_field = data["int32_field"]
		if "int64_field" in data:
			int64_field = data["int64_field"]
		if "uint32_field" in data:
			uint32_field = data["uint32_field"]
		if "uint64_field" in data:
			uint64_field = data["uint64_field"]
		if "sint32_field" in data:
			sint32_field = data["sint32_field"]
		if "sint64_field" in data:
			sint64_field = data["sint64_field"]
		if "fixed32_field" in data:
			fixed32_field = data["fixed32_field"]
		if "fixed64_field" in data:
			fixed64_field = data["fixed64_field"]
		if "sfixed32_field" in data:
			sfixed32_field = data["sfixed32_field"]
		if "sfixed64_field" in data:
			sfixed64_field = data["sfixed64_field"]
		if "float_field" in data:
			float_field = data["float_field"]
		if "double_field" in data:
			double_field = data["double_field"]

# =========================================

class DefaultValues extends Message:
	var int_with_default: int = 42
	var string_with_default: String = "default string"
	var bytes_with_default: PackedByteArray = PackedByteArray("default bytes".to_utf8_buffer())
	var bool_with_default: bool = true
	var float_with_default: float = 3.14159
	var enum_with_default: ComplexMessage.Status = ComplexMessage.Status.ACTIVE

	func New() -> Message:
		return DefaultValues.new()
 
	func MergeFrom(other : Message) -> void:
		if other is DefaultValues:
			int_with_default += other.int_with_default
			string_with_default += other.string_with_default
			bytes_with_default.append_array(other.bytes_with_default)
			bool_with_default = other.bool_with_default
			float_with_default += other.float_with_default
			enum_with_default = other.enum_with_default
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if int_with_default != 42:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, int_with_default)
 
		if string_with_default != "default string":
			GDScriptUtils.encode_tag(buffer, 2, 9)
			GDScriptUtils.encode_string(buffer, string_with_default)
 
		if bytes_with_default != PackedByteArray("default bytes".to_utf8_buffer()):
			GDScriptUtils.encode_tag(buffer, 3, 12)
			GDScriptUtils.encode_bytes(buffer, bytes_with_default)
 
		if bool_with_default != true:
			GDScriptUtils.encode_tag(buffer, 4, 8)
			GDScriptUtils.encode_bool(buffer, bool_with_default)
 
		if float_with_default != 3.14159:
			GDScriptUtils.encode_tag(buffer, 5, 2)
			GDScriptUtils.encode_float(buffer, float_with_default)
 
		if enum_with_default != ComplexMessage.Status.ACTIVE:
			GDScriptUtils.encode_tag(buffer, 6, 14)
			GDScriptUtils.encode_varint(buffer, enum_with_default)
 
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
					int_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_string(data, pos, self)
					string_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_bytes(data, pos, self)
					bytes_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_bool(data, pos, self)
					bool_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_float(data, pos, self)
					float_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					enum_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["int_with_default"] = int_with_default
		map["string_with_default"] = string_with_default
		map["bytes_with_default"] = bytes_with_default
		map["bool_with_default"] = bool_with_default
		map["float_with_default"] = float_with_default
		map["enum_with_default"] = enum_with_default
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "int_with_default" in data:
			int_with_default = data["int_with_default"]
		if "string_with_default" in data:
			string_with_default = data["string_with_default"]
		if "bytes_with_default" in data:
			bytes_with_default = data["bytes_with_default"]
		if "bool_with_default" in data:
			bool_with_default = data["bool_with_default"]
		if "float_with_default" in data:
			float_with_default = data["float_with_default"]
		if "enum_with_default" in data:
			enum_with_default = data["enum_with_default"]

# =========================================

class FieldRules extends Message:
	var required_field: String = ""
	var optional_field: String = ""
	var repeated_field = []
	var required_message: ComplexMessage.NestedMessage = ComplexMessage.NestedMessage.new()
	var optional_message: ComplexMessage.NestedMessage = ComplexMessage.NestedMessage.new()
	var repeated_message = []

	func New() -> Message:
		return FieldRules.new()
 
	func MergeFrom(other : Message) -> void:
		if other is FieldRules:
			required_field += other.required_field
			optional_field += other.optional_field
			repeated_field.append_array(other.repeated_field)
			required_message.MergeFrom(other.required_message)
			optional_message.MergeFrom(other.optional_message)
			repeated_message.append_array(other.repeated_message)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if required_field != "":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, required_field)
 
		if optional_field != "":
			GDScriptUtils.encode_tag(buffer, 2, 9)
			GDScriptUtils.encode_string(buffer, optional_field)
 
		for item in repeated_field:
			GDScriptUtils.encode_tag(buffer, 3, 9)
			GDScriptUtils.encode_string(buffer, item)
 
		if required_message != null:
			GDScriptUtils.encode_tag(buffer, 4, 11)
			GDScriptUtils.encode_message(buffer, required_message)
 
		if optional_message != null:
			GDScriptUtils.encode_tag(buffer, 5, 11)
			GDScriptUtils.encode_message(buffer, optional_message)
 
		for item in repeated_message:
			GDScriptUtils.encode_tag(buffer, 6, 11)
			GDScriptUtils.encode_message(buffer, item)
 
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
					var value = GDScriptUtils.decode_string(data, pos, self)
					required_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_string(data, pos, self)
					optional_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_string(data, pos)
					repeated_field.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_message(data, pos, required_message)
					required_message = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_message(data, pos, optional_message)
					optional_message = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var value = GDScriptUtils.decode_message(data, pos)
					repeated_message.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["required_field"] = required_field
		map["optional_field"] = optional_field
		map["repeated_field"] = repeated_field
		if required_message != null:
			map["required_message"] = required_message.SerializeToDictionary()
		if optional_message != null:
			map["optional_message"] = optional_message.SerializeToDictionary()
		map["repeated_message"] = repeated_message
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "required_field" in data:
			required_field = data["required_field"]
		if "optional_field" in data:
			optional_field = data["optional_field"]
		if "repeated_field" in data:
			repeated_field = data["repeated_field"]
		if "required_message" in data:
			if data["required_message"] != null:
				required_message.ParseFromDictionary(data["required_message"])
		if "optional_message" in data:
			if data["optional_message"] != null:
				optional_message.ParseFromDictionary(data["optional_message"])
		if "repeated_message" in data:
			repeated_message = data["repeated_message"]

# =========================================

