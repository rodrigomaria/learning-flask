ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)
EXEC = docker-compose exec learning-flask

help: ## show the make help
	@echo 'usage: make [target] [option]'
	@echo ''
	@echo 'Common sequence of commands:'
	@echo '- make build [nocache]'
	@echo '- make run'
	@echo '- make sh'
	@echo '- make lint'
	@echo ''
	@echo 'targets:'
	@egrep '^(.+)\:\ .*##\ (.+)' ${MAKEFILE_LIST} | sed 's/:.*##/#/' | column -t -c 2 -s '#'

build: ## build application image
ifeq ($(ARGS), nocache)
	@ docker-compose build --no-cache
else
	@ docker-compose build
endif

run: ## run this container
	@ docker-compose up -d

.PHONY: sh
sh: run ## runs pure shell on application container
	@ $(EXEC) sh

lint: ## runs linters over the code
	@ $(EXEC) /bin/sh -c "isort . && black . && flake8 ."