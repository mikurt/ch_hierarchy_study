SELECT g_scenario, g_versions, `year`, `month`, g_currency_type, g_currency, g_entity, g_forms, g_adjustments, 
g_flows, g_mine, g_finance_contracts, g_stores_list, g_appraisal_model_items, g_counterparty, 
g_counterparty_re, g_cost_elements_cash_flows, g_project, f_uh_accounts_dt, f_uh_accounts_kt, 
g_accounts,
{%- set filter_result = filter_values('production_group_node') %}
{%- if filter_result and filter_result[0] %}
    {%- set parts = filter_result[0].split('  /  ') %}
    {%- set hier = parts[0] %}
    {%- set node = parts[1] %}
{%- else %}
    {%- set hier = None %}
    {%- set node = None %}
{%- endif %}
{%- for i in range(0, 9) %}
  {%- if hier %}
    dictGet('DDM.h_g_production_groups_2', 'g_production_groups', 
      dictGetHierarchy('DDM.h_g_production_groups_2',xxHash32('{{hier}} ' || g_production_groups))[{{(-1-i)}}])
  {%- elif i==0 %}
    g_production_groups
  {%- else %}
    ''
  {%- endif %} as g_production_groups_{{i}},
{%- endfor %}
g_subdivisions, g_msa_measures, value
FROM `DDM`.ddm_msa
where 1 = 1 
{% if hier %} 
		AND xxHash32('{{hier}} ' || g_production_groups) IN 
		  arrayPushBack(dictGetDescendants('DDM.h_g_production_groups_2',xxHash32('{{hier}} {{node}}')), 
		  xxHash32('{{hier}} {{node}}'))
{% endif %}
