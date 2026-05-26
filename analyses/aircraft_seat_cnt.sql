/*
Создайте analyses (ad hoc) с названием aircraft_seat_cnt, который посчитает, сколько у каждого из типов самолетов всего мест.
Выведите 2 поля:

код самолета (поле aircraft_code из модели stg_flights__seats)
количество мест в самолете (количество строк с одинаковым значением aircraft_code)
Выполните ad hoc запрос и приложите скриншот с результатом.
(Подсказка: Сгруппируйте модель stg_flights__aircrafts по полю aircraft_code и посчитайте количество строк в каждой группе)
*/
select
aircraft_code,
count(*) seat_cnt
from 
{{ ref('stg_flights__aircrafts') }}
group by aircraft_code
