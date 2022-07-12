#!/bin/sh

python /code/manage.py migrate
python /code/manage.py createcachetable
python /code/manage.py collectstatic  --noinput
gunicorn mysite.wsgi:application --bind 0.0.0.0:8000

exec "$@"