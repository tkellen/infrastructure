-- migrate:up
CREATE OR REPLACE FUNCTION updated_at() RETURNS TRIGGER AS $$
  BEGIN
    IF (NEW != OLD) THEN
      NEW.updated_at = CURRENT_TIMESTAMP;
      RETURN NEW;
    END IF;
    RETURN OLD;
  END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION updated_at() IS $$
  To be used on BEFORE UPDATE triggers for tables that maintain an updated_at
  field.

  Example usage:
  ```sql
  CREATE TRIGGER updated_at BEFORE UPDATE ON table_name
    FOR EACH ROW EXECUTE PROCEDURE updated_at();
  ```
$$

-- migrate:down
DROP FUNCTION updated_at();
