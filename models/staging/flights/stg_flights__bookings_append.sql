{{
      config(
        materialized = 'incremental',
        incremental_strategy = 'append',
        tags = ['bookings']
        
        )   
}}
select
{{bookref_to_bigint('book_ref')}} as book_ref,
book_date,
{{kopeck_to_ruble('total_amount')}} as total_amount

from {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
WHERE book_ref > (select max(book_ref) from {{ this }})
{% endif %}

    