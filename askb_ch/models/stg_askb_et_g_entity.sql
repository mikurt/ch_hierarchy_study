{{  config(
    materialized='external_table',
    engine='S3',
    tags=['askb', 'stg'],
    conn_config={ 
        'connection_name': 's3_pkd_stg',
        'filename': 'askb/dim/G_Entity/*',
        'format': 'CSVWithNames',
        'settings': "format_csv_delimiter = '|'"
    },
    columns='''
      ElementType	String,
      ElementName	String,
      Parent	String,
      Weight	Float32
  ''' )
}}