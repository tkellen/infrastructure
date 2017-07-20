STATES_DIR = terraform/states
STATES = $(notdir $(wildcard $(STATES_DIR)/*))
STATE_FROM_TARGET = $(firstword $(subst /, ,$1))

.PHONY: init plan apply cowboy %/init %/plan %/apply %/cowboy %/ssh-status %/ssh-toggle
init: $(addsuffix /init, $(STATES))
plan: $(addsuffix /plan, $(STATES))
apply: $(addsuffix /apply, $(STATES))

%/init %/plan %/apply %/cowboy: state = $(call STATE_FROM_TARGET, $@)

%/init:
	cd terraform/states/$(state) && terraform init

%/plan:
	cd terraform/states/$(state) && terraform plan -out $(state).plan

%/apply:
	cd terraform/states/$(state) && terraform apply $(state).plan

%/cowboy:
	cd terraform/states/$(state) && terraform apply

##
# This section provides support for managing SSH access.
# See README for more information.
#
SSH_CHECK = $(shell aws ec2 \
	describe-security-groups \
	--group-ids $1 \
	--profile $2 \
	--filters Name=ip-permission.from-port,Values=22 \
	--query "SecurityGroups[*].GroupId" \
	--region us-east-1 \
	--output text \
)
SSH_MODIFY = $(shell aws ec2 \
	$1-security-group-ingress \
	--group-id $2 \
	--profile $3 \
	--protocol tcp \
	--port 22 \
	--cidr 0.0.0.0/0 \
	--region us-east-1 \
	&& echo $1 \
)
SSH_STATE = $(if $(findstring $(call SSH_CHECK,$1,$2),$1),'true',)
SSH_TOGGLE = $(if $1,$(call SSH_DISABLE,$2,$3),$(call SSH_ENABLE,$2,$3))

%/ssh-status %/ssh-toggle: state = $(call STATE_FROM_TARGET, $@)
%/ssh-status %/ssh-toggle: sg_id = $(shell cd terraform/states/$(state) && terraform output security_group_id 2> /dev/null)
%/ssh-status %/ssh-toggle: profile = $(shell cd terraform/states/$(state) && terraform output profile)
%/ssh-status %/ssh-toggle: ssh_is_enabled = $(call SSH_STATE,$(sg_id),$(profile))
%/ssh-status %/ssh-toggle: next_state = $(if $(sg_id),$(if $(ssh_is_enabled),'revoke','authorize'),)
%/ssh-status:
	@echo SSH status for $(state) set to $(if $(sg_id),$(if $(ssh_is_enabled),'authorize','revoke'),'n/a').

%/ssh-toggle:
	@echo SSH status for $(state) set to $(if $(sg_id),$(call SSH_MODIFY,$(next_state),$(sg_id),$(profile)),'n/a').

ssh-status: $(addsuffix /ssh-status, $(STATES))
