.DEFAULT_GOAL := help

STACKS       ?= $(shell find . -mindepth 2 -type f -name 'Makefile' | sed -E "s|/[^/]+$$||" | sed "s|^\./||" | sort)
CLEAN_STACKS ?= $(STACKS:%=clean-%)
START_STACKS ?= $(STACKS:%=start-%)
STOP_STACKS  ?= $(STACKS:%=stop-%)

.PHONY: clean
clean: $(CLEAN_STACKS) ## Clean all stacks.
.PHONY: clean-cluster
clean-cluster: clean-stack-cluster ## Clean stack for 'cluster'.

.PHONY: start
start: $(START_STACKS) ## Start all stacks.
.PHONY: start-cluster
start-cluster: start-stack-cluster ## Start stack for 'cluster'.

.PHONY: stop
stop: $(STOP_STACKS) ## Stop all stacks.
.PHONY: stop-cluster
stop-cluster: stop-stack-cluster ## Stop stack for 'cluster'.

.PHONY: clean-stack-%
clean-stack-%:
	@echo "==> Cleaning stack $*"
	@$(MAKE) -C $* clean

.PHONY: start-stack-%
start-stack-%:
	@echo "==> Starting stack $*"
	@$(MAKE) -C $* start

.PHONY: stop-stack-%
stop-stack-%:
	@echo "==> Stopping stack $*"
	@$(MAKE) -C $* stop

.PHONY: restart-broker-%s
restart-broker-%: ## Restart broker for the given stem id.
	@echo "==> Restarting broker id=$* in v2 stack"
	@$(MAKE) -C cluster restart-broker-$*

.PHONY: start-broker-%s
start-broker-%: ## Start broker for the given stem id.
	@$(MAKE) -C cluster start-broker-$*

.PHONY: stop-broker-%s
stop-broker-%: ## Stop broker for the given stem id.
	@$(MAKE) -C cluster stop-broker-$*

.PHONY: pause-broker-%s
pause-broker-%: ## Pause broker for the given stem id.
	@$(MAKE) -C cluster pause-broker-$*

.PHONY: resume-broker-%s
resume-broker-%: ## Resume broker for the given stem id.
	@$(MAKE) -C cluster resume-broker-$*

.PHONY: shell-broker-%s
shell-broker-%: ## Open shell to broker for the given stem id.
	@$(MAKE) -C cluster shell-broker-$*

.PHONY: pause-zk
pause-zk: ## Pause zookeeper.
	@$(MAKE) -C cluster pause-zk

.PHONY: resume-zk
resume-zk: ## Resume zookeeper.
	@$(MAKE) -C cluster resume-zk

.PHONY: help
help: ## Show help/usage.
	@grep -E '^[%a-zA-Z0-9_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
