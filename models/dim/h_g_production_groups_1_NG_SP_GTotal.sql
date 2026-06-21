{{ config(
    materialized='dictionary',
    fields=[
        ('g_production_groups_id', 'UInt64'),
        ('parent_id', 'UInt64 HIERARCHICAL')
    ],
    primary_key='g_production_groups_id',
    layout='HASHED()',
    lifetime='3600',
    source_type='clickhouse',
    schema='DDM',
    tags=['ch_hier','ddm'],
) }}
with RECURSIVE h_all AS (
    SELECT 'NG_SP_GTotal' as ElementName, '' as Parent
    UNION ALL
    -- Рекурсия: связываем детей с родителями
    SELECT c.ElementName, c.Parent
    FROM h_all h
    JOIN {{ref("stg_et_g_production_groups")}} c ON c.Parent = h.ElementName
)
select xxHash32(ElementName) as g_production_groups_id, 
    if(Parent<>'', xxHash32(Parent), 0)  as parent_id
from h_all h
