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

declare -a FILES=("./data/druid/compact/order_user_reward.json" "./data/druid/compact/order_user_reward_rekeyed.json")

declare -a DATASOURCES=("orders_user_reward" "orders_user_reward_topic_key_order_id")

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
