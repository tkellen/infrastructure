INSERT INTO meal (id, name) VALUES (1, 'breakfast');
INSERT INTO meal (id, name) VALUES (2, 'lunch');
INSERT INTO meal (id, name) VALUES (3, 'snack');
INSERT INTO meal (id, name) VALUES (4, 'appetizer');
INSERT INTO meal (id, name, alias) VALUES (5, 'dinner', 'supper');
INSERT INTO meal (id, name) VALUES (6, 'dessert');

INSERT INTO stage (id, name) VALUES (1, 'prep');
INSERT INTO stage (id, name) VALUES (2, 'cook');
INSERT INTO stage (id, name) VALUES (3, 'bake');
INSERT INTO stage (id, name) VALUES (4, 'chill');

INSERT INTO volume (id, name, abbr, ratio_to_tsp) VALUES (1, 'teaspoon', 'tsp', 1.0);
INSERT INTO volume (id, name, abbr, ratio_to_tsp) VALUES (2, 'tablespoon', 'tbs', 1.0/3);
INSERT INTO volume (id, name, abbr, ratio_to_tsp) VALUES (3, 'cup', 'cup', 1.0/48);
INSERT INTO volume (id, name, abbr, ratio_to_tsp) VALUES (4, 'pint', 'pt', 1.0/96);
INSERT INTO volume (id, name, abbr, ratio_to_tsp) VALUES (5, 'quart', 'qt', 1.0/192);
INSERT INTO volume (id, name, abbr, ratio_to_tsp) VALUES (6, 'gallon', 'gal', 1.0/768);
INSERT INTO volume (id, name, abbr, ratio_to_tsp) VALUES (7, 'pinch', null, null);
INSERT INTO volume (id, name, abbr, ratio_to_tsp) VALUES (8, 'drop', null, null);
INSERT INTO volume (id, name, abbr, ratio_to_tsp) VALUES (9, 'stick', null, 24);

INSERT INTO ingredient (
  id, name, base_volume_id, weight_in_grams
) VALUES
  (1,'cold water',1,5),
  (2,'sugar',1,4.166),
  (3,'fine salt',1,5),
  (4,'all purpose flour',1,2.708),
  (5,'butter',3,226.8),
  (6,'heavy cream',1,5),
  (7,'rose water',1,5),
  (8,'gelatin',1,3.397),
  (9,'lemon zest',1,1.78),
  (10,'sliced strawberries',3,125),
  (11,'currants',1,4.434),
  (12,'brandy',1,4.2),
  (13,'cocoa powder',1,2.2),
  (14,'baking powder',1,4.1),
  (15,'baking soda',1,6.148),
  (16,'ground cinnamon',1,2.3),
  (17,'ground allspice',1,1.9),
  (18,'ground ginger',1,1.8),
  (19,'ground nutmeg',1,1.849),
  (20,'dark chocolate coarsely grated',1,1.7),
  (21,'vanilla extract',1,4.2),
  (22,'orange zest',1,1.78),
  (23,'large egg',null,56),
  (24,'minced crystallized ginger',1,4.434),
  (25,'candied orange peel',1,null),
  (26,'lemon extract', 1, null);

INSERT INTO recipe (id, name, description, output, amount) VALUES
  (1, 'Ottolenghi''s Jerusalem Spice Cookies', 'to be written', 'cups', 1.5),
  (2, 'Panna Cotta', 'to be written', 'servings', 4),
  (3, 'Strawberry Topping', 'to be written', 'cups', 1.5);

INSERT INTO recipe_meal (recipe_id, meal_id) VALUES
  (1, 6),
  (2, 6),
  (3, 1),
  (3, 6);

