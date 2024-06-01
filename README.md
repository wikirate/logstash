# Logstash for WikiRate

```sh
docker compose run --build --rm -it logstash bash -c "logstash -f pipeline/wikirate.conf"
docker compose down --volumes
```
