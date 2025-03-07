extends SceneTree

const proto3Test = preload("res://addons/protobuf/example/proto3/generated/test.proto.gd")
const common = preload("res://addons/protobuf/example/proto3/generated/common.proto.gd")

var websocket: WebSocketPeer
const REQUEST_TIMEOUT: float = 5.0  # 5 seconds timeout
var start_time: float = 0

func _init():
	# Create WebSocket connection
	websocket = WebSocketPeer.new()
	
	# Connect to server
	var url = "ws://localhost:8080/ws"
	var error = websocket.connect_to_url(url)
	if error != OK:
		push_error("Failed to connect to WebSocket server: " + str(error))
		quit(1)
		return
	
	# Record start time
	start_time = Time.get_unix_time_from_system()
	
	# Start processing
	process_websocket()

func check_timeout() -> bool:
	var elapsed = Time.get_unix_time_from_system() - start_time
	if elapsed > REQUEST_TIMEOUT:
		push_error("Operation timed out after %f seconds" % REQUEST_TIMEOUT)
		return true
	return false

func bytes_to_hex(bytes: PackedByteArray) -> String:
	var hex_str = ""
	for b in bytes:
		hex_str += "%02x" % b
	return hex_str

func process_websocket():
	# Wait for connection
	while websocket.get_ready_state() == WebSocketPeer.STATE_CONNECTING:
		websocket.poll()
		if check_timeout():
			push_error("connect timeout")
			quit(1)
			return
		OS.delay_msec(100)  # 100ms delay
	
	if websocket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		push_error("Failed to establish WebSocket connection")
		quit(1)
		return
	
	print("WebSocket connection established")
	
	# Reset timeout timer
	start_time = Time.get_unix_time_from_system()


	send_test_message2()
	# Send test message
   # send_test_message()

	# Continue processing messages
	var message_received = false
	while websocket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		websocket.poll()
		
		# Process all pending messages
		while websocket.get_available_packet_count() > 0:
			var packet = websocket.get_packet()
			handle_message(packet)
			message_received = true
			# Exit after receiving message
			quit(0)
			return
		
		if check_timeout():
			quit(1)
			return
			
		OS.delay_msec(100)  # 100ms delay
	
	if not message_received:
		push_error("WebSocket connection closed without receiving message")
		quit(1)
	else:
		print("WebSocket connection closed")
		quit(0)

var send_test = proto3Test.MsgBase.new()
var recv_test = proto3Test.MsgBase.new()

func send_test_message2():
#	var test = proto3Test.MsgBase.new()
#    example.common_msg.common_field2 = "example"
#    example.common_msg.common_field1 = 42
#    example.common_msg.common_sint32 = 22222333
#    example.common_msg.common_sfixed32 = 3333333
#    example.common_msg.common_sfixed64 = 4444444444
#    example.common_msg.common_sint64 = 55555555
#    example.double_field = 123.456223
#    example.msg_field32 = 13232323232323
#    example.fixed_field32 = 1234567890
#    example.fixed_field64 = 1234567890123456789
#    example.f_field4 = 4343.222323
#    example.map_field5[1] = "map_1"
	send_test.map_field5[2] = "map_2"
	send_test.map_field5[4] = "map_4"
	var sub1 = proto3Test.MsgBase.SubMsg.new()
	sub1.sub_field1 = 99
	send_test.map_field_sub["223"] = sub1
	var sub2 = proto3Test.MsgBase.SubMsg.new()
	send_test.map_field_sub["333"] = sub2

	var test_bytes = send_test.SerializeToBytes()

	print("send_test_message2 Message size: ", len(test_bytes))
	print("send_test_message2 Message hex: ", bytes_to_hex(test_bytes))
	print("Send message: ", send_test.ToString())
		# Send message
	var error = websocket.send(test_bytes, WebSocketPeer.WRITE_MODE_BINARY)
	if error != OK:
		push_error("Failed to send message: " + str(error))
		quit(1)

func send_test_message():
	# Manually construct protobuf message
	var binary_data = PackedByteArray()
	
	# MsgTest message
	# Field 1: common_msg (embedded message)
	binary_data.append(0x4A)  # Field number 1, wire type 2 (length-delimited)
	
	# Build CommonMessage
	var common_msg_data = PackedByteArray()
	
	# Field 1: common_field1 (string)
	common_msg_data.append(0x0A)  # Field number 1, wire type 2 (length-delimited)
	common_msg_data.append(4)     # String length
	common_msg_data.append_array("test".to_utf8_buffer())
	
	# Field 2: common_field2 (int32)
	common_msg_data.append(0x10)  # Field number 2, wire type 0 (varint)
	common_msg_data.append(42)    # Value 42
	
	# Add embedded message length and data
	binary_data.append(common_msg_data.size())  # Length of embedded message
	binary_data.append_array(common_msg_data)   # Embedded message content
	
	print("Message size: ", len(binary_data))
	print("Message hex: ", bytes_to_hex(binary_data))
	
	# Send message
	var error = websocket.send(binary_data, WebSocketPeer.WRITE_MODE_BINARY)
	if error != OK:
		push_error("Failed to send message: " + str(error))
		quit(1)

func handle_message(packet: PackedByteArray):
	print("Received packet, size: ", len(packet))
	print("Received packet hex: ", bytes_to_hex(packet))

#	var res = proto3Test.MsgBase.new()
	recv_test.ParseFromBytes(packet)

	print("Received message:", recv_test.ToString())
	
	assert(send_test.ToString() == recv_test.ToString(), "send not equal recv")

	return
