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
  {%- if hier %}
    '{{hier}}'
  {%- else %}
    g_production_groups
  {%- endif %} as g_production_groups_0,
{%- for i in range(1, 9) %}
  {%- if hier %}
    dictGet('DDM.h_g_production_groups_3', 'g_production_groups_h', 
      ('{{hier}}', g_production_groups))[{{i}}]
  {%- else %}
    ''
  {%- endif %} as g_production_groups_{{i}},
{%- endfor %}
g_subdivisions, g_msa_measures, value
FROM `DDM`.ddm_msa
where 1 = 1 
{% if hier %} 
		AND g_production_groups IN (select g_production_groups from DDM.h_g_production_groups_3 
		  where g_production_groups_0 = '{{hier}}'
		  {%- if hier != node %}
		    and has(g_production_groups_h,'{{node}}')
		  {%- endif %})
{% endif %}