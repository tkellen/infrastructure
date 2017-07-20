-- migrate:up
CREATE TABLE meal (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> '') UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE meal IS $$
  Allow categorization of recipes into meal.
$$;

CREATE TABLE volume (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> '') UNIQUE,
  abbr TEXT,
  ratio_to_tsp NUMERIC,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE volume IS $$
  Allow conversions between common measurements when cooking or baking.
  The base measure for each record is the ratio to one teaspoon.
$$;

CREATE TABLE ingredient (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> '') UNIQUE,
  base_volume_id INTEGER REFERENCES volume(id),
  weight_in_grams NUMERIC,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE ingredient IS $$
  Itemize anything used in a recipe. Each record has a base volume of measure
  along with a corresponding weight in grams. This enables the dynamic display
  of alternate volume and weight measures.
$$;

CREATE TABLE stage (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> '') UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE stage IS $$
  Give names to various steps in the process of making a recipe.
  For example: prep time or chilling time.
$$;

CREATE TABLE recipe (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL CHECK(name <> '') UNIQUE,
  description TEXT NOT NULL,
  instructions TEXT NOT NULL,
  output TEXT,
  amount NUMERIC,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE recipe IS $$
  Annotate recipes, parent record for meals / components / ingredients / stages.
$$;

CREATE TABLE recipe_component (
  id SERIAL PRIMARY KEY,
  source_recipe_id INTEGER NOT NULL REFERENCES recipe(id),
  recipe_id INTEGER NOT NULL REFERENCES recipe(id),
  ordering INTEGER NOT NULL DEFAULT 0,
  show_description BOOLEAN NOT NULL DEFAULT false,
  show_stages BOOLEAN NOT NULL DEFAULT false,
  show_output BOOLEAN NOT NULL DEFAULT false,
  show_instructions BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE recipe_component IS $$
  Augment a recipe by attaching other recipes to it. For example, most pie
  recipes are a common crust + filling. This allows recipe authors to use
  the same crust across multiple recipes.
$$;

CREATE TABLE recipe_meal (
  id SERIAL PRIMARY KEY,
  recipe_id INTEGER NOT NULL REFERENCES recipe(id),
  meal_id INTEGER NOT NULL REFERENCES meal(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE recipe_meal IS $$
  Annotate recipes with meals they would ideally be used in.
$$;

CREATE TABLE recipe_ingredient (
  id SERIAL PRIMARY KEY,
  recipe_id INTEGER NOT NULL REFERENCES recipe(id),
  amount NUMERIC,
  volume_id INTEGER REFERENCES volume(id),
  alternate_volume_id INTEGER REFERENCES volume(id),
  ingredient_id INTEGER NOT NULL REFERENCES ingredient(id),
  note TEXT,
  ordering INTEGER NOT NULL,
  is_to_taste BOOLEAN NOT NULL DEFAULT false,
  is_optional BOOLEAN NOT NULL DEFAULT false,
  is_decorative BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE recipe_ingredient IS $$
  Attach ingredients to recipes, supporting flags for augmenting display.
$$;

CREATE TABLE recipe_stage (
  id SERIAL PRIMARY KEY,
  stage_id INTEGER NOT NULL REFERENCES stage(id),
  recipe_id INTEGER NOT NULL REFERENCES recipe(id),
  duration INTERVAL NOT NULL,
  range_multiplier INT4RANGE,
  ordering INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);
COMMENT ON TABLE recipe_stage IS $$
  Annotate recipes with stages to give readers an idea of how much time will
  be needed to complete various steps. At minimum, a duration must be provided.
  If there is a range of acceptable or expected times, a multiplier for the
  lower and upper bounds may be supplied.
$$;

CREATE TRIGGER updated_at BEFORE UPDATE ON meal
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

CREATE TRIGGER updated_at BEFORE UPDATE ON volume
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

CREATE TRIGGER updated_at BEFORE UPDATE ON ingredient
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

CREATE TRIGGER updated_at BEFORE UPDATE ON stage
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

CREATE TRIGGER updated_at BEFORE UPDATE ON recipe
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

CREATE TRIGGER updated_at BEFORE UPDATE ON recipe_component
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

CREATE TRIGGER updated_at BEFORE UPDATE ON recipe_meal
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

CREATE TRIGGER updated_at BEFORE UPDATE ON recipe_ingredient
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

CREATE TRIGGER updated_at BEFORE UPDATE ON recipe_stage
  FOR EACH ROW EXECUTE PROCEDURE updated_at();

-- migrate:down
DROP TABLE recipe_stage;
DROP TABLE recipe_ingredient;
DROP TABLE recipe_meal;
DROP TABLE recipe_component;
DROP TABLE recipe;
DROP TABLE stage;
DROP TABLE ingredient;
DROP TABLE volume;
DROP TABLE meal;
