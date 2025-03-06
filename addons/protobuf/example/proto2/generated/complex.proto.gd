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
 
	#1
	var int_field: int = 0
	#2
	var long_field: int = 1000000
	#3
	var bool_field: bool = true
	#4
	var float_field: float = 3.14
	#5
	var string_field: String = "hello"
	#6
	var bytes_field: PackedByteArray = PackedByteArray()
	#7
	var status: ComplexMessage.Status = ComplexMessage.Status.UNKNOWN
	#8
	var nested_messages: Array[ComplexMessage.NestedMessage] = []
	#11
	var name: String = ""
	#12
	var id: int = 0
	#13
	var message: ComplexMessage.NestedMessage = null
	#14
	var status_list: Array[ComplexMessage.Status] = []
	class NestedMessage extends Message:
		#1
		var id: String = ""
		#2
		var value: int = 0
		#3
		var deep: ComplexMessage.NestedMessage.DeepNested = null
		class DeepNested extends Message:
			#1
			var data: String = ""
			#2
			var numbers: Array[int] = []

			func Init() -> void:
				self.data = ""
				self.numbers = []

			func New() -> Message:
				var msg = DeepNested.new()
				return msg

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
							var field_value = GDScriptUtils.decode_string(data, pos, self)
							self.data = field_value[GDScriptUtils.VALUE_KEY]
							pos += field_value[GDScriptUtils.SIZE_KEY]
						2:
							var field_value = GDScriptUtils.decode_varint(data, pos, self)
							self.numbers.append(field_value[GDScriptUtils.VALUE_KEY])
							pos += field_value[GDScriptUtils.SIZE_KEY]
						_:
							pass

				return pos

			func SerializeToDictionary() -> Dictionary:
				var dict = {}
				dict["data"] = self.data
				dict["numbers"] = self.numbers
				return dict

			func ParseFromDictionary(dict: Dictionary) -> void:
				if dict == null:
					return

				if dict.has("data"):
					self.data = dict.get("data")
					self.numbers = dict.get("numbers")


		func Init() -> void:
			self.id = ""
			self.value = 0
			if self.deep != null:				self.deep.clear()

		func New() -> Message:
			var msg = NestedMessage.new()
			return msg

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
						var field_value = GDScriptUtils.decode_string(data, pos, self)
						self.id = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
					2:
						var field_value = GDScriptUtils.decode_varint(data, pos, self)
						self.value = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
					3:
						if self.deep == null:
							self.deep = ComplexMessage.NestedMessage.DeepNested.new()
						self.deep.Init()
						var field_value = GDScriptUtils.decode_message(data, pos, self.deep)
						self.deep = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var dict = {}
			dict["id"] = self.id
			dict["value"] = self.value
			if self.deep != null:
				dict["deep"] = self.deep.SerializeToDictionary()
			return dict

		func ParseFromDictionary(dict: Dictionary) -> void:
			if dict == null:
				return

			if dict.has("id"):
				self.id = dict.get("id")
			if dict.has("value"):
				self.value = dict.get("value")
			if dict.has("deep"):
				if self.deep == null:
					self.deep = ComplexMessage.NestedMessage.DeepNested.new()
				self.deep.Init()
				self.deep.ParseFromDictionary(dict.get("deep"))
			else:
				self.deep = null


	func Init() -> void:
		self.int_field = 0
		self.long_field = 1000000
		self.bool_field = true
		self.float_field = 3.14
		self.string_field = "hello"
		self.bytes_field = PackedByteArray()
		self.status = ComplexMessage.Status.UNKNOWN
		self.nested_messages = []
		self.name = ""
		self.id = 0
		if self.message != null:			self.message.clear()
		self.status_list = []

	func New() -> Message:
		var msg = ComplexMessage.new()
		return msg

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
		if len(self.bytes_field) > 0:
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
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.int_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.long_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_bool(data, pos, self)
					self.bool_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.float_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.string_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var field_value = GDScriptUtils.decode_bytes(data, pos, self)
					self.bytes_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				7:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.status = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				8:
					var sub_nested_messages = ComplexMessage.NestedMessage.new()
					var field_value = GDScriptUtils.decode_message(data, pos, sub_nested_messages)
					self.nested_messages.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				11:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.name = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				12:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.id = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				13:
					if self.message == null:
						self.message = ComplexMessage.NestedMessage.new()
					self.message.Init()
					var field_value = GDScriptUtils.decode_message(data, pos, self.message)
					self.message = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				14:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.status_list.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["int_field"] = self.int_field
		dict["long_field"] = self.long_field
		dict["bool_field"] = self.bool_field
		dict["float_field"] = self.float_field
		dict["string_field"] = self.string_field
		dict["bytes_field"] = self.bytes_field
		dict["status"] = self.status
		dict["nested_messages"] = []
		for item in self.nested_messages:
			dict["nested_messages"].append(item.SerializeToDictionary())

		dict["name"] = self.name
		dict["id"] = self.id
		if self.message != null:
			dict["message"] = self.message.SerializeToDictionary()
		dict["status_list"] = self.status_list
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("int_field"):
			self.int_field = dict.get("int_field")
		if dict.has("long_field"):
			self.long_field = dict.get("long_field")
		if dict.has("bool_field"):
			self.bool_field = dict.get("bool_field")
		if dict.has("float_field"):
			self.float_field = dict.get("float_field")
		if dict.has("string_field"):
			self.string_field = dict.get("string_field")
		if dict.has("bytes_field"):
			self.bytes_field = dict.get("bytes_field")
		if dict.has("status"):
			self.status = dict.get("status")
		if dict.has("nested_messages"):
			var list = dict.get("nested_messages")
			for item in list:
				var item_msg = ComplexMessage.NestedMessage.new()
				item_msg.ParseFromDictionary(item)
				self.nested_messages.append(item_msg)
		if dict.has("name"):
			self.name = dict.get("name")
		if dict.has("id"):
			self.id = dict.get("id")
		if dict.has("message"):
			if self.message == null:
				self.message = ComplexMessage.NestedMessage.new()
			self.message.Init()
			self.message.ParseFromDictionary(dict.get("message"))
		else:
			self.message = null
			self.status_list = dict.get("status_list")

