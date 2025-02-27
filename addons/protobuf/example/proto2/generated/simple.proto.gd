# Package: 

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")

enum SimpleEnum {
	UNKNOWN = 0,
	VALUE1 = 1,
	VALUE2 = 2,
} 
 
class SimpleMessage extends Message:
	var name: String = "simple_demo"
	var value: int = 100
	var tags = []
	var active: bool = false
	var score: float = 0.5

	func New() -> Message:
		return SimpleMessage.new()
 
	func MergeFrom(other : Message) -> void:
		if other is SimpleMessage:
			self.name += other.name
			self.value += other.value
			self.tags.append_array(other.tags)
			self.active = other.active
			self.score += other.score
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.name != "simple_demo":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, self.name)
 
		if self.value != 100:
			GDScriptUtils.encode_tag(buffer, 2, 5)
			GDScriptUtils.encode_varint(buffer, self.value)
 
		for item in self.tags:
			GDScriptUtils.encode_tag(buffer, 3, 9)
			GDScriptUtils.encode_string(buffer, item)
 
		if self.active != false:
			GDScriptUtils.encode_tag(buffer, 4, 8)
			GDScriptUtils.encode_bool(buffer, self.active)
 
		if self.score != 0.5:
			GDScriptUtils.encode_tag(buffer, 5, 1)
			GDScriptUtils.encode_double(buffer, self.score)
 
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
					self.name = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.value = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var item_value = []
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.tags.append(item_value)
				4:
					var value = GDScriptUtils.decode_bool(data, pos, self)
					self.active = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_double(data, pos, self)
					self.score = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		_tmap["name"] = self.name
		_tmap["value"] = self.value
		_tmap["tags"] = self.tags
		_tmap["active"] = self.active
		_tmap["score"] = self.score
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "name" in _fmap:
			self.name = _fmap["name"]
		if "value" in _fmap:
			self.value = _fmap["value"]
		if "tags" in _fmap:
			self.tags = _fmap["tags"]
		if "active" in _fmap:
			self.active = _fmap["active"]
		if "score" in _fmap:
			self.score = _fmap["score"]

# =========================================

