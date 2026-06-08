{% if execute %}
    {% set model_list = []%}
    {% set seed_list = []%}
    {% set snapshot_list = []%}
  {% for node in graph.nodes.values() %}
    {% if node.resource_type == 'model'%}
        {% do model_list.append(node.name)%}
    {% elif node.resource_type == 'seed'%}
        {% do seed_list.append(node.name)%}
    {% elif node.resource_type == 'snapshot'%}
        {% do snapshot_list.append(node.name)%}
    {% endif %}
    
  {% endfor %} 

    {% do log('Всего в проекте:',True)%}
    {% do log('- '~ model_list|length ~ ' моделей',True)%}
    {% do log('- '~ seed_list|length ~ ' seed',True)%}
    {% do log('- '~ snapshot_list|length ~ ' snapshot',True)%}

{% endif %}
