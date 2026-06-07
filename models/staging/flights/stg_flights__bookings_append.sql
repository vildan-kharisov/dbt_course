{{
      config(
        materialized = 'incremental',
        incremental_strategy = 'append',
        tags = ['bookings']
        
        )   
}}
-- invocation_args_dict:
-- {{ invocation_args_dict }}
select
{{bookref_to_bigint('book_ref')}} as book_ref,
book_date,
{{kopeck_to_ruble('total_amount',-2)}} as total_amount

from {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
WHERE book_ref > (select max(book_ref) from {{ this }})
{% endif %}

{% if execute %}
  {% for node in graph.nodes.values() %}
  {% if node.resource_type=='model' %}
  --{{ node.name}}
  -- -------------------------
  --{{ node.depends_on}}
  {% endif %}
  {% endfor %} 

{% endif %}



    