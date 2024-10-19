SELECT
  cards.updated_at,
  cards.id,
  IF (
    cards.created_at = cards.updated_at,
    'create',
    IF (cards.trash = 1, 'delete', 'update')
  ) AS action_type,
  titles.search_content AS name,
  cards.left_id,
  cards.right_id,
  cards.search_content,
  cards.codename,
  cards.type_id,
  titles.search_content AS autocomplete_field
FROM
  cards AS cards
  RIGHT JOIN cards AS titles ON titles.left_id = cards.id
WHERE
  cards.type_id = :source
  AND titles.type_id = :phrase
  AND titles.right_id = :wikirate_title
  AND cards.updated_at > :sql_last_value
ORDER BY
  cards.updated_at;
