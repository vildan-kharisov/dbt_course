{# 1. (1/3) В макросе limit_data_dev, уменьшающем количество строк при работе в dev окружении, сделать проверку, 
что в переданном параметре days содержится не отрицательное значение.
Если в параметре days отрицательное значение, то необходимо сгенерировать exception с ошибкой. #}

{% macro limit_data_dev(column_name, days=2) %}
{% if target.name == 'dev' %}
    {% if days < 0 %}
        {{ exceptions.raise_compiler_error("Invalid 'days'. Got: " ~ days) }}
    {% endif %}
WHERE
    --{{ column_name }} >= current_date - interval '{{ days }} days' 
    {{ column_name }} >= {{ dbt.dateadd(datepart="day", interval=-days, from_date_or_timestamp="current_date")}}
{% endif %}
{% endmacro %}