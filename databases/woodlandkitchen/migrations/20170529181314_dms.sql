-- migrate:up
CREATE SCHEMA dms;
CREATE TABLE dms.module (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> ''),
  parent_id INTEGER REFERENCES dms.module(id),
  UNIQUE(name, parent_id)
);

CREATE TABLE dms.func (
  id SERIAL PRIMARY KEY,
  module_id INTEGER NOT NULL REFERENCES dms.module(id),
  name text NOT NULL CHECK(name <> ''),
  url text,
  lastrun TIMESTAMPTZ
);

CREATE TABLE dms.menu (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> ''),
  parent_id INTEGER REFERENCES dms.menu(id),
  func_id INTEGER NOT NULL REFERENCES dms.func(id),
  runmode TEXT NOT NULL CHECK(runmode <> ''),
  param TEXT,
  ordering INTEGER,
  cmdkey CHAR(1),
  loggedin bool NOT NULL DEFAULT true,
  loggedout bool NOT NULL DEFAULT false
);

CREATE TABLE dms.access_group (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> '') UNIQUE
);

CREATE TABLE dms.access_listing (
  id SERIAL PRIMARY KEY,
  access_group_id INTEGER NOT NULL REFERENCES dms.access_group(id),
  func_id INTEGER NOT NULL REFERENCES dms.func(id),
  UNIQUE(access_group_id,func_id)
);

CREATE TABLE dms.account (
  id SERIAL PRIMARY KEY,
  first TEXT,
  last TEXT,
  email TEXT,
  phone TEXT,
  login TEXT NOT NULL CHECK(login <> '') UNIQUE,
  pass CHAR(32),
  disabled BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE dms.account_access_group (
  id SERIAL PRIMARY KEY,
  account_id INTEGER NOT NULL REFERENCES dms.account(id),
  access_group_id INTEGER NOT NULL REFERENCES dms.access_group(id),
  UNIQUE(account_id,access_group_id)
);

-- migrate:down
DROP TABLE dms.account_access_group;
DROP TABLE dms.account;
DROP TABLE dms.access_listing;
DROP TABLE dms.menu;
DROP TABLE dms.func;
DROP TABLE dms.module;
DROP TABLE dms
DROP SCHEMA dms;
