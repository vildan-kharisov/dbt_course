{{
  config(
    materialized = 'table',
    )
}}

select
    tf.ticket_no as ticket_no,
    tf.flight_id as flight_id,
    tf.fare_conditions as fare_conditions,
    tf.amount as amount,
    (select case
        when bp.boarding_no is null 
        then 'no' 
        else 'yes' 
    end) as boarding_pass_exists,
    bp.boarding_no as boarding_no,
    bp.seat_no as seat_no,
    current_date as load_date
from
    {{ ref('stg_flights__ticket_flights') }} tf
        left join {{ ref('stg_flights__boarding_passes') }} bp
        on tf.ticket_no=bp.ticket_no
        and tf.flight_id=bp.flight_id