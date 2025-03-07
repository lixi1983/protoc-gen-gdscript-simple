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

func send_test_message2():
    var test = proto3Test.MsgBase.new()
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
    test.map_field5[2] = "map_2"
    test.map_field5[4] = "map_4"
    var sub1 = proto3Test.MsgBase.SubMsg.new()
    sub1.sub_field1 = 99
    test.map_field_sub["223"] = sub1
    var sub2 = proto3Test.MsgBase.SubMsg.new()
    test.map_field_sub["333"] = sub2

    var test_bytes = test.SerializeToBytes()

    print("send_test_message2 Message size: ", len(test_bytes))
    print("send_test_message2 Message hex: ", bytes_to_hex(test_bytes))
    print("Send message: ", test.ToString())
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

    var res = proto3Test.MsgBase.new()
    res.ParseFromBytes(packet)

    print("Received message:", res.ToString())

    return

    # Manually parse protobuf message
    var offset = 0
    
    # Field 1: common_msg (embedded message)
    if offset >= len(packet) || packet[offset] != 0x0A:
        push_error("Invalid message format: missing common_msg field")
        return
    offset += 1
    
    # Read embedded message length
    if offset >= len(packet):
        push_error("Invalid message format: missing common_msg length")
        return
    var common_msg_length = packet[offset]
    offset += 1
    
    # Read embedded message content
    if offset + common_msg_length > len(packet):
        push_error("Invalid message format: common_msg content truncated")
        return
    var common_msg_data = packet.slice(offset, offset + common_msg_length)
    
    # Parse CommonMessage fields
    var common_field1 = ""
    var common_field2 = 0
    var msg_offset = 0
    
    while msg_offset < common_msg_length:
        if msg_offset >= common_msg_length:
            break
            
        # Read field tag
        var field_tag = common_msg_data[msg_offset]
        msg_offset += 1
        
        match field_tag:
            0x0A:  # Field 1: common_field1 (string)
                if msg_offset >= common_msg_length:
                    push_error("Invalid message format: missing common_field1 length")
                    return
                var str_length = common_msg_data[msg_offset]
                msg_offset += 1
                
                if msg_offset + str_length > common_msg_length:
                    push_error("Invalid message format: common_field1 content truncated")
                    return
                var str_data = common_msg_data.slice(msg_offset, msg_offset + str_length)
                common_field1 = str_data.get_string_from_utf8()
                msg_offset += str_length
            
            0x10:  # Field 2: common_field2 (int32)
                if msg_offset >= common_msg_length:
                    push_error("Invalid message format: missing common_field2 value")
                    return
                common_field2 = common_msg_data[msg_offset]
                msg_offset += 1
    
    print("Decoded message fields:")
    print("  common_field1: ", common_field1)
    print("  common_field2: ", common_field2)
