STATES_DIR = terraform/states
STATES = $(notdir $(wildcard $(STATES_DIR)/*))
STATE_FROM_TARGET = $(firstword $(subst /, ,$1))

.PHONY: init
init: $(addsuffix /init, $(STATES))

.PHONY: plan
plan: $(addsuffix /plan, $(STATES))

.PHONY: apply
apply: $(addsuffix /apply, $(STATES))

.PHONY: %-init
%/init: state = $(call STATE_FROM_TARGET, $@)
%/init:
	cd terraform/states/$(state) && terraform init

.PHONY: %-plan
%/plan: state = $(call STATE_FROM_TARGET, $@)
%/plan:
	cd terraform/states/$(state) && terraform plan -out $(state).plan

.PHONY: %-apply
%/apply: state = $(call STATE_FROM_TARGET, $@)
%/apply:
	cd terraform/states/$(state) && terraform apply $(state).plan
