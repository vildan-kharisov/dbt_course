{# {{ codegen.generate_model_yaml(
    model_names=['fct_bookings','fct_flights']
) }} #}

{{ codegen.create_base_models(
    source_name="demo_src", 
    tables=['flights','ticket_flights']
) }}
