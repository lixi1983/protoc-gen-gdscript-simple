extends SceneTree

const SimpleProto = preload("res://addons/protobuf/example/proto2/generated/simple.proto.gd")

func _init():
	run_tests()
	quit()

func run_tests():
	print("Starting SimpleMessage tests...")
	
	# Test binary serialization
	print("\n=== Testing Binary Serialization ===")
	test_default_values()
	test_custom_values()
	test_all_fields_modified()
	
	# Test dictionary serialization
	print("\n=== Testing Dictionary Serialization ===")
	test_dictionary_default_values()
	test_dictionary_custom_values()
	test_dictionary_all_fields()
	test_dictionary_null_handling()
	
	# Test string representation
	print("\n=== Testing String Representation ===")
	test_to_string()
	
	# Test SimpleMessage
	print("\n=== Testing SimpleMessage ===")
	test_simple_message_default()
	test_simple_message_custom()
	test_simple_message_to_string()
	
	print("\nAll tests completed!")

func test_default_values():
	print("\nTesting default values...")
	var msg1 = SimpleProto.SimpleMessage.new()
	
	# Serialize default message
	var bytes = msg1.SerializeToBytes()
	
	# Parse into new message
	var msg2 = SimpleProto.SimpleMessage.new()
	msg2.ParseFromBytes(bytes)
	
	# Verify default values are preserved
	assert(msg2.name == "simple_demo", "Default name mismatch")
	assert(msg2.value == 100, "Default value mismatch")
	assert(msg2.tags.size() == 0, "Default tags mismatch")
	assert(msg2.active == false, "Default active mismatch")
	assert(is_equal_approx(msg2.score, 0.5), "Default score mismatch")
	print("Default values test passed!")

func test_custom_values():
	print("\nTesting custom values...")
	var msg1 = SimpleProto.SimpleMessage.new()
	msg1.name = "test_message"
	msg1.value = 42
	msg1.tags.append_array(["tag1", "tag2"])
	msg1.active = true
	msg1.score = 3.14
	
	# Serialize modified message
	var bytes = msg1.SerializeToBytes()
	
	# Parse into new message
	var msg2 = SimpleProto.SimpleMessage.new()
	msg2.ParseFromBytes(bytes)
	
	# Verify custom values are preserved
	assert(msg2.name == "test_message", "Custom name mismatch")
	assert(msg2.value == 42, "Custom value mismatch")
	assert(msg2.tags.size() == 2 && msg2.tags[0] == "tag1" && msg2.tags[1] == "tag2", "Custom tags mismatch")
	assert(msg2.active == true, "Custom active mismatch")
	assert(is_equal_approx(msg2.score, 3.14), "Custom score mismatch")
	print("Custom values test passed!")

func test_all_fields_modified():
	print("\nTesting all fields modified...")
	var msg1 = SimpleProto.SimpleMessage.new()
	msg1.name = "modified_message"
	msg1.value = 999
	msg1.tags.append("test")
	msg1.active = true
	msg1.score = 1.23
	
	# Serialize modified message
	var bytes = msg1.SerializeToBytes()
	
	# Parse into new message
	var msg2 = SimpleProto.SimpleMessage.new()
	msg2.ParseFromBytes(bytes)
	
	# Verify all modified values are preserved
	assert(msg2.name == "modified_message", "Modified name mismatch")
	assert(msg2.value == 999, "Modified value mismatch")
	assert(msg2.tags.size() == 1 && msg2.tags[0] == "test", "Modified tags mismatch")
	assert(msg2.active == true, "Modified active mismatch")
	assert(is_equal_approx(msg2.score, 1.23), "Modified score mismatch")
	print("All fields modified test passed!")