# =========================================

class TreeNode extends Message:
	#1
	var value: String = ""
	#2
	var children: Array[TreeNode] = []
	#3
	var parent: TreeNode = null

	func Init() -> void:
		self.value = ""
		self.children = []
		if self.parent != null:			self.parent.clear()

	func New() -> Message:
		var msg = TreeNode.new()
		return msg

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
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var sub_children = TreeNode.new()
					var field_value = GDScriptUtils.decode_message(data, pos, sub_children)
					self.children.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					if self.parent == null:
						self.parent = TreeNode.new()
					self.parent.Init()
					var field_value = GDScriptUtils.decode_message(data, pos, self.parent)
					self.parent = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["value"] = self.value
		dict["children"] = []
		for item in self.children:
			dict["children"].append(item.SerializeToDictionary())

		if self.parent != null:
			dict["parent"] = self.parent.SerializeToDictionary()
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("value"):
			self.value = dict.get("value")
		if dict.has("children"):
			var list = dict.get("children")
			for item in list:
				var item_msg = TreeNode.new()
				item_msg.ParseFromDictionary(item)
				self.children.append(item_msg)
		if dict.has("parent"):
			if self.parent == null:
				self.parent = TreeNode.new()
			self.parent.Init()
			self.parent.ParseFromDictionary(dict.get("parent"))
		else:
			self.parent = null

# =========================================

