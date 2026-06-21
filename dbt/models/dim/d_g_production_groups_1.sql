{{ config(
    materialized='dictionary',
    fields=[
        ('g_production_groups_id', 'UInt64'),
        ('g_production_groups', 'String')
    ],
    primary_key='g_production_groups_id',
    layout='HASHED()',
    lifetime='3600',
    source_type='clickhouse',
    schema='DDM',
    tags=['ch_hier','ddm'],
) }}
with els as (
    select distinct ElementName
    from {{ref("stg_et_g_production_groups")}}
)
select xxHash32(ElementName) as g_production_groups_id, 
    ElementName as g_production_groups
from els
