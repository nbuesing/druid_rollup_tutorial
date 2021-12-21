#!/bin/bash

DIR=$(dirname $0)
cd $DIR || exit

case "$1" in
start)
  COMMAND=start
  ;;
query)
  COMMAND=query
  ;;
shutdown)
  COMMAND=shutdown
  ;;
*)
  echo ""
  echo "usage: $0 {start|query|shutdown}"
  echo ""
  exit
  ;;
esac

declare -a FILES=(
  "./data/druid/sketch/order_sketch_none.json"
  "./data/druid/sketch/order_sketch_theta_16.json"
  "./data/druid/sketch/order_sketch_theta_32.json"
  "./data/druid/sketch/order_sketch_theta_16384.json"
  "./data/druid/sketch/order_sketch_hll_4_4.json"
  "./data/druid/sketch/order_sketch_hll_4_12.json"
)

#  "./data/druid/sketch/order_sketch_hll_8_12.json"

declare -a DATASOURCES=(
  "order_sketch_none"
  "order_sketch_theta_16"
  "order_sketch_theta_32"
  "order_sketch_theta_16384"
  "order_sketch_hll_4_4"
  "order_sketch_hll_4_12"
)

#  "order_sketch_hll_8_12"

if [ "$COMMAND" == "start" ]; then
  for i in "${FILES[@]}"; do
        curl -s -X POST -H "Content-Type:application/json" -d @$i http://localhost:8888/druid/indexer/v1/supervisor
        echo ""
  done
elif [ "$COMMAND" == "shutdown" ]; then
  for i in "${DATASOURCES[@]}"; do
        curl -s -X POST -H "Content-Type:application/json"  http://localhost:8888/druid/indexer/v1/supervisor/${i}/reset
        curl -s -X POST -H "Content-Type:application/json"  http://localhost:8888/druid/indexer/v1/supervisor/${i}/shutdown
        echo ""
  done
elif [ "$COMMAND" == "query" ]; then
  "$DIR"/bin/query "./data/druid/sketch/sketch.sql"
fi
