extends Node

# Test scripts
var proto2_complex_test = preload("res://addons/protobuf/example/proto2/test/test_complex_message.gd")
var proto2_simple_test = preload("res://addons/protobuf/example/proto2/test/test_simple_message.gd")
var proto3_serialize_test = preload("res://addons/protobuf/example/proto3/test/proto_serialize.gd")
var http_test = preload("res://addons/protobuf/example/http_client/http_client.gd")

func _ready():
	print("\n=== Starting Proto2 Complex Message Tests ===")
	var complex_test = proto2_complex_test.new()
#	complex_test.run_tests()
	complex_test.free()
	
	print("\n=== Starting Proto2 Simple Message Tests ===")
	var simple_test = proto2_simple_test.new()
	simple_test.run_tests()
	simple_test.free()
	
	print("\n=== Starting Proto3 Serialization Tests ===")
	var serialize_test = proto3_serialize_test.new()
#	serialize_test.run_tests()	
	serialize_test.free()
	
	var http_client = http_test.new()
	
	print("\n=== All Tests Completed ===")
