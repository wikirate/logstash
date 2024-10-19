FROM docker.elastic.co/logstash/logstash-oss:8.13.4

USER root

RUN apt-get update && apt-get install -y mysql-client
RUN curl -O -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-9.1.0.tar.gz
RUN tar -zxvf mysql-connector-j-9.1.0.tar.gz
RUN bin/logstash-plugin install logstash-output-opensearch

USER 1000

ENV JDBC_DRIVER_LIBRARY=/usr/share/logstash/mysql-connector-j-9.1.0/mysql-connector-j-9.1.0.jar
ENV JDBC_DRIVER_CLASS=com.mysql.cj.jdbc.Driver
ENV JDBC_DRIVER_DATABASE=mysql

COPY --chown=1000 config /usr/share/logstash/config
COPY --chown=1000 pipeline /usr/share/logstash/pipeline
COPY --chown=1000 entrypoint.sh /usr/share/logstash/entrypoint.sh

ENTRYPOINT ["/usr/share/logstash/entrypoint.sh"]
