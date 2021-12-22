#!/bin/bash

cd "$(dirname $0)" || exit

curl -k -s -H "Accept:application/json" -X GET http://localhost:8083/connector-plugins >/dev/null 2>&1
[ $? -ne 0 ] && echo "connector API is not yet available, check container heath 'docker compose ps'" && exit 1

CREATE=$(cat <<EOF
unset KAFKA_OPTS
kafka-topics --bootstrap-server broker-1:9092 --create --replication-factor 1 --partitions 4 --topic users
kafka-topics --bootstrap-server broker-1:9092 --create --replication-factor 1 --partitions 4 --topic stores
kafka-topics --bootstrap-server broker-1:9092 --create --replication-factor 1 --partitions 4 --topic orders
kafka-topics --bootstrap-server broker-1:9092 --create --replication-factor 1 --partitions 4 --topic ORDERS_ENRICHED
EOF
)

KSQL=$(cat <<EOF
unset KAFKA_OPTS
ksql --config-file /data/ksql/ksql.properties --file=/data/ksql/users.ksql
ksql --config-file /data/ksql/ksql.properties --file=/data/ksql/stores.ksql
ksql --config-file /data/ksql/ksql.properties --file=/data/ksql/orders.ksql
ksql --config-file /data/ksql/ksql.properties --file=/data/ksql/orders_enriched.ksql
ksql --config-file /data/ksql/ksql.properties --file=/data/ksql/orders_enriched_rekeyed.ksql
EOF
)

# copy datagen files, since the connector has to have access to them from the connect cluster
docker cp data/datagen drt_connect:/data

# copy the ksql scripts to the ksql-server for easy execution
docker cp data/ksql drt_ksql-server:/data

docker exec -it drt_broker-1 sh -c "$CREATE"

curl -k -s -H "Content-Type:application/json" -X POST --data @./data/connectors/store.json http://localhost:8083/connectors >/dev/null
curl -k -s -H "Content-Type:application/json" -X POST --data @./data/connectors/user.json http://localhost:8083/connectors >/dev/null
curl -k -s -H "Content-Type:application/json" -X POST --data @./data/connectors/order.json http://localhost:8083/connectors >/dev/null

docker exec -it drt_ksql-server sh -c "$KSQL"
