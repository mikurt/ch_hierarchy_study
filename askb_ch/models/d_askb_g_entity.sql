{# Иерархия БЕ #}
{{ config(
    materialized='proplum',
    incremental_strategy='full',
    engine='MergeTree',
    schema='DDM_ASKB',
    tags=['askb','ddm'],
    order_by='g_entity'    
) }}
select ElementName as g_entity,
    ElementType as el_type
    from {{ref('stg_askb_et_g_entity')}}
{# таблица атрибутов кривая, после исправления ее надо добавлять сюда через Join #}