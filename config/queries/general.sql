SELECT
  cards.updated_at,
  IF (
    cards.created_at = cards.updated_at,
    "create",
    IF (cards.trash = 1, "delete", "update")
  ) AS action_type,
  cards.id,
  cards.name,
  cards.left_id,
  cards.right_id,
  cards.search_content,
  cards.codename,
  cards.type_id,
  cards.name AS autocomplete_field
FROM
  cards AS cards
WHERE
  cards.updated_at > :sql_last_value
  AND cards.type_id IN (
    :wikirate_company,
    :wikirate_topic,
    :project,
    :research_group,
    :company_group,
    :dataset
  )
ORDER BY
  cards.updated_at;
