## Directory Structure

```
ubuntu@ip-172-31-28-154:~/dev$ tree -L 1
.
├── ccnet-server
├── libevhtp
├── libsearpc
├── seafile-docker
├── seafile-server
├── seahub
```

## Build Image

Build dependency image for seafile CE.
```
docker build -f ~/dev/seafile-docker/dev/Dockerfile-seafile-deps -t seafile-deps .
```

Build seafile CE 6.2.2.
```
docker build -f ~/dev/seafile-docker/dev/Dockerfile-seafile-dev -t xiez/seafile-dev:6.2.2 .
```

## Init Test Data

ccnet & seafile conf
```
mkdir seafile-conf
docker run --name tmp-sf -d xiez/seafile-dev:6.2.2
docker cp tmp-sf:/code/seafile-server/tests/conf ~/dev/seafile-conf
docker rm -f tmp-sf
```

## Attatch to Container

```
docker run -it -v ~/dev/seafile-conf:/code/seafile-server/tests/conf -v ~/dev/seahub:/code/seahub xiez/seafile-dev:6.2.2  /bin/bash
```


## Start Container

```
docker run -p 8000:8000 -v ~/dev/seafile-conf:/code/seafile-server/tests/conf -v ~/dev/seahub:/code/seahub xiez/seafile-dev:6.2.2
```


## Docker-compose

Start develop environment from scratch using Docker-compose.

```
mkdir ~/dev2 && cd ~/dev2

git clone https://github.com/xiez/seafile-docker.git && cd seafile-docker
git fetch origin dev:dev && git checkout dev

cd ~/dev2/seafile-docker/dev
cp docker-compose.yml.template ~/dev2/docker-compose.yml && cd ~/dev2
```

Modify `volums` in docker-compose.yml,

e.g.

```
    volumes:
      - /Users/xiez/dev2/seafile-conf:/code/seafile-server/tests/conf
      - /Users/xiez/dev2/seahub:/code/seahub
```

Create ~/dev2/seafile-conf

```
docker run --name tmp-sf -d xiez/seafile-dev:6.2.2
docker cp tmp-sf:/code/seafile-server/tests/conf ~/dev2/seafile-conf
docker rm -f tmp-sf
```

Add `UNIX_SOCKET=/tmp/ccnet.sock` to [Client] in `seafile-conf/ccnet.conf`

Clone seahub repo

```
cd ~/dev2 && git clone git@github.com:haiwen/seahub.git
printf "DEBUG=True\nENABLE_SIGNUP=True" >> ~/dev2/seahub/seahub/local_settings.py
```

Start service and register new account on login page.

```
docker-compose up dev
```

Enter into a container to run tests

```
docker exec -i -t 0384410bb16f /bin/bash
```


