{{  config(
    materialized='external_table',
    engine='S3',
    tags=['askb', 'stg'],
    conn_config={ 
        'connection_name': 's3_pkd_stg',
        'filename': 'askb/attr/}ElementAttributes_G_Entity/*',
        'format': 'CSVWithNames',
        'settings': "format_csv_delimiter = '|'"
    },
    columns='''
      G_Entity	String,
      "}ElementAttributes_G_Entity"	String,
      Value	Int64
  ''' )
}}