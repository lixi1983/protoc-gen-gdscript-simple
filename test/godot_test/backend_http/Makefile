.PHONY: all proto build clean

all: proto build

proto:
	protoc --go_out=. --go_opt=paths=source_relative proto3/*.proto

build: 
	go build -o server main.go

clean:
	rm -f server
	rm -f proto3/*.pb.go

run:
	./server
