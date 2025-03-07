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
	print("\n=== Testing TreeNode End ===")

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
	assert(parsed_msg.nested_messages_size() == 0, "Default nested_messages mismatch")
	assert(parsed_msg.name == "", "Default name mismatch")
	assert(parsed_msg.id == 0, "Default id mismatch")
	assert(parsed_msg.status_list_size() == 0, "Default status_list mismatch")
	
	# Verify dictionary parsed values
	assert(dict_parsed_msg.int_field == 0, "Default dict int_field mismatch")
	assert(dict_parsed_msg.long_field == 1000000, "Default dict long_field mismatch")
	assert(dict_parsed_msg.bool_field == true, "Default dict bool_field mismatch")
	assert(is_equal_approx(dict_parsed_msg.float_field, 3.14), "Default dict float_field mismatch")
	assert(dict_parsed_msg.string_field == "hello", "Default dict string_field mismatch")
	assert(dict_parsed_msg.bytes_field.size() == 0, "Default dict bytes_field mismatch")
	assert(dict_parsed_msg.status == ComplexProto.ComplexMessage.Status.UNKNOWN, "Default dict status mismatch")
	assert(dict_parsed_msg.nested_messages_size() == 0, "Default dict nested_messages mismatch")
	assert(dict_parsed_msg.name == "", "Default dict name mismatch")
	assert(dict_parsed_msg.id == 0, "Default dict id mismatch")
	assert(dict_parsed_msg.status_list_size() == 0, "Default dict status_list mismatch")
	
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
	msg.string_field = "Test Message"
	msg.bytes_field = "Hello".to_utf8_buffer()
	msg.status = ComplexProto.ComplexMessage.Status.ACTIVE
	msg.name = "Complex Message"
	msg.id = 123
	msg.add_status_list(ComplexProto.ComplexMessage.Status.ACTIVE)
	msg.add_status_list(ComplexProto.ComplexMessage.Status.PENDING)
	
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
	assert(parsed_msg.string_field == "Test Message", "Custom string_field mismatch")
	assert(parsed_msg.bytes_field == "Hello".to_utf8_buffer(), "Custom bytes_field mismatch")
	assert(parsed_msg.status == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom status mismatch")
	assert(parsed_msg.name == "Complex Message", "Custom name mismatch")
	assert(parsed_msg.id == 123, "Custom id mismatch")
	assert(parsed_msg.status_list_size() == 2, "Custom status_list size mismatch")
	assert(parsed_msg.get_status_list(1) == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom status_list[0] mismatch")
	assert(parsed_msg.get_status_list(2) == ComplexProto.ComplexMessage.Status.PENDING, "Custom status_list[1] mismatch")
	
	# Verify dictionary parsed values
	assert(dict_parsed_msg.int_field == 42, "Custom dict int_field mismatch")
	assert(dict_parsed_msg.long_field == 999999999, "Custom dict long_field mismatch")
	assert(dict_parsed_msg.bool_field == false, "Custom dict bool_field mismatch")
	assert(is_equal_approx(dict_parsed_msg.float_field, 2.718), "Custom dict float_field mismatch")
	assert(dict_parsed_msg.string_field == "Test Message", "Custom dict string_field mismatch")
	assert(dict_parsed_msg.bytes_field == "Hello".to_utf8_buffer(), "Custom dict bytes_field mismatch")
	assert(dict_parsed_msg.status == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom dict status mismatch")
	assert(dict_parsed_msg.name == "Complex Message", "Custom dict name mismatch")
	assert(dict_parsed_msg.id == 123, "Custom dict id mismatch")
	assert(dict_parsed_msg.status_list_size() == 2, "Custom dict status_list size mismatch")
	assert(dict_parsed_msg.get_status_list(1) == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom dict status_list[0] mismatch")
	assert(dict_parsed_msg.get_status_list(2) == ComplexProto.ComplexMessage.Status.PENDING, "Custom dict status_list[1] mismatch")
	
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
	deep.append_numbers( [1, 2, 3] )
	nested.deep = deep
	
	msg.message = nested
	
	# Create clones for nested_messages array
	var clone1 = ComplexProto.ComplexMessage.NestedMessage.new()
	clone1.id = "clone1"
	clone1.value = 43
	clone1.deep = ComplexProto.ComplexMessage.NestedMessage.DeepNested.new()
	clone1.deep.data = "clone1_deep"
	var numbers1: Array[int] = []
	numbers1.append_array([4, 5, 6])
	clone1.deep.append_numbers(numbers1)
	
	var clone2 = ComplexProto.ComplexMessage.NestedMessage.new()
	clone2.id = "clone2"
	clone2.value = 44
	clone2.deep = ComplexProto.ComplexMessage.NestedMessage.DeepNested.new()
	clone2.deep.data = "clone2_deep"
	var numbers2: Array[int] = []
	numbers2.append_array([7, 8, 9])
	clone2.deep.append_numbers(numbers2)
	
	msg.append_nested_messages([clone1, clone2])
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = ComplexProto.ComplexMessage.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Verify nested message
#	print("Nested message:", parsed_msg.message.id)
	print("<<<<<< msg message: <<<<<<<<<<", msg.ToString())
	print("<<<<<< parsed_msg message: <<<<<<<<<<", parsed_msg.ToString())
	assert(parsed_msg.message.id == "nested_id", "Nested message id mismatch")
	assert(parsed_msg.message.value == 42, "Nested message value mismatch")
	assert(parsed_msg.message.deep.data == "deep_data", "Deep nested data mismatch")
	assert(parsed_msg.message.deep.numbers_size() == 3, "Deep nested numbers size mismatch")
	for i in range(3):
		assert(parsed_msg.message.deep.get_numbers(i + 1) == i + 1, "Deep nested number %d mismatch" % i)

	# Verify nested messages array
	assert(parsed_msg.nested_messages_size() == 2, "Nested messages array size mismatch: %d" %parsed_msg.nested_messages_size())
	assert(parsed_msg.get_nested_messages(1).id == "clone1", "First clone id mismatch")
	assert(parsed_msg.get_nested_messages(1).value == 43, "First clone value mismatch")
	assert(parsed_msg.get_nested_messages(1).deep.data == "clone1_deep", "First clone deep data mismatch")
	assert(parsed_msg.get_nested_messages(2).id == "clone2", "Second clone id mismatch")
	assert(parsed_msg.get_nested_messages(2).value == 44, "Second clone value mismatch")
	assert(parsed_msg.get_nested_messages(2).deep.data == "clone2_deep", "Second clone deep data mismatch")
	
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
	custom_msg.name = "Complex Message"  # Test UTF-8 support
	custom_msg.int_field = 42
	custom_msg.long_field = 999999
	custom_msg.bool_field = false
	custom_msg.float_field = 2.718
	custom_msg.string_field = "Hello World"  # Test UTF-8
	custom_msg.bytes_field = [1, 2, 3, 4]
	custom_msg.status = ComplexProto.ComplexMessage.Status.ACTIVE
	
	# Add nested messages
	var nested1 = ComplexProto.ComplexMessage.NestedMessage.new()
	nested1.id = "Nested 1"  # Test UTF-8 in nested
	nested1.value = 1
	nested1.deep = ComplexProto.ComplexMessage.NestedMessage.DeepNested.new()
	nested1.deep.data = "Deep 1"  # Test UTF-8 in deep nested
	nested1.deep.append_numbers( [1, 2, 3] )
	
	var nested2 = ComplexProto.ComplexMessage.NestedMessage.new()
	nested2.id = "Nested 2"
	nested2.value = 2
	nested2.deep = ComplexProto.ComplexMessage.NestedMessage.DeepNested.new()
	nested2.deep.data = "Deep 2"
	nested2.deep.append_numbers([4, 5, 6])
	
	custom_msg.append_nested_messages([nested1, nested2])
	custom_msg.append_status_list([
		ComplexProto.ComplexMessage.Status.ACTIVE,
		ComplexProto.ComplexMessage.Status.INACTIVE
	])
	
	var custom_str = custom_msg.ToString()
	print("Custom ToString():", custom_str)
	
	# Verify custom string is valid JSON
	var custom_json = JSON.parse_string(custom_str)
	assert(custom_json != null, "Custom ToString() should produce valid JSON")
	assert(custom_json["name"] == "Complex Message", "Custom name mismatch in ToString()")
	assert(custom_json["int_field"] == 42, "Custom int_field mismatch in ToString()")
	assert(custom_json["long_field"] == 999999, "Custom long_field mismatch in ToString()")
	assert(custom_json["bool_field"] == false, "Custom bool_field mismatch in ToString()")
	assert(is_equal_approx(custom_json["float_field"], 2.718), "Custom float_field mismatch in ToString()")
	assert(custom_json["string_field"] == "Hello World", "Custom string_field mismatch in ToString()")
	assert(custom_json["bytes_field"] == "[1, 2, 3, 4]", "Custom bytes_field mismatch in ToString()")
	assert(custom_json["status"] == ComplexProto.ComplexMessage.Status.ACTIVE, "Custom status mismatch in ToString()")
	
	# Verify nested messages
	assert(custom_json["nested_messages"].size() == 2, "Custom nested_messages size mismatch in ToString()")
	
	# Parse nested messages JSON strings
	var nested1_json = custom_json["nested_messages"][0]
	var nested2_json = custom_json["nested_messages"][1]
	
	assert(nested1_json["id"] == "Nested 1", "First nested message id mismatch")
	assert(nested1_json["value"] == 1, "First nested message value mismatch")
	assert(nested1_json["deep"]["data"] == "Deep 1", "First deep nested data mismatch")
	assert(nested1_json["deep"]["numbers"].size() == 3, "First deep nested numbers size mismatch")
	assert(nested2_json["id"] == "Nested 2", "Second nested message id mismatch")
	assert(nested2_json["value"] == 2, "Second nested message value mismatch")
	assert(nested2_json["deep"]["data"] == "Deep 2", "Second deep nested data mismatch")
	assert(nested2_json["deep"]["numbers"].size() == 3, "Second deep nested numbers size mismatch")
	
	# Verify status list
	assert(custom_json["status_list"].size() == 2, "Custom status_list size mismatch in ToString()")
	assert(custom_json["status_list"][0] == ComplexProto.ComplexMessage.Status.ACTIVE, "First status mismatch")
	assert(custom_json["status_list"][1] == ComplexProto.ComplexMessage.Status.INACTIVE, "Second status mismatch")
	
	print("ComplexMessage ToString() test passed!")

func test_tree_node():
	print("\nTesting TreeNode...")
	var root = ComplexProto.TreeNode.new()
	root.value = "Root Node"
	
	# Create child nodes without setting their children to avoid recursion
	var child1 = ComplexProto.TreeNode.new()
	child1.value = "Child Node 1"
	
	var child2 = ComplexProto.TreeNode.new()
	child2.value = "Child Node 2"
	
	# Set children after creation
	root.append_children([child1, child2])
	
	# Test binary serialization
	var bytes = root.SerializeToBytes()
	var parsed_root = ComplexProto.TreeNode.new()
	parsed_root.ParseFromBytes(bytes)
	
	# Verify tree structure
	print("Root value:", parsed_root.value)
	assert(parsed_root.value == root.value, "Root value mismatch")
	assert(parsed_root.children_size() == 2, "Children size mismatch")
	assert(parsed_root.get_children(1).value == "Child Node 1", "Child1 value mismatch")
	assert(parsed_root.get_children(2).value == "Child Node 2", "Child2 value mismatch")
	
	print("TreeNode test passed!")

func test_number_types():
	print("\nTesting NumberTypes...")
	var msg = ComplexProto.NumberTypes.new()
	
	# Verify default values
	assert(msg.int32_field == -42, "Default int32_field mismatch")
	assert(msg.int64_field == -9223372036854775808, "Default int64_field mismatch")
	assert(msg.uint32_field == 4294967295, "Default uint32_field mismatch")
	assert(msg.uint64_field == 1844674407370955161, "Default uint64_field mismatch")
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = ComplexProto.NumberTypes.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Verify parsed values
	assert(parsed_msg.int32_field == -42, "Parsed int32_field mismatch")
	assert(parsed_msg.int64_field == -9223372036854775808, "Parsed int64_field mismatch")
	assert(parsed_msg.uint32_field == 4294967295, "Parsed uint32_field mismatch")
	assert(parsed_msg.uint64_field == 1844674407370955161, "Parsed uint64_field mismatch")
	
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
	msg.required_field = "Required Field"
	msg.optional_field = "Optional Field"
	msg.append_repeated_field(["Repeated 1", "Repeated 2"])
	msg.required_message = ComplexProto.ComplexMessage.NestedMessage.new()
	msg.required_message.id = "required_nested"
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = ComplexProto.FieldRules.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Verify fields
	assert(parsed_msg.required_field == "Required Field", "Required field mismatch")
	assert(parsed_msg.optional_field == "Optional Field", "Optional field mismatch")
	assert(parsed_msg.repeated_field_size() == 2, "Repeated field size mismatch")
	assert(parsed_msg.required_message.id == "required_nested", "Required message field mismatch")
	
	print("FieldRules test passed!")
