{{ config(
    materialized='table',
    engine='MergeTree',
    schema='DDM',
    tags=['ch_hier','ddm'],
    order_by='g_currency_type_h, g_currency_type'
) }}
with RECURSIVE h_all AS (
    with leaves as (
        select ElementName from {{ref("stg_et_g_currency_type")}}
        where ElementType = 'N'
    )
    SELECT e.Parent as cid, e.ElementName as lid, [lid] as path
    FROM {{ref("stg_et_g_currency_type")}} e
    where e.ElementName in leaves and e.Parent <> ''
    UNION ALL
    -- Рекурсия: связываем детей с родителями
    SELECT c.Parent as cid, h.lid, arrayPushFront(h.path, h.cid) as path
    FROM h_all h
    JOIN {{ref("stg_et_g_currency_type")}} c ON c.ElementName = h.cid and c.Parent <> ''
)
select toLowCardinality(h.cid) as g_currency_type_h, h.lid as g_currency_type,
    {% for i in range(1, 4) -%}
    path[{{ i }}] as  g_currency_type_{{ i }}{{ "," if not loop.last }}
    {% endfor %}
from h_all h
anti join (
    select ElementName from {{ref("stg_et_g_currency_type")}}
    where Parent <> '') as r on h.cid=r.ElementName