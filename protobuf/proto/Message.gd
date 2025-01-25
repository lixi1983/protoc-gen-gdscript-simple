class_name Message
extends RefCounted

## 基类，所有由 protobuf 生成的消息类都继承自此类
## 提供序列化和反序列化的基本接口

func _init() -> void:
	pass

## 将消息序列化为二进制字符串
## 返回值: PackedByteArray - 序列化后的二进制数据
func SerializeToString() -> PackedByteArray:
	push_error("Message.SerializeToString() is virtual")
	return PackedByteArray()

## 从二进制字符串解析消息
## 参数: bytes: PackedByteArray - 要解析的二进制数据
## 返回值: bool - 解析是否成功
func ParseFromString(bytes: PackedByteArray) -> bool:
	push_error("Message.ParseFromString() is virtual")
	return false

## 将消息序列化为字典
## 返回值: Dictionary - 包含消息数据的字典
func SerializeToDictionary() -> Dictionary:
	push_error("Message.SerializeToDictionary() is virtual")
	return {}

## 从字典解析消息
## 参数: data: Dictionary - 包含消息数据的字典
## 返回值: bool - 解析是否成功
func ParseFromDictionary(data: Dictionary) -> bool:
	push_error("Message.ParseFromDictionary() is virtual")
	return false

## 创建一个新的消息实例
## 返回值: Message - 新的消息实例
func New() -> Message:
	push_error("Message.New() is virtual")
	return null

## 合并两个消息
## 参数: other: Message - 要合并的消息
## 返回值: Message - 合并后的消息
func Merge(other: Message) -> Message:
	push_error("Message.Merge() is virtual")
	return self

## 复制当前消息
## 返回值: Message - 复制的消息
func Copy() -> Message:
	push_error("Message.Copy() is virtual")
	return self