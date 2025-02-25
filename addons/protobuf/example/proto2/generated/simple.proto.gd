# Package: 

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")

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
			name += other.name
			value += other.value
			tags.append_array(other.tags)
			active = other.active
			score += other.score
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if name != "simple_demo":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, name)
 
		if value != 100:
			GDScriptUtils.encode_tag(buffer, 2, 5)
			GDScriptUtils.encode_varint(buffer, value)
 
		for item in tags:
			GDScriptUtils.encode_tag(buffer, 3, 9)
			GDScriptUtils.encode_string(buffer, item)
 
		if active != false:
			GDScriptUtils.encode_tag(buffer, 4, 8)
			GDScriptUtils.encode_bool(buffer, active)
 
		if score != 0.5:
			GDScriptUtils.encode_tag(buffer, 5, 2)
			GDScriptUtils.encode_float(buffer, score)
 
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
					name = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					value = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_string(data, pos)
					tags.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_bool(data, pos, self)
					active = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_float(data, pos, self)
					score = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["name"] = name
		map["value"] = value
		map["tags"] = tags
		map["active"] = active
		map["score"] = score
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "name" in data:
			name = data["name"]
		if "value" in data:
			value = data["value"]
		if "tags" in data:
			tags = data["tags"]
		if "active" in data:
			active = data["active"]
		if "score" in data:
			score = data["score"]

# =========================================

