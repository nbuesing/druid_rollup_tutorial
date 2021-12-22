# Apache Druid Rollup Tutorial

# Purpose
These examples showcase concepts around Apache Druid Rollups focusing on real-time ingestion. 

## Overview
* To minimize resources, it shares 1 zookeeper instances between Apache Kafka and Apache Druid.
* One Kafka Broker, as this is not a production grade Kafka representation.
* The scripts push as much as possible to functionality on the containers to avoid the installation of specific tooling.
* Required tools: `bash`, `docker`, `curl`, and `docker-compose` if the instance of `docker` does not have the built-in `compose` component.
* Optional tools: `jq`, `column`
* Having access to Kafka command-line tools and the ksqlDB command-line interface are helpful, but the scripts do not require it.  Do checkout [Confluent Apache Kafka Distribution](https://docs.confluent.io/platform/current/installation/installing_cp/zip-tar.html#get-the-software) if you would like them installed on your physical machine.
* The druid console is at [http://localhost:8888/unified-console.html](http://localhost:8888/unified-console.html), but the demos will execute the "showcase query" as part of the script.  But copying that query into the editor and adjusting would be helpful to any learning.

## Start Containers 
```
docker compose up -d
```
## Create Data
This creates the data into Kafka topics leveraging, Apache Kafka, Kafka Connect, Kafka Datagen Source Connector.
The containers all need to be up and running prior to running this. The script does check that the Kafka Connect cluster is available before continuing.  If you want to adjust the data being created, read about the `Datagen` connector and the adjust the `data/datagen` avro templates used to generate the data.
The enriching of data is done with `ksqlDB`.  The scripts are all in `demo/ksql`. If you make changed to the data being generated you will probably need to adjust the script here as well. While `ksqlDB` supports after, all topics contain JSON, to reduce a startup dependencies and to make it easier to inspect the topics for your understanding.
```
./setup.sh
```

## Demos
There are currently demos as part of this repository.

| script | description |
|---|---|
|demo_compare.sh| Shows how rollups are impacted when a new dimension is added.|
|demo_compact.sh| How leveraging Kafka keys and partitioning to improve real-time rollups.|
|demo_sketch.sh| How Sketches provided estimated uniqueness w/out impacting rollup.|
|demo_custom_granularity.sh| How a transform can be used to create a non-traditional rollup interval.|


### Start a Demo

To start a demonstration. Due to limited resources available within a dockerized environment, it is recommended to only run 1 demo at a time. You do not need to shut down docker or rerun the setup.sh script, you just would want to shutdown and start them independently.

```
./demo_{compare|compact|sketch|custom_granuliarity}.sh start
```

### Run a Query to showcase the example

Each demonstration has a query to show the the behavior. This query is executed with the RESTful endpoint. You can (and it is encouraged) to run this query within the query console.
```
./demo_{compare|compact|sketch|custom_granuliarity}.sh query
```

### Status of Supervisors and Tasks for the datasource
To see if a supervisor and its corresponding tasks are running. 
```
./demo_{compare|compact|sketch|custom_granuliarity}.sh status
```

### Shutdown a Demo
Tasks and Supervisor are removed, no additional ingestion to occur.  Datasources also removed.
```
./demo_{compare|compact|sketch|custom_granuliarity}.sh shutdown
```

## Notes

* This environment is to showcase rollups, not an actual production setup. One Kafka Broker and sharing zookeeper between Druid and Kafka are not pattens you should follow for building any production grade environment.
* each task for ingestion creates a stand-alone JVM `peon` to perform the work. Resources are tuned so each demo can run with all tasks executing, but not more than that. Only 8 tasks can be started at once. If you have the machine resources you can adjust task JVM settings and number of tasks availble within the druid.env environment file.
* Druid has experimental Indexer that can replace MiddleManager which spans threads not forks processes for tasks. Looking into moving demo into that incubating feature of Apache Druid as it could greatly improve container resources for examples.