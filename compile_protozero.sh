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
mkdir -p $DIR/tmp;

# make protozero
rm -rf $DIR/tmp/protozero;
git clone https://github.com/mapbox/protozero.git $DIR/tmp/protozero;
mkdir -p $DIR/tmp/protozero/build;
cd $DIR/tmp/protozero/build;
cmake ..;
make -j4;
sudo make install;
sudo ldconfig;
cd -;
