/*1 (1/3). Создайте singular тест для проверки модели с бронированиями (модель stg_flights__bookings с данными из таблицы bookings на источнике),
который проверяет, что нет строк, у которых поле total_amount больше 10000000 или меньше или равно 0.

Приложите ссылку на github с кодом теста, а также команды запуска теста
*/
{{
    config(
    severity = 'warn',
    )
}}
select
total_amount

from {{ ref('stg_flights__bookings') }}
where total_amount > 10000000 or total_amount <=0