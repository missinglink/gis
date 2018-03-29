# base image
FROM ubuntu:16.04

# configure env
ENV DEBIAN_FRONTEND noninteractive

# configure user
RUN apt-get update && apt-get --no-install-recommends -y install sudo apt-utils locales build-essential autotools-dev autoconf automake pkg-config libtool wget file && rm -rf /var/lib/apt/lists/*
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN sed -i "s/sudo	ALL=(ALL:ALL) ALL/sudo	ALL=(ALL:ALL) NOPASSWD:ALL/" /etc/sudoers

# configure locale
ENV LD_LIBRARY_PATH=.:/lib:/usr/lib:/usr/local/lib
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# configure directories & copy source files
RUN mkdir -p /service/gis
RUN chown "docker:docker" /service/gis
WORKDIR /service/gis

# compile sqlite3
COPY compile_sqlite3.sh /service/gis/
RUN sudo -H -u docker /bin/bash compile_sqlite3.sh

# compile spatialite
COPY compile_spatialite.sh /service/gis/
RUN sudo -H -u docker /bin/bash compile_spatialite.sh

# compile gdal
COPY compile_gdal.sh /service/gis/
RUN sudo -H -u docker /bin/bash compile_gdal.sh

# compile protozero
COPY compile_protozero.sh /service/gis/
RUN sudo -H -u docker /bin/bash compile_protozero.sh

# compile osmium
COPY compile_osmium.sh /service/gis/
RUN sudo -H -u docker /bin/bash compile_osmium.sh

# volumes
VOLUME "/data"

# clean up
RUN rm -rf /service/gis/tmp
RUN rm -rf /var/lib/apt/lists/*
