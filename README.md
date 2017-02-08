
this container can be found on dockerhub: https://hub.docker.com/r/missinglink/gis/

# build

```bash
$ cd path_to_this_directory

$ docker build -t missinglink/gis .
```

# run

> interactive shell

```bash
$ docker run -it -v /data:/data missinglink/gis bash
```

# use as base for another Dockerfile

```bash
$ head -n2 Dockerfile

# base image
FROM missinglink/gis
```
