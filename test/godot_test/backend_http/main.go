package main

import (
    "log"
    "net/http"
    "github.com/gorilla/websocket"
    "google.golang.org/protobuf/proto"
    pb "backend_http/proto3"
)

var upgrader = websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool {
        return true // 允许所有来源
    },
}

func handleWebSocket(w http.ResponseWriter, r *http.Request) {
    conn, err := upgrader.Upgrade(w, r, nil)
    if err != nil {
        log.Printf("Failed to upgrade connection: %v", err)
        return
    }
    defer conn.Close()

    log.Printf("New WebSocket connection from %s", conn.RemoteAddr())

    for {
        messageType, data, err := conn.ReadMessage()
        if err != nil {
            if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
                log.Printf("WebSocket error: %v", err)
            }
            break
        }

        log.Printf("Received message type: %d, data length: %d", messageType, len(data))
        log.Printf("Raw message hex: %x", data)

        // 解析 protobuf 消息
        msg := &pb.MsgTest{}
        err = proto.Unmarshal(data, msg)
        if err != nil {
            log.Printf("Failed to unmarshal protobuf message: %v", err)
            continue
        }

        log.Printf("Decoded message: %+v", msg)

        // 创建响应消息
        response := msg 

        // 序列化响应消息
        responseData, err := proto.Marshal(response)
        if err != nil {
            log.Printf("Failed to marshal response: %v", err)
            continue
        }

        log.Printf("Sending response: %+v", response)
        log.Printf("Response hex: %x", responseData)

        err = conn.WriteMessage(messageType, responseData)
        if err != nil {
            log.Printf("Failed to write message: %v", err)
            break
        }
    }
}

func handleDebug(w http.ResponseWriter, r *http.Request) {
    log.Printf("hello")
    w.Write([]byte("hello"))
}

func main() {
    http.HandleFunc("/ws", handleWebSocket)
    http.HandleFunc("/debug", handleDebug)
    http.HandleFunc("/", handleDebug)

    log.Printf("WebSocket server starting on :8080...")
    err := http.ListenAndServe(":8080", nil)
    if err != nil {
        log.Fatal(err)
    }
}
