#!/usr/bin/env bash


ccnet-server -c /code/seafile-server/tests/conf -f - & 
sleep 2

seaf-server -c /code/seafile-server/tests/conf -d /code/seafile-server/tests/conf/seafile-data -f -l - &
sleep 2

. /code/setenv.sh
cd /code/seahub
python manage.py migrate
python manage.py runserver 0.0.0.0:8000 

