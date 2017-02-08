#!/bin/bash
set -e;
export LC_ALL=en_US.UTF-8;

# location of this file in filesystem
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

# install the latest version of spatialite

# the latest official build is quite old, so we will build from source
# see: http://www.gaia-gis.it/gaia-sins/about-fossil.html
# see: https://www.gaia-gis.it/fossil/libspatialite/index

# remove version provided by package manager
# sudo apt-get -qq remove -y "libspatialite*";

# install the CVS tools used for this repo
sudo apt-get update;
sudo apt-get -qq install -y fossil git-core;

# install shared dependencies
sudo apt-get -y install \
  zlib1g-dev \
  libproj-dev \
  libgeos-dev \
  libxml2-dev \
  libexpat1-dev \
  libwxgtk3.0-dev \
  libopenjp2-7-dev \
  libwebp-dev \
  liblzma-dev;

# clean up
rm -rf $DIR/tmp;
mkdir -p $DIR/tmp;

# clone a fossil source
function clone(){
  REPO="$1";
  rm -rf $DIR/tmp/$REPO $DIR/tmp/$REPO.fossil*;
  fossil clone https://www.gaia-gis.it/fossil/$REPO $DIR/tmp/$REPO.fossil;
  mkdir -p $DIR/tmp/$REPO;
  cd $DIR/tmp/$REPO;
  fossil open ../$REPO.fossil;
  cd -;
}

# ---- librttopo ----
rm -rf $DIR/tmp/librttopo;
git clone https://git.osgeo.org/gogs/rttopo/librttopo.git $DIR/tmp/librttopo;
cd $DIR/tmp/librttopo;
./autogen.sh;
./configure;
make -j4;
sudo make install;
sudo ldconfig;
cd -;

# ---- libspatialite ----
clone "libspatialite";
cd $DIR/tmp/libspatialite;

# configure xml2 location
export LIBXML2_CFLAGS=`xml2-config --cflags`;
export LIBXML2_LIBS=`xml2-config --libs --static`;

./configure --enable-rttopo --enable-geocallbacks --enable-libxml2 --disable-freexl; # disable excel spreadsheet support
make -j4;
sudo make install;
sudo ldconfig;
cd -;

# ---- readosm ----
clone "readosm";
cd $DIR/tmp/readosm;
./configure --disable-freexl; # disable excel spreadsheet support
make -j4;
sudo make install;
sudo ldconfig;
cd -;

# ---- spatialite-tools ----
clone "spatialite-tools";
cd $DIR/tmp/spatialite-tools;
./configure --disable-freexl; # disable excel spreadsheet support
make -j4;
sudo make install;
sudo ldconfig;
cd -;

# # ---- spatialite-gui ----
# clone "spatialite_gui";
# cd $DIR/tmp/spatialite_gui;
# ./configure --disable-freexl --disable-libxml2 --disable-webp --disable-charls --disable-liblzma;
# make -j4;
# sudo make install;
# cd -;
