extends SceneTree

const SimpleProto = preload("res://addons/protobuf/example/proto2/generated/simple.proto.gd")

func _init():
	run_tests()
	quit()

func run_tests():
	print("Starting SimpleMessage tests...")
	
	# Test SimpleMessage
	print("\n=== Testing SimpleMessage ===")
	test_simple_message_default()
	test_simple_message_custom()
	test_simple_message_to_string()
	
	# Test SimpleDefaultMessage
	print("\n=== Testing SimpleDefaultMessage ===")
	test_default_message()
	
	# Test SimpleRepeatedMessage
	print("\n=== Testing SimpleRepeatedMessage ===")
	test_repeated_message()
	
	print("\nAll tests completed!")

func test_simple_message_default():
	print("\nTesting SimpleMessage default values...")
	var msg1 = SimpleProto.SimpleMessage.new()
	
	# Serialize default message
	var bytes = msg1.SerializeToBytes()
	
	# Parse into new message
	var msg2 = SimpleProto.SimpleMessage.new()
	msg2.ParseFromBytes(bytes)
	
	# Verify default values
	assert(msg2.int32_v == 0, "Default int32_v mismatch")
	assert(msg2.int64_v == 0, "Default int64_v mismatch")
	assert(msg2.uint32_v == 0, "Default uint32_v mismatch")
	assert(msg2.uint64_v == 0, "Default uint64_v mismatch")
	assert(msg2.sint32_v == 0, "Default sint32_v mismatch")
	assert(msg2.sint64_v == 0, "Default sint64_v mismatch")
	assert(msg2.fixed32_v == 0, "Default fixed32_v mismatch")
	assert(msg2.fixed64_v == 0, "Default fixed64_v mismatch")
	assert(msg2.sfixed32_v == 0, "Default sfixed32_v mismatch")
	assert(msg2.sfixed64_v == 0, "Default sfixed64_v mismatch")
	assert(msg2.float_v == 0.0, "Default float_v mismatch")
	assert(msg2.double_v == 0.0, "Default double_v mismatch")
	assert(msg2.bool_v == false, "Default bool_v mismatch")
	assert(msg2.string_v == "", "Default string_v mismatch")
	var empty_bytes = PackedByteArray([])
	assert(msg2.bytes_v == empty_bytes, "Default bytes_v mismatch")
	# 在proto2中，如果没有指定默认值，枚举字段会使用第一个定义的枚举值作为默认值
	assert(msg2.elem_v == 0, "Default elem_v mismatch")
	assert(msg2.elem_vd == SimpleProto.SimpleMessage.EnumDemo.E_UNKNOWN, "Default elem_vd mismatch")
	print("Default values test passed!")

func test_simple_message_custom():
	print("\nTesting SimpleMessage custom values...")
	var msg1 = SimpleProto.SimpleMessage.new()
	
	# Set custom values
	msg1.int32_v = 100
	msg1.int64_v = 200
	msg1.uint32_v = 300
	msg1.uint64_v = 400
	msg1.sint32_v = -500
	msg1.sint64_v = -600
	msg1.fixed32_v = 700
	msg1.fixed64_v = 800
	msg1.sfixed32_v = -900
	msg1.sfixed64_v = -1000
	msg1.float_v = 3.14
	msg1.double_v = 2.718
	msg1.bool_v = true
	msg1.string_v = "test string"
	msg1.bytes_v = [1, 2, 3, 4]
	msg1.elem_v = SimpleProto.SimpleEnum.VALUE1
	msg1.elem_vd = SimpleProto.SimpleMessage.EnumDemo.E_VALUE1
	
	# Serialize message
	var bytes = msg1.SerializeToBytes()
	
	# Parse into new message
	var msg2 = SimpleProto.SimpleMessage.new()
	msg2.ParseFromBytes(bytes)
	
	# Verify custom values
	assert(msg2.int32_v == 100, "Custom int32_v mismatch")
	assert(msg2.int64_v == 200, "Custom int64_v mismatch")
	assert(msg2.uint32_v == 300, "Custom uint32_v mismatch")
	assert(msg2.uint64_v == 400, "Custom uint64_v mismatch")
	assert(msg2.sint32_v == -500, "Custom sint32_v mismatch")
	assert(msg2.sint64_v == -600, "Custom sint64_v mismatch")
	assert(msg2.fixed32_v == 700, "Custom fixed32_v mismatch")
	assert(msg2.fixed64_v == 800, "Custom fixed64_v mismatch")
	assert(msg2.sfixed32_v == -900, "Custom sfixed32_v mismatch")
	assert(msg2.sfixed64_v == -1000, "Custom sfixed64_v mismatch")
	assert(is_equal_approx(msg2.float_v, 3.14), "Custom float_v mismatch")
	assert(is_equal_approx(msg2.double_v, 2.718), "Custom double_v mismatch")
	assert(msg2.bool_v == true, "Custom bool_v mismatch")
	assert(msg2.string_v == "test string", "Custom string_v mismatch")
	var expected_bytes = PackedByteArray([1, 2, 3, 4])
	assert(msg2.bytes_v == expected_bytes, "Custom bytes_v mismatch")
	assert(msg2.elem_v == SimpleProto.SimpleEnum.VALUE1, "Custom elem_v mismatch")
	assert(msg2.elem_vd == SimpleProto.SimpleMessage.EnumDemo.E_VALUE1, "Custom elem_vd mismatch")
	print("Custom values test passed!")

