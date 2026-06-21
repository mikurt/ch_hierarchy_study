{{ config(
    materialized='external_table',
    engine='S3',
    tags=['ch_hier', 'stg'],
    conn_config={
        'connection_name': 's3_tmyu',
        'filename': 'dim/G_MSA_Measures*',
        'format': 'CSVWithNames',
        'settings': "format_csv_delimiter = '|'"
    },
    columns='''
      ElementType	String,
      ElementName	String,
      Parent	String,
      Weight	Float32
    '''
) }}`