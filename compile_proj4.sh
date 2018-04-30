#!/bin/bash
set -e;
export LC_ALL=en_US.UTF-8;

# location of this file in filesystem
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

# install the latest version of protozero
# https://github.com/mapbox/protozero

# install dependencies
sudo apt-get -y install cmake

# clean up
rm -rf $DIR/tmp;
rm -rf $DIR/tmp/proj4;
mkdir -p $DIR/tmp/proj4;

# make protozero
cd $DIR/tmp/proj4;
curl -O https://launchpad.net/ubuntu/+archive/primary/+files/proj_4.9.3.orig.tar.gz;
tar tar xvfz proj_4.9.3.orig.tar.gz;
cd proj-4.9.3;
./configure;
make -j4;
sudo make install;
sudo ldconfig;
