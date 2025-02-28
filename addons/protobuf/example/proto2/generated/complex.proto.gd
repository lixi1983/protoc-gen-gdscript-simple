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
	var message: ComplexMessage.NestedMessage = null
	var status_list = []

	class NestedMessage extends Message:
		var id: String = ""
		var value: int = 0
		var deep: ComplexMessage.NestedMessage.DeepNested = null

		class DeepNested extends Message:
			var data: String = ""
			var numbers = []

			func New() -> Message:
				return DeepNested.new()
 
			func MergeFrom(other : Message) -> void:
				if other is DeepNested:
					self.data += other.data
					self.numbers.append_array(other.numbers)
 
			func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
				if self.data != "":
					GDScriptUtils.encode_tag(buffer, 1, 9)
					GDScriptUtils.encode_string(buffer, self.data)
 
				for item in self.numbers:
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
							self.data = value[GDScriptUtils.VALUE_KEY]
							pos += value[GDScriptUtils.SIZE_KEY]
						2:
							var item_value = []
							var field_value = GDScriptUtils.decode_varint(data, pos, self)
							item_value = field_value[GDScriptUtils.VALUE_KEY]
							pos += field_value[GDScriptUtils.SIZE_KEY]
							self.numbers.append(item_value)
						_:
							pass

				return pos

			func SerializeToDictionary() -> Dictionary:
				var _tmap = {}
				_tmap["data"] = self.data
				_tmap["numbers"] = self.numbers
				return _tmap

			func ParseFromDictionary(_fmap: Dictionary) -> void:
				if _fmap == null:
					return

				if "data" in _fmap:
					self.data = _fmap["data"]
				if "numbers" in _fmap:
					self.numbers = _fmap["numbers"]

		func New() -> Message:
			return NestedMessage.new()
 
		func MergeFrom(other : Message) -> void:
			if other is NestedMessage:
				self.id += other.id
				self.value += other.value
				if self.deep == null:
					self.deep = ComplexMessage.NestedMessage.DeepNested.new()
				self.deep.MergeFrom(other.deep)
 
		func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if self.id != "":
				GDScriptUtils.encode_tag(buffer, 1, 9)
				GDScriptUtils.encode_string(buffer, self.id)
 
			if self.value != 0:
				GDScriptUtils.encode_tag(buffer, 2, 5)
				GDScriptUtils.encode_varint(buffer, self.value)
 
			if self.deep != null:
				GDScriptUtils.encode_tag(buffer, 3, 11)
				GDScriptUtils.encode_message(buffer, self.deep)
 
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
						self.id = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					2:
						var value = GDScriptUtils.decode_varint(data, pos, self)
						self.value = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					3:
						if self.deep == null:
							self.deep = ComplexMessage.NestedMessage.DeepNested.new()
						else:
							self.deep = ComplexMessage.NestedMessage.DeepNested.new()
						var value = GDScriptUtils.decode_message(data, pos, self.deep)
						self.deep = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var _tmap = {}
			_tmap["id"] = self.id
			_tmap["value"] = self.value
			if self.deep != null:
				_tmap["deep"] = self.deep.SerializeToDictionary()
			return _tmap

		func ParseFromDictionary(_fmap: Dictionary) -> void:
			if _fmap == null:
				return

			if "id" in _fmap:
				self.id = _fmap["id"]
			if "value" in _fmap:
				self.value = _fmap["value"]
			if "deep" in _fmap:
				if _fmap["deep"] != null:
					self.deep.ParseFromDictionary(_fmap["deep"])

	func New() -> Message:
		return ComplexMessage.new()
 
	func MergeFrom(other : Message) -> void:
		if other is ComplexMessage:
			self.int_field += other.int_field
			self.long_field += other.long_field
			self.bool_field = other.bool_field
			self.float_field += other.float_field
			self.string_field += other.string_field
			self.bytes_field.append_array(other.bytes_field)
			self.status = other.status
			self.nested_messages.append_array(other.nested_messages)
			self.name += other.name
			self.id += other.id
			if self.message == null:
				self.message = ComplexMessage.NestedMessage.new()
			self.message.MergeFrom(other.message)
			self.status_list.append_array(other.status_list)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.int_field != 0:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, self.int_field)
 
		if self.long_field != 1000000:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, self.long_field)
 
		if self.bool_field != true:
			GDScriptUtils.encode_tag(buffer, 3, 8)
			GDScriptUtils.encode_bool(buffer, self.bool_field)
 
		if self.float_field != 3.14:
			GDScriptUtils.encode_tag(buffer, 4, 2)
			GDScriptUtils.encode_float(buffer, self.float_field)
 
		if self.string_field != "hello":
			GDScriptUtils.encode_tag(buffer, 5, 9)
			GDScriptUtils.encode_string(buffer, self.string_field)
 
		if self.bytes_field != PackedByteArray():
			GDScriptUtils.encode_tag(buffer, 6, 12)
			GDScriptUtils.encode_bytes(buffer, self.bytes_field)
 
		if self.status != ComplexMessage.Status.UNKNOWN:
			GDScriptUtils.encode_tag(buffer, 7, 14)
			GDScriptUtils.encode_varint(buffer, self.status)
 
		for item in self.nested_messages:
			GDScriptUtils.encode_tag(buffer, 8, 11)
			GDScriptUtils.encode_message(buffer, item)
 
		if self.name != "":
			GDScriptUtils.encode_tag(buffer, 11, 9)
			GDScriptUtils.encode_string(buffer, self.name)
 
		if self.id != 0:
			GDScriptUtils.encode_tag(buffer, 12, 5)
			GDScriptUtils.encode_varint(buffer, self.id)
 
		if self.message != null:
			GDScriptUtils.encode_tag(buffer, 13, 11)
			GDScriptUtils.encode_message(buffer, self.message)
 
		for item in self.status_list:
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
					self.int_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.long_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_bool(data, pos, self)
					self.bool_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_float(data, pos, self)
					self.float_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_string(data, pos, self)
					self.string_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var value = GDScriptUtils.decode_bytes(data, pos, self)
					self.bytes_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				7:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.status = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				8:
					var item_value = ComplexMessage.NestedMessage.new()
					if item_value == null:
						item_value = ComplexMessage.NestedMessage.new()
					else:
						item_value = ComplexMessage.NestedMessage.new()
					var field_value = GDScriptUtils.decode_message(data, pos, item_value)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.nested_messages.append(item_value)
				11:
					var value = GDScriptUtils.decode_string(data, pos, self)
					self.name = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				12:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.id = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				13:
					if self.message == null:
						self.message = ComplexMessage.NestedMessage.new()
					else:
						self.message = ComplexMessage.NestedMessage.new()
					var value = GDScriptUtils.decode_message(data, pos, self.message)
					self.message = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				14:
					var item_value = []
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.status_list.append(item_value)
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		_tmap["int_field"] = self.int_field
		_tmap["long_field"] = self.long_field
		_tmap["bool_field"] = self.bool_field
		_tmap["float_field"] = self.float_field
		_tmap["string_field"] = self.string_field
		_tmap["bytes_field"] = self.bytes_field
		_tmap["status"] = self.status
		_tmap["nested_messages"] = self.nested_messages
		_tmap["name"] = self.name
		_tmap["id"] = self.id
		if self.message != null:
			_tmap["message"] = self.message.SerializeToDictionary()
		_tmap["status_list"] = self.status_list
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "int_field" in _fmap:
			self.int_field = _fmap["int_field"]
		if "long_field" in _fmap:
			self.long_field = _fmap["long_field"]
		if "bool_field" in _fmap:
			self.bool_field = _fmap["bool_field"]
		if "float_field" in _fmap:
			self.float_field = _fmap["float_field"]
		if "string_field" in _fmap:
			self.string_field = _fmap["string_field"]
		if "bytes_field" in _fmap:
			self.bytes_field = _fmap["bytes_field"]
		if "status" in _fmap:
			self.status = _fmap["status"]
		if "nested_messages" in _fmap:
			self.nested_messages = _fmap["nested_messages"]
		if "name" in _fmap:
			self.name = _fmap["name"]
		if "id" in _fmap:
			self.id = _fmap["id"]
		if "message" in _fmap:
			if _fmap["message"] != null:
				self.message.ParseFromDictionary(_fmap["message"])
		if "status_list" in _fmap:
			self.status_list = _fmap["status_list"]

