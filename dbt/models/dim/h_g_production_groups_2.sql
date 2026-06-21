{{ config(
    materialized='dictionary',
    fields=[
        ('g_production_groups_id', 'UInt64'),
        ('parent_id', 'UInt64 HIERARCHICAL'),
        ('g_production_groups', 'String')
    ],
    primary_key='g_production_groups_id',
    layout='HASHED()',
    lifetime='3600',
    source_type='clickhouse',
    schema='DDM',
    tags=['ch_hier','ddm'],
) }}
with RECURSIVE h_all AS (
    with tops as (
        select ElementName from {{ref("stg_et_g_production_groups")}} t
        anti join (
            select ElementName from {{ref("stg_et_g_production_groups")}}
            where Parent <> '') as r on t.ElementName=r.ElementName
        where ElementType = 'C'
    )
    SELECT ElementName, '' as Parent, ElementName as hier
    FROM tops
    UNION ALL
    -- Рекурсия: связываем детей с родителями
    SELECT c.ElementName, c.Parent, h.hier
    FROM h_all h
    JOIN {{ref("stg_et_g_production_groups")}} c ON c.Parent = h.ElementName
)
select xxHash32(hier||' '||ElementName) as g_production_groups_id, 
    if(Parent<>'', xxHash32(hier||' '||Parent), 0) as parent_id,
    ElementName as g_production_groups
from h_all h
