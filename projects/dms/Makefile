PLAYBOOKS_DIR = ansible
DISTRIBUTIONS = $(subst -deploy,,$(patsubst %.yml,%,$(notdir $(wildcard $(PLAYBOOKS_DIR)/*-deploy.yml))))
DISTRIBUTION_FROM_TARGET = $(lastword $(subst /, ,$1))
ENV ?= dev

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: provision
provision: ## install system dependencies (php, nginx, postgresql, etc)
	@echo Please specify a distribution.
	@echo Usage: make provision/[$(DISTRIBUTIONS)]

.PHONY: deploy
deploy: ## deploy a distribution
	@echo Please specify a distribution.
	@echo Usage: make deploy/[$(DISTRIBUTIONS)]

.PHONY: restore-db
restore-db: ## restore a database
	@echo Please specify a distribution and ensure src/[dist].sql exists on the target host.
	@echo Usage: make restore-db/[$(DISTRIBUTIONS)]

.PHONY: edit-vars
edit-vars: ## edit encrypted variables
	@echo Please specify a distribution.
	@echo Usage: make edit-vars/[$(DISTRIBUTIONS)]

deploy/% provision/% restore-db/% edit-vars/%: dist = $(call DISTRIBUTION_FROM_TARGET, $@)
deploy/% provision/% restore-db/% edit-vars/%: inv = inventory/$(dist)-$(ENV)
provision/%:
	@echo Provisioning environment...
	cd $(PLAYBOOKS_DIR) && ansible-playbook --ask-vault-pass -i $(inv) $(dist)-provision.yml
	@echo Environment provisioned.

deploy/%:
	@echo Deploying $(dist)...
	cd $(PLAYBOOKS_DIR) && ansible-playbook --ask-vault-pass -i $(inv) $(dist)-deploy.yml
	@echo Deployed.

restore-db/%:
	@echo Restoring database for $(dist)...
	cd $(PLAYBOOKS_DIR) && ansible-playbook --ask-vault-pass -i $(inv) $(dist)-restore-db.yml
	@echo Database restored.

edit-vars/%:
	@echo Decrypting $(dist) variables for editing...
	ansible-vault edit ansible/vars/$(dist).yml
	@echo Variables re-encrypted.
