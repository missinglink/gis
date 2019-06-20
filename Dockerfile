# base image
FROM ubuntu:19.04

# configure env
ENV DEBIAN_FRONTEND noninteractive

# install dependencies
RUN apt-get update && apt-get --no-install-recommends -y install sudo apt-utils locales build-essential autotools-dev autoconf automake pkg-config libtool wget file tzdata && rm -rf /var/lib/apt/lists/*

# configure locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# set ld path
ENV LD_LIBRARY_PATH=.:/lib:/usr/lib:/usr/local/lib

# create user and grant sudo
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# configure directories & copy source files
RUN mkdir -p /service/gis
RUN chown "docker:docker" /service/gis
WORKDIR /service/gis

# switch user
USER docker
ENV USER docker

# compile sqlite3
COPY compile_sqlite3.sh /service/gis/
RUN ./compile_sqlite3.sh && sudo rm -rf /service/gis/* /var/lib/apt/lists/*

# compile spatialite
COPY compile_spatialite.sh /service/gis/
RUN ./compile_spatialite.sh && sudo rm -rf /service/gis/* /var/lib/apt/lists/*

# compile gdal
COPY compile_gdal.sh /service/gis/
RUN ./compile_gdal.sh && sudo rm -rf /service/gis/* /var/lib/apt/lists/*

# compile protozero
COPY compile_protozero.sh /service/gis/
RUN ./compile_protozero.sh && sudo rm -rf /service/gis/* /var/lib/apt/lists/*

# compile osmium
COPY compile_osmium.sh /service/gis/
RUN ./compile_osmium.sh && sudo rm -rf /service/gis/* /var/lib/apt/lists/*

# volumes
VOLUME "/data"
