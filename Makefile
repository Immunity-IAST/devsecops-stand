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

change_creds:
	docker-compose exec faraday faraday-manage change-password

.PHONY: up down clean creds change_creds
