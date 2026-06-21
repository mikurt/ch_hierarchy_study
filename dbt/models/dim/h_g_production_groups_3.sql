{{ config(
    materialized='dictionary',
    fields=[
        ('g_production_groups_0', 'String'),
        ('g_production_groups', 'String'),
        ('g_production_groups_h', 'Array(String)')
    ],
    primary_key='g_production_groups_0, g_production_groups',
    layout='COMPLEX_KEY_HASHED()',
    lifetime='3600',
    source_type='clickhouse',
    schema='DDM',
    tags=['ch_hier','ddm'],
) }}
with RECURSIVE h_all AS (
    with leaves as (
        select ElementName from {{ref("stg_et_g_production_groups")}}
        where ElementType = 'N'
    )
    SELECT e.Parent as cid, e.ElementName as lid, [lid] as path
    FROM {{ref("stg_et_g_production_groups")}} e
    where e.ElementName in leaves and e.Parent <> ''
    UNION ALL
    -- Рекурсия: связываем детей с родителями
    SELECT c.Parent as cid, h.lid, arrayPushFront(h.path, h.cid) as path
    FROM h_all h
    JOIN {{ref("stg_et_g_production_groups")}} c ON c.ElementName = h.cid and c.Parent <> ''
)
select h.cid as g_production_groups_0, h.lid as g_production_groups,
    path as g_production_groups_h
from h_all h
anti join (
    select ElementName from {{ref("stg_et_g_production_groups")}}
    where Parent <> '') as r on h.cid=r.ElementName