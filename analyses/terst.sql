{% set fct_flights = api.Relation.create(
        database="dwh_flights",
        schema="intermediate",
        identifier="fct_flights") %}

{% set column_list = []%}
{% for column in adapter.get_columns_in_relation(fct_flights) %}
{% do column_list.append(column.column) %}
    {# {{'columns:' ~column.column}} #}
    {% do log(column.column,true)%}
{%- endfor %}
{{'columns:' ~column_list}}