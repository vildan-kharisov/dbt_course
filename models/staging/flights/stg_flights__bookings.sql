{{
      config(
        materialized = 'table',
        tags = ['bookings']
        )   
}}
select
{{show_columns_relation("stg_flights__bookings")}} 
{# book_ref,
book_date,
total_amount #}

from {{ source('demo_src', 'bookings') }}
{{ limit_data_dev('book_date') }}
    