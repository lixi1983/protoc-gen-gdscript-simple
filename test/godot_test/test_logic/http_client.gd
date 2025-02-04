extends SceneTree

const proto3Test = preload("res://proto3/test.gd")
const common = preload("res://proto3/common.gd")

var websocket: WebSocketPeer
const REQUEST_TIMEOUT: float = 5.0  # 5 seconds timeout
var start_time: float = 0

func _init():
    # 创建 WebSocket 连接
    websocket = WebSocketPeer.new()
    
    # 连接到服务器
    var url = "ws://localhost:8080/ws"
    var error = websocket.connect_to_url(url)
    if error != OK:
        push_error("Failed to connect to WebSocket server: " + str(error))
        quit(1)
        return
    
    # 记录开始时间
    start_time = Time.get_unix_time_from_system()
    
    # 开始处理
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
    # 等待连接建立
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
    
    # 重置超时计时器
    start_time = Time.get_unix_time_from_system()
    
    # 发送测试消息
    send_test_message()
    
    # 持续处理消息
    var message_received = false
    while websocket.get_ready_state() == WebSocketPeer.STATE_OPEN:
        websocket.poll()
        
        # 处理所有待处理的消息
        while websocket.get_available_packet_count() > 0:
            var packet = websocket.get_packet()
            handle_message(packet)
            message_received = true
            # 收到消息后退出
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

func send_test_message():
    # 手动构建 protobuf 消息
    var binary_data = PackedByteArray()
    
    # MsgTest message
    # Field 1: common_msg (embedded message)
    binary_data.append(0x0A)  # Field number 1, wire type 2 (length-delimited)
    
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
    
    # 发送消息
    var error = websocket.send(binary_data, WebSocketPeer.WRITE_MODE_BINARY)
    if error != OK:
        push_error("Failed to send message: " + str(error))
        quit(1)

func handle_message(packet: PackedByteArray):
    print("Received packet, size: ", len(packet))
    print("Received packet hex: ", bytes_to_hex(packet))
    
    # 手动解析 protobuf 消息
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
