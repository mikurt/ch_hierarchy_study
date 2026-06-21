{% materialization external_table, adapter='clickhouse' -%}
  {#- {%- set identifier = model['alias'] -%} -#}
  {%- set columns = config.get('columns') -%}
  {%- set conn_config = config.get('conn_config') -%}
  {%- set engine = config.get('engine') -%}
  
  {#- {%- set target_relation = api.Relation.create(
      identifier=identifier,
      schema=schema,
      database=database,
      type='table'
  ) -%} -#}

  {%- set existing_relation = load_cached_relation(this) -%}
  {%- set target_relation = this.incorporate(type='table') -%}
  {%- set backup_relation = none -%}
  {%- set preexisting_backup_relation = none -%}

  {% if existing_relation is not none %}
    {%- set backup_relation_type = existing_relation.type -%}
    {%- set backup_relation = make_backup_relation(target_relation, backup_relation_type) -%}
    {%- set preexisting_backup_relation = load_cached_relation(backup_relation) -%}
  {% endif %}

  {# {{ drop_relation_if_exists(target_relation) }} #}
  -- drop the temp relations if they exist already in the database
  {{ drop_relation_if_exists(preexisting_backup_relation) }}

  {%- call statement('main') -%}
    CREATE TABLE  IF NOT EXISTS  {{ backup_relation if backup_relation else target_relation }} (
    {% if config.get('columns') -%}
      {{ config.get('columns') }}
    {%- endif %}
    ) ENGINE = {{engine}}(
      {%- set engine_params = [] -%}      
      {%- if conn_config.connection_name -%}
        {%- do engine_params.append(conn_config.connection_name) -%}
      {%- endif -%}
      {# process the list of parameter names by looping #}
      {%- set pars = ['table', 'schema', 'filename', 'format', 'compression'] -%}
      {%- for p in pars -%}
        {%- if conn_config[p] -%}
          {%- do engine_params.append(p ~ "='" ~ conn_config[p] ~ "'") -%}
        {%- endif -%}
      {%- endfor -%}
      {{ engine_params | join(', ') }}
    )
    {% if conn_config.settings %} 
    SETTINGS {{ conn_config.settings }}
    {% endif %}
  {%- endcall -%}

  {%- if existing_relation -%}
    {% do exchange_tables_atomic(backup_relation, existing_relation) %}
  {%- endif -%}

  {{ adapter.commit() }}
  {{ drop_relation_if_exists(backup_relation) }}

  {{ return({'relations': [target_relation]}) }}
{%- endmaterialization %}