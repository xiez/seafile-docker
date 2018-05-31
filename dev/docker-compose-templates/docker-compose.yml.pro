version: '3'
services:
  db:
    image: mysql:5.7
    container_name: seafile-mysql
    volumes:
      - /opt/mysql-data:/var/lib/mysql
    ports:
      - "3306:3306"

  memcached:
    image: memcached:1.4-alpine
    container_name: seafile-memcached
    ports:
      - "11211:11211"

  pro:
    image: xiez/seafile-dev-pro:6.2.13-pro

    environment:
      - DOCKER_DEV=1
      - LOCAL_USER_ID=1000
      - IS_PRO_VERSION=1
      - LICENSE_DIR=/code/seaf-license # comment this value if image is pro:6.0
      - CCNET_CONF_DIR=/code/seafile-pro-server/tests/conf
      - SEAFILE_CONF_DIR=/code/seafile-pro-server/tests/conf/seafile-data
      - PYTHONPATH=/code:/code/seafevents:/usr/local/lib/python2.7/dist-packages:/code/seahub/thirdpart:/code/seahub/thirdpart/social-app-django
      - MIGRATE_SEAHUB_DB=1

    container_name: seafile-dev-pro
    # volumes:
    #   - /Users/xiez/dev_docker_test/seafile-conf:/code/seafile-pro-server/tests/conf
    #   - /Users/xiez/dev_docker_test/seahub:/code/seahub
    #   - /Users/xiez/dev_docker_test/seahub-extra/seahub_extra:/code/seahub_extra
    #   - /Users/xiez/dev_docker_test/seafevents:/code/seafevents
    #   - /Users/xiez/dev_docker_test/seafes:/code/seafes
    ports:
     - "8000:8000"
     - "8082:8082"
     - "3000:3000"
    depends_on:
      # - db
      - memcached
