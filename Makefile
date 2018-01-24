PROJECTS = $(filter-out Makefile README.md,$(notdir $(wildcard *)))
PROJECT_FROM_TARGET = $(firstword $(subst /, ,$1))

.PHONY: init plan apply cowboy %/init %/plan %/apply %/cowboy %/ssh-status %/ssh-toggle
init: $(addsuffix /init, $(PROJECTS))
plan: $(addsuffix /plan, $(PROJECTS))
apply: $(addsuffix /apply, $(PROJECTS))

%/init %/plan %/apply %/cowboy: project = $(call PROJECT_FROM_TARGET, $@)

%/init:
	rm -rf $(project)/terraform/.terraform
	cd $(project)/terraform && terraform init

%/plan:
	cd $(project)/terraform && terraform plan -out $(project).plan

%/apply:
	cd $(project)/terraform && terraform apply $(project).plan

%/cowboy:
	cd $(project)/terraform && terraform apply

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

%/ssh-status %/ssh-toggle: project = $(call PROJECT_FROM_TARGET, $@)
%/ssh-status %/ssh-toggle: sg_id = $(shell cd $(project)/terraform && terraform output security_group_id 2> /dev/null)
%/ssh-status %/ssh-toggle: profile = $(shell cd $(project)/terraform && terraform output profile)
%/ssh-status %/ssh-toggle: ssh_is_enabled = $(call SSH_STATE,$(sg_id),$(profile))
%/ssh-status %/ssh-toggle: next_project = $(if $(sg_id),$(if $(ssh_is_enabled),'revoke','authorize'),)
%/ssh-status:
	@echo SSH status for $(project) set to $(if $(sg_id),$(if $(ssh_is_enabled),'authorize','revoke'),'n/a').

%/ssh-toggle:
	@echo SSH status for $(project) set to $(if $(sg_id),$(call SSH_MODIFY,$(next_state),$(sg_id),$(profile)),'n/a').

ssh-status: $(addsuffix /ssh-status, $(PROJECTS))
