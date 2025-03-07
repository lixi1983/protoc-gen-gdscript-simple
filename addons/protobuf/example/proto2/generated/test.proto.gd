# Package: test.proto2

const GDScriptUtils = preload("res://addons/protobuf/proto/GDScriptUtils.gd")
const Message = preload("res://addons/protobuf/proto/Message.gd")

class Character extends Message:
	enum CharacterClass {
		WARRIOR = 0,
		MAGE = 1,
		ROGUE = 2,
	} 
 
	#1 : name
	var name: String = ""

	#2 : level
	var level: int = 1

	#3 : health
	var health: float = 100

	#4 : character
	var character: Character.CharacterClass = Character.CharacterClass.WARRIOR

	#5 : skills
	var _skills: Array[String] = []
	var _skills_size: int = 0
	## Size of _skills
	func skills_size() -> int:
		return self._skills_size
	## Get _skills
	func skills() -> Array[String]:
		return self._skills.slice(0, self._skills_size)
	## Get _skills item 
	func get_skills(index: int) -> String: # index begin from 1
		if index > 0 and index <= _skills_size and index <= _skills.size():
			return self._skills[index - 1]
		return ""
	## Add _skills
	func add_skills(item: String) -> String:
		if self._skills_size >= 0 and self._skills_size < self._skills.size():
			self._skills[self._skills_size] = item
		else:
			self._skills.append(item)
		self._skills_size += 1
		return item
	## Append _skills
	func append_skills(item_array: Array):
		for item in item_array:
			if item is String:
				self.add_skills(item)
	## Clean _skills 
	func clear_skills() -> void:
		self._skills_size = 0

	#6 : inventory
	var inventory: Character.Inventory = null

	class Inventory extends Message:
		#1 : slots
		var slots: int = 10

		#2 : items
		var _items: Array[Character.Item] = []
		var _items_size: int = 0
		## Size of _items
		func items_size() -> int:
			return self._items_size
		## Get _items
		func items() -> Array[Character.Item]:
			return self._items.slice(0, self._items_size)
		## Get _items item 
		func get_items(index: int) -> Character.Item: # index begin from 1
			if index > 0 and index <= _items_size and index <= _items.size():
				return self._items[index - 1]
			return null
		## Add _items
		func add_items(item: Character.Item) -> Character.Item:
			if self._items_size >= 0 and self._items_size < self._items.size():
				self._items[self._items_size] = item
			else:
				self._items.append(item)
			self._items_size += 1
			return item
		## Append _items
		func append_items(item_array: Array):
			for item in item_array:
				if item is Character.Item:
					self.add_items(item)
		## Clean _items 
		func clear_items() -> void:
			self._items_size = 0


		## Init message field values to default value
		func Init() -> void:
			self.slots = 10
			self.clear_items

		## Create a new message instance
		## Returns: Message - New message instance
		func New() -> Message:
			var msg = Inventory.new()
			return msg

		## Message ProtoName
		## Returns: String - ProtoName
		func ProtoName() -> String:
			return "test.proto2.Inventory"

		func MergeFrom(other : Message) -> void:
			if other is Inventory:
				self.slots += other.slots
				self._items = self._items.slice(0, _items_size)
				self._items.append_array(other._items.slice(0, other._items_size))
				self._items_size += other._items_size
 
		func SerializeToBytes(buffer: PackedByteArray = PackedByteArray()) -> PackedByteArray:
			if self.slots != 10:
				GDScriptUtils.encode_tag(buffer, 1, 5)
				GDScriptUtils.encode_varint(buffer, self.slots)
			for item in self._items:
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
						var sub__items = Character.Item.new()
						var field_value = GDScriptUtils.decode_message(data, pos, sub__items)
						self.add_items(field_value[GDScriptUtils.VALUE_KEY])
						pos += field_value[GDScriptUtils.SIZE_KEY]
					_:
						pass

			return pos

		func SerializeToDictionary() -> Dictionary:
			var dict = {}
			dict["slots"] = self.slots
			dict["items"] = []
			for index in range(1, self._items_size + 1):
				var item = self.get_items(index)
				dict["items"].append(item.SerializeToDictionary())
			return dict

		func ParseFromDictionary(dict: Dictionary) -> void:
			if dict == null:
				return

			if dict.has("slots"):
				self.slots = dict.get("slots")
			self.clear_items()
			if dict.has("items"):
				var list = dict["items"]
				for item in list:
					var item_msg = Character.Item.new()
					item_msg.ParseFromDictionary(item)
					self.add_items(item_msg)

	class Item extends Message:
		#1 : id
		var id: String = ""

		#2 : name
		var name: String = ""

		#3 : quantity
		var quantity: int = 1


		## Init message field values to default value
		func Init() -> void:
			self.id = ""
			self.name = ""
			self.quantity = 1

		## Create a new message instance
		## Returns: Message - New message instance
		func New() -> Message:
			var msg = Item.new()
			return msg

		## Message ProtoName
		## Returns: String - ProtoName
		func ProtoName() -> String:
			return "test.proto2.Item"

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


	## Init message field values to default value
	func Init() -> void:
		self.name = ""
		self.level = 1
		self.health = 100
		self.character = Character.CharacterClass.WARRIOR
		self.clear_skills
		if self.inventory != null:			self.inventory.clear()

	## Create a new message instance
	## Returns: Message - New message instance
	func New() -> Message:
		var msg = Character.new()
		return msg

	## Message ProtoName
	## Returns: String - ProtoName
	func ProtoName() -> String:
		return "test.proto2.Character"

	func MergeFrom(other : Message) -> void:
		if other is Character:
			self.name += other.name
			self.level += other.level
			self.health += other.health
			self.character = other.character
			self._skills = self._skills.slice(0, _skills_size)
			self._skills.append_array(other._skills.slice(0, other._skills_size))
			self._skills_size += other._skills_size
			if other.inventory != null:
				if self.inventory == null:
					self.inventory = Character.Inventory.new()
				self.inventory.MergeFrom(other.inventory)
			else:
				self.inventory = null
 
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
		for item in self._skills:
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
					self.add_skills(field_value[GDScriptUtils.VALUE_KEY])
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
		dict["skills"] = self._skills
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
		self.clear_skills()
		if dict.has("skills"):
			var list = dict["skills"]
			for item in list:
				self.add_skills(item)
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
 
	#1 : session_id
	var session_id: String = ""

	#2 : start_time
	var start_time: int = 0

	#3 : end_time
	var end_time: int = 0

	#4 : players
	var _players: Array[Character] = []
	var _players_size: int = 0
	## Size of _players
	func players_size() -> int:
		return self._players_size
	## Get _players
	func players() -> Array[Character]:
		return self._players.slice(0, self._players_size)
	## Get _players item 
	func get_players(index: int) -> Character: # index begin from 1
		if index > 0 and index <= _players_size and index <= _players.size():
			return self._players[index - 1]
		return null
	## Add _players
	func add_players(item: Character) -> Character:
		if self._players_size >= 0 and self._players_size < self._players.size():
			self._players[self._players_size] = item
		else:
			self._players.append(item)
		self._players_size += 1
		return item
	## Append _players
	func append_players(item_array: Array):
		for item in item_array:
			if item is Character:
				self.add_players(item)
	## Clean _players 
	func clear_players() -> void:
		self._players_size = 0

	#5 : state
	var state: GameSession.GameState = GameSession.GameState.WAITING


	## Init message field values to default value
	func Init() -> void:
		self.session_id = ""
		self.start_time = 0
		self.end_time = 0
		self.clear_players
		self.state = GameSession.GameState.WAITING

	## Create a new message instance
	## Returns: Message - New message instance
	func New() -> Message:
		var msg = GameSession.new()
		return msg

	## Message ProtoName
	## Returns: String - ProtoName
	func ProtoName() -> String:
		return "test.proto2.GameSession"

	func MergeFrom(other : Message) -> void:
		if other is GameSession:
			self.session_id += other.session_id
			self.start_time += other.start_time
			self.end_time += other.end_time
			self._players = self._players.slice(0, _players_size)
			self._players.append_array(other._players.slice(0, other._players_size))
			self._players_size += other._players_size
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
		for item in self._players:
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
					var sub__players = Character.new()
					var field_value = GDScriptUtils.decode_message(data, pos, sub__players)
					self.add_players(field_value[GDScriptUtils.VALUE_KEY])
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
		dict["players"] = []
		for index in range(1, self._players_size + 1):
			var item = self.get_players(index)
			dict["players"].append(item.SerializeToDictionary())
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
		self.clear_players()
		if dict.has("players"):
			var list = dict["players"]
			for item in list:
				var item_msg = Character.new()
				item_msg.ParseFromDictionary(item)
				self.add_players(item_msg)
		if dict.has("state"):
			self.state = dict.get("state")

# =========================================

