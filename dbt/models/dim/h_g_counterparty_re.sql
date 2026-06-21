{{ config(
    materialized='table',
    engine='MergeTree',
    schema='DDM',
    tags=['ch_hier','ddm'],
    order_by='g_counterparty_re_h, g_counterparty_re'
) }}
with RECURSIVE h_all AS (
    with leaves as (
        select ElementName from {{ref("stg_et_g_counterparty_re")}}
        where ElementType = 'N'
    )
    SELECT e.Parent as cid, e.ElementName as lid, [lid] as path
    FROM {{ref("stg_et_g_counterparty_re")}} e
    where e.ElementName in leaves and e.Parent <> ''
    UNION ALL
    -- Рекурсия: связываем детей с родителями
    SELECT c.Parent as cid, h.lid, arrayPushFront(h.path, h.cid) as path
    FROM h_all h
    JOIN {{ref("stg_et_g_counterparty_re")}} c ON c.ElementName = h.cid and c.Parent <> ''
)
select toLowCardinality(h.cid) as g_counterparty_re_h, h.lid as g_counterparty_re,
    {% for i in range(1, 4) -%}
    path[{{ i }}] as  g_counterparty_re_{{ i }}{{ "," if not loop.last }}
    {% endfor %}
from h_all h
anti join (
    select ElementName from {{ref("stg_et_g_counterparty_re")}}
    where Parent <> '') as r on h.cid=r.ElementName