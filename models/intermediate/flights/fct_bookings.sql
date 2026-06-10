{{
  config(
    materialized = 'table',
    meta = {
      'owner': 'sql_owner@gmail.com'
    }
    )
}}
select 
{{- show_columns_relation('stg_flights__bookings') -}},
{{ dbt_utils.generate_surrogate_key(['book_ref']) }}
    {# book_ref,
    book_date,
    total_amount #}
from {{ ref('stg_flights__bookings') }}

