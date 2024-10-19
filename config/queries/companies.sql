SELECT co.updated_at,
  IF(co.created_at = co.updated_at, 'create', IF(co.trash=1, 'delete', 'update')) as action_type,
  co.id,
  co.name,
  hq.db_content as headquarters,
  GROUP_CONCAT(cids.db_content SEPARATOR ',') as corporate_identifiers
FROM cards as co
  LEFT JOIN cards as hq ON co.id = hq.left_id AND hq.right_id=:headquarters
  LEFT JOIN cards as cids ON co.id=cids.left_id AND cids.right_id IN (SELECT id from cards where type_id=:company_identifier)
WHERE co.type_id=:wikirate_company
  AND co.updated_at >= :sql_last_value
GROUP BY
    co.updated_at,
    co.created_at,
    co.trash,
    co.id,
    co.name,
    hq.db_content
ORDER BY co.updated_at;
