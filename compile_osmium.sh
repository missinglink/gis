#!/bin/bash
set -e;
export LC_ALL=en_US.UTF-8;
export DEBIAN_FRONTEND=noninteractive;

# location of this file in filesystem
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

# install the latest version of osmium
# https://github.com/osmcode/libosmium

# clean up
rm -rf $DIR/tmp;
mkdir -p $DIR/tmp;

# install dependencies
# libprotozero-dev \
sudo apt-get update -y
sudo apt-get -y install \
  cmake \
  cmake-curses-gui \
  make \
  g++ \
  git \
  ruby \
  ruby-json \
  libutfcpp-dev \
  libexpat1-dev \
  zlib1g-dev \
  libbz2-dev \
  libboost-dev \
  libsparsehash-dev \
  libgdal-dev \
  libgeos++-dev \
  libproj-dev \
  doxygen \
  graphviz;

# install the latest version of libosmium
rm -rf $DIR/tmp/libosmium;
git clone https://github.com/osmcode/libosmium.git $DIR/tmp/libosmium;
mkdir -p $DIR/tmp/libosmium/build;
cd $DIR/tmp/libosmium/build;
cmake ..;
make -j8;
sudo make install;
sudo ldconfig;
cd -;

# install the latest version of osmium-tool
# https://github.com/osmcode/osmium-tool

# install dependencies
sudo apt-get -y install \
  libboost-program-options-dev;

# download and extract source code
rm -rf $DIR/tmp/osmium-tool;
git clone https://github.com/osmcode/osmium-tool.git $DIR/tmp/osmium-tool;
mkdir -p $DIR/tmp/osmium-tool/build;
cd $DIR/tmp/osmium-tool/build;
cmake ..;
make -j8;
sudo make install;
sudo ldconfig;
cd -;
