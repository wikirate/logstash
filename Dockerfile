FROM docker.elastic.co/logstash/logstash-oss:8.13.4

USER root

RUN apt-get update && apt-get install -y mariadb-client
RUN curl -O -L https://dlm.mariadb.com/3824147/Connectors/java/connector-java-3.4.0/mariadb-java-client-3.4.0.jar
RUN bin/logstash-plugin install logstash-output-opensearch

USER 1000

ENV JDBC_DRIVER_LIBRARY=/usr/share/logstash/mariadb-java-client-3.4.0.jar
ENV JDBC_DRIVER_CLASS=org.mariadb.jdbc.Driver
ENV JDBC_DRIVER_DATABASE=mariadb

COPY --chown=1000 config /usr/share/logstash/config
COPY --chown=1000 pipeline /usr/share/logstash/pipeline
COPY --chown=1000 entrypoint.sh /usr/share/logstash/entrypoint.sh

ENTRYPOINT ["/usr/share/logstash/entrypoint.sh"]
