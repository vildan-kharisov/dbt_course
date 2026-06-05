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

{# 3 (уровень 2/3). Перечисление всех колонок из другой модели.

Часто при создании кода модели нам требуется взять все поля из предыдущей модели. 
Чтобы не перечислять список всех полей предыдущей модели, сделайте макрос, 
который перечислит через запятую названия всех колонок из модели, название, которой будет передано в аргументе.

Назовите макрос show_columns_relation и поместите в macros/utils.sql.

В модели models/intermediate/fligths/fct_bookings.sql используйте вызов макроса show_columns_relation вместо перечисления всех колонок stg_flights__bookings. #}

{% macro show_columns_relation(table_name) %}

{% set relation_exists = api.Relation.create(
        database=target.database,
        schema=target.schema,
        identifier=table_name) %}

{% set column_list = []%}

{% for column in adapter.get_columns_in_relation(relation_exists) %}
    {% do column_list.append(column.column) %}  
{%- endfor %}

{% do log(column_list,true)%}

{%- for column in column_list -%}
  {{column}} {% if not loop.last %},{% endif%}
{%- endfor -%}
  
{% endmacro %}