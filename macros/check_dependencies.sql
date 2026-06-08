{# 3. (3/3) Написать макрос check_dependencies(), который проверяет, от какого количества других объектов (сидов, снэпшотов, моделей и т.д.) зависит текущая модель. 
Если текущая модель зависит более чем от одного объекта, то нужно вывести в логи предупреждение:

Модель [название модели] зависит от [количество объектов, от которых зависит] объектов!
Добавьте выполнение данного макроса в post_hook всех моделей проекта.
Подсказка: у объекта model используйте атрибут depends_on, чтобы найти все объекты, от которых зависит модель. #}

{% macro check_dependencies(model_name) %}
{% set list_depencies = {}%}
  {% for node in graph.nodes.values() %}
    {% do list_depencies.update(node.depends_on)%}
  {% endfor %}
{% if list_depencies|length >1 %}
  {% do log('Модель '~ model_name ~' зависит от '~list_depencies|length ~' объектов!',True)%}
  {% do log(list_depencies.keys()|list, True)%}
{% endif %}


{% endmacro %}