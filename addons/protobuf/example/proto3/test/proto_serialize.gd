extends SceneTree

const proto3Test = preload("res://addons/protobuf/example/proto3/generated/test.proto.gd")
const common = preload("res://addons/protobuf/example/proto3/generated/common.proto.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _init() -> void:
	print("proto serialize!")
	test_proto3_serialize()
	test_proto3_merge()
	test_proto3_clone()

	test_float()
	quit(0)


func test_proto3_serialize():
	print("========= begin proto3/test.proto serialize ==============")
	var test = proto3Test.MsgBase.new()
	test.msg_field32 = 12345789098765
	test.msg_field2 = "132"
	test.field64.append(123451232232332233)
	test.b_field3 = true
	test.f_field4 = 1234.5566
	test.map_field5 = {1: "hello", 2: "world"}
	test.enum_field6 = proto3Test.EnumTest.ENUM_TEST2
	test.sub_msg = proto3Test.MsgBase.SubMsg.new()
	test.sub_msg.sub_field1 = 123
	test.sub_msg.sub_field2 = "hello"
	test.common_msg = common.CommonMessage.new()
	test.common_msg.common_field2 = "world344"
	test.common_msg.common_field1 = 23232
	test.common_msg.common_sint32 = 654321
	test.common_msg.common_sint64 = 9876789876
	test.fixed_field32 = 112323
	test.fixed_field64 = 11232322
	test.double_field = 1234.557744
#    example.common_enum = common.CommonEnum.COMMON_ENUM_ONE

	print("test string: ", test.ToString())

	var bytesString = test.SerializeToBytes()
	print("test: ", bytesString.size())
	var test2 = proto3Test.MsgBase.new()
	test2.ParseFromBytes(bytesString)
	var testBytesString = test2.SerializeToBytes()
	print("test2 size: ", testBytesString.size())
	print("test2: ", test2.ToString())
	print("test end, is equal: ", test.ToString() == test2.ToString())

	print("========= end proto3/test.proto serialize ==============")

func test_proto3_merge():
	print("========= begin proto3/test.proto merge ==============")
	var first = proto3Test.MsgBase.new()
	first.msg_field32 = 13232
	first.field64.append_array([1, 2, 3, 4, 5])
	first.msg_field2 = "hello"
	first.b_field3 = true
	first.map_field5 = {3: "hello", 4: "world"}

	var second = proto3Test.MsgBase.new()

	print("first toString: ", first.ToString())
	second.MergeFrom(first)
	first.field64[1] = 10
	print("second toString: ", second.ToString())

	print("after first toString: ", first.ToString())
	print("========= end proto3/test.proto merge ==============")

func test_proto3_clone():
	print("========= begin proto3/test.proto clone ==============")
	var first = proto3Test.MsgBase.new()
	first.msg_field32 = 668866
	first.field64.append_array([1, 2, 3, 4])
	first.msg_field2 = "world"
	first.b_field3 = false
	first.map_field5 = {5: "hello", 6: "world"}

	var second = first.Clone() #proto3Test.MsgBase.new()

	print("first toString: ", first.ToString())
	first.field64[1] = 10
	print("second toString: ", second.ToString())

	print("after first toString: ", first.ToString())
	print("========= end proto3/test.proto merge ==============")


func test_float():
	print("========= begin proto3/test.proto float ==============")
	var a = 1234.53233
	print("Original float: ", a)

	print("\n1. 使用 StreamPeerBuffer 和 slice 方法:")
	var writer = StreamPeerBuffer.new()
	writer.put_float(a)
	var source_bytes = writer.data_array
	print("Source bytes: ", source_bytes.hex_encode())

	# 方法1: 使用 slice
	var bytes1 = source_bytes.slice(0, 4)
	print("Method 1 (slice): ", bytes1.hex_encode())

	print("\n2. 使用 resize 和循环赋值:")
	# 方法2: 使用 resize 和循环
	var bytes2 = PackedByteArray()
	bytes2.resize(4)
	for i in range(4):
		bytes2[i] = source_bytes[i]
	print("Method 2 (loop copy): ", bytes2.hex_encode())

	print("\n3. 使用 append_array:")
	# 方法3: 使用 append_array
	var bytes3 = PackedByteArray()
	bytes3.append_array(source_bytes.slice(0, 4))
	print("Method 3 (append_array): ", bytes3.hex_encode())

	# 验证所有方法的结果
	var reader1 = StreamPeerBuffer.new()
	reader1.data_array = bytes1
	var float1 = reader1.get_float()

	var reader2 = StreamPeerBuffer.new()
	reader2.data_array = bytes2
	var float2 = reader2.get_float()

	var reader3 = StreamPeerBuffer.new()
	reader3.data_array = bytes3
	var float3 = reader3.get_float()

	print("\n结果验证:")
	print("Original float: ", a)
	print("Method 1 result: ", float1, " (差异: ", abs(a - float1), ")")
	print("Method 2 result: ", float2, " (差异: ", abs(a - float2), ")")
	print("Method 3 result: ", float3, " (差异: ", abs(a - float3), ")")

	print("\n字节对比:")
	print("Method 1 bytes: ", bytes1.hex_encode())
	print("Method 2 bytes: ", bytes2.hex_encode())
	print("Method 3 bytes: ", bytes3.hex_encode())

	print("\n单个字节内容:")
	for i in range(4):
		print("byte[", i, "]:",
			" Method1: ", bytes1[i],
			" Method2: ", bytes2[i],
			" Method3: ", bytes3[i])
	# 检查所有方法的结果是否一致
	if float1 == float2 and float2 == float3:
		print("\n所有方法结果一致!")
	else:
		print("\n警告: 不同方法的结果不一致!")
	print("========= end proto3/test.proto float ==============")
