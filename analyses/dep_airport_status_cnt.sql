/*
4 (3/3*). Получите список уникальных значений кодов аэропортов, из которых совершался вылет (уникальные значения из колонки departure_airport модели fct_fligths).
 Каждое значение выведите в отдельной строке в колонке departure_airport.

Получите список уникальных значений статусов полетов (уникальные значения из колонки status модели fct_fligths). На каждый статус выведите отдельный столбец,
 который будет называться также, как значение статуса. В ячейках, находящихся на пересечении кода аэропорта вылета и статуса полета выведите количество полетов в данном статусе с вылетом из данного аэропорта.

Пример таблицы:

 

dep_air Departed Arrived On_Time
DME     1        110     3 
VKO     2        15      1
SVO     5        7       9

 

Значение 15 в 3ьем столбце в 3ьей строке значит, что из аэропорта VKO совершено 15 вылетов в статусе Arrived.

Используйте dbt_utils.pivot и dbt_utils.slugify
*/

select 
departure_airport,
{{ dbt_utils.pivot(
    'status',     
        dbt_utils.get_column_values(ref('fct_flights'),'status'),
        quote_identifiers=False       
    
)

}}
from 
{{ ref('fct_flights') }}
group by
departure_airport

