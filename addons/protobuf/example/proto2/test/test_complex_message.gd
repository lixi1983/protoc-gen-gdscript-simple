extends SceneTree

const ComplexProto = preload("res://addons/protobuf/example/proto2/generated/complex.proto.gd")

func _init():
	print("\nStarting ComplexMessage tests...")
	
	# Test ComplexMessage
	print("\n=== Testing ComplexMessage ===")
	test_complex_message_default()
	test_complex_message_custom()
	test_complex_message_nested()
	test_complex_message_to_string()
	
	# Test TreeNode
	print("\n=== Testing TreeNode ===")
	test_tree_node()
	
	# Test NumberTypes
	print("\n=== Testing NumberTypes ===")
	test_number_types()
	
	# Test DefaultValues
	print("\n=== Testing DefaultValues ===")
	test_default_values()
	
	# Test FieldRules
	print("\n=== Testing FieldRules ===")
	test_field_rules()
	
	print("\nAll tests completed!")
	quit()

func test_complex_message_default():
	print("\nTesting ComplexMessage default values...")
	var msg = ComplexProto.ComplexMessage.new()
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = ComplexProto.ComplexMessage.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Test dictionary serialization
	var dict = msg.SerializeToDictionary()
	var dict_parsed_msg = ComplexProto.ComplexMessage.new()
	dict_parsed_msg.ParseFromDictionary(dict)
	
	# Verify default values
	assert(parsed_msg.int_field == 0, "Default int_field mismatch")
	assert(parsed_msg.long_field == 1000000, "Default long_field mismatch")
	assert(parsed_msg.bool_field == true, "Default bool_field mismatch")
	assert(is_equal_approx(parsed_msg.float_field, 3.14), "Default float_field mismatch")
	assert(parsed_msg.string_field == "hello", "Default string_field mismatch")
	assert(parsed_msg.bytes_field.size() == 0, "Default bytes_field mismatch")
	assert(parsed_msg.status == ComplexProto.ComplexMessage.Status.UNKNOWN, "Default status mismatch")
	assert(parsed_msg.nested_messages.size() == 0, "Default nested_messages mismatch")
	assert(parsed_msg.name == "", "Default name mismatch")
	assert(parsed_msg.id == 0, "Default id mismatch")
	assert(parsed_msg.status_list.size() == 0, "Default status_list mismatch")
	
	# Verify dictionary parsed values
	assert(dict_parsed_msg.int_field == 0, "Default dict int_field mismatch")
	assert(dict_parsed_msg.long_field == 1000000, "Default dict long_field mismatch")
	assert(dict_parsed_msg.bool_field == true, "Default dict bool_field mismatch")
	assert(is_equal_approx(dict_parsed_msg.float_field, 3.14), "Default dict float_field mismatch")
	assert(dict_parsed_msg.string_field == "hello", "Default dict string_field mismatch")
	assert(dict_parsed_msg.bytes_field.size() == 0, "Default dict bytes_field mismatch")
	assert(dict_parsed_msg.status == ComplexProto.ComplexMessage.Status.UNKNOWN, "Default dict status mismatch")
	assert(dict_parsed_msg.nested_messages.size() == 0, "Default dict nested_messages mismatch")
	assert(dict_parsed_msg.name == "", "Default dict name mismatch")
	assert(dict_parsed_msg.id == 0, "Default dict id mismatch")
	assert(dict_parsed_msg.status_list.size() == 0, "Default dict status_list mismatch")
	
	# Test string representation
	var str_repr = str(msg)
	print("Default string representation:", str_repr)
	var json = JSON.parse_string(str_repr)
	assert(json != null, "Should be valid JSON")
	
	print("ComplexMessage default values test passed!")

