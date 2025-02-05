extends SceneTree

const proto3Test = preload("res://proto3/test.gd")
const common = preload("res://proto3/common.gd")

func _init():
    print("proto serialize!")
    test_proto3_serialize()
    test_proto3_merge()
    test_proto3_clone()
    quit(0)

func _read():
    pass

func test_proto3_serialize():
    print("========= begin proto3/test.proto serialize ==============")
    var test = proto3Test.MsgBase.new()
    test.msg_field1 = 12345789098765
    test.msg_field2 = "132"
    test.field2 = [12345, 13]
    test.b_field3 = true
    test.f_field4 = 1234.5566
    test.map_field5 = {1: "hello", 2: "world"}
    test.enum_field6 = proto3Test.EnumTest.ENUM_TEST2
    test.sub_msg.sub_field1 = 123
    test.sub_msg.sub_field2 = "hello"
    test.common_msg.common_field2 = "world344"
    test.common_msg.common_field1 = 23232
#    test.common_enum = common.CommonEnum.COMMON_ENUM_ONE

    print("test string: ", test.ToString())

    var bytesString = test.SerializeToString()
    print("test: ", bytesString.size())
    var test2 = proto3Test.MsgBase.new()
    test2.ParseFromString(bytesString)
    var testBytesString = test2.SerializeToString()
    print("test2 size: ", testBytesString.size())
    print("test2: ", test2.ToString())
    print("test end, is equal: ", test.ToString() == test2.ToString())

    print("========= end proto3/test.proto serialize ==============")

func test_proto3_merge():
    print("========= begin proto3/test.proto merge ==============")
    var first = proto3Test.MsgBase.new()
    first.msg_field1 = 13232
    first.field2 = [1, 2, 3, 4, 5]
    first.msg_field2 = "hello"
    first.b_field3 = true
    first.map_field5 = {3: "hello", 4: "world"}

    var second = proto3Test.MsgBase.new()

    print("first toString: ", first.ToString())
    second.MergeFrom(first)
    first.field2[1] = 10
    print("second toString: ", second.ToString())

    print("after first toString: ", first.ToString())
    print("========= end proto3/test.proto merge ==============")

func test_proto3_clone():
    print("========= begin proto3/test.proto clone ==============")
    var first = proto3Test.MsgBase.new()
    first.msg_field1 = 668866
    first.field2 = [1, 2, 3, 4]
    first.msg_field2 = "world"
    first.b_field3 = false
    first.map_field5 = {5: "hello", 6: "world"}

    var second = first.Clone() #proto3Test.MsgBase.new()

    print("first toString: ", first.ToString())
    first.field2[1] = 10
    print("second toString: ", second.ToString())

    print("after first toString: ", first.ToString())
    print("========= end proto3/test.proto merge ==============")
