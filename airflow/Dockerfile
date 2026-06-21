## contents with airflow-clickhouse-plugin
FROM apache/airflow:2.10.5
USER root
RUN apt-get update && apt-get install -y gcc g++ python3-dev python3-venv && rm -rf /var/lib/apt/lists/*
USER airflow
RUN pip install --no-cache-dir airflow-clickhouse-plugin astronomer-cosmos
RUN python3 -m venv /home/airflow/dbt_venv
RUN /home/airflow/dbt_venv/bin/pip install --no-cache-dir dbt-core==1.11.11 dbt-clickhouse