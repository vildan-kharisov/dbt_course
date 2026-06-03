{# 1. Напишите Jinja код, который выведет список всех колонок таблицы dwh_fligths.intermediate.stg_flights__flights 
(или любой другой таблицы, в которой хранятся полеты, если у вас отличаются названия таблиц от учебного проекта).
Ответ приложите в виде кода Jinja #}

{% set stg_flight_flights = load_relation(ref('stg_flights__flights'))%}
{% set columns_list =  adapter.get_columns_in_relation(stg_flight_flights) %}
{% for column in columns_list -%}
    {{"columns:" ~column }}
{% endfor %}