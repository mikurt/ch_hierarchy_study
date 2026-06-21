{# G_MSA #}
{{ config(
    materialized='incremental',
    unique_key='g_scenario, g_versions, month, g_entity',
    engine='MergeTree',
    schema='DDM',
    tags=['ch_hier','ddm'],
    order_by='g_scenario, g_versions, g_entity, month',
    partition_by = 'month'    
) }}
select convertCharset(G_Scenario,'WINDOWS-1251','UTF-8')	as	g_scenario,
    convertCharset(G_Versions,'WINDOWS-1251','UTF-8')	as	g_versions,
    substring(G_Year,4,4)::UInt16	as	year,
    makeDate(year, toUInt8(substring(G_Period,6,2))*3 + toUInt8(substring(G_Period,8,2)) -3, 1) as month,
    --G_Period	as	g_period,
    convertCharset(G_Currency_Type,'WINDOWS-1251','UTF-8')	as	g_currency_type,
    convertCharset(G_Currency,'WINDOWS-1251','UTF-8')	as	g_currency,
    convertCharset(G_Entity,'WINDOWS-1251','UTF-8')	as	g_entity,
    convertCharset(G_Forms,'WINDOWS-1251','UTF-8')	as	g_forms,
    convertCharset(G_Adjustments,'WINDOWS-1251','UTF-8')	as	g_adjustments,
    convertCharset(G_Flows,'WINDOWS-1251','UTF-8')	as	g_flows,
    convertCharset(G_Mine,'WINDOWS-1251','UTF-8')	as	g_mine,
    convertCharset(G_Finance_Contracts,'WINDOWS-1251','UTF-8')	as	g_finance_contracts,
    convertCharset(G_Stores_List,'WINDOWS-1251','UTF-8')	as	g_stores_list,
    convertCharset(G_Appraisal_Model_Items,'WINDOWS-1251','UTF-8')	as	g_appraisal_model_items,
    convertCharset(G_Counterparty,'WINDOWS-1251','UTF-8')	as	g_counterparty,
    convertCharset(G_Counterparty_Re,'WINDOWS-1251','UTF-8')	as	g_counterparty_re,
    convertCharset(G_Cost_Elements_Cash_Flows,'WINDOWS-1251','UTF-8')	as	g_cost_elements_cash_flows,
    convertCharset(G_Project,'WINDOWS-1251','UTF-8')	as	g_project,
    convertCharset(F_UH_Accounts_Dt,'WINDOWS-1251','UTF-8')	as	f_uh_accounts_dt,
    convertCharset(F_UH_Accounts_Kt,'WINDOWS-1251','UTF-8')	as	f_uh_accounts_kt,
    convertCharset(G_Accounts,'WINDOWS-1251','UTF-8')	as	g_accounts,
    convertCharset(G_Production_Groups,'WINDOWS-1251','UTF-8') 	as	g_production_groups,
    convertCharset(G_Subdivisions,'WINDOWS-1251','UTF-8')	as	g_subdivisions,
    convertCharset(G_MSA_Measures,'WINDOWS-1251','UTF-8')	as	g_msa_measures,
    Value	as	value,
    assumeNotNull(_time) as load_at
from {{ref('stg_et_g_msa')}}
{% if is_incremental() %}
    where load_at > (select max(load_at) from {{this}})
{% endif %}