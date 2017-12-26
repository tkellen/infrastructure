.PHONY: create up down

create:
	@read -p "Enter migration name: " name; \
	dbmate -d db/migrations new $$name

up:
	dbmate -d db/migrations up

down:
	dbmate -d db/migrations down
