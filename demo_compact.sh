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
  "./data/druid/compact/order_user_reward.json"
  "./data/druid/compact/order_user_reward_rekeyed.json"
)

declare -a DATASOURCES=(
  "orders_user_reward"
  "orders_user_reward_topic_key_order_id"
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
elif [ "$COMMAND" == "status" ]; then
  for i in "${DATASOURCES[@]}"; do
        curl -s -X GET http://localhost:8888/druid/indexer/v1/supervisor/${i}/status | $FORMATTER
        echo ""
  done
elif [ "$COMMAND" == "query" ]; then
  "$DIR"/bin/query "./data/druid/compact/query.sql"
fi
