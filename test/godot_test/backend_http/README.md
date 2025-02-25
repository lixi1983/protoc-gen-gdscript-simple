# HTTP Protobuf Echo Server

这是一个用golang实现的http服务，用于接收protobuf二进制消息，解码后重新编码并返回。

## 功能
- 通过HTTP POST接收protobuf二进制消息
- 支持解码MsgBase和MsgTest两种消息类型
- 将解码后的消息重新编码并返回

## 设置步骤

1. 安装Go 1.21或更高版本
2. 安装protoc编译器
3. 安装Go protobuf插件:
   ```bash
   go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
   ```

## 生成Protobuf代码

```bash
cd example/godot_test/backend_http
protoc --go_out=. --go_opt=paths=source_relative ../../proto3/*.proto
```

## 运行服务器

```bash
go mod tidy  # 下载依赖
go run main.go  # 启动服务器
```

## 使用方法

服务器监听8080端口，接受POST请求到`/proto`端点。
在请求体中发送protobuf二进制消息，服务器将解码并重新编码消息后返回。

支持的消息类型:
- MsgBase
- MsgTest

Content-Type应设置为`application/x-protobuf`
