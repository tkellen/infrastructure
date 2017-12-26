PLAYBOOKS_DIR = ansible
DISTRIBUTIONS = $(subst -deploy,,$(patsubst %.yml,%,$(notdir $(wildcard $(PLAYBOOKS_DIR)/*-deploy.yml))))
DISTRIBUTION_FROM_TARGET = $(firstword $(subst /, ,$1))
ENV ?= dev

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: ## provision, deploy and restore database
	@echo Please specify a distribution.
	@echo Usage: make [$(DISTRIBUTIONS)]/init

.PHONY: provision
provision: ## install system dependencies (php, nginx, postgresql, etc)
	@echo Please specify a distribution.
	@echo Usage: make [$(DISTRIBUTIONS)]/provision

.PHONY: deploy
deploy: ## deploy a distribution
	@echo Please specify a distribution.
	@echo Usage: make [$(DISTRIBUTIONS)]/deploy

.PHONY: restore-db
restore-db: ## restore a database
	@echo Please specify a distribution and ensure src/[dist].sql exists on the target host.
	@echo Usage: make [$(DISTRIBUTIONS)]/restore-db

.PHONY: edit-vars
edit-vars: ## edit encrypted variables
	@echo Please specify a distribution.
	@echo Usage: make [$(DISTRIBUTIONS)]/edit-vars

%/init %/deploy %/provision %/restore-db %/edit-vars: dist = $(call DISTRIBUTION_FROM_TARGET, $@)
%/init %/deploy %/provision %/restore-db %/edit-vars: inv = inventory/$(dist)-$(ENV)

%/init:
	$(MAKE) $(dist)/deploy
	$(MAKE) $(dist)/provision
	$(MAKE) $(dist)/restore-db

%/deploy:
	@echo Deploying $(dist)...
	cd $(PLAYBOOKS_DIR) && ansible-playbook --ask-vault-pass -i $(inv) $(dist)-deploy.yml
	@echo Deployed.

%/provision:
	@echo Provisioning $(dist) environment...
	cd $(PLAYBOOKS_DIR) && ansible-playbook --ask-vault-pass -i $(inv) $(dist)-provision.yml
	@echo Environment provisioned.

%/restore-db:
	@echo Restoring $(dist) database...
	cd $(PLAYBOOKS_DIR) && ansible-playbook --ask-vault-pass -i $(inv) $(dist)-restore-db.yml
	@echo Database restored.

%/edit-vars:
	@echo Decrypting $(dist) variables for editing...
	ansible-vault edit ansible/vars/$(dist).yml
	@echo Variables re-encrypted.
