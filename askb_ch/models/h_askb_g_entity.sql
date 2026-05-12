{# Иерархия БЕ #}
{{ config(
    materialized='proplum',
    incremental_strategy='full',
    engine='MergeTree',
    schema='DDM_ASKB',
    tags=['askb','ddm'],
    order_by='g_entity_h, g_entity'    
) }}
with RECURSIVE h_all AS (
with leaves as (
	select ElementName from {{ref("stg_askb_et_g_entity")}}
	where ElementType = 'N' 
)
    SELECT e.Parent as cid, e.ElementName as lid, [lid] as path
    FROM {{ref("stg_askb_et_g_entity")}} e 
    where e.ElementName in leaves and e.Parent <> ''
    UNION ALL
    -- Рекурсия: связываем детей с родителями
    SELECT c.Parent as cid, h.lid, arrayPushFront(h.path, h.cid) as path
    FROM h_all h
    JOIN {{ref("stg_askb_et_g_entity")}} c ON c.ElementName = h.cid and c.Parent <> ''
)
select toLowCardinality(h.cid) as g_entity_h, h.lid as g_entity,
    {% for i in range(1, 4) -%}
    path[{{ i }}] as  g_entity_{{ i }}{{ "," if not loop.last }}
    {% endfor %}
from h_all h
	anti join (
		select ElementName from {{ref("stg_askb_et_g_entity")}}
		where Parent <> '') as r on h.cid=r.ElementName