class NumberTypes extends Message:
	#1
	var int32_field: int = -42
	#2
	var int64_field: int = -9223372036854775808
	#3
	var uint32_field: int = 4294967295
	#4
	var uint64_field: int = 1844674407370955161
	#5
	var sint32_field: int = -2147483648
	#6
	var sint64_field: int = -9223372036854775808
	#7
	var fixed32_field: int = 4294967295
	#8
	var fixed64_field: int = 1844674407370955161
	#9
	var sfixed32_field: int = -2147483648
	#10
	var sfixed64_field: int = -9223372036854775808
	#11
	var float_field: float = 3.40282347e+38
	#12
	var double_field: float = 2.2250738585072014e-308

	func Init() -> void:
		self.int32_field = -42
		self.int64_field = -9223372036854775808
		self.uint32_field = 4294967295
		self.uint64_field = 1844674407370955161
		self.sint32_field = -2147483648
		self.sint64_field = -9223372036854775808
		self.fixed32_field = 4294967295
		self.fixed64_field = 1844674407370955161
		self.sfixed32_field = -2147483648
		self.sfixed64_field = -9223372036854775808
		self.float_field = 3.40282347e+38
		self.double_field = 2.2250738585072014e-308

	func New() -> Message:
		var msg = NumberTypes.new()
		return msg

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
		if self.uint64_field != 1844674407370955161:
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
		if self.fixed64_field != 1844674407370955161:
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
			GDScriptUtils.encode_float(buffer, self.double_field)
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
					self.int32_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.int64_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint32_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.uint64_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_zigzag32(data, pos, self)
					self.sint32_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var field_value = GDScriptUtils.decode_zigzag64(data, pos, self)
					self.sint64_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				7:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.fixed32_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				8:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.fixed64_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				9:
					var field_value = GDScriptUtils.decode_int32(data, pos, self)
					self.sfixed32_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				10:
					var field_value = GDScriptUtils.decode_int64(data, pos, self)
					self.sfixed64_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				11:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.float_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				12:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.double_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["int32_field"] = self.int32_field
		dict["int64_field"] = self.int64_field
		dict["uint32_field"] = self.uint32_field
		dict["uint64_field"] = self.uint64_field
		dict["sint32_field"] = self.sint32_field
		dict["sint64_field"] = self.sint64_field
		dict["fixed32_field"] = self.fixed32_field
		dict["fixed64_field"] = self.fixed64_field
		dict["sfixed32_field"] = self.sfixed32_field
		dict["sfixed64_field"] = self.sfixed64_field
		dict["float_field"] = self.float_field
		dict["double_field"] = self.double_field
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("int32_field"):
			self.int32_field = dict.get("int32_field")
		if dict.has("int64_field"):
			self.int64_field = dict.get("int64_field")
		if dict.has("uint32_field"):
			self.uint32_field = dict.get("uint32_field")
		if dict.has("uint64_field"):
			self.uint64_field = dict.get("uint64_field")
		if dict.has("sint32_field"):
			self.sint32_field = dict.get("sint32_field")
		if dict.has("sint64_field"):
			self.sint64_field = dict.get("sint64_field")
		if dict.has("fixed32_field"):
			self.fixed32_field = dict.get("fixed32_field")
		if dict.has("fixed64_field"):
			self.fixed64_field = dict.get("fixed64_field")
		if dict.has("sfixed32_field"):
			self.sfixed32_field = dict.get("sfixed32_field")
		if dict.has("sfixed64_field"):
			self.sfixed64_field = dict.get("sfixed64_field")
		if dict.has("float_field"):
			self.float_field = dict.get("float_field")
		if dict.has("double_field"):
			self.double_field = dict.get("double_field")

# =========================================

