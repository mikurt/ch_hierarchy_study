{{ config(
    materialized='table',
    engine='MergeTree',
    order_by='nr',
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
    SELECT ElementName, ElementName as hier, [ElementName] as path
    FROM tops
    UNION ALL
    -- Рекурсия: связываем детей с родителями
    SELECT c.ElementName, h.hier, arrayPushBack(h.path, c.ElementName) as path
    FROM h_all h
    JOIN {{ref("stg_et_g_production_groups")}} c ON c.Parent = h.ElementName
)
select (row_number() over (order by path))::UInt32 as nr,
    hier as g_production_groups_0,
    ElementName as g_production_groups
from h_all h
