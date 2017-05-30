# databases
> manage schema for everything.

## Setup
1. Install [dbmate].
2. Set DATABASE_URL env (TODO: automate getting creds from Vault in Makefile)

### Commands Available
The most common database migration commands `create`, `up`, and `down` have been
aliased in the supplied Makefile. If more complex management is needed, `cd`
into the appropriate `database/migrations/` folder and run [dbmate] directly.

#### make [database]/create
Create a new migration file for the specified database.

#### make [database]/up
Update the specified database to the latest migration.

#### make [database]/down
Roll back the specified database one migration.

[dbmate]: https://github.com/amacneil/dbmate
