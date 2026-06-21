{{ config(
    materialized='table',
    engine='MergeTree',
    schema='DDM',
    tags=['ch_hier','ddm'],
    order_by='g_finance_contracts_h, g_finance_contracts'
) }}
with RECURSIVE h_all AS (
    with leaves as (
        select ElementName from {{ref("stg_et_g_finance_contracts")}}
        where ElementType = 'N'
    )
    SELECT e.Parent as cid, e.ElementName as lid, [lid] as path
    FROM {{ref("stg_et_g_finance_contracts")}} e
    where e.ElementName in leaves and e.Parent <> ''
    UNION ALL
    -- Рекурсия: связываем детей с родителями
    SELECT c.Parent as cid, h.lid, arrayPushFront(h.path, h.cid) as path
    FROM h_all h
    JOIN {{ref("stg_et_g_finance_contracts")}} c ON c.ElementName = h.cid and c.Parent <> ''
)
select toLowCardinality(h.cid) as g_finance_contracts_h, h.lid as g_finance_contracts,
    {% for i in range(1, 4) -%}
    path[{{ i }}] as  g_finance_contracts_{{ i }}{{ "," if not loop.last }}
    {% endfor %}
from h_all h
anti join (
    select ElementName from {{ref("stg_et_g_finance_contracts")}}
    where Parent <> '') as r on h.cid=r.ElementName