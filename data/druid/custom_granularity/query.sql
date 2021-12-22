select 'orders_custom_granularity' "Datasource",
       __time,
       USER_REWARD,
       sum("COUNT")                "Logical_Count",
       count("COUNT")              "Physical_Count"
  from orders_custom_granularity
 where __time >= CURRENT_TIMESTAMP - INTERVAL '5' MINUTE
 group by 1,2,3
