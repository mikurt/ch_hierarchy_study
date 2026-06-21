-- Выгрузка из DBeaver объектов, созданных через dbt

-- `DDM`.d_g_production_groups_1 определение

CREATE DICTIONARY DDM.d_g_production_groups_1
(

    `g_production_groups_id` UInt64,

    `g_production_groups` String
)
PRIMARY KEY g_production_groups_id
SOURCE(CLICKHOUSE(USER 'default' PASSWORD '[HIDDEN]' QUERY `\nwith els as (\n    select distinct ElementName\n    from \`STG\`.\`stg_et_g_production_groups\`\n)\nselect xxHash32(ElementName) as g_production_groups_id,
 \n    ElementName as g_production_groups\nfrom els`))
LIFETIME(MIN 0 MAX 3600)
LAYOUT(HASHED());


-- `DDM`.d_g_production_groups_h определение

CREATE TABLE DDM.d_g_production_groups_h
(

    `nr` UInt32,

    `g_production_groups_0` String,

    `g_production_groups` String
)
ENGINE = MergeTree
ORDER BY nr
SETTINGS replicated_deduplication_window = '0',
 index_granularity = 8192;


-- `DDM`.ddm_msa определение

CREATE TABLE DDM.ddm_msa
(

    `g_scenario` LowCardinality(String),

    `g_versions` LowCardinality(String),

    `year` UInt16,

    `month` Date,

    `g_currency_type` LowCardinality(String),

    `g_currency` LowCardinality(String),

    `g_entity` LowCardinality(String),

    `g_forms` LowCardinality(String),

    `g_adjustments` LowCardinality(String),

    `g_flows` LowCardinality(String),

    `g_mine` LowCardinality(String),

    `g_finance_contracts` String,

    `g_stores_list` LowCardinality(String),

    `g_appraisal_model_items` LowCardinality(String),

    `g_counterparty` LowCardinality(String),

    `g_counterparty_re` LowCardinality(String),

    `g_cost_elements_cash_flows` LowCardinality(String),

    `g_project` LowCardinality(String),

    `f_uh_accounts_dt` LowCardinality(String),

    `f_uh_accounts_kt` LowCardinality(String),

    `g_accounts` LowCardinality(String),

    `g_production_groups` String,

    `g_subdivisions` LowCardinality(String),

    `g_msa_measures` LowCardinality(String),

    `value` Float64,

    `load_at` DateTime
)
ENGINE = MergeTree
PARTITION BY month
ORDER BY (g_scenario,
 g_versions,
 g_entity,
 month)
SETTINGS replicated_deduplication_window = '0',
 index_granularity = 8192;


-- `DDM`.h_g_production_groups определение

CREATE TABLE DDM.h_g_production_groups
(

    `g_production_groups_h` LowCardinality(String),

    `g_production_groups` String,

    `g_production_groups_1` String,

    `g_production_groups_2` String,

    `g_production_groups_3` String
)
ENGINE = MergeTree
ORDER BY (g_production_groups_h,
 g_production_groups)
SETTINGS replicated_deduplication_window = '0',
 index_granularity = 8192;


-- `DDM`.`h_g_production_groups_1_NG_GTotal` определение

CREATE DICTIONARY DDM.h_g_production_groups_1_NG_GTotal
(

    `g_production_groups_id` UInt64,

    `parent_id` UInt64 HIERARCHICAL
)
PRIMARY KEY g_production_groups_id
SOURCE(CLICKHOUSE(USER 'default' PASSWORD '[HIDDEN]' QUERY `\nwith RECURSIVE h_all AS (\n    SELECT 'NG_GTotal' as ElementName,
 '' as Parent\n    UNION ALL\n    -- Рекурсия: связываем детей с родителями\n    SELECT c.ElementName,
 c.Parent\n    FROM h_all h\n    JOIN \`STG\`.\`stg_et_g_production_groups\` c ON c.Parent = h.ElementName\n)\nselect xxHash32(ElementName) as g_production_groups_id,
 \n    if(Parent<>'',
 xxHash32(Parent),
 0) as parent_id\nfrom h_all h`))
LIFETIME(MIN 0 MAX 3600)
LAYOUT(HASHED());


-- `DDM`.`h_g_production_groups_1_NG_SP_GTotal` определение

CREATE DICTIONARY DDM.h_g_production_groups_1_NG_SP_GTotal
(

    `g_production_groups_id` UInt64,

    `parent_id` UInt64 HIERARCHICAL
)
PRIMARY KEY g_production_groups_id
SOURCE(CLICKHOUSE(USER 'default' PASSWORD '[HIDDEN]' QUERY `\nwith RECURSIVE h_all AS (\n    SELECT 'NG_SP_GTotal' as ElementName,
 '' as Parent\n    UNION ALL\n    -- Рекурсия: связываем детей с родителями\n    SELECT c.ElementName,
 c.Parent\n    FROM h_all h\n    JOIN \`STG\`.\`stg_et_g_production_groups\` c ON c.Parent = h.ElementName\n)\nselect xxHash32(ElementName) as g_production_groups_id,
 \n    if(Parent<>'',
 xxHash32(Parent),
 0)  as parent_id\nfrom h_all h`))
