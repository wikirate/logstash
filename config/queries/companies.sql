SELECT
  co.updated_at,
  IF (
    co.created_at = co.updated_at,
    "create",
    IF (co.trash = 1, "delete", "update")
  ) AS action_type,
  co.id,
  co.name,
  hq.db_content AS headquarters,
  sec.db_content AS sec_cik,
  oar.db_content AS oar_id,
  oc.db_content AS open_corporates,
  uk_cn.db_content AS uk_cn,
  abn.db_content AS aus_cn
FROM
  cards AS co
  LEFT JOIN cards AS hq ON co.id = hq.left_id
  AND hq.right_id = :headquarters
  LEFT JOIN cards AS sec ON co.id = sec.left_id
  AND sec.right_id = :sec_cik
  LEFT JOIN cards AS oar ON co.id = oar.left_id
  AND oar.right_id = :oar_id
  LEFT JOIN cards AS oc ON co.id = oc.left_id
  AND oc.right_id = :open_corporates
  LEFT JOIN cards AS uk_cn ON co.id = uk_cn.left_id
  AND uk_cn.right_id = :uk_cn
  LEFT JOIN cards AS abn ON co.id = abn.left_id
  AND abn.right_id = :abn
WHERE
  co.type_id = :wikirate_company
  AND co.updated_at > :sql_last_value
ORDER BY
  co.updated_at;
