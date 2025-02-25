# Package: test.proto2

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")

class Character extends Message:
	enum CharacterClass {
		WARRIOR = 0,
		MAGE = 1,
		ROGUE = 2,
	} 
 
	var name: String = ""
	var level: int = 1
	var health: float = 100
	var character: Character.CharacterClass = Character.CharacterClass.WARRIOR
	var skills = []
	var inventory: Character.Inventory = Character.Inventory.new()

	class Inventory extends Message:
		var slots: int = 10
		var items = []

		func New() -> Message:
			return Inventory.new()
 
		func MergeFrom(other : Message) -> void:
			if other is Inventory:
				slots += other.slots
				items.append_array(other.items)
 
		func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if slots != 10:
				GDScriptUtils.encode_tag(buffer, 1, 5)
				GDScriptUtils.encode_varint(buffer, slots)
 
			for item in items:
				GDScriptUtils.encode_tag(buffer, 2, 11)
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
						var value = GDScriptUtils.decode_varint(data, pos, self)
						slots = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					2:
						var value = GDScriptUtils.decode_message(data, pos)
						items.append_array([value[GDScriptUtils.VALUE_KEY]])
						pos += value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var map = {}
			map["slots"] = slots
			map["items"] = items
			return map

		func ParseFromDictionary(data: Dictionary) -> void:
			if data == null:
				return

			if "slots" in data:
				slots = data["slots"]
			if "items" in data:
				items = data["items"]

	class Item extends Message:
		var id: String = ""
		var name: String = ""
		var quantity: int = 1

		func New() -> Message:
			return Item.new()
 
		func MergeFrom(other : Message) -> void:
			if other is Item:
				id += other.id
				name += other.name
				quantity += other.quantity
 
		func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if id != "":
				GDScriptUtils.encode_tag(buffer, 1, 9)
				GDScriptUtils.encode_string(buffer, id)
 
			if name != "":
				GDScriptUtils.encode_tag(buffer, 2, 9)
				GDScriptUtils.encode_string(buffer, name)
 
			if quantity != 1:
				GDScriptUtils.encode_tag(buffer, 3, 5)
				GDScriptUtils.encode_varint(buffer, quantity)
 
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
						var value = GDScriptUtils.decode_string(data, pos, self)
						name = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					3:
						var value = GDScriptUtils.decode_varint(data, pos, self)
						quantity = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var map = {}
			map["id"] = id
			map["name"] = name
			map["quantity"] = quantity
			return map

		func ParseFromDictionary(data: Dictionary) -> void:
			if data == null:
				return

			if "id" in data:
				id = data["id"]
			if "name" in data:
				name = data["name"]
			if "quantity" in data:
				quantity = data["quantity"]

	func New() -> Message:
		return Character.new()
 
	func MergeFrom(other : Message) -> void:
		if other is Character:
			name += other.name
			level += other.level
			health += other.health
			character = other.character
			skills.append_array(other.skills)
			inventory.MergeFrom(other.inventory)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if name != "":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, name)
 
		if level != 1:
			GDScriptUtils.encode_tag(buffer, 2, 5)
			GDScriptUtils.encode_varint(buffer, level)
 
		if health != 100:
			GDScriptUtils.encode_tag(buffer, 3, 2)
			GDScriptUtils.encode_float(buffer, health)
 
		if character != Character.CharacterClass.WARRIOR:
			GDScriptUtils.encode_tag(buffer, 4, 14)
			GDScriptUtils.encode_varint(buffer, character)
 
		for item in skills:
			GDScriptUtils.encode_tag(buffer, 5, 9)
			GDScriptUtils.encode_string(buffer, item)
 
		if inventory != null:
			GDScriptUtils.encode_tag(buffer, 6, 11)
			GDScriptUtils.encode_message(buffer, inventory)
 
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
					level = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_float(data, pos, self)
					health = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					character = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_string(data, pos)
					skills.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				6:
					var value = GDScriptUtils.decode_message(data, pos, inventory)
					inventory = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["name"] = name
		map["level"] = level
		map["health"] = health
		map["character"] = character
		map["skills"] = skills
		if inventory != null:
			map["inventory"] = inventory.SerializeToDictionary()
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "name" in data:
			name = data["name"]
		if "level" in data:
			level = data["level"]
		if "health" in data:
			health = data["health"]
		if "character" in data:
			character = data["character"]
		if "skills" in data:
			skills = data["skills"]
		if "inventory" in data:
			if data["inventory"] != null:
				inventory.ParseFromDictionary(data["inventory"])

# =========================================

class GameSession extends Message:
	enum GameState {
		WAITING = 0,
		PLAYING = 1,
		FINISHED = 2,
	} 
 
	var session_id: String = ""
	var start_time: int = 0
	var end_time: int = 0
	var players = []
	var state: GameSession.GameState = GameSession.GameState.WAITING

	func New() -> Message:
		return GameSession.new()
 
	func MergeFrom(other : Message) -> void:
		if other is GameSession:
			session_id += other.session_id
			start_time += other.start_time
			end_time += other.end_time
			players.append_array(other.players)
			state = other.state
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if session_id != "":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, session_id)
 
		if start_time != 0:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, start_time)
 
		if end_time != 0:
			GDScriptUtils.encode_tag(buffer, 3, 3)
			GDScriptUtils.encode_varint(buffer, end_time)
 
		for item in players:
			GDScriptUtils.encode_tag(buffer, 4, 11)
			GDScriptUtils.encode_message(buffer, item)
 
		if state != GameSession.GameState.WAITING:
			GDScriptUtils.encode_tag(buffer, 5, 14)
			GDScriptUtils.encode_varint(buffer, state)
 
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
					session_id = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					start_time = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					end_time = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_message(data, pos)
					players.append_array([value[GDScriptUtils.VALUE_KEY]])
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					state = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var map = {}
		map["session_id"] = session_id
		map["start_time"] = start_time
		map["end_time"] = end_time
		map["players"] = players
		map["state"] = state
		return map

	func ParseFromDictionary(data: Dictionary) -> void:
		if data == null:
			return

		if "session_id" in data:
			session_id = data["session_id"]
		if "start_time" in data:
			start_time = data["start_time"]
		if "end_time" in data:
			end_time = data["end_time"]
		if "players" in data:
			players = data["players"]
		if "state" in data:
			state = data["state"]

# =========================================