LIFETIME(MIN 0 MAX 3600)
LAYOUT(HASHED());


-- `DDM`.`h_g_production_groups_1_NG_SP_not_Gold` определение

CREATE DICTIONARY DDM.h_g_production_groups_1_NG_SP_not_Gold
(

    `g_production_groups_id` UInt64,

    `parent_id` UInt64 HIERARCHICAL
)
PRIMARY KEY g_production_groups_id
SOURCE(CLICKHOUSE(USER 'default' PASSWORD '[HIDDEN]' QUERY `\nwith RECURSIVE h_all AS (\n    SELECT 'NG_SP_not_Gold' as ElementName,
 '' as Parent\n    UNION ALL\n    -- Рекурсия: связываем детей с родителями\n    SELECT c.ElementName,
 c.Parent\n    FROM h_all h\n    JOIN \`STG\`.\`stg_et_g_production_groups\` c ON c.Parent = h.ElementName\n)\nselect xxHash32(ElementName) as g_production_groups_id,
 \n    if(Parent<>'',
 xxHash32(Parent),
 0)  as parent_id\nfrom h_all h`))
LIFETIME(MIN 0 MAX 3600)
LAYOUT(HASHED());


-- `DDM`.h_g_production_groups_2 определение

CREATE DICTIONARY DDM.h_g_production_groups_2
(

    `g_production_groups_id` UInt64,

    `parent_id` UInt64 HIERARCHICAL,

    `g_production_groups` String
)
PRIMARY KEY g_production_groups_id
SOURCE(CLICKHOUSE(USER 'default' PASSWORD '[HIDDEN]' QUERY `\nwith RECURSIVE h_all AS (\n    with tops as (\n        select ElementName from \`STG\`.\`stg_et_g_production_groups\` t\n        anti join (\n            select ElementName from \`STG\`.\`stg_et_g_production_groups\`\n            where Parent <> '') as r on t.ElementName=r.ElementName\n        where ElementType = 'C'\n    )\n    SELECT ElementName,
 '' as Parent,
 ElementName as hier\n    FROM tops\n    UNION ALL\n    -- Рекурсия: связываем детей с родителями\n    SELECT c.ElementName,
 c.Parent,
 h.hier\n    FROM h_all h\n    JOIN \`STG\`.\`stg_et_g_production_groups\` c ON c.Parent = h.ElementName\n)\nselect xxHash32(hier||' '||ElementName) as g_production_groups_id,
 \n    if(Parent<>'',
 xxHash32(hier||' '||Parent),
 0) as parent_id,
\n    ElementName as g_production_groups\nfrom h_all h`))
LIFETIME(MIN 0 MAX 3600)
LAYOUT(HASHED());


-- `DDM`.h_g_production_groups_3 определение

CREATE DICTIONARY DDM.h_g_production_groups_3
(

    `g_production_groups_0` String,

    `g_production_groups` String,

    `g_production_groups_h` Array(String)
)
PRIMARY KEY g_production_groups_0,
 g_production_groups
SOURCE(CLICKHOUSE(USER 'default' PASSWORD '[HIDDEN]' QUERY `\nwith RECURSIVE h_all AS (\n    with leaves as (\n        select ElementName from \`STG\`.\`stg_et_g_production_groups\`\n        where ElementType = 'N'\n    )\n    SELECT e.Parent as cid,
 e.ElementName as lid,
 [lid] as path\n    FROM \`STG\`.\`stg_et_g_production_groups\` e\n    where e.ElementName in leaves and e.Parent <> ''\n    UNION ALL\n    -- Рекурсия: связываем детей с родителями\n    SELECT c.Parent as cid,
 h.lid,
 arrayPushFront(h.path,
 h.cid) as path\n    FROM h_all h\n    JOIN \`STG\`.\`stg_et_g_production_groups\` c ON c.ElementName = h.cid and c.Parent <> ''\n)\nselect h.cid as g_production_groups_0,
 h.lid as g_production_groups,
\n    path as g_production_groups_h\nfrom h_all h\nanti join (\n    select ElementName from \`STG\`.\`stg_et_g_production_groups\`\n    where Parent <> '') as r on h.cid=r.ElementName`))
LIFETIME(MIN 0 MAX 3600)
LAYOUT(COMPLEX_KEY_HASHED());


-- `DDM`.h_g_production_groups_4 определение

CREATE TABLE DDM.h_g_production_groups_4
(

    `g_production_groups_0` String,

    `g_production_groups` String,

    `g_production_groups_h` Array(String)
)
ENGINE = MergeTree
ORDER BY (g_production_groups_0,
 g_production_groups)
SETTINGS replicated_deduplication_window = '0',
 index_granularity = 8192;


-- `DDM`.h_g_production_groups_5 определение

CREATE TABLE DDM.h_g_production_groups_5
(

    `g_production_groups_0` String,

    `g_production_groups` String,

    `g_production_groups_h` Array(String)
)
ENGINE = Join(`ALL`,
 INNER,
 g_production_groups_0,
 g_production_groups);