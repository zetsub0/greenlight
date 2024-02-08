##help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

##run: run the cmd/api application
.PHONY: run
run:
	go run ./cmd/api

##psql: connect to the database using psql
.PHONY: psql
psql:
	psql${GREENLIGHT_DB_DSN}

##migration: create a new database migration
.PHONY: migration
migration: confirm
	@echo 'Creating migration file for ${name}'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

##up: apply all database migrations
.PHONY: up
up:
	@echo 'Running up migrations...'
	migrate -path "./migrations" -database "${GREENLIGHT_DB_DSN}" up

##down: undo all database migrations
.PHONY: down
down:
	@echo 'Running down migrations...'
	migrate -path "./migrations" -database "${GREENLIGHT_DB_DSN}" down

