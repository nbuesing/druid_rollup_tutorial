# Apache Druid Rollup Tutorial

## Start Containers 

```
docker compose up -v
```

* To minimize resources, 1 zookeeper instances shared between Apache Kafka and Apache Druid
* One Kafka Broker with ensuring replication factor in minimum ISR is 1 for all topics.
* The scripts do not assume you have any additional tooling installed on your developer machine, meaning 
commands as `kafka-topics` executes on the broker, and `ksql` executes on the ksql-server. 

## Create Data

This creates the data into Kafka topics leveraging, Apache Kafka, Kafka Connect, Kafka Datagen Source Connector.

```
./setup.sh
```

## Druid UI

```
http://localhost:8888
```

## Start a Demo

### Rollup Effectiveness

```
./demo_compare.sh
```

To shutdown the ingestion and remove the datasets `./demo_compare.sh shutdown`.

### Unique Counts and Rollups

```
./demo_sketch.sh
```

To shutdown the ingestion and remove the datasets `./demo_compare.sh shutdown`.

### Apache Kafka Partitioning 

```
./demo_compact.sh
```

To shutdown the ingestion and remove the datasets `./demo_compare.sh shutdown`.
