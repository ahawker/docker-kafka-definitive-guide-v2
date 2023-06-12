.DEFAULT_GOAL := help

NAME ?= $(shell basename $$(pwd))
DEPS ?= network zookeeper kafka_3
ENVS ?= $(foreach dep,$(DEPS),../partials/$(dep)/$(dep).env )
YMLS ?= $(foreach dep,$(DEPS),-f ../partials/$(dep)/$(dep).yml )

.PHONY: start
start: ## Start environment.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) up --remove-orphans

.PHONY: stop
stop: ## Stop environment.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) down --remove-orphans

.PHONY: clean
clean: ## Clean environment.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) down --volumes --remove-orphans

.PHONY: restart-broker-%s
restart-broker-%: ## Restart broker for the given stem id.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) restart kafka_$*

.PHONY: stop-broker-%s
start-broker-%: ## Start broker for the given stem id.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) start kafka_$*

.PHONY: stop-broker-%s
stop-broker-%: ## Stop broker for the given stem id.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) stop kafka_$*

.PHONY: pause-broker-%s
pause-broker-%: ## Pause broker for the given stem id.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) pause kafka_$*

.PHONY: resume-broker-%s
resume-broker-%: ## Resume broker for the given stem id.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) unpause kafka_$*

.PHONY: shell-broker-%s
shell-broker-%: ## Open a shell to broker for the given stem id.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) exec kafka_$* /bin/bash

.PHONY: pause-zk
pause-zk: ## Pause zookeeper.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) pause zookeeper

.PHONY: resume-zk
resume-zk: ## Resume zookeeper.
	env $$(cat $(ENVS)) docker-compose -p $(NAME) $(YMLS) unpause zookeeper

.PHONY: help
help: ## Show help/usage.
	@grep -E '^[%a-zA-Z0-9_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
