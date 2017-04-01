STATES := $(wildcard terraform/states/*)
STATE_FROM_TARGET = $(firstword $(subst :, ,$1))

%\:init: state = $(call STATE_FROM_TARGET, $@)
%\:init:
	cd terraform/states/$(state) && terraform init

%\:plan: state = $(call STATE_FROM_TARGET, $@)
%\:plan:
	cd terraform/states/$(state) && terraform plan -out $(state).plan

%\:apply: state = $(call STATE_FROM_TARGET, $@)
%\:apply:
	cd terraform/states/$(state) && terraform apply $(state).plan
