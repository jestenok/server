import os
from airflow.models import DAG
from airflow.operators.python import PythonOperator

import datetime
from contextlib import closing
import psutil
import psycopg2
import requests


def get_cpu_temp():
    tempFile = open("/sys/class/thermal/thermal_zone0/temp")
    cpu_temp = tempFile.read()
    tempFile.close()
    return float(cpu_temp) / 1000


def check_service(host, port):
    try:
        requests.head(f"http://{host}:{port}")
        return 1
    except:
        return 0


def main():
    with closing(psycopg2.connect(database="server",
                                  user=os.environ.get('LOGIN'),
                                  password=os.environ.get('PASSWORD'),
                                  host="db",
                                  port='5432')) as conn:
        with conn.cursor() as c:
            c.execute("INSERT INTO monitoring.metrics("
                      f"timestamp, cpu_usage, mem_available, cpu_temp, time_of_proc,"
                      f"adminer_status, site_status, jira_status, airflow_status, telegram_status) VALUES "
                      f"('{datetime.datetime.utcnow()}', "
                      f"{psutil.cpu_percent()}, "
                      f"{psutil.virtual_memory().available}, "
                      f"{get_cpu_temp()}, "
                      f"{0 * 1000:.2f},"
                      f"{check_service('adminer', 8080)},"
                      f"{check_service('mysite', 8000)},"
                      f"{check_service('jira', 8080)},"
                      f"{check_service('airflow-webserver', 8080)},"
                      f"{check_service('telegram', 8080)})"
                      )
            conn.commit()


args = {
    'owner': 'airflow',
    'start_date': datetime.datetime(2022, 7, 8),
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=1),
    'depends_on_past': False,
}

with DAG(
        dag_id='monitoring',
        schedule_interval="0/5 * * * *",
        default_args=args,
        catchup=False,
) as dag:
    m = PythonOperator(
        task_id='m',
        python_callable=main,
        dag=dag
    )
