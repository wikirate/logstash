SELECT
  cards.updated_at,
  metrics.metric_id AS id,
  titles.name AS name,
  IF (
    cards.created_at = cards.updated_at,
    "create",
    IF (cards.trash = 1, "delete", "update")
  ) AS action_type,
  metrics.designer_id AS left_id,
  metrics.title_id AS right_id,
  titles.search_content,
  titles.name AS autocomplete_field,
  cards.codename AS codename,
  cards.type_id AS type_id
FROM
  metrics
  LEFT JOIN cards AS cards ON cards.id = metrics.metric_id
  LEFT JOIN cards AS titles ON titles.id = metrics.title_id
WHERE
  cards.type_id = :metric
  AND cards.updated_at > :sql_last_value
ORDER BY
  cards.updated_at;