# =========================================

class TreeNode extends Message:
	var value: String = ""
	var children = []
	var parent: TreeNode = null

	func New() -> Message:
		return TreeNode.new()
 
	func MergeFrom(other : Message) -> void:
		if other is TreeNode:
			self.value += other.value
			self.children.append_array(other.children)
			if self.parent == null:
				self.parent = TreeNode.new()
			self.parent.MergeFrom(other.parent)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.value != "":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, self.value)
 
		for item in self.children:
			GDScriptUtils.encode_tag(buffer, 2, 11)
			GDScriptUtils.encode_message(buffer, item)
 
		if self.parent != null:
			GDScriptUtils.encode_tag(buffer, 3, 11)
			GDScriptUtils.encode_message(buffer, self.parent)
 
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
					self.value = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var item_value = TreeNode.new()
					if item_value == null:
						item_value = TreeNode.new()
					else:
						item_value = TreeNode.new()
					var field_value = GDScriptUtils.decode_message(data, pos, item_value)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.children.append(item_value)
				3:
					if self.parent == null:
						self.parent = TreeNode.new()
					else:
						self.parent = TreeNode.new()
					var value = GDScriptUtils.decode_message(data, pos, self.parent)
					self.parent = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		_tmap["value"] = self.value
		_tmap["children"] = self.children
		if self.parent != null:
			_tmap["parent"] = self.parent.SerializeToDictionary()
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "value" in _fmap:
			self.value = _fmap["value"]
		if "children" in _fmap:
			self.children = _fmap["children"]
		if "parent" in _fmap:
			if _fmap["parent"] != null:
				self.parent.ParseFromDictionary(_fmap["parent"])

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
			self.int32_field += other.int32_field
			self.int64_field += other.int64_field
			self.uint32_field += other.uint32_field
			self.uint64_field += other.uint64_field
			self.sint32_field += other.sint32_field
			self.sint64_field += other.sint64_field
			self.fixed32_field += other.fixed32_field
			self.fixed64_field += other.fixed64_field
			self.sfixed32_field += other.sfixed32_field
			self.sfixed64_field += other.sfixed64_field
			self.float_field += other.float_field
			self.double_field += other.double_field
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.int32_field != -42:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, self.int32_field)
 
		if self.int64_field != -9223372036854775808:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, self.int64_field)
 
		if self.uint32_field != 4294967295:
			GDScriptUtils.encode_tag(buffer, 3, 13)
			GDScriptUtils.encode_varint(buffer, self.uint32_field)
 
		if self.uint64_field != 9223372036854775807:
			GDScriptUtils.encode_tag(buffer, 4, 4)
			GDScriptUtils.encode_varint(buffer, self.uint64_field)
 
		if self.sint32_field != -2147483648:
			GDScriptUtils.encode_tag(buffer, 5, 17)
			GDScriptUtils.encode_zigzag32(buffer, self.sint32_field)
 
		if self.sint64_field != -9223372036854775808:
			GDScriptUtils.encode_tag(buffer, 6, 18)
			GDScriptUtils.encode_zigzag64(buffer, self.sint64_field)
 
		if self.fixed32_field != 4294967295:
			GDScriptUtils.encode_tag(buffer, 7, 7)
			GDScriptUtils.encode_int32(buffer, self.fixed32_field)
 
		if self.fixed64_field != 9223372036854775807:
			GDScriptUtils.encode_tag(buffer, 8, 6)
			GDScriptUtils.encode_int64(buffer, self.fixed64_field)
 
		if self.sfixed32_field != -2147483648:
			GDScriptUtils.encode_tag(buffer, 9, 15)
			GDScriptUtils.encode_int32(buffer, self.sfixed32_field)
 
		if self.sfixed64_field != -9223372036854775808:
			GDScriptUtils.encode_tag(buffer, 10, 16)
			GDScriptUtils.encode_int64(buffer, self.sfixed64_field)
 
		if self.float_field != 3.40282347e+38:
			GDScriptUtils.encode_tag(buffer, 11, 2)
			GDScriptUtils.encode_float(buffer, self.float_field)
 
		if self.double_field != 2.2250738585072014e-308:
			GDScriptUtils.encode_tag(buffer, 12, 1)
			GDScriptUtils.encode_double(buffer, self.double_field)
 
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
					self.int32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.int64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_zigzag32(data, pos, self)
					self.sint32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var value = GDScriptUtils.decode_zigzag64(data, pos, self)
					self.sint64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				7:
					var value = GDScriptUtils.decode_int32(data, pos, self)
					self.fixed32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				8:
					var value = GDScriptUtils.decode_int64(data, pos, self)
					self.fixed64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				9:
					var value = GDScriptUtils.decode_int32(data, pos, self)
					self.sfixed32_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				10:
					var value = GDScriptUtils.decode_int64(data, pos, self)
					self.sfixed64_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				11:
					var value = GDScriptUtils.decode_float(data, pos, self)
					self.float_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				12:
					var value = GDScriptUtils.decode_double(data, pos, self)
					self.double_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		_tmap["int32_field"] = self.int32_field
		_tmap["int64_field"] = self.int64_field
		_tmap["uint32_field"] = self.uint32_field
		_tmap["uint64_field"] = self.uint64_field
		_tmap["sint32_field"] = self.sint32_field
		_tmap["sint64_field"] = self.sint64_field
		_tmap["fixed32_field"] = self.fixed32_field
		_tmap["fixed64_field"] = self.fixed64_field
		_tmap["sfixed32_field"] = self.sfixed32_field
		_tmap["sfixed64_field"] = self.sfixed64_field
		_tmap["float_field"] = self.float_field
		_tmap["double_field"] = self.double_field
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "int32_field" in _fmap:
			self.int32_field = _fmap["int32_field"]
		if "int64_field" in _fmap:
			self.int64_field = _fmap["int64_field"]
		if "uint32_field" in _fmap:
			self.uint32_field = _fmap["uint32_field"]
		if "uint64_field" in _fmap:
			self.uint64_field = _fmap["uint64_field"]
		if "sint32_field" in _fmap:
			self.sint32_field = _fmap["sint32_field"]
		if "sint64_field" in _fmap:
			self.sint64_field = _fmap["sint64_field"]
		if "fixed32_field" in _fmap:
			self.fixed32_field = _fmap["fixed32_field"]
		if "fixed64_field" in _fmap:
			self.fixed64_field = _fmap["fixed64_field"]
		if "sfixed32_field" in _fmap:
			self.sfixed32_field = _fmap["sfixed32_field"]
		if "sfixed64_field" in _fmap:
			self.sfixed64_field = _fmap["sfixed64_field"]
		if "float_field" in _fmap:
			self.float_field = _fmap["float_field"]
		if "double_field" in _fmap:
			self.double_field = _fmap["double_field"]

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
			self.int_with_default += other.int_with_default
			self.string_with_default += other.string_with_default
			self.bytes_with_default.append_array(other.bytes_with_default)
			self.bool_with_default = other.bool_with_default
			self.float_with_default += other.float_with_default
			self.enum_with_default = other.enum_with_default
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.int_with_default != 42:
			GDScriptUtils.encode_tag(buffer, 1, 5)
			GDScriptUtils.encode_varint(buffer, self.int_with_default)
 
		if self.string_with_default != "default string":
			GDScriptUtils.encode_tag(buffer, 2, 9)
			GDScriptUtils.encode_string(buffer, self.string_with_default)
 
		if self.bytes_with_default != PackedByteArray("default bytes".to_utf8_buffer()):
			GDScriptUtils.encode_tag(buffer, 3, 12)
			GDScriptUtils.encode_bytes(buffer, self.bytes_with_default)
 
		if self.bool_with_default != true:
			GDScriptUtils.encode_tag(buffer, 4, 8)
			GDScriptUtils.encode_bool(buffer, self.bool_with_default)
 
		if self.float_with_default != 3.14159:
			GDScriptUtils.encode_tag(buffer, 5, 2)
			GDScriptUtils.encode_float(buffer, self.float_with_default)
 
		if self.enum_with_default != ComplexMessage.Status.ACTIVE:
			GDScriptUtils.encode_tag(buffer, 6, 14)
			GDScriptUtils.encode_varint(buffer, self.enum_with_default)
 
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
					self.int_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_string(data, pos, self)
					self.string_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_bytes(data, pos, self)
					self.bytes_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_bool(data, pos, self)
					self.bool_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_float(data, pos, self)
					self.float_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.enum_with_default = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		_tmap["int_with_default"] = self.int_with_default
		_tmap["string_with_default"] = self.string_with_default
		_tmap["bytes_with_default"] = self.bytes_with_default
		_tmap["bool_with_default"] = self.bool_with_default
		_tmap["float_with_default"] = self.float_with_default
		_tmap["enum_with_default"] = self.enum_with_default
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "int_with_default" in _fmap:
			self.int_with_default = _fmap["int_with_default"]
		if "string_with_default" in _fmap:
			self.string_with_default = _fmap["string_with_default"]
		if "bytes_with_default" in _fmap:
			self.bytes_with_default = _fmap["bytes_with_default"]
		if "bool_with_default" in _fmap:
			self.bool_with_default = _fmap["bool_with_default"]
		if "float_with_default" in _fmap:
			self.float_with_default = _fmap["float_with_default"]
		if "enum_with_default" in _fmap:
			self.enum_with_default = _fmap["enum_with_default"]

