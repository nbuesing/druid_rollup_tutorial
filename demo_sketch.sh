#!/bin/bash

if [ -x "$(command -v jq)" ]; then
  FORMATTER=jq
elif [ -x "$(command -v python)" ]; then
  if python -c "import json.tool" >/dev/null 2>&1; then
    FORMATTER='python -m json.tool'
  else
    FORMATTER="cat"
  fi
else
  FORMATTER="cat"
fi

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
status)
  COMMAND=status
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
  "orders_sketch_none"
  "orders_sketch_theta_16"
  "orders_sketch_theta_32"
  "orders_sketch_theta_16384"
  "orders_sketch_hll_4_4"
  "orders_sketch_hll_4_12"
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
elif [ "$COMMAND" == "status" ]; then
  for i in "${DATASOURCES[@]}"; do
        curl -s -X GET http://localhost:8888/druid/indexer/v1/supervisor/${i}/status | $FORMATTER
        echo ""
  done
elif [ "$COMMAND" == "query" ]; then
  "$DIR"/bin/query "./data/druid/sketch/sketch.sql"
fi
