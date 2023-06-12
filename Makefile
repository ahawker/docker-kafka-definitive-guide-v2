.DEFAULT_GOAL := help
.SUFFIXES:

include project.vars
export $(shell sed 's/=.*//' project.vars)

.PHONY: clean-%
clean-%: ## Clean target deployment stack for the given stem.
	@$(MAKE) -C $(DEPLOY_DIR) clean-$*

.PHONY: start-%
start-%: ## Start target deployment stack for the given stem.
	@$(MAKE) -C $(DEPLOY_DIR) start-$*

.PHONY: stop-%
stop-%: ## Stop target deployment stack for the given stem.
	@$(MAKE) -C $(DEPLOY_DIR) stop-$*

.PHONY: restart-broker-%s
restart-broker-%: ## Restart broker for the given stem id.
	@$(MAKE) -C $(DEPLOY_DIR) restart-broker-$*

.PHONY: start-broker-%s
start-broker-%: ## Start cluster broker for the given stem id.
	@$(MAKE) -C $(DEPLOY_DIR) start-broker-$*

.PHONY: stop-broker-%s
stop-broker-%: ## Stop cluster broker for the given stem id.
	@$(MAKE) -C $(DEPLOY_DIR) stop-broker-$*

.PHONY: pause-broker-%s
pause-broker-%: ## Pause cluster broker for the given stem id.
	@$(MAKE) -C $(DEPLOY_DIR) pause-broker-$*

.PHONY: resume-broker-%s
resume-broker-%: ## Resume cluster broker for the given stem id.
	@$(MAKE) -C $(DEPLOY_DIR) resume-broker-$*

.PHONY: shell-broker-%s
shell-broker-%: ## Open shell to cluster broker for the given stem id.
	@$(MAKE) -C $(DEPLOY_DIR) shell-broker-$*

.PHONY: pause-zk
pause-zk: ## Pause zookeeper.
	@$(MAKE) -C $(DEPLOY_DIR) pause-zk

.PHONY: resume-zk
resume-zk: ## Resume zookeeper.
	@$(MAKE) -C $(DEPLOY_DIR) resume-zk

.PHONY: help
help: ## Show help/usage.
	@grep -E '^[%a-zA-Z0-9_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