# =========================================

class FieldRules extends Message:
	var required_field: String = ""
	var optional_field: String = ""
	var repeated_field = []
	var required_message: ComplexMessage.NestedMessage = null
	var optional_message: ComplexMessage.NestedMessage = null
	var repeated_message = []

	func New() -> Message:
		return FieldRules.new()
 
	func MergeFrom(other : Message) -> void:
		if other is FieldRules:
			self.required_field += other.required_field
			self.optional_field += other.optional_field
			self.repeated_field.append_array(other.repeated_field)
			if self.required_message == null:
				self.required_message = ComplexMessage.NestedMessage.new()
			self.required_message.MergeFrom(other.required_message)
			if self.optional_message == null:
				self.optional_message = ComplexMessage.NestedMessage.new()
			self.optional_message.MergeFrom(other.optional_message)
			self.repeated_message.append_array(other.repeated_message)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.required_field != "":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, self.required_field)
 
		if self.optional_field != "":
			GDScriptUtils.encode_tag(buffer, 2, 9)
			GDScriptUtils.encode_string(buffer, self.optional_field)
 
		for item in self.repeated_field:
			GDScriptUtils.encode_tag(buffer, 3, 9)
			GDScriptUtils.encode_string(buffer, item)
 
		if self.required_message != null:
			GDScriptUtils.encode_tag(buffer, 4, 11)
			GDScriptUtils.encode_message(buffer, self.required_message)
 
		if self.optional_message != null:
			GDScriptUtils.encode_tag(buffer, 5, 11)
			GDScriptUtils.encode_message(buffer, self.optional_message)
 
		for item in self.repeated_message:
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
					self.required_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_string(data, pos, self)
					self.optional_field = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var item_value = []
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.repeated_field.append(item_value)
				4:
					if self.required_message == null:
						self.required_message = ComplexMessage.NestedMessage.new()
					else:
						self.required_message = ComplexMessage.NestedMessage.new()
					var value = GDScriptUtils.decode_message(data, pos, self.required_message)
					self.required_message = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					if self.optional_message == null:
						self.optional_message = ComplexMessage.NestedMessage.new()
					else:
						self.optional_message = ComplexMessage.NestedMessage.new()
					var value = GDScriptUtils.decode_message(data, pos, self.optional_message)
					self.optional_message = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var item_value = ComplexMessage.NestedMessage.new()
					if item_value == null:
						item_value = ComplexMessage.NestedMessage.new()
					else:
						item_value = ComplexMessage.NestedMessage.new()
					var field_value = GDScriptUtils.decode_message(data, pos, item_value)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.repeated_message.append(item_value)
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		_tmap["required_field"] = self.required_field
		_tmap["optional_field"] = self.optional_field
		_tmap["repeated_field"] = self.repeated_field
		if self.required_message != null:
			_tmap["required_message"] = self.required_message.SerializeToDictionary()
		if self.optional_message != null:
			_tmap["optional_message"] = self.optional_message.SerializeToDictionary()
		_tmap["repeated_message"] = self.repeated_message
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "required_field" in _fmap:
			self.required_field = _fmap["required_field"]
		if "optional_field" in _fmap:
			self.optional_field = _fmap["optional_field"]
		if "repeated_field" in _fmap:
			self.repeated_field = _fmap["repeated_field"]
		if "required_message" in _fmap:
			if _fmap["required_message"] != null:
				self.required_message.ParseFromDictionary(_fmap["required_message"])
		if "optional_message" in _fmap:
			if _fmap["optional_message"] != null:
				self.optional_message.ParseFromDictionary(_fmap["optional_message"])
		if "repeated_message" in _fmap:
			self.repeated_message = _fmap["repeated_message"]

# =========================================

