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
				self.slots += other.slots
				self.items.append_array(other.items)
 
		func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if self.slots != 10:
				GDScriptUtils.encode_tag(buffer, 1, 5)
				GDScriptUtils.encode_varint(buffer, self.slots)
 
			for item in self.items:
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
						self.slots = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					2:
						var item_value = Character.Item.new()
						var field_value = GDScriptUtils.decode_message(data, pos, item_value)
						item_value = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
						self.items.append(item_value)
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var _tmap = {}
			_tmap["slots"] = self.slots
			_tmap["items"] = self.items
			return _tmap

		func ParseFromDictionary(_fmap: Dictionary) -> void:
			if _fmap == null:
				return

			if "slots" in _fmap:
				self.slots = _fmap["slots"]
			if "items" in _fmap:
				self.items = _fmap["items"]

	class Item extends Message:
		var id: String = ""
		var name: String = ""
		var quantity: int = 1

		func New() -> Message:
			return Item.new()
 
		func MergeFrom(other : Message) -> void:
			if other is Item:
				self.id += other.id
				self.name += other.name
				self.quantity += other.quantity
 
		func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if self.id != "":
				GDScriptUtils.encode_tag(buffer, 1, 9)
				GDScriptUtils.encode_string(buffer, self.id)
 
			if self.name != "":
				GDScriptUtils.encode_tag(buffer, 2, 9)
				GDScriptUtils.encode_string(buffer, self.name)
 
			if self.quantity != 1:
				GDScriptUtils.encode_tag(buffer, 3, 5)
				GDScriptUtils.encode_varint(buffer, self.quantity)
 
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
						var value = GDScriptUtils.decode_string(data, pos, self)
						self.name = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					3:
						var value = GDScriptUtils.decode_varint(data, pos, self)
						self.quantity = value[GDScriptUtils.VALUE_KEY]
						pos += value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var _tmap = {}
			_tmap["id"] = self.id
			_tmap["name"] = self.name
			_tmap["quantity"] = self.quantity
			return _tmap

		func ParseFromDictionary(_fmap: Dictionary) -> void:
			if _fmap == null:
				return

			if "id" in _fmap:
				self.id = _fmap["id"]
			if "name" in _fmap:
				self.name = _fmap["name"]
			if "quantity" in _fmap:
				self.quantity = _fmap["quantity"]

	func New() -> Message:
		return Character.new()
 
	func MergeFrom(other : Message) -> void:
		if other is Character:
			self.name += other.name
			self.level += other.level
			self.health += other.health
			self.character = other.character
			self.skills.append_array(other.skills)
			self.inventory.MergeFrom(other.inventory)
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.name != "":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, self.name)
 
		if self.level != 1:
			GDScriptUtils.encode_tag(buffer, 2, 5)
			GDScriptUtils.encode_varint(buffer, self.level)
 
		if self.health != 100:
			GDScriptUtils.encode_tag(buffer, 3, 2)
			GDScriptUtils.encode_float(buffer, self.health)
 
		if self.character != Character.CharacterClass.WARRIOR:
			GDScriptUtils.encode_tag(buffer, 4, 14)
			GDScriptUtils.encode_varint(buffer, self.character)
 
		for item in self.skills:
			GDScriptUtils.encode_tag(buffer, 5, 9)
			GDScriptUtils.encode_string(buffer, item)
 
		if self.inventory != null:
			GDScriptUtils.encode_tag(buffer, 6, 11)
			GDScriptUtils.encode_message(buffer, self.inventory)
 
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
					self.level = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_float(data, pos, self)
					self.health = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.character = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				5:
					var item_value = []
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.skills.append(item_value)
				6:
					var value = GDScriptUtils.decode_message(data, pos, inventory)
					self.inventory = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		_tmap["name"] = self.name
		_tmap["level"] = self.level
		_tmap["health"] = self.health
		_tmap["character"] = self.character
		_tmap["skills"] = self.skills
		if self.inventory != null:
			_tmap["inventory"] = self.inventory.SerializeToDictionary()
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "name" in _fmap:
			self.name = _fmap["name"]
		if "level" in _fmap:
			self.level = _fmap["level"]
		if "health" in _fmap:
			self.health = _fmap["health"]
		if "character" in _fmap:
			self.character = _fmap["character"]
		if "skills" in _fmap:
			self.skills = _fmap["skills"]
		if "inventory" in _fmap:
			if _fmap["inventory"] != null:
				self.inventory.ParseFromDictionary(_fmap["inventory"])

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
			self.session_id += other.session_id
			self.start_time += other.start_time
			self.end_time += other.end_time
			self.players.append_array(other.players)
			self.state = other.state
 
	func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
		if self.session_id != "":
			GDScriptUtils.encode_tag(buffer, 1, 9)
			GDScriptUtils.encode_string(buffer, self.session_id)
 
		if self.start_time != 0:
			GDScriptUtils.encode_tag(buffer, 2, 3)
			GDScriptUtils.encode_varint(buffer, self.start_time)
 
		if self.end_time != 0:
			GDScriptUtils.encode_tag(buffer, 3, 3)
			GDScriptUtils.encode_varint(buffer, self.end_time)
 
		for item in self.players:
			GDScriptUtils.encode_tag(buffer, 4, 11)
			GDScriptUtils.encode_message(buffer, item)
 
		if self.state != GameSession.GameState.WAITING:
			GDScriptUtils.encode_tag(buffer, 5, 14)
			GDScriptUtils.encode_varint(buffer, self.state)
 
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
					self.session_id = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				2:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.start_time = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				3:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.end_time = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				4:
					var item_value = Character.new()
					var field_value = GDScriptUtils.decode_message(data, pos, item_value)
					item_value = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
					self.players.append(item_value)
				5:
					var value = GDScriptUtils.decode_varint(data, pos, self)
					self.state = value[GDScriptUtils.VALUE_KEY]
					pos += value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var _tmap = {}
		_tmap["session_id"] = self.session_id
		_tmap["start_time"] = self.start_time
		_tmap["end_time"] = self.end_time
		_tmap["players"] = self.players
		_tmap["state"] = self.state
		return _tmap

	func ParseFromDictionary(_fmap: Dictionary) -> void:
		if _fmap == null:
			return

		if "session_id" in _fmap:
			self.session_id = _fmap["session_id"]
		if "start_time" in _fmap:
			self.start_time = _fmap["start_time"]
		if "end_time" in _fmap:
			self.end_time = _fmap["end_time"]
		if "players" in _fmap:
			self.players = _fmap["players"]
		if "state" in _fmap:
			self.state = _fmap["state"]

# =========================================

