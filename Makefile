all: up

rebuild: clean up

up:
	docker-compose up -d --build

down:
	docker-compose down

clean:
	docker-compose down -v

creds:
	docker-compose logs faraday | findstr Admin

.PHONY: up down clean creds
