{% macro elements_cnt() %}

{% if execute %}

{% set all_models = [] %}
{% set all_seeds = [] %}
{% set all_snapshots = [] %}
   
{% for node in graph.nodes.values() %}
    {% if node.resource_type == 'model' %}
        {% do all_models.append(node.name) %}
    {% elif node.resource_type == 'seed' %}
        {% do all_seeds.append(node.name) %}
    {% elif node.resource_type == 'snapshot' %}
        {% do all_snapshots.append(node.name) %}
    {% endif %}
{% endfor %}

{% set models_cnt = all_models | length %}
{% set seeds_cnt = all_seeds | length %}
{% set snapshots_cnt = all_snapshots | length %}

{% set result %}
    Всего в проекте:
    - {{ models_cnt }} моделей
    - {{ seeds_cnt }} seed
    - {{ snapshots_cnt }} snapshot
{% endset %}

{% do log(result, True)%}

{% endif %}
{% endmacro %}