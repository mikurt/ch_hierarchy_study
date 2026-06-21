from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig, RenderConfig
from cosmos.profiles.base import BaseProfileMapping
from cosmos.constants import TestBehavior
from airflow.decorators import dag
import pendulum
import sys
import os
from datetime import datetime

# для логирования процессов
import logging


DBT_PROJECT_PATH_CH = "/opt/airflow/dbt/"
DBT_EXECUTABLE_PATH = f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt"
logger = logging.getLogger("airflow.task") #(__name__)

# Кастомный профиль для ClickHouse
class ClickHouseProfileMapping(BaseProfileMapping):
    airflow_connection_type = "sqlite"
    dbt_profile_type = "clickhouse"
    @property
    def profile(self):
        return {
            "type": "clickhouse",
            "host": self.conn.host,
            "port": self.conn.port or 9000,
            "user": self.conn.login or "default",
            "password": self.conn.password or "",
            "database": self.conn.schema or "default",
            "schema": self.conn.schema or "default",
            "secure": False,
            "verify": False,
            "cluster": self.profile_args.get("cluster"),
            "send_receive_timeout": 900,
            "tcp_keepalive": True,
            "sync_request_timeout": 10,
            "custom_settings": self.profile_args.get("custom_settings", {"receive_timeout": 900, "send_timeout": 900, "http_receive_timeout": 900, "max_block_size": 10000000}),
        }

target_name = Variable.get("target_name", default_var="dev")

def get_clickhouse_connection_profile():
    return ProfileConfig(
        profile_name="ch",
        target_name=target_name,
        profile_mapping=ClickHouseProfileMapping(
            conn_id='ch',
            profile_args={}  
        )
    )

#
#Автоматизированная обработка данных с использованием dbt-моделей.
#

execution_config = ExecutionConfig(
    dbt_executable_path=DBT_EXECUTABLE_PATH,
)

@dag(
    dag_id="ch_hier",
    start_date=pendulum.datetime(2025, 12, 10, tz="Europe/Moscow"),
    schedule=None,
    catchup=False,
    max_active_runs=3,
    params={},
    default_args={"owner": "tmyu", "retries": 2,
        'depends_on_past': False},
    render_template_as_native_obj=True,
    tags=['srm']
)
def dbt_run_dag():

    # загрузка в Clikhouse
    ddm_ch = DbtTaskGroup(
        group_id="ddm_ch",
        project_config=ProjectConfig(DBT_PROJECT_PATH_CH),
        profile_config=get_clickhouse_connection_profile(),
        execution_config=execution_config,
        render_config=RenderConfig(
            test_behavior=TestBehavior.NONE,
            select=["tag:ch_hier"]
        )
    )    

dbt_run_dag()
