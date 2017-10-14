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

```
docker build -f ~/dev/seafile-docker/dev/Dockerfile-seafile-dev -t xiez/seafile-dev:6.2.2 .
```

## Attatch to Container

```
docker run -it -v ~/dev/seafile-conf:/code/seafile-server/tests/conf -v ~/dev/seahub:/code/seahub xiez/seafile-dev:6.2.2  /bin/bash
```

## Start Container

```
docker run -p 8000:8000 -v ~/dev/seafile-conf:/code/seafile-server/tests/conf -v ~/dev/seahub:/code/seahub xiez/seafile-dev:6.2.2
```





