class_name Message
extends RefCounted

## 基类，所有由 protobuf 生成的消息类都继承自此类
## 提供序列化和反序列化的基本接口

func _init() -> void:
	Init()

func Init() -> void:
	pass

## 将消息序列化为二进制字符串
## 返回值: PackedByteArray - 序列化后的二进制数据
func SerializeToBytes(bytes: PackedByteArray = PackedByteArray()) -> PackedByteArray:
	push_error("Message.SerializeToString() is virtual")
	return bytes

## 从二进制字符串解析消息
## 参数: bytes: PackedByteArray - 要解析的二进制数据
## 返回值: bool - 解析是否成功
func ParseFromBytes(bytes: PackedByteArray) -> int:
	push_error("Message.ParseFromString() is virtual")
	return 0

## 将消息序列化为字典
## 返回值: Dictionary - 包含消息数据的字典
func SerializeToDictionary() -> Dictionary:
	push_error("Message.SerializeToDictionary() is virtual")
	return {}

## 从字典解析消息
## 参数: data: Dictionary - 包含消息数据的字典
## 返回值: bool - 解析是否成功
func ParseFromDictionary(data: Dictionary) -> void:
	push_error("Message.ParseFromDictionary() is virtual")
	return

## 创建一个新的消息实例
## 返回值: Message - 新的消息实例
func New() -> Message:
	push_error("Message.New() is virtual")
	return null

## 合并两个消息
## 参数: other: Message - 要合并的消息
## 返回值: Message - 合并后的消息
func MergeFrom(other: Message) -> void:
	push_error("Message.Merge() is virtual")

## 复制当前消息
## 返回值: Message - 复制的消息
func Clone() -> Message:
	var other = New()
	other.MergeFrom(self)
	return other

func SerializeToJson() -> String:
	var map = SerializeToDictionary()
	return JSON.stringify(map)

func ToString() -> String:
	return SerializeToJson()