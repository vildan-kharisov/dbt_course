{# 1 (уровень 1/3). Создать макрос bookref_to_bigint, 
который принимает один строковый параметр bookref и преобразует его к типу bigint следующим образом:
('0x' || book_ref)::bigint
Использовать данный макрос в модели stg_flights__bookings_append или другой модели с данными о бронированиях. #}

{% macro bookref_to_bigint(bookref) %}
    ('0x' || {{bookref}})::bigint
{% endmacro %}

{# 2 (уровень 2/3) Написать макрос безопасного запроса данных из таблицы. 
Под безопасностью подразумевается, что сначала происходит проверка существования таблицы, 
название которой передано в макрос. Если таблица существует, то макрос возвращает код SQL запроса, возвращающего  все строки и столбцы из нее:

SELECT * FROM [название таблицы]

Если таблица не существует, то макрос возвращает запрос:
SELECT NULL

Название макроса - safe_select.
На вход принимает один параметр под названием table_name с названием таблицы, из которой нужно запросить все колонки и все строки.
Приложить ссылки на github с кодом макроса и вызовом макроса. #}

{# Образец #}
{% macro safe_select(table_name) %}
{% if execute %}

{% set all_tables_query %}
    select
        TABLE_NAME
    from 
        {{ target.database }}.INFORMATION_SCHEMA.TABLES as all_tables
    where   
        TABLE_SCHEMA = '{{ target.schema }}'
{% endset %}

{% do log(all_tables_query, True) %}

{% set all_tables_query_result = run_query(all_tables_query)%}
{% set all_tables = all_tables_query_result.columns[0].values() %}


{% set safe_select_query %}
    {% if table_name in all_tables %}
        select *
        from {{ ref(table_name) }}
    {% else %}
        select null
    {% endif %}
{% endset %}

{% do log(safe_select_query, True) %}


{% endif %}
{% endmacro %}



{# Мой вариант #}

{% macro safe_select_my(table_name) %}

{% set relation_exists = api.Relation.create(
        database="dwh_flights",
        schema="intermediate",
        identifier="{{table_name}}") %}

{% set sql_query %}
    {% if relation_exists %}
        SELECT * from {{target.schema}}.{{table_name}};
    
    {% else %}
    SELECT NULL

    {% endif %}

{% endset %}

{% do log(sql_query,True) %}

  
{% endmacro %}

