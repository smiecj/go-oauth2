build:
	go build -o example/server/oauth_server example/server/server.go
	go build -o example/client/oauth_client example/client/client.go

run: stop
	cd example/server && nohup ./oauth_server >> server.log 2>&1 &
	cd example/client && nohup ./oauth_client >> client.log 2>&1 &

run_docker: stop
	cd example/server && nohup ./oauth_server >> server.log 2>&1 &
	cd example/client && nohup ./oauth_client -ch "${client_host}" -cp "${client_port}" -sh "${server_host}" -sp "${server_port}" >> client.log 2>&1 &

stop:
	ps -ef | grep "oauth_server" | grep -v grep | awk '{print $$2}' | xargs -I {} bash -c "kill -9 {}"
	ps -ef | grep "oauth_client" | grep -v grep | awk '{print $$2}' | xargs -I {} bash -c "kill -9 {}"

restart: stop build run

clean: stop
	rm -f example/server/oauth_server
	rm -f example/server/server.log
	rm -f example/client/oauth_client
	rm -f example/client/client.log