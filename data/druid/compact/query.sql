SELECT 'orders_user_reward' "Datasource",
    __time,
    USER_REWARD,
    "COUNT"
FROM orders_user_reward
WHERE __time >= CURRENT_TIMESTAMP - INTERVAL '3' MINUTE
  AND __time < CURRENT_TIMESTAMP - INTERVAL '2' MINUTE
  AND USER_REWARD = 'DIAMOND'
union all
SELECT 'orders_user_reward_topic_key_order_id' "Datasource",
    __time,
    USER_REWARD,
    "COUNT"
FROM orders_user_reward_topic_key_order_id
WHERE __time >= CURRENT_TIMESTAMP - INTERVAL '3' MINUTE
  AND __time < CURRENT_TIMESTAMP - INTERVAL '2' MINUTE
  AND USER_REWARD = 'DIAMOND'