class DefaultValues extends Message:
	#1
	var int_with_default: int = 42
	#2
	var string_with_default: String = "default string"
	#3
	var bytes_with_default: PackedByteArray = PackedByteArray()
	#4
	var bool_with_default: bool = true
	#5
	var float_with_default: float = 3.14159
	#6
	var enum_with_default: ComplexMessage.Status = ComplexMessage.Status.ACTIVE

	func Init() -> void:
		self.int_with_default = 42
		self.string_with_default = "default string"
		self.bytes_with_default = PackedByteArray()
		self.bool_with_default = true
		self.float_with_default = 3.14159
		self.enum_with_default = ComplexMessage.Status.ACTIVE

	func New() -> Message:
		var msg = DefaultValues.new()
		return msg

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
		if len(self.bytes_with_default) > 0:
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
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.int_with_default = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.string_with_default = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_bytes(data, pos, self)
					self.bytes_with_default = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_bool(data, pos, self)
					self.bool_with_default = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.float_with_default = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.enum_with_default = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["int_with_default"] = self.int_with_default
		dict["string_with_default"] = self.string_with_default
		dict["bytes_with_default"] = self.bytes_with_default
		dict["bool_with_default"] = self.bool_with_default
		dict["float_with_default"] = self.float_with_default
		dict["enum_with_default"] = self.enum_with_default
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("int_with_default"):
			self.int_with_default = dict.get("int_with_default")
		if dict.has("string_with_default"):
			self.string_with_default = dict.get("string_with_default")
		if dict.has("bytes_with_default"):
			self.bytes_with_default = dict.get("bytes_with_default")
		if dict.has("bool_with_default"):
			self.bool_with_default = dict.get("bool_with_default")
		if dict.has("float_with_default"):
			self.float_with_default = dict.get("float_with_default")
		if dict.has("enum_with_default"):
			self.enum_with_default = dict.get("enum_with_default")

# =========================================

class FieldRules extends Message:
	#1
	var required_field: String = ""
	#2
	var optional_field: String = ""
	#3
	var repeated_field: Array[String] = []
	#4
	var required_message: ComplexMessage.NestedMessage = null
	#5
	var optional_message: ComplexMessage.NestedMessage = null
	#6
	var repeated_message: Array[ComplexMessage.NestedMessage] = []

	func Init() -> void:
		self.required_field = ""
		self.optional_field = ""
		self.repeated_field = []
		if self.required_message != null:			self.required_message.clear()
		if self.optional_message != null:			self.optional_message.clear()
		self.repeated_message = []

	func New() -> Message:
		var msg = FieldRules.new()
		return msg

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
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.required_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.optional_field = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.repeated_field.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					if self.required_message == null:
						self.required_message = ComplexMessage.NestedMessage.new()
					self.required_message.Init()
					var field_value = GDScriptUtils.decode_message(data, pos, self.required_message)
					self.required_message = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					if self.optional_message == null:
						self.optional_message = ComplexMessage.NestedMessage.new()
					self.optional_message.Init()
					var field_value = GDScriptUtils.decode_message(data, pos, self.optional_message)
					self.optional_message = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					var sub_repeated_message = ComplexMessage.NestedMessage.new()
					var field_value = GDScriptUtils.decode_message(data, pos, sub_repeated_message)
					self.repeated_message.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["required_field"] = self.required_field
		dict["optional_field"] = self.optional_field
		dict["repeated_field"] = self.repeated_field
		if self.required_message != null:
			dict["required_message"] = self.required_message.SerializeToDictionary()
		if self.optional_message != null:
			dict["optional_message"] = self.optional_message.SerializeToDictionary()
		dict["repeated_message"] = []
		for item in self.repeated_message:
			dict["repeated_message"].append(item.SerializeToDictionary())

		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("required_field"):
			self.required_field = dict.get("required_field")
		if dict.has("optional_field"):
			self.optional_field = dict.get("optional_field")
			self.repeated_field = dict.get("repeated_field")
		if dict.has("required_message"):
			if self.required_message == null:
				self.required_message = ComplexMessage.NestedMessage.new()
			self.required_message.Init()
			self.required_message.ParseFromDictionary(dict.get("required_message"))
		else:
			self.required_message = null
		if dict.has("optional_message"):
			if self.optional_message == null:
				self.optional_message = ComplexMessage.NestedMessage.new()
			self.optional_message.Init()
			self.optional_message.ParseFromDictionary(dict.get("optional_message"))
		else:
			self.optional_message = null
		if dict.has("repeated_message"):
			var list = dict.get("repeated_message")
			for item in list:
				var item_msg = ComplexMessage.NestedMessage.new()
				item_msg.ParseFromDictionary(item)
				self.repeated_message.append(item_msg)

# =========================================
