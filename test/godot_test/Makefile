
http_server:
	cd backend_http && make run

http_client:
	${GODOT} --headless --script test_logic/http_client.gd

clean:
	cd backend_http && make clean

test: proto
	cd backend_http && make build

proto:
	cd backend_http && make proto

run: http_server