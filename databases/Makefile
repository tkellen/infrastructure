DB = $(notdir $(wildcard *))
DB_FROM_TARGET = $(firstword $(subst /, ,$1))

.PHONY: create up down %/create %/up %/down

# Create target for every possible database.
create up down: $(addsuffix $@, $(DB))

# Set the database context for all commands.
%/create %/up %/down %version: db = $(call DB_FROM_TARGET, $@)

%/create:
	@read -p "Enter migration name: " name; \
	dbmate -d $(db)/migrations new $$name

%/up:
	dbmate -d $(db)/migrations up

%/down:
	dbmate -d $(db)/migrations down
