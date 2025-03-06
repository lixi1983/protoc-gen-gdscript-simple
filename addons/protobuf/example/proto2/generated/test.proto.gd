# Package: test.proto2

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")

class Character extends Message:
	enum CharacterClass {
		WARRIOR = 0,
		MAGE = 1,
		ROGUE = 2,
	} 
 
	#1
	var name: String = ""
	#2
	var level: int = 1
	#3
	var health: float = 100
	#4
	var character: Character.CharacterClass = Character.CharacterClass.WARRIOR
	#5
	var skills: Array[String] = []
	#6
	var inventory: Character.Inventory = null
	class Inventory extends Message:
		#1
		var slots: int = 10
		#2
		var items: Array[Character.Item] = []

		func Init() -> void:
			self.slots = 10
			self.items = []

		func New() -> Message:
			var msg = Inventory.new()
			return msg

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
						var field_value = GDScriptUtils.decode_varint(data, pos, self)
						self.slots = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
					2:
						var sub_items = Character.Item.new()
						var field_value = GDScriptUtils.decode_message(data, pos, sub_items)
						self.items.append(field_value[GDScriptUtils.VALUE_KEY])
						pos += field_value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var dict = {}
			dict["slots"] = self.slots
			for item in self.items:
				dict["items"].append(item.ToString())

			return dict

		func ParseFromDictionary(dict: Dictionary) -> void:
			if dict == null:
				return

			if dict.has("slots"):
				self.slots = dict.get("slots")
			if dict.has("items"):
				var list = dict.get("items")
				for item in list:
					var item_msg = Character.Item.new()
					item_msg.ParseFromDictionary(item)
					self.items.append(item_msg)

	class Item extends Message:
		#1
		var id: String = ""
		#2
		var name: String = ""
		#3
		var quantity: int = 1

		func Init() -> void:
			self.id = ""
			self.name = ""
			self.quantity = 1

		func New() -> Message:
			var msg = Item.new()
			return msg

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
						var field_value = GDScriptUtils.decode_string(data, pos, self)
						self.id = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
					2:
						var field_value = GDScriptUtils.decode_string(data, pos, self)
						self.name = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
					3:
						var field_value = GDScriptUtils.decode_varint(data, pos, self)
						self.quantity = field_value[GDScriptUtils.VALUE_KEY]
						pos += field_value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var dict = {}
			dict["id"] = self.id
			dict["name"] = self.name
			dict["quantity"] = self.quantity
			return dict

		func ParseFromDictionary(dict: Dictionary) -> void:
			if dict == null:
				return

			if dict.has("id"):
				self.id = dict.get("id")
			if dict.has("name"):
				self.name = dict.get("name")
			if dict.has("quantity"):
				self.quantity = dict.get("quantity")


	func Init() -> void:
		self.name = ""
		self.level = 1
		self.health = 100
		self.character = Character.CharacterClass.WARRIOR
		self.skills = []
		if self.inventory != null:			self.inventory.clear()

	func New() -> Message:
		var msg = Character.new()
		return msg

	func MergeFrom(other : Message) -> void:
		if other is Character:
			self.name += other.name
			self.level += other.level
			self.health += other.health
			self.character = other.character
			self.skills.append_array(other.skills)
			if self.inventory == null:
				self.inventory = Character.Inventory.new()
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
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.name = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.level = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_float(data, pos, self)
					self.health = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.character = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.skills.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				6:
					if self.inventory == null:
						self.inventory = Character.Inventory.new()
					self.inventory.Init()
					var field_value = GDScriptUtils.decode_message(data, pos, self.inventory)
					self.inventory = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["name"] = self.name
		dict["level"] = self.level
		dict["health"] = self.health
		dict["character"] = self.character
		dict["skills"] = self.skills
		if self.inventory != null:
			dict["inventory"] = self.inventory.SerializeToDictionary()
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("name"):
			self.name = dict.get("name")
		if dict.has("level"):
			self.level = dict.get("level")
		if dict.has("health"):
			self.health = dict.get("health")
		if dict.has("character"):
			self.character = dict.get("character")
			self.skills = dict.get("skills")
		if dict.has("inventory"):
			if self.inventory == null:
				self.inventory = Character.Inventory.new()
			self.inventory.Init()
			self.inventory.ParseFromDictionary(dict.get("inventory"))
		else:
			self.inventory = null

# =========================================

class GameSession extends Message:
	enum GameState {
		WAITING = 0,
		PLAYING = 1,
		FINISHED = 2,
	} 
 
	#1
	var session_id: String = ""
	#2
	var start_time: int = 0
	#3
	var end_time: int = 0
	#4
	var players: Array[Character] = []
	#5
	var state: GameSession.GameState = GameSession.GameState.WAITING

	func Init() -> void:
		self.session_id = ""
		self.start_time = 0
		self.end_time = 0
		self.players = []
		self.state = GameSession.GameState.WAITING

	func New() -> Message:
		var msg = GameSession.new()
		return msg

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
					var field_value = GDScriptUtils.decode_string(data, pos, self)
					self.session_id = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				2:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.start_time = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				3:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.end_time = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				4:
					var sub_players = Character.new()
					var field_value = GDScriptUtils.decode_message(data, pos, sub_players)
					self.players.append(field_value[GDScriptUtils.VALUE_KEY])
					pos += field_value[GDScriptUtils.SIZE_KEY]
				5:
					var field_value = GDScriptUtils.decode_varint(data, pos, self)
					self.state = field_value[GDScriptUtils.VALUE_KEY]
					pos += field_value[GDScriptUtils.SIZE_KEY]
				_:
					pass

		return pos

	func SerializeToDictionary() -> Dictionary:
		var dict = {}
		dict["session_id"] = self.session_id
		dict["start_time"] = self.start_time
		dict["end_time"] = self.end_time
		for item in self.players:
			dict["players"].append(item.ToString())

		dict["state"] = self.state
		return dict

	func ParseFromDictionary(dict: Dictionary) -> void:
		if dict == null:
			return

		if dict.has("session_id"):
			self.session_id = dict.get("session_id")
		if dict.has("start_time"):
			self.start_time = dict.get("start_time")
		if dict.has("end_time"):
			self.end_time = dict.get("end_time")
		if dict.has("players"):
			var list = dict.get("players")
			for item in list:
				var item_msg = Character.new()
				item_msg.ParseFromDictionary(item)
				self.players.append(item_msg)
		if dict.has("state"):
			self.state = dict.get("state")

# =========================================