func test_dictionary_default_values():
	print("\nTesting dictionary default values...")
	var msg1 = SimpleProto.SimpleMessage.new()
	
	# Serialize to dictionary
	var dict = msg1.SerializeToDictionary()
	
	# Create new message and parse from dictionary
	var msg2 = SimpleProto.SimpleMessage.new()
	msg2.ParseFromDictionary(dict)
	
	# Verify default values are preserved
	assert(msg2.name == "simple_demo", "Default name mismatch")
	assert(msg2.value == 100, "Default value mismatch")
	assert(msg2.tags.size() == 0, "Default tags mismatch")
	assert(msg2.active == false, "Default active mismatch")
	assert(is_equal_approx(msg2.score, 0.5), "Default score mismatch")
	print("Dictionary default values test passed!")

func test_dictionary_custom_values():
	print("\nTesting dictionary custom values...")
	var msg1 = SimpleProto.SimpleMessage.new()
	msg1.name = "test_dict"
	msg1.value = 42
	msg1.tags.append_array(["tag1", "tag2"])
	msg1.active = true
	msg1.score = 3.14
	
	# Serialize to dictionary
	var dict = msg1.SerializeToDictionary()
	
	# Verify dictionary contents
	assert(dict["name"] == "test_dict", "Dictionary name mismatch")
	assert(dict["value"] == 42, "Dictionary value mismatch")
	assert(dict["tags"].size() == 2 && dict["tags"][0] == "tag1" && dict["tags"][1] == "tag2", "Dictionary tags mismatch")
	assert(dict["active"] == true, "Dictionary active mismatch")
	assert(is_equal_approx(dict["score"], 3.14), "Dictionary score mismatch")
	
	# Create new message and parse from dictionary
	var msg2 = SimpleProto.SimpleMessage.new()
	msg2.ParseFromDictionary(dict)
	
	# Verify values are preserved
	assert(msg2.name == "test_dict", "Parsed name mismatch")
	assert(msg2.value == 42, "Parsed value mismatch")
	assert(msg2.tags.size() == 2 && msg2.tags[0] == "tag1" && msg2.tags[1] == "tag2", "Parsed tags mismatch")
	assert(msg2.active == true, "Parsed active mismatch")
	assert(is_equal_approx(msg2.score, 3.14), "Parsed score mismatch")
	print("Dictionary custom values test passed!")

func test_dictionary_all_fields():
	print("\nTesting dictionary all fields...")
	var msg1 = SimpleProto.SimpleMessage.new()
	msg1.name = "modified_dict"
	msg1.value = 999
	msg1.tags.append("test_tag")
	msg1.active = true
	msg1.score = 1.23
	
	# Round trip through dictionary
	var dict = msg1.SerializeToDictionary()
	var msg2 = SimpleProto.SimpleMessage.new()
	msg2.ParseFromDictionary(dict)
	
	# Verify all fields
	assert(msg2.name == "modified_dict", "Modified name mismatch")
	assert(msg2.value == 999, "Modified value mismatch")
	assert(msg2.tags.size() == 1 && msg2.tags[0] == "test_tag", "Modified tags mismatch")
	assert(msg2.active == true, "Modified active mismatch")
	assert(is_equal_approx(msg2.score, 1.23), "Modified score mismatch")
	print("Dictionary all fields test passed!")

func test_dictionary_null_handling():
	print("\nTesting dictionary null handling...")
	var msg = SimpleProto.SimpleMessage.new()
	
	# Test parsing from empty dictionary
	msg.ParseFromDictionary({})
	assert(msg.name == "simple_demo", "Name should remain default after empty dict parse")
	assert(msg.value == 100, "Value should remain default after empty dict parse")
	assert(msg.tags.size() == 0, "Tags should remain default after empty dict parse")
	assert(msg.active == false, "Active should remain default after empty dict parse")
	assert(is_equal_approx(msg.score, 0.5), "Score should remain default after empty dict parse")
	
	# Test parsing from dictionary with missing fields
	msg.ParseFromDictionary({"name": "test"})  # Only set name
	assert(msg.name == "test", "Name should be updated from partial dict")
	assert(msg.value == 100, "Value should remain default in partial dict")
	assert(msg.tags.size() == 0, "Tags should remain default in partial dict")
	assert(msg.active == false, "Active should remain default in partial dict")
	assert(is_equal_approx(msg.score, 0.5), "Score should remain default in partial dict")
	print("Dictionary null handling test passed!")

