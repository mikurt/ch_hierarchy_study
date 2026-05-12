{# G_MSA с иерархиями #}
{{ config(
    materialized='view',
    schema='DDM_ASKB',
    tags=['askb','ddm']
) }}
select m.*, h.*
from {{ref('ddm_askb_msa')}} m
join {{ref('h_askb_g_entity')}} h on m.g_entity = h.g_entity 
    {# Для выбора иерархии - можно при вызове из BI фильтровать или сделать параметр
        and h.g_entity_h = {hier:String} #}