func test_complex_message_custom():
	print("\nTesting ComplexMessage custom values...")
	var msg = ComplexProto.ComplexMessage.new()
	msg.int_field = 42
	msg.long_field = 999999999
	msg.bool_field = false
	msg.float_field = 2.718
	msg.string_field = "测试消息"
	msg.bytes_field = "Hello".to_utf8_buffer()
	msg.status = ComplexProto.ComplexMessage.Status.ACTIVE
	msg.name = "复杂消息"
	msg.id = 123
	msg.status_list = [ComplexProto.ComplexMessage.Status.ACTIVE, ComplexProto.ComplexMessage.Status.PENDING]
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = ComplexProto.ComplexMessage.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Test dictionary serialization
	var dict = msg.SerializeToDictionary()
	var dict_parsed_msg = ComplexProto.ComplexMessage.new()
	dict_parsed_msg.ParseFromDictionary(dict)
	
	# Verify custom values
	assert(parsed_msg.int_field == 42, "Custom int_field mismatch")
	assert(parsed_msg.long_field == 999999999, "Custom long_field mismatch")
	assert(parsed_msg.bool_field == false, "Custom bool_field mismatch")
	assert(is_equal_approx(parsed_msg.float_field, 2.718), "Custom float_field mismatch")
	assert(parsed_msg.string_field == "测试消息", "Custom string_field mismatch")
	assert(parsed_msg.bytes_field == "Hello".to_utf8_buffer(), "Custom bytes_field mismatch")
	assert(parsed_msg.status == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom status mismatch")
	assert(parsed_msg.name == "复杂消息", "Custom name mismatch")
	assert(parsed_msg.id == 123, "Custom id mismatch")
	assert(parsed_msg.status_list.size() == 2, "Custom status_list size mismatch")
	assert(parsed_msg.status_list[0] == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom status_list[0] mismatch")
	assert(parsed_msg.status_list[1] == ComplexProto.ComplexMessage.Status.PENDING, "Custom status_list[1] mismatch")
	
	# Verify dictionary parsed values
	assert(dict_parsed_msg.int_field == 42, "Custom dict int_field mismatch")
	assert(dict_parsed_msg.long_field == 999999999, "Custom dict long_field mismatch")
	assert(dict_parsed_msg.bool_field == false, "Custom dict bool_field mismatch")
	assert(is_equal_approx(dict_parsed_msg.float_field, 2.718), "Custom dict float_field mismatch")
	assert(dict_parsed_msg.string_field == "测试消息", "Custom dict string_field mismatch")
	assert(dict_parsed_msg.bytes_field == "Hello".to_utf8_buffer(), "Custom dict bytes_field mismatch")
	assert(dict_parsed_msg.status == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom dict status mismatch")
	assert(dict_parsed_msg.name == "复杂消息", "Custom dict name mismatch")
	assert(dict_parsed_msg.id == 123, "Custom dict id mismatch")
	assert(dict_parsed_msg.status_list.size() == 2, "Custom dict status_list size mismatch")
	assert(dict_parsed_msg.status_list[0] == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom dict status_list[0] mismatch")
	assert(dict_parsed_msg.status_list[1] == ComplexProto.ComplexMessage.Status.PENDING, "Custom dict status_list[1] mismatch")
	
	# Test string representation
	var str_repr = str(msg)
	print("Custom string representation:", str_repr)
	var json = JSON.parse_string(str_repr)
	assert(json != null, "Should be valid JSON")
	
	print("ComplexMessage custom values test passed!")

func test_complex_message_nested():
	print("\nTesting ComplexMessage nested structures...")
	var msg = ComplexProto.ComplexMessage.new()
	
	# Setup nested message
	var nested = ComplexProto.ComplexMessage.NestedMessage.new()
	nested.id = "nested_id"
	nested.value = 42
	
	# Setup deep nested
	var deep = ComplexProto.ComplexMessage.NestedMessage.DeepNested.new()
	deep.data = "deep_data"
	deep.numbers = [1, 2, 3]
	nested.deep = deep
	
	msg.message = nested
	
	# Create clones for nested_messages array
	var clone1 = ComplexProto.ComplexMessage.NestedMessage.new()
	clone1.id = "clone1"
	clone1.value = 43
	clone1.deep = ComplexProto.ComplexMessage.NestedMessage.DeepNested.new()
	clone1.deep.data = "clone1_deep"
	clone1.deep.numbers = [4, 5, 6]
	
	var clone2 = ComplexProto.ComplexMessage.NestedMessage.new()
	clone2.id = "clone2"
	clone2.value = 44
	clone2.deep = ComplexProto.ComplexMessage.NestedMessage.DeepNested.new()
	clone2.deep.data = "clone2_deep"
	clone2.deep.numbers = [7, 8, 9]
	
	msg.nested_messages = [clone1, clone2]
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = ComplexProto.ComplexMessage.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Verify nested message
	assert(parsed_msg.message.id == "nested_id", "Nested message id mismatch")
	assert(parsed_msg.message.value == 42, "Nested message value mismatch")
	assert(parsed_msg.message.deep.data == "deep_data", "Deep nested data mismatch")
	assert(parsed_msg.message.deep.numbers.size() == 3, "Deep nested numbers size mismatch")
	for i in range(3):
		assert(parsed_msg.message.deep.numbers[i] == i + 1, "Deep nested number %d mismatch" % i)
	
	# Verify nested messages array
	assert(parsed_msg.nested_messages.size() == 2, "Nested messages array size mismatch")
	assert(parsed_msg.nested_messages[0].id == "clone1", "First clone id mismatch")
	assert(parsed_msg.nested_messages[0].value == 43, "First clone value mismatch")
	assert(parsed_msg.nested_messages[0].deep.data == "clone1_deep", "First clone deep data mismatch")
	assert(parsed_msg.nested_messages[1].id == "clone2", "Second clone id mismatch")
	assert(parsed_msg.nested_messages[1].value == 44, "Second clone value mismatch")
	assert(parsed_msg.nested_messages[1].deep.data == "clone2_deep", "Second clone deep data mismatch")
	
	# Test string representation
	var str_repr = str(msg)
	print("Nested message string representation:", str_repr)
	var json = JSON.parse_string(str_repr)
	assert(json != null, "Should be valid JSON")
	
	print("ComplexMessage nested structures test passed!")

func test_complex_message_to_string():
	print("\nTesting ComplexMessage ToString()...")
	
	# Test default values
	var default_msg = ComplexProto.ComplexMessage.new()
	var default_str = default_msg.ToString()
	print("Default ToString():", default_str)
	
	# Verify default string is valid JSON
	var default_json = JSON.parse_string(default_str)
	assert(default_json != null, "Default ToString() should produce valid JSON")
	assert(default_json["name"] == "", "Default name mismatch in ToString()")
	assert(default_json["int_field"] == 0, "Default int_field mismatch in ToString()")
	assert(default_json["long_field"] == 1000000, "Default long_field mismatch in ToString()")
	assert(default_json["bool_field"] == true, "Default bool_field mismatch in ToString()")
	assert(is_equal_approx(default_json["float_field"], 3.14), "Default float_field mismatch in ToString()")
	assert(default_json["string_field"] == "hello", "Default string_field mismatch in ToString()")
	assert(default_json["bytes_field"] == "[]", "Default bytes_field mismatch in ToString()")
	assert(default_json["status"] == ComplexProto.ComplexMessage.Status.UNKNOWN, "Default status mismatch in ToString()")
	assert(default_json["nested_messages"].is_empty(), "Default nested_messages mismatch in ToString()")
	assert(default_json["status_list"].is_empty(), "Default status_list mismatch in ToString()")
	
	# Test custom values with nested messages
	var custom_msg = ComplexProto.ComplexMessage.new()
	custom_msg.name = "复杂消息"  # Test UTF-8 support
	custom_msg.int_field = 42
	custom_msg.long_field = 999999
	custom_msg.bool_field = false
	custom_msg.float_field = 2.718
	custom_msg.string_field = "你好世界"  # Test UTF-8
	custom_msg.bytes_field = [1, 2, 3, 4]
	custom_msg.status = ComplexProto.ComplexMessage.Status.ACTIVE
	
	# Add nested messages
	var nested1 = ComplexProto.ComplexMessage.NestedMessage.new()
	nested1.id = "嵌套1"  # Test UTF-8 in nested
	nested1.value = 1
	nested1.deep = ComplexProto.ComplexMessage.NestedMessage.DeepNested.new()
	nested1.deep.data = "深层1"  # Test UTF-8 in deep nested
	nested1.deep.numbers = [1, 2, 3]
	
	var nested2 = ComplexProto.ComplexMessage.NestedMessage.new()
	nested2.id = "嵌套2"
	nested2.value = 2
	nested2.deep = ComplexProto.ComplexMessage.NestedMessage.DeepNested.new()
	nested2.deep.data = "深层2"
	nested2.deep.numbers = [4, 5, 6]
	
	custom_msg.nested_messages = [nested1, nested2]
	custom_msg.status_list = [
		ComplexProto.ComplexMessage.Status.ACTIVE,
		ComplexProto.ComplexMessage.Status.INACTIVE
	]
	
	var custom_str = custom_msg.ToString()
	print("Custom ToString():", custom_str)
	
	# Verify custom string is valid JSON
	var custom_json = JSON.parse_string(custom_str)
	assert(custom_json != null, "Custom ToString() should produce valid JSON")
	assert(custom_json["name"] == "复杂消息", "Custom name mismatch in ToString()")
	assert(custom_json["int_field"] == 42, "Custom int_field mismatch in ToString()")
	assert(custom_json["long_field"] == 999999, "Custom long_field mismatch in ToString()")
	assert(custom_json["bool_field"] == false, "Custom bool_field mismatch in ToString()")
	assert(is_equal_approx(custom_json["float_field"], 2.718), "Custom float_field mismatch in ToString()")
	assert(custom_json["string_field"] == "你好世界", "Custom string_field mismatch in ToString()")
	assert(custom_json["bytes_field"] == "[1, 2, 3, 4]", "Custom bytes_field mismatch in ToString()")
	assert(custom_json["status"] == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom status mismatch in ToString()")
	
	# Verify nested messages
	assert(custom_json["nested_messages"].size() == 2, "Custom nested_messages size mismatch in ToString()")
	
	# Parse nested messages JSON strings
	var nested1_json = JSON.parse_string(custom_json["nested_messages"][0])
	var nested2_json = JSON.parse_string(custom_json["nested_messages"][1])
	
	assert(nested1_json["id"] == "嵌套1", "First nested message id mismatch")
	assert(nested1_json["value"] == 1, "First nested message value mismatch")
	assert(nested1_json["deep"]["data"] == "深层1", "First deep nested data mismatch")
	assert(nested1_json["deep"]["numbers"].size() == 3, "First deep nested numbers size mismatch")
	assert(nested2_json["id"] == "嵌套2", "Second nested message id mismatch")
	assert(nested2_json["value"] == 2, "Second nested message value mismatch")
	assert(nested2_json["deep"]["data"] == "深层2", "Second deep nested data mismatch")
	assert(nested2_json["deep"]["numbers"].size() == 3, "Second deep nested numbers size mismatch")
	
	# Verify status list
	assert(custom_json["status_list"].size() == 2, "Custom status_list size mismatch in ToString()")
	assert(custom_json["status_list"][0] == ComplexProto.ComplexMessage.Status.ACTIVE, "First status mismatch")
	assert(custom_json["status_list"][1] == ComplexProto.ComplexMessage.Status.INACTIVE, "Second status mismatch")
	
	print("ComplexMessage ToString() test passed!")

func test_tree_node():
	print("\nTesting TreeNode...")
	var root = ComplexProto.TreeNode.new()
	root.value = "根节点"
	
	# Create child nodes without setting their children to avoid recursion
	var child1 = ComplexProto.TreeNode.new()
	child1.value = "子节点1"
	
	var child2 = ComplexProto.TreeNode.new()
	child2.value = "子节点2"
	
	# Set children after creation
	root.children = [child1, child2]
	
	# Test binary serialization
	var bytes = root.SerializeToBytes()
	var parsed_root = ComplexProto.TreeNode.new()
	parsed_root.ParseFromBytes(bytes)
	
	# Verify tree structure
	assert(parsed_root.value == "根节点", "Root value mismatch")
	assert(parsed_root.children.size() == 2, "Children size mismatch")
	assert(parsed_root.children[0].value == "子节点1", "Child1 value mismatch")
	assert(parsed_root.children[1].value == "子节点2", "Child2 value mismatch")
	
	print("TreeNode test passed!")

func test_number_types():
	print("\nTesting NumberTypes...")
	var msg = ComplexProto.NumberTypes.new()
	
	# Verify default values
	assert(msg.int32_field == -42, "Default int32_field mismatch")
	assert(msg.int64_field == -9223372036854775808, "Default int64_field mismatch")
	assert(msg.uint32_field == 4294967295, "Default uint32_field mismatch")
	assert(msg.uint64_field == 9223372036854775807, "Default uint64_field mismatch")
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = ComplexProto.NumberTypes.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Verify parsed values
	assert(parsed_msg.int32_field == -42, "Parsed int32_field mismatch")
	assert(parsed_msg.int64_field == -9223372036854775808, "Parsed int64_field mismatch")
	assert(parsed_msg.uint32_field == 4294967295, "Parsed uint32_field mismatch")
	assert(parsed_msg.uint64_field == 9223372036854775807, "Parsed uint64_field mismatch")
	
	print("NumberTypes test passed!")

func test_default_values():
	print("\nTesting DefaultValues...")
	var msg = ComplexProto.DefaultValues.new()
	
	# Verify default values
	assert(msg.int_with_default == 42, "Default int value mismatch")
	assert(msg.string_with_default == "default string", "Default string value mismatch")
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = ComplexProto.DefaultValues.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Verify parsed values
	assert(parsed_msg.int_with_default == 42, "Parsed int value mismatch")
	assert(parsed_msg.string_with_default == "default string", "Parsed string value mismatch")
	
	print("DefaultValues test passed!")

func test_field_rules():
	print("\nTesting FieldRules...")
	var msg = ComplexProto.FieldRules.new()
	
	# Set required fields
	msg.required_field = "必填字段"
	msg.optional_field = "可选字段"
	msg.repeated_field = ["重复1", "重复2"]
	msg.required_message.id = "required_nested"
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = ComplexProto.FieldRules.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Verify fields
	assert(parsed_msg.required_field == "必填字段", "Required field mismatch")
	assert(parsed_msg.optional_field == "可选字段", "Optional field mismatch")
	assert(parsed_msg.repeated_field.size() == 2, "Repeated field size mismatch")
	assert(parsed_msg.required_message.id == "required_nested", "Required message field mismatch")
	
	print("FieldRules test passed!")