func test_simple_message_to_string():
	print("\nTesting SimpleMessage string representation...")
	var msg = SimpleProto.SimpleMessage.new()
	msg.int32_v = 42
	msg.string_v = "hello"
	msg.bool_v = true
	print(msg.to_string())
	print("String representation test passed!")

func test_default_message():
	print("\nTesting SimpleDefaultMessage...")
	var msg = SimpleProto.SimpleDefaultMessage.new()
	
	# Verify default values
	assert(msg.int32_v == 101, "Default int32_v mismatch")
	assert(msg.int64_v == 102, "Default int64_v mismatch")
	assert(msg.uint32_v == 103, "Default uint32_v mismatch")
	assert(msg.uint64_v == 104, "Default uint64_v mismatch")
	assert(msg.sint32_v == 105, "Default sint32_v mismatch")
	assert(msg.sint64_v == 106, "Default sint64_v mismatch")
	assert(msg.fixed32_v == 107, "Default fixed32_v mismatch")
	assert(msg.fixed64_v == 108, "Default fixed64_v mismatch")
	assert(msg.sfixed32_v == 109, "Default sfixed32_v mismatch")
	assert(msg.sfixed64_v == 110, "Default sfixed64_v mismatch")
	assert(is_equal_approx(msg.float_v, 11.1), "Default float_v mismatch")
	assert(is_equal_approx(msg.double_v, 11.2), "Default double_v mismatch")
	assert(msg.bool_v == true, "Default bool_v mismatch")
	assert(msg.string_v == "simple_demo", "Default string_v mismatch")
	assert(msg.elem_v == SimpleProto.SimpleEnum.VALUE1, "Default elem_v mismatch")
	assert(msg.elem_vd == SimpleProto.SimpleMessage.EnumDemo.E_VALUE1, "Default elem_vd mismatch")
	print("Default message test passed!")

func test_repeated_message():
	print("\nTesting SimpleRepeatedMessage...")
	var msg1 = SimpleProto.SimpleRepeatedMessage.new()
	
	# Add some values to repeated fields
	msg1.add_int32_v(1)
	msg1.add_int32_v(2)
	msg1.add_string_v("one")
	msg1.add_string_v("two")
	msg1.add_elem_v(SimpleProto.SimpleEnum.VALUE1)
	msg1.add_elem_v(SimpleProto.SimpleEnum.VALUE2)
	
	# Serialize message
	var bytes = msg1.SerializeToBytes()
	
	# Parse into new message
	var msg2 = SimpleProto.SimpleRepeatedMessage.new()
	msg2.ParseFromBytes(bytes)
	
	# Verify repeated values
	assert(msg2.int32_v_size() == 2 && msg2.get_int32_v(1) == 1 && msg2.get_int32_v(2) == 2, "Repeated int32_v mismatch")
	assert(msg2.string_v_size() == 2 && msg2.get_string_v(1) == "one" && msg2.get_string_v(2) == "two", "Repeated string_v mismatch")
	assert(msg2.elem_v_size() == 2 && msg2.get_elem_v(1) == SimpleProto.SimpleEnum.VALUE1 && msg2.get_elem_v(2) == SimpleProto.SimpleEnum.VALUE2, "Repeated elem_v mismatch")
	print("Repeated message test passed!")
