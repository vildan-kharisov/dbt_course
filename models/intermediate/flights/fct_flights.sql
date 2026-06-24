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
    {{concat_columns(['flight_id','flight_no'])}} as flight_info,
    case
      when actual_departure is not null and scheduled_departure < actual_departure
      then actual_departure - scheduled_departure 
      else INTERVAL '0 seconds'
      end as fligth_departure_delay,
    case
      when actual_departure is not null and actual_arrival is not null and actual_arrival > actual_departure then actual_arrival - actual_departure
      else INTERVAL '0 seconds'
      end as actual_duration_flight
from {{ ref('stg_flights__flights') }}

/*
1. Добавьте в модель fct_fligths поле actual_duration_flight, в котором рассчитайте фактическую продолжительность полета. 
Алгоритм расчета:
- Если поля actual_departure и actual_arrival не пустые, то actual_duration_flight должен быть равен их разности: actual_arrival - actual_departure.
- Если одно из полей actual_arrival, actual_departure равно пустому значениями (is null), 
то actual_duration_flight должен быть равен нулевому интервалу (INTERVAL '0 seconds').
*/

{# 3 (2/3). С помощью макроса get_column_values получить все уникальные значения статуса полетов (поле status модели fct_fligths). 
Вывести их в логи, при обновлении модели fct_fligths. #}

{# {% set get_column = dbt_utils.get_column_values(table=this, column='status') %}

{% for col in get_column %}
  {% do log(col,True) %}
{% endfor %} #}

{# 4 (3/3*). Получите список уникальных значений кодов аэропортов, 
из которых совершался вылет (уникальные значения из колонки departure_airport модели fct_fligths). 
Каждое значение выведите в отдельной строке в колонке departure_airport. #}

{% set get_column = dbt_utils.get_column_values(table=this, column='departure_airport') %}

{% for col in get_column %}
  --{{col}}
{% endfor %}