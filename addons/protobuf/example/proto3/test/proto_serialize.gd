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
	test.add_field64(123451232232332233)
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
	assert( test.ToString() == test2.ToString(), "test end, is equal " )

	print("========= end proto3/test.proto serialize ==============")

func test_proto3_merge():
	print("========= begin proto3/test.proto merge ==============")
	var first = proto3Test.MsgBase.new()
	first.msg_field32 = 13232
	first.add_field64(1)
	first.add_field64(2)
	first.add_field64(3)
	first.add_field64(4)
	first.add_field64(5)
	first.msg_field2 = "hello"
	first.b_field3 = true
	first.map_field5 = {3: "hello", 4: "world"}

	var second = proto3Test.MsgBase.new()

	print("first toString: ", first.ToString())
	second.MergeFrom(first)
	print("second toString: ", second.ToString())

	assert(first.ToString() == second.ToString(), "merge failed")
	print("========= end proto3/test.proto merge ==============")

func test_proto3_clone():
	print("========= begin proto3/test.proto clone ==============")
	var first = proto3Test.MsgBase.new()
	first.msg_field32 = 668866
	first.add_field64(1)
	first.add_field64(2)
	first.add_field64(3)
	first.add_field64(4)
	first.msg_field2 = "world"
	first.b_field3 = false
	first.map_field5 = {5: "hello", 6: "world"}

	var second = first.Clone() #proto3Test.MsgBase.new()

	print("first toString: ", first.ToString())
	print("second toString: ", second.ToString())

	assert(first.ToString() == second.ToString(), "Clone failed")
	print("========= end proto3/test.proto merge ==============")


func test_float():
	print("========= begin proto3/test.proto float ==============")
	var a = 1234.53233
	print("Original float: ", a)

	print("\n1. Using StreamPeerBuffer and slice method:")
	var writer = StreamPeerBuffer.new()
	writer.put_float(a)
	var source_bytes = writer.data_array
	print("Source bytes: ", source_bytes.hex_encode())

	# Method 1: Using slice
	var bytes1 = source_bytes.slice(0, 4)
	print("Method 1 (slice): ", bytes1.hex_encode())

	print("\n2. Using resize and loop assignment:")
	# Method 2: Using resize and loop
	var bytes2 = PackedByteArray()
	bytes2.resize(4)
	for i in range(4):
		bytes2[i] = source_bytes[i]
	print("Method 2 (loop copy): ", bytes2.hex_encode())

	print("\n3. Using append_array:")
	# Method 3: Using append_array
	var bytes3 = PackedByteArray()
	bytes3.append_array(source_bytes.slice(0, 4))
	print("Method 3 (append_array): ", bytes3.hex_encode())

	# Verify all method results
	var reader1 = StreamPeerBuffer.new()
	reader1.data_array = bytes1
	var float1 = reader1.get_float()

	var reader2 = StreamPeerBuffer.new()
	reader2.data_array = bytes2
	var float2 = reader2.get_float()

	var reader3 = StreamPeerBuffer.new()
	reader3.data_array = bytes3
	var float3 = reader3.get_float()

	print("\nResult verification:")
	print("Original float: ", a)
	print("Method 1 result: ", float1, " (Difference: ", abs(a - float1), ")")
	print("Method 2 result: ", float2, " (Difference: ", abs(a - float2), ")")
	print("Method 3 result: ", float3, " (Difference: ", abs(a - float3), ")")

	print("\nByte comparison:")
	print("Method 1 bytes: ", bytes1.hex_encode())
	print("Method 2 bytes: ", bytes2.hex_encode())
	print("Method 3 bytes: ", bytes3.hex_encode())

	print("\nIndividual byte contents:")
	for i in range(4):
		print("byte[", i, "]:",
			" Method1: ", bytes1[i],
			" Method2: ", bytes2[i],
			" Method3: ", bytes3[i])
	# Check if all method results are consistent
	if is_equal_approx(float1, float2) and is_equal_approx(float2, float3):
		print("\nAll method results are consistent!")
	else:
		print("\nWarning: Different method results are inconsistent!")
	print("========= end proto3/test.proto float ==============")
