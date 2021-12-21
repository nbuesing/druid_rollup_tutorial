#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR" || exit

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
  "./data/druid/compare/order_non_rolled.json"
  "./data/druid/compare/order_store_zipcode.json"
  "./data/druid/compare/order_user_reward.json"
  "./data/druid/compare/order_user_reward_store_zipcode.json"
)

declare -a DATASOURCES=(
  "orders"
  "orders_store_zipcode"
  "orders_user_reward"
  "orders_user_reward_store_zipcode"
)

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
  "$DIR"/bin/query "./data/druid/compare/compare.sql"
fi
