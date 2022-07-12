import os
from airflow.models import DAG
from airflow.operators.python import PythonOperator

import datetime
from contextlib import closing
import psutil
import psycopg2


def get_cpu_temp():
    tempFile = open("/sys/class/thermal/thermal_zone0/temp")
    cpu_temp = tempFile.read()
    tempFile.close()
    return float(cpu_temp) / 1000


def main():

    with closing(psycopg2.connect(database="server",
                                  user=os.environ.get('LOGIN'),
                                  password=os.environ.get('PASSWORD'),
                                  host="db",
                                  port='5432')) as conn:


        with conn.cursor() as cursor:
            head = "INSERT INTO monitoring.metrics(timestamp, cpu_usage, mem_available, cpu_temp, time_of_proc) VALUES "
            insert_value = f"('{datetime.datetime.utcnow()}', {psutil.cpu_percent()}, {psutil.virtual_memory().available}, {get_cpu_temp()}, {0 * 1000:.2f})"
            cursor.execute(head + insert_value)
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
