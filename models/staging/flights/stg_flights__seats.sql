{{
      config(
        materialized = 'table'
        )   
}}

select
aircraft_code,
seat_no,
fare_condition,
'test' as test_col
from {{ source('demo_src', 'seats') }}