func test_to_string():
	print("\nTesting string representation...")
	
	# 测试默认值的字符串表示
	var msg1 = SimpleProto.SimpleMessage.new()
	var default_str = str(msg1)
	print("默认值字符串: ", default_str)
	# 解析JSON字符串并验证内容
	var default_json = JSON.parse_string(default_str)
	assert(default_json != null, "应该是有效的JSON")
	assert(default_json["name"] == "simple_demo", "JSON应包含默认名称")
	assert(default_json["value"] == 100, "JSON应包含默认数值")
	assert(default_json["tags"].size() == 0, "JSON应包含空标签数组")
	assert(default_json["active"] == false, "JSON应包含默认激活状态")
	assert(is_equal_approx(default_json["score"], 0.5), "JSON应包含默认分数")
	
	# 测试包含中文的自定义值
	var msg2 = SimpleProto.SimpleMessage.new()
	msg2.name = "测试消息"
	msg2.value = 42
	msg2.tags.append_array(["标签1", "标签2"])
	msg2.active = true
	msg2.score = 3.14
	
	var custom_str = str(msg2)
	print("自定义值字符串: ", custom_str)
	# 解析JSON字符串并验证内容
	var custom_json = JSON.parse_string(custom_str)
	assert(custom_json != null, "应该是有效的JSON")
	assert(custom_json["name"] == "测试消息", "JSON应包含中文名称")
	assert(custom_json["value"] == 42, "JSON应包含自定义数值")
	assert(custom_json["tags"].size() == 2 && custom_json["tags"][0] == "标签1" && custom_json["tags"][1] == "标签2", "JSON应包含中文标签")
	assert(custom_json["active"] == true, "JSON应包含自定义激活状态")
	assert(is_equal_approx(custom_json["score"], 3.14), "JSON应包含自定义分数")
	
	print("String representation test passed!")

func test_simple_message_default():
	print("\nTesting SimpleMessage default values...")
	var msg = SimpleProto.SimpleMessage.new()
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = SimpleProto.SimpleMessage.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Test dictionary serialization
	var dict = msg.SerializeToDictionary()
	var dict_parsed_msg = SimpleProto.SimpleMessage.new()
	dict_parsed_msg.ParseFromDictionary(dict)
	
	# Verify default values
	assert(parsed_msg.name == "simple_demo", "Default name mismatch")
	assert(parsed_msg.value == 100, "Default value mismatch")
	assert(parsed_msg.tags.size() == 0, "Default tags mismatch")
	assert(parsed_msg.active == false, "Default active mismatch")
	assert(is_equal_approx(parsed_msg.score, 0.5), "Default score mismatch")
	
	# Verify dictionary parsed values
	assert(dict_parsed_msg.name == "simple_demo", "Default dict name mismatch")
	assert(dict_parsed_msg.value == 100, "Default dict value mismatch")
	assert(dict_parsed_msg.tags.size() == 0, "Default dict tags mismatch")
	assert(dict_parsed_msg.active == false, "Default dict active mismatch")
	assert(is_equal_approx(dict_parsed_msg.score, 0.5), "Default dict score mismatch")
	
	# Test string representation
	var str_repr = str(msg)
	print("Default string representation:", str_repr)
	var json = JSON.parse_string(str_repr)
	assert(json != null, "Should be valid JSON")
	
	print("SimpleMessage default values test passed!")