INSERT INTO recipe_stage (
  ordering, stage_id, recipe_id, duration, range_multiplier
) VALUES
  -- Ottolenghi's Jerusalem Spice Cookies
  (1,1,1,'15 minutes',null), -- prep time approximately 10 minutes
  (2,3,1,'15 minutes',null), -- bake time approximately 20 minutes

  -- Panna Cotta
  (1,1,2,'5 minutes',null),    -- prep time approximately 5 minutes
  (2,4,2,'1 hour','[4,8]'), -- chill time approximately 4-8 hours

  -- Strawberry Topping
  (1,3,3,'10 minutes',null), -- prep time approximately 10 minutes
  (2,3,3,'30 minutes',null); -- mascerating time approximately 30 minutes

INSERT INTO recipe_ingredient (
  ordering, recipe_id, amount, volume_id, alternate_volume_id, ingredient_id, note, is_decorative
) VALUES
  -- Ottolenghi's Jerusalem Spice Cookies
  (1,1,.75,3,null,11,'or combination of currants and minced raisins',false),    -- see below line, grouped by ingredient_id/text
  (2,1,2,2,null,11,null,false),      -- 3/4 cup + 2 tablespoons currants (or combination of currants and minced raisins)
  (3,1,2,2,null,12,null,false),      -- 2 tablespoons brandy (2g)
  (4,1,2,3,null,4,null,false),       -- 2 cups all purpose flour (2g)
  (5,1,.5,1,null,13,null,false),     -- 1 1/2 teaspoons cocoa powder (2g)
  (6,1,.5,1,null,14,null,false),     -- 1/2 teaspoon baking powder (2g)
  (7,1,.25,1,null,15,null,false),    -- 1/4 teaspoon baking soda (2g)
  (8,1,.5,1,null,16,null,false),     -- 1/2 teaspoon ground cinnamon (2g)
  (9,1,.5,1,null,17,null,false),     -- 1/2 teaspoon ground allspice (2g)
  (10,1,.5,1,null,18,null,false),    -- 1/2 teaspoon ground ginger (2g)
  (11,1,.5,1,null,19,null,false),    -- 1/2 teaspoon ground nutmeg (2g)
  (12,1,.25,1,null,3,null,false),    -- 1/4 teaspoon salt (2g)
  (13,1,1.5,3,null,20,null,false),   -- 1/2 cup dark chocolate coarsely grated (2g)
  (14,1,.5,3,9,5,null,false),        -- 1/2 cup / 1 stick butter (2g)
  (15,1,.66,3,null,2,null,false),    -- 2/3 cup sugar (2g)
  (16,1,1,1,null,21,null,false),     -- 1 teaspoon vanilla extract (2g)
  (17,1,.5,1,null,9,null,false),     -- 1/2 teaspoon lemon zest (2g)
  (18,1,.5,1,null,22,null,false),    -- 1/2 teaspoon orange zest (2g)
  (19,1,.5,null,null,24,null,false),   -- 1/2 large egg (26g)
  (20,1,2,2,null,25,null,true),      -- 2 tablespoons minced crystallized ginger (2g) (decorative)
  (21,1,2,2,null,26,null,true);      -- 2 tablespoons candied orange peel (2g) (decorative)

INSERT INTO recipe_ingredient (
  ordering, recipe_id, amount, volume_id, ingredient_id
) VALUES
  -- Panna Cotta
  (1,2,3,2,1),    -- 3 tablespoons cold water
  (2,2,2,1,3),    -- 2 teaspoons gelatin
  (3,2,2,3,2),    -- 2 cups cream
  (4,2,.25,3,4),  -- 1/4 cup sugar
  (5,2,1,7,5),    -- 1 pinch salt
  (6,2,.25,1,7),  -- 1/4 teaspoon rose water
  (7,2,.25,1,26); -- 1/4 teaspoon lemon extract

INSERT INTO recipe_ingredient (
  ordering, recipe_id, amount, volume_id, ingredient_id, note, is_to_taste, is_optional
) VALUES
  -- Strawberry Topping
  (1,3,3,3,10,'about 1 1lb package of strawberries',false,false), -- 3 cups sliced strawberries (450g) (about 1 1lb package of strawberries)
  (2,3,.25,2,2,null,false,false),  -- 1/4 cup sugar
  (3,3,2,8,7,null,true,true);      -- 2 drops rose water (or to taste) (optional)
