-- migrate:up
CREATE TABLE image_set (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> ''),
  flickr_id TEXT NOT NULL CHECK(flickr_id <> '') UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE image_set IS $$
  Local cache of flickr photoset data.
$$;

CREATE TABLE image (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> ''),
  flickr_id TEXT NOT NULL CHECK(flickr_id <> '') UNIQUE,
  is_uploaded BOOLEAN NOT NULL DEFAULT false,
  is_uploading BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE image IS $$
  Local cache of flickr photo, used for auto-generating images.
$$;

CREATE TRIGGER updated_at BEFORE UPDATE ON image_set
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

CREATE TRIGGER updated_at BEFORE UPDATE ON image
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

-- migrate:down
DROP TABLE image;
DROP TABLE image_set;
