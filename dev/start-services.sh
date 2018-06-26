#!/usr/bin/env bash

# https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

echo "Change ownership of /code to user"
chown -R user:user /code/ccnet-pro-server
chown -R user:user /code/seafile-pro-server
chown -R user:user /code/seafevents
chown -R user:user /code/seahub/seahub

if [ "$IS_PRO_VERSION" ]; then
    echo "Starting PRO services......"

    # start services
    if [ "$LICENSE_DIR" ]; then
        /usr/local/bin/gosu user ccnet-server -c /code/seafile-pro-server/tests/conf -L $LICENSE_DIR -f - &
    else
        /usr/local/bin/gosu user ccnet-server -c /code/seafile-pro-server/tests/conf -f - &
    fi
    sleep 2

    echo "Starting seaf-pro-server ..."
    /usr/local/bin/gosu user seaf-server -c /code/seafile-pro-server/tests/conf -d /code/seafile-pro-server/tests/conf/seafile-data -f -l - &
    sleep 2

    /usr/local/bin/gosu user python -m seafevents.main --loglevel=debug --logfile=/tmp/events.log --config-file=/code/seafevents/events.conf --reconnect &
    # sleep 2
else
    echo "Starting CE services......"

    # start services
    /usr/local/bin/gosu user ccnet-server -c /code/seafile-server/tests/conf -f - &
    sleep 2

    /usr/local/bin/gosu user seaf-server -c /code/seafile-server/tests/conf -d /code/seafile-server/tests/conf/seafile-data -f -l - &
    sleep 2
fi

cd /code/seahub

if [ "$MIGRATE_SEAHUB_DB" ]; then
    echo "Migrating seahub db..."
    /usr/local/bin/gosu user python manage.py migrate --noinput
fi

cd ./frontend
/usr/local/bin/gosu user npm install
cd ..

/usr/local/bin/gosu user python manage.py runserver 0.0.0.0:8000
