select
book_ref
from 
{{ ref('stg_flights__bookings') }}
where length(book_ref) > 7