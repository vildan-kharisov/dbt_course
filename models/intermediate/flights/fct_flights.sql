{{
  config(
    materialized = 'table',
    )
}}
select
    flight_id,
    flight_no,
    scheduled_departure,
    scheduled_arrival,
    departure_airport,
    arrival_airport,
    status,
    aircraft_code,
    actual_departure,
    actual_arrival,
    CURRENT_DATE load_date,
    {{concat_columns(['flight_id','flight_no'])}} as flight_info
from {{ ref('stg_flights__flights') }}



{# 3 (2/3). С помощью макроса get_column_values получить все уникальные значения статуса полетов (поле status модели fct_fligths). 
Вывести их в логи, при обновлении модели fct_fligths. #}

{% set get_column = dbt_utils.get_column_values(table=ref('fct_fligths'), column='status') %}

{% for col in get_column %}
  {% do log(col,True) %}
{% endfor %}

{# 4 (3/3*). Получите список уникальных значений кодов аэропортов, 
из которых совершался вылет (уникальные значения из колонки departure_airport модели fct_fligths). 
Каждое значение выведите в отдельной строке в колонке departure_airport. #}

{% set get_column = dbt_utils.get_column_values(table=ref('fct_fligths'), column='aircraft_code') %}

{% for col in get_column %}
  --{{col}}
{% endfor %}