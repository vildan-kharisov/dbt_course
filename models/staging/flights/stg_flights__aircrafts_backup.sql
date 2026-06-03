{# 2. Создайте копию модели stg_flights__aircrafts.sql с названием stg_flights__aircrafts_backup.sql.
В модели stg_flights__aircrafts_backup.sql создайте pre_hook,  который перед обновлением модели будет переименовывать таблицу, 
существующую до начала обновления модели и относящуюся к данной модели, устанавливая название по следующему шаблону:
intermediate.stg_flights__aircrafts_backup_[YYYY_MM_DD_HHSSmm]
, где [YYYY_MM_DD_HHSSmm] - год, месяц, число, часы, минуты и секунды текущего времени (времени начала обновления модели)
Опубликуйте модель в github и приложите на нее ссылку. #}

{{
    config(
        materialized = 'table',
        pre_hook = '
            {% set curr_time = run_started_at|string|truncate(19, True, "")|replace("-","_")|replace(" ","_")|replace(":","") %}
            {% set old_relation = adapter.get_relation(
                    database=this.database,
                    schema=this.schema,
                    identifier=this.identifier
                )
            %}
            {% set beckup_relation = api.Relation.create(
                    database = this.database,
                    schema = this.schema,
                    identifier = this.identifier ~ "_" ~ curr_time,
                    type = "table"
                )
            %}
            {% if old_relation %}
                {% do adapter.rename_relation(old_relation, beckup_relation) %}
            {% endif %}
        '
    )
}}
select
    aircraft_code, 
    model, 
    "range"
from
    {{ source('demo_src', 'aircrafts') }}