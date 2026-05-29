{# 2*. Создайте analyses (ad hoc запрос) с названием fligth_status_cnt, который будет возвращать одну строку. 
На каждое уникальное значение в поле "статус" таблицы с перелетами (stg_flights__flights.status) выведите одну колонку с названием status_[название статуса].
 В этой колонке нужно отобразить значение с количеством перелетов с данным статусом (количество строк в таблице stg_flights__flights с данным статусом). #}
{% set status_query %}
    select
    distinct status
    from {{ ref('stg_flights__flights') }}
{% endset %}

{% set status_query_result = run_query(status_query) %}

{% if execute %}
    {% set status_list = status_query_result.columns[0].values() %}
{% else %}
    {% set status_list = [] %}
{% endif %}

select
{% for element in status_list %}
    sum(case when status = '{{element}}' then 1 else 0 end) as status_{{element.replace(" ","_")}}
    {% if not loop.last %},
    {% endif %}
{% endfor %}
from {{ ref('stg_flights__flights') }}
 
