-- migrate:up
CREATE TABLE author (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> ''),
  email TEXT NOT NULL CHECK(email <> '') UNIQUE
);

CREATE TABLE post (
  id SERIAL PRIMARY KEY,
  author_id INTEGER NOT NULL REFERENCES author(id),
  title TEXT NOT NULL CHECK(title <> ''),
  name TEXT NOT NULL CHECK(name <> ''),
  body TEXT,
  recipe_id INTEGER NOT NULL REFERENCES recipe(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);

CREATE TRIGGER updated_at BEFORE UPDATE ON post
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

-- migrate:down
DROP TABLE post;
DROP TABLE author;
