## Seafile Pro Dev

### Use Seafile Dev Image

* Prepare dev folder


```
$ mkdir ~/dev_docker_test
$ cd ~/dev_docker_test

```

* pull image


```
scp 192.168.1.140:~/data/docker-registry/seafile-dev-6.2.13-pro.tar.gz .
docker load -i seafile-dev-6.2.13-pro.tar.gz

```

vi docker-compose.yml

```
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
      - PYTHONPATH=/code:/code/seafevents:/usr/local/lib/python2.7/dist-packages:/code/seahub/thirdpart
      - MIGRATE_SEAHUB_DB=1

    container_name: seafile-dev-pro

    ports:
     - "8000:8000"
     - "8082:8082"
     
    depends_on:
      # - db
      - memcached

```

* up and create seahub user

`$ docker-compose  up pro`

```
xiez:dev_docker_test xiez$ docker ps
CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                                    NAMES
61f1430b8b4d        xiez/seafile-dev-pro:6.2   "./start-services.sh"    2 minutes ago       Up 2 minutes        0.0.0.0:3000->3000/tcp, 0.0.0.0:8000->8000/tcp, 0.0.0.0:8082->8082/tcp   seafile-dev-pro
a0ff5a0e27df        memcached:1.4-alpine       "docker-entrypoint..."   5 minutes ago       Up 6 minutes        0.0.0.0:11211->11211/tcp                                                 seafile-memcached

```

Switch to new terminal and attach to container, create superuser

```
xiez:dev_docker_test xiez$ docker exec -i -t 61f1430b8b4d  /bin/bash

root@61f1430b8b4d:/code# cd seahub
root@61f1430b8b4d:/code/seahub# python manage.py createsuperuser

```

### Build Seafile Dev Image (6.2.13 pro)

* Prepare code structure


```
cd ~/dev_docker_test
mkdir build
cd build/

```

* Clone seafile-docker & libsearpc & seahub


```
git clone https://github.com/haiwen/libsearpc.git

git clone https://github.com/haiwen/seahub.git
checkout to 6.2.13-pro tag by `git checkout v6.2.13-pro -b 6.2.13`

```

* Clone seafile-pro-server & ccnet-pro-server & seafobj & seafevents & seahub-extra & seafes


```
mkdir pro && cd pro

git clone https://github.com/seafileltd/seafile-pro-server.git
checkout to 6.2.13-pro tag by `git checkout v6.2.13-pro -b 6.2.13`

...

```

* Add seafevents python requirements (rqeuired in v6.2)


```
vi seafevents/requirements.txt

SQLAlchemy
reportlab==3.4.0
pdfrw==0.4
mysql-python

```

* Add seafile, seafevents & seahub sample conf

  Ref : [dev-conf](https://dev.seafile.com/seahub/d/bc679934df1f468e9be8/)

* Final folder structure:


```
xiez:build xiez$ tree -L 1
.
├── dev-conf
├── docker-compose.yml
├── docker-compose.yml~
├── libsearpc
├── pro
├── seafile-docker
└── seahub

xiez:build xiez$ cd pro && tree -L 1 && cd ..

xiez:pro xiez$ tree -L 1
.
├── ccnet-pro-server
├── seafes
├── seafevents
├── seafile-pro-server
├── seafobj
└── seahub-extra

```

* Build & Test

`docker-compose  build pro`

cd ~/dev_docker_test

change image in docker-compose.yml to `image: xiez/seafile-dev-pro:6.2.13-pro`

`docker-compose up pro`

* Export image to .tar.gz


```
docker save -o /tmp/seafile-dev-6.2.13-pro.tar.gz xiez/seafile-dev-pro:6.2.13-pro

```
