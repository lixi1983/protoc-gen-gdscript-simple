class_name Message
extends RefCounted

## Base class for all protobuf generated message classes
## Provides basic interfaces for serialization and deserialization

func _init() -> void:
	Init()

func Init() -> void:
	pass

func ProtoName() -> String:
	return ""

## Serialize message to binary string
## Returns: PackedByteArray - Serialized binary data
func SerializeToBytes(bytes: PackedByteArray = PackedByteArray()) -> PackedByteArray:
	push_error("Message.SerializeToString() is virtual")
	return bytes

## Parse message from binary string
## Args: bytes: PackedByteArray - Binary data to parse
## Returns: bool - True if parsing successful
func ParseFromBytes(bytes: PackedByteArray) -> int:
	push_error("Message.ParseFromString() is virtual")
	return 0

## Serialize message to dictionary
## Returns: Dictionary - Dictionary containing message data
func SerializeToDictionary() -> Dictionary:
	push_error("Message.SerializeToDictionary() is virtual")
	return {}

## Parse message from dictionary
## Args: data: Dictionary - Dictionary containing message data
## Returns: void
func ParseFromDictionary(data: Dictionary) -> void:
	push_error("Message.ParseFromDictionary() is virtual")
	return

## Create a new message instance
## Returns: Message - New message instance
func New() -> Message:
	push_error("Message.New() is virtual")
	return null

## Merge two messages
## Args: other: Message - Message to merge from
## Returns: void
func MergeFrom(other: Message) -> void:
	push_error("Message.Merge() is virtual")

## Clone current message
## Returns: Message - Cloned message
func Clone() -> Message:
	var other = New()
	other.MergeFrom(self)
	return other

## Serialize message to JSON string
## Returns: String - JSON string representation
func SerializeToJson() -> String:
	var map = SerializeToDictionary()
	return JSON.stringify(map)

## Convert message to string
## Returns: String - String representation
func ToString() -> String:
	return SerializeToJson()

## Built-in string conversion
## Returns: String - String representation
func _to_string() -> String:
	return ToString()
