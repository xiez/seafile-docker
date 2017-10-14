#!/usr/bin/env bash

# https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user


# start services
/usr/local/bin/gosu user ccnet-server -c /code/seafile-server/tests/conf -f - & 
sleep 2

/usr/local/bin/gosu user seaf-server -c /code/seafile-server/tests/conf -d /code/seafile-server/tests/conf/seafile-data -f -l - &
sleep 2

. /code/setenv.sh
cd /code/seahub
python manage.py migrate && python manage.py runserver 0.0.0.0:8000 

