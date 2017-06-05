PROJECTS_DIR = terraform/states
PROJECTS = $(notdir $(wildcard $(PROJECTS_DIR)/*))
PROJECT_FROM_TARGET = $(firstword $(subst /, ,$1))
ACTION_FROM_TARGET = $(lastword $(subst /, ,$1))

%/build %/run %/publish %/provision %/deploy: project = $(call PROJECT_FROM_TARGET, $@)
%/build %/run %/publish %/provision %/deploy: action = $(call ACTION_FROM_TARGET, $@)
%/build %/run %/publish %/provision %/deploy:
	cd $(project) && make $(action)
