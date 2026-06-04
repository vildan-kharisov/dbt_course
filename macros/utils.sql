{%- macro concat_columns(columns,delimiter=', ') %}
{%- for column in columns -%}
  {{column}} {% if not loop.last %} || '{{delimiter}} '||{% endif%}
{%- endfor -%}
{% endmacro %}

{# Скрипт, который проверяет неудаленные старые таблицы или вьюхи, не соответсвующие названием моделей
dryrun = False выведет только в логи, что собирается удалить #}

{% macro drop_old_relations(dryrun = False) %}

{# находим все модели, seed, snaphsot #}

{% set current_models = [] %}
{% for node in graph.nodes.values()|selectattr("resource_type","in",["model","snapshot","seed"]) %}
    {% do current_models.append(node.name) %}
{% endfor %}

{# сформируем скрипт, который удалит все таблицы и вьюхи не соответствующие ни одной модели, seed, snapshot #}

{% set cleanup_query %}
with models_to_drop as
    (SELECT 
        case
        when table_type = 'BASE TABLE' then 'TABLE'
        when table_type = 'VIEW' then 'VIEW'
        END as relation_type,
        concat_ws('.',table_catalog,table_schema,table_name) as relation_name
    FROM {{target.database}}.information_schema.tables
    WHERE table_schema = '{{target.schema}}'
    AND upper(table_name) not in (
        {%- for model in current_models -%}
            '{{model.upper()}}'    
            {%- if not loop.last -%}
            ,
            {%- endif %}
        {%- endfor -%}
    ))
SELECT 
'DROP '||relation_type||' '||relation_name||';' as relation_commands
FROM models_to_drop;

{% endset %}
{% do log(cleanup_query,True) %}

{% set drop_commands = run_query(cleanup_query).columns[0].values()%}

{# удаление таблиц, вьюх и вывод в лог скрипта удаления #}

{% if drop_commands %}

  {% if dryrun | as_bool == False %}
    {% do log('Executing DROP COMMANDS ...', True)%}
  {% else %}
    {% do log('Printing DROP COMMANDS ...', True)%}   
  {% endif %}

  {% for command in drop_commands %}
    {% do log(command, True)%}
    {% if dryrun | as_bool == False %}
        {% do run_query(command)%}
    {% endif %}
  {% endfor %}

{% else %}
    {% do log('No relations', True)%}


{% endif %}
  
{% endmacro %}