#!/bin/bash

set -euo pipefail

export DATABASE_PORT=${DATABASE_PORT:-3306}

cards="'headquarters','sec_cik','oar_id','open_corporates_id','wikirate_company',\
'metric','source','phrase','wikirate_title','wikirate_topic','project',\
'research_group','company_group','dataset','uk_cn', 'abn'"

query="SELECT CONCAT('PARAM_', UPPER(IFNULL(codename, name)), '=', id) AS result \
FROM cards WHERE codename IN ($cards) OR name IN ($cards)"

echo -n "Fetching cards from database..."

ids=$(
  mariadb \
    --host=$DATABASE_HOST \
    --port=$DATABASE_PORT \
    --database=$DATABASE_NAME \
    --user=$DATABASE_USERNAME \
    --password=$DATABASE_PASSWORD \
    --protocol tcp \
    --skip-column-names \
    --silent \
    --execute="$query"
)

echo -e "done\nConfiguring the following parameters:\n$ids"

export $(xargs -d "\n" <<< $ids)

mkdir -p /usr/share/logstash/data/plugins/inputs/jdbc

/usr/local/bin/docker-entrypoint "$@"
