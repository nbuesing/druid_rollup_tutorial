select 'orders_sketch_none' "Datasource",
       TIME_FLOOR(__time, 'PT1H'),
       SUM("COUNT") "COUNT",
       ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 7) "Rollup Factor",
       count(distinct CODE) "UNIQUE CODES"
from orders_sketch_none
group by 1,2
union all
select 'orders_sketch_theta_16'   "Datasource",
       TIME_FLOOR(__time, 'PT1H'),
       SUM("COUNT") "COUNT",
       ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
       APPROX_COUNT_DISTINCT_DS_THETA(UNIQUE_CODES) UNIQUE_CODES
from orders_sketch_theta_16
group by 1,2
union all
select 'orders_sketch_theta_32'   "Datasource",
       TIME_FLOOR(__time, 'PT1H'),
       SUM("COUNT") "COUNT",
       ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
       APPROX_COUNT_DISTINCT_DS_THETA(UNIQUE_CODES) UNIQUE_CODES
from orders_sketch_theta_32
group by 1,2
union all
select 'orders_sketch_theta_16384'   "Datasource",
       TIME_FLOOR(__time, 'PT1H'),
       SUM("COUNT") "COUNT",
       ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
       APPROX_COUNT_DISTINCT_DS_THETA(UNIQUE_CODES) UNIQUE_CODES
from orders_sketch_theta_16384
group by 1,2
union all
select 'orders_sketch_hll_4_4'   "Datasource",
       TIME_FLOOR(__time, 'PT1H'),
       SUM("COUNT") "COUNT",
       ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
       APPROX_COUNT_DISTINCT_DS_HLL(UNIQUE_CODES) UNIQUE_CODES
from orders_sketch_hll_4_4
group by 1,2
union all
select 'orders_sketch_hll_4_12'   "Datasource",
       TIME_FLOOR(__time, 'PT1H'),
       SUM("COUNT") "COUNT",
       ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
       APPROX_COUNT_DISTINCT_DS_HLL(UNIQUE_CODES) UNIQUE_CODES
from orders_sketch_hll_4_12
group by 1,2
