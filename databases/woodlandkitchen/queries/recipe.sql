SELECT
  ri.amount,
  volume_display.name AS volume_display,
  volume_alternate.name AS volume_alternate,
  i.name,
  volume_display.ratio_to_tsp,
  ROUND(ri.amount*volume_display.ratio_to_tsp) AS ratio,
  CASE WHEN ri.note IS NOT null THEN CONCAT('(',ri.note,')') END AS note,
  ARRAY_TO_STRING(ARRAY[
    CASE WHEN ri.is_to_taste THEN '(to taste)' END,
    CASE WHEN ri.is_decorative THEN '(decorative)' END,
    CASE WHEN ri.is_optional THEN '(optional)' END
  ],' ') AS options
FROM recipe_ingredient AS ri
INNER JOIN ingredient AS i ON i.id=ri.ingredient_id
LEFT JOIN volume AS volume_base ON volume_base.id=i.base_volume_id
LEFT JOIN volume AS volume_display ON volume_display.id=ri.volume_id
LEFT JOIN volume AS volume_alternate ON volume_alternate.id=ri.alternate_volume_id
WHERE ri.recipe_id=1
ORDER BY ri.ordering;
