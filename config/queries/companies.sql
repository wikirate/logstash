SELECT
  co.updated_at,
  IF(
    co.created_at = co.updated_at,
    'create',
    IF(co.trash = 1, 'delete', 'update')
  ) AS action_type,
  co.id,
  co.name,
  hq.db_content AS headquarters,
  GROUP_CONCAT(cids.db_content SEPARATOR ';') AS company_identifiers
FROM
  cards AS co
  LEFT JOIN cards AS hq ON co.id = hq.left_id
  AND hq.right_id = :headquarters
  LEFT JOIN cards AS cids ON co.id = cids.left_id
  AND cids.right_id IN (
    SELECT
      id
    FROM
      cards
    WHERE
      type_id = :company_identifier
  )
WHERE
  co.type_id = :wikirate_company
  AND co.updated_at >= :sql_last_value
GROUP BY
  co.updated_at,
  co.created_at,
  co.trash,
  co.id,
  co.name,
  hq.db_content
ORDER BY
  co.updated_at;