func test_simple_message_custom():
	print("\nTesting SimpleMessage custom values...")
	var msg = SimpleProto.SimpleMessage.new()
	msg.name = "Test Message"
	msg.value = 42
	msg.tags.append_array(["tag1", "tag2"])
	msg.active = true
	msg.score = 3.14
	
	# Test binary serialization
	var bytes = msg.SerializeToBytes()
	var parsed_msg = SimpleProto.SimpleMessage.new()
	parsed_msg.ParseFromBytes(bytes)
	
	# Test dictionary serialization
	var dict = msg.SerializeToDictionary()
	var dict_parsed_msg = SimpleProto.SimpleMessage.new()
	dict_parsed_msg.ParseFromDictionary(dict)
	
	# Verify custom values
	assert(parsed_msg.name == "Test Message", "Custom name mismatch")
	assert(parsed_msg.value == 42, "Custom value mismatch")
	assert(parsed_msg.tags.size() == 2, "Custom tags size mismatch")
	assert(parsed_msg.tags[0] == "tag1", "Custom tags[0] mismatch")
	assert(parsed_msg.tags[1] == "tag2", "Custom tags[1] mismatch")
	assert(parsed_msg.active == true, "Custom active mismatch")
	assert(is_equal_approx(parsed_msg.score, 3.14), "Custom score mismatch")
	
	# Verify dictionary parsed values
	assert(dict_parsed_msg.name == "Test Message", "Custom dict name mismatch")
	assert(dict_parsed_msg.value == 42, "Custom dict value mismatch")
	assert(dict_parsed_msg.tags.size() == 2, "Custom dict tags size mismatch")
	assert(dict_parsed_msg.tags[0] == "tag1", "Custom dict tags[0] mismatch")
	assert(dict_parsed_msg.tags[1] == "tag2", "Custom dict tags[1] mismatch")
	assert(dict_parsed_msg.active == true, "Custom dict active mismatch")
	assert(is_equal_approx(dict_parsed_msg.score, 3.14), "Custom dict score mismatch")
	
	# Test string representation
	var str_repr = str(msg)
	print("Custom string representation:", str_repr)
	var json = JSON.parse_string(str_repr)
	assert(json != null, "Should be valid JSON")
	
	print("SimpleMessage custom values test passed!")

func test_simple_message_to_string():
	print("\nTesting SimpleMessage ToString()...")
	
	# Test default values
	var default_msg = SimpleProto.SimpleMessage.new()
	var default_str = default_msg.ToString()
	print("Default ToString():", default_str)
	
	# Verify default string is valid JSON
	var default_json = JSON.parse_string(default_str)
	assert(default_json != null, "Default ToString() should produce valid JSON")
	assert(default_json["name"] == "simple_demo", "Default name mismatch in ToString()")
	assert(default_json["value"] == 100, "Default value mismatch in ToString()")
	assert(default_json["tags"].size() == 0, "Default tags mismatch in ToString()")
	assert(default_json["active"] == false, "Default active mismatch in ToString()")
	assert(is_equal_approx(default_json["score"], 0.5), "Default score mismatch in ToString()")
	
	# Test custom values
	var custom_msg = SimpleProto.SimpleMessage.new()
	custom_msg.name = "测试消息"  # Test UTF-8 support
	custom_msg.value = 42
	custom_msg.tags.append_array(["标签1", "标签2"])  # Test array with UTF-8
	custom_msg.active = true
	custom_msg.score = 3.14
	
	var custom_str = custom_msg.ToString()
	print("Custom ToString():", custom_str)
	
	# Verify custom string is valid JSON
	var custom_json = JSON.parse_string(custom_str)
	assert(custom_json != null, "Custom ToString() should produce valid JSON")
	assert(custom_json["name"] == "测试消息", "Custom name mismatch in ToString()")
	assert(custom_json["value"] == 42, "Custom value mismatch in ToString()")
	assert(custom_json["tags"].size() == 2, "Custom tags size mismatch in ToString()")
	assert(custom_json["tags"][0] == "标签1", "Custom tags[0] mismatch in ToString()")
	assert(custom_json["tags"][1] == "标签2", "Custom tags[1] mismatch in ToString()")
	assert(custom_json["active"] == true, "Custom active mismatch in ToString()")
	assert(is_equal_approx(custom_json["score"], 3.14), "Custom score mismatch in ToString()")
	
	print("SimpleMessage ToString() test passed!")
