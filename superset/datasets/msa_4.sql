SELECT m.g_scenario, m.g_versions, m.`year`, m.`month`, m.g_currency_type, m.g_currency, m.g_entity, m.g_forms, m.g_adjustments, 
m.g_flows, m.g_mine, m.g_finance_contracts, m.g_stores_list, m.g_appraisal_model_items, m.g_counterparty, 
m.g_counterparty_re, m.g_cost_elements_cash_flows, m.g_project, m.f_uh_accounts_dt, m.f_uh_accounts_kt, 
m.g_accounts,
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
    m.g_production_groups
  {%- endif %} as g_production_groups_0,
{%- for i in range(1, 9) %}
  {%- if hier %}
    h.g_production_groups_h[{{i}}]
  {%- else %}
    ''
  {%- endif %} as g_production_groups_{{i}},
{%- endfor %}
m.g_subdivisions, m.g_msa_measures, m.value
FROM `DDM`.ddm_msa m
{%- if hier %}
    join (select g_production_groups, g_production_groups_h 
      from DDM.h_g_production_groups_4 where g_production_groups_0 = '{{hier}}'
		  {%- if hier != node %}
		    and has(g_production_groups_h,'{{node}}')
		  {%- endif %}
		  ) h using (g_production_groups)
{%- endif %}
