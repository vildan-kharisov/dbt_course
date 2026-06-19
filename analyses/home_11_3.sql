{# 1 (1/3) Напишите команду, которая обновит все модели проекта dbt за исключением моделей, 
содержащихся в папке models/intermediate/fligths (если у вас такой папки нет, то укажите любую другую) #}

dbt run --exclude "models/intermediate/fligth"

{# 2 (1/3) Напишите команду, которая обновит все элементы проекта (и запустит их тесты) 
за исключением сида city_region и всех его потомков. #}
dbt ls --select "resource_type:seed"
dbt ls --resource-type seed --output name
dbt ls --select "resource_type:seed" --exclude "job_passengers"
dbt run --exclude "city_region+"

#---------------------------------------
/*
3 (2/3) Создайте selector, который находит все инкрементальные модели. 
Напишите команду обновления всех инкрементальных моделей, используя созданный selector.
Приложите код selectors.yml и код команды.
*/
selectors:
  - name: update_incremental_models
    definition: 'config.materialized:incremental'
dbt run --selector update_incremental_models --state target

#----------------------------------------
/*
Добавьте новое поле со статическим значением в модель stg_flights__seats. 

Сохранив предыдущей экземпляр файла manifest.json, напишите команду вызова dbt ls, 
которая покажет все измененные модели в проекте. Приложите скриншот с результатом.
*/
dbt ls --select "state:modified" --state ./manifest_old