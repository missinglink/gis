#!/bin/bash
set -e;
export LC_ALL=en_US.UTF-8;
export DEBIAN_FRONTEND=noninteractive;

# location of this file in filesystem
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

# install the latest version of protozero
# https://github.com/mapbox/protozero

# install dependencies
sudo apt-get -y install cmake

# clean up
rm -rf $DIR/tmp;
rm -rf $DIR/tmp/geos;
mkdir -p $DIR/tmp/geos;

# make protozero
cd $DIR/tmp/geos;
curl -O https://launchpad.net/ubuntu/+archive/primary/+files/geos_3.6.2.orig.tar.bz2;
tar xvfj geos_3.6.2.orig.tar.bz2;
cd geos-3.6.2;
./configure;
make -j8;
sudo make install;
sudo ldconfig;
