{# G_MSA с иерархиями #}
{{ config(
    materialized='view',
    schema='DDM',
    tags=['ch_hier','ddm']
) }}
{% set h_dims = [
    'g_scenario',
'g_versions',
'g_currency_type',
'g_currency',
'g_entity',
'g_forms',
'g_adjustments',
'g_flows',
'g_mine',
'g_finance_contracts',
'g_stores_list',
'g_appraisal_model_items',
'g_counterparty',
'g_counterparty_re',
'g_cost_elements_cash_flows',
'g_project',
'f_uh_accounts_dt',
'f_uh_accounts_kt',
'g_accounts',
'g_production_groups',
'g_subdivisions',
'g_msa_measures'
]
-%}
select * 
from {{ref('ddm_msa')}} m
{% for dim in h_dims %}
    left join {{ref('h_'~dim)}} h_{{dim}} using {{dim}} {% endfor %}
    {# Для выбора иерархии - можно при вызове из BI фильтровать или сделать параметр
        and h.g_entity_h = {hier:String} #}