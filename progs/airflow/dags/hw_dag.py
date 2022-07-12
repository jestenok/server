import datetime
import os
import sys

from airflow.models import DAG
from airflow.operators.python import PythonOperator

from modules.pipeline import pipeline
from modules.predict import predict


path = '/opt/airflow/dags'

# Добавим путь к коду проекта в переменную окружения, чтобы он был доступен python-процессу
os.environ['PROJECT_PATH'] = path
# Добавим путь к коду проекта в $PATH, чтобы импортировать функции
sys.path.insert(0, path)


# <YOUR_IMPORTS>

args = {
    'owner': 'airflow',
    'start_date': datetime.datetime(2022, 7, 8),
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=1),
    'depends_on_past': True,
    'catchup': False,
}

with DAG(
        dag_id='car_price_prediction',
        schedule_interval="00 21 * * *",
        default_args=args,
) as dag:
    pipeline = PythonOperator(
        task_id='pipeline',
        python_callable=pipeline,
        dag=dag
    )

    predict = PythonOperator(
        task_id='predict',
        python_callable=predict,
        dag=dag
    )

    pipeline >> predict
