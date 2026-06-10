{{
  config(
    materialized = 'table',
    )
}}
select
  ticket_no,
  book_ref,
  passenger_id,
  passenger_name,
  contact_data
from {{ ref('stg_flights__tickets') }}
where passenger_id not in(select passenger_id from {{ ref('job_passengers') }} )

{% set get_column = dbt_utils.get_column_values(table=this, column='book_ref') %}

{% for col in get_column %}
  --{{col}}
{% endfor %}