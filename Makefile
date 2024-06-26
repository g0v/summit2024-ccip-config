# Use bash syntax
# Ref:https://askubuntu.com/questions/95365/
SHELL := /bin/bash
-include .env
export $(shell sed 's/=.*//' .env)

DOCKER_DEFAULT_PLATFORM ?= linux/amd64

.EXPORT_ALL_VARIABLES:

.ONESHELL:

.phony:
	help

## ============================================================================
## Help Commands

help: ## Show help
	sed -ne '/sed/!s/## //p' $(MAKEFILE_LIST)

## ============================================================================
## Server-side Commands

caddy: ## replace Caddyfile and restart caddy server
	$(call FUNC_MAKE_INIT) \
		&& systemctl stop caddy \
		&& mv /etc/caddy/Caddyfile /etc/caddy/Caddyfile.bak \
		&& ln -s "${PWD}"/Caddyfile /etc/caddy/Caddyfile \
		&& systemctl start caddy \
		&& systemctl status caddy

go: ## rm->up->log container image via docker
	make rm up log

up: ## run Mongo & Mongo Express
	$(call FUNC_MAKE_INIT) \
	&& docker compose \
	-f container/docker-compose.yml \
	up \
	--detach

log: ## get Mongo & Mongo Express
	$(call FUNC_MAKE_INIT) \
	&& docker compose \
	-f container/docker-compose.yml \
	logs \
	--follow \
	--tail 20

rm: ## rm Mongo & Mongo Express
	$(call FUNC_MAKE_INIT) \
	&& docker compose \
	-f container/docker-compose.yml \
	rm \
	--stop \
	--force

## ============================================================================
## Local-env Commands

sync: ## sync local to server
	$(call FUNC_MAKE_INIT) \
	&& rsync \
	-avzh \
	--progress \
	--exclude '.DS_Store' \
	--exclude '.env' \
	--exclude '.git' \
	--exclude '.gitignore' \
	--exclude '*.md' \
	--exclude '*sample*' \
	--exclude '*container*' \
	--chown=opass:opass \
	--ignore-times \
	"${FOLDER_TO_SYNC}" \
	"${RSYNC_TARGET}":"${FOLDER_TARGET}"

define FUNC_MAKE_INIT
	if [ -n "$$(command -v hr)" ]; then hr -; else echo "-----";fi \
	&& echo "⚙️ Running Makefile target: ${MAKECMDGOALS}"
endef
