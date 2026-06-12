{# {{ codegen.generate_model_yaml(
    model_names=['fct_bookings','fct_flights']
) }} #}

{# 1 (2/3). С помощью codegen.create_base_models создать код моделей, получащих данных из таблиц на источнике: flights и ticket_flights.

2 (2/3). Сгенерируйте код yml файла по созданным моделям с помощью codegen.generate_model_yaml. #}

{# {{ codegen.create_base_models(
    source_name="demo_src", 
    tables=['flights','ticket_flights']
) }} #}

{{ codegen.generate_model_yaml(
    model_names=['stg_demo_src__flights','stg_demo_src__ticket_flights']
) }}