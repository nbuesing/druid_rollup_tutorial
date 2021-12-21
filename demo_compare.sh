#!/bin/bash

DIR=$(dirname $0)
cd $DIR || exit

case "$1" in
start)
  COMMAND=start
  ;;
shutdown)
  COMMAND=shutdown
  ;;
*)
  COMMAND=start
  ;;
esac

declare -a FILES=(
  "./data/druid/compare/order_non_rolled.json"
  "./data/druid/compare/order_store_zipcode.json"
  "./data/druid/compare/order_user_reward.json"
  "./data/druid/compare/order_user_reward_store_zipcode.json"
)

declare -a DATASOURCES=(
  "order_non_rolled"
  "order_store_zipcode"
  "order_user_reward"
  "order_user_reward_store_zipcode"
)

if [ "$COMMAND" == "start" ]; then
  for i in "${FILES[@]}"; do
        curl -s -X POST -H "Content-Type:application/json" -d @$i http://localhost:8888/druid/indexer/v1/supervisor
  done
elif [ "$COMMAND" == "shutdown" ]; then
  for i in "${DATASOURCES[@]}"; do
        curl -s -X POST -H "Content-Type:application/json"  http://localhost:8888/druid/indexer/v1/supervisor/${i}/reset
        curl -s -X POST -H "Content-Type:application/json"  http://localhost:8888/druid/indexer/v1/supervisor/${i}/shutdown
  done
fi
