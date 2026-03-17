{{  config(
    materialized='external_table',
    engine='S3',
    tags=['askb', 'stg'],
    conn_config={ 
        'connection_name': 's3_pkd_stg',
        'filename': 'askb/G_MSA/**',
        'format': 'CSVWithNames',
        'settings': "format_csv_delimiter = '|'"
    },
    columns='''
      G_Scenario        LowCardinality(String),
      G_Versions        LowCardinality(String),
      G_Year                  LowCardinality(String),
      G_Period          LowCardinality(String),
      G_Currency_Type LowCardinality(String),
      G_Currency        LowCardinality(String),
      G_Entity          LowCardinality(String),
      G_Forms           LowCardinality(String),
      G_Adjustments     LowCardinality(String),
      G_Flows           LowCardinality(String),
      G_Mine                  LowCardinality(String),
      G_Finance_Contracts           String,
      G_Stores_List     LowCardinality(String),
      G_Appraisal_Model_Items            LowCardinality(String),
      G_Counterparty    LowCardinality(String),
      G_Counterparty_Re             LowCardinality(String),
      G_Cost_Elements_Cash_Flows         LowCardinality(String),
      G_Project         LowCardinality(String),
      F_UH_Accounts_Dt        LowCardinality(String),
      F_UH_Accounts_Kt        LowCardinality(String),
      G_Accounts        LowCardinality(String),
      G_Production_Groups           String,
      G_Subdivisions          LowCardinality(String),
      G_MSA_Measures          LowCardinality(String),
      Value Float64
  ''' )
}}