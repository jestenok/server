FROM apache/airflow:2.3.2

COPY . /docker-context-files

RUN python3 -m pip install -r /docker-context-files/requirements.txt
