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
  libopenjp2-7-dev;
  # libwebp-dev \
  # liblzma-dev \
  # libpng-dev \
  # libgif-dev \
  # libgeotiff-dev \
  # libfreetype6-dev;

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

# ---- freexl ----
clone "freexl";
cd $DIR/tmp/freexl;
./configure;
make -j4;
sudo make install;
sudo ldconfig;
cd -;


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

./configure --enable-rttopo --enable-geocallbacks --enable-gcp=yes --enable-libxml2;
make -j4;
sudo make install;
sudo ldconfig;
cd -;

# ---- readosm ----
clone "readosm";
cd $DIR/tmp/readosm;
./configure;
make -j4;
sudo make install;
sudo ldconfig;
cd -;

# ---- spatialite-tools ----
clone "spatialite-tools";
cd $DIR/tmp/spatialite-tools;
./configure;
make -j4;
sudo make install;
sudo ldconfig;
cd -;

# ---- librasterlite2 ----
# /usr/lib/x86_64-linux-gnu/libcairo.so.2.11400.6
# export LIBCAIRO_CFLAGS='-I/var/www/gis';
# export LIBCAIRO_LIBS='-I/var/www/gis -L/usr/local/lib -lcairo';
# export FREETYPE2_CFLAGS='-I/usr/include/freetype2';
# export FREETYPE2_LIBS='-I/usr/include/freetype2 -L/usr/local/lib -lfreetype2';
# clone "librasterlite2";
# cd $DIR/tmp/librasterlite2;
# ./configure --disable-charls;
# make -j4;
# sudo make install;
# sudo ldconfig;
# cd -;

# # # ---- spatialite-gui ----
# # configure liblzma location
# export LIBXML2_CFLAGS=`xml2-config --cflags`;
# export LIBXML2_LIBS=`xml2-config --libs --static`;
# export LIBLZMA_CFLAGS='-I/usr/include/lzma';
# export LIBLZMA_LIBS='-llzma';
# export LIBSPATIALITE_CFLAGS='-I/usr/local/lib';
# export LIBSPATIALITE_LIBS='-L/usr/local/lib';
# # export LIBRASTERLITE2_CFLAGS='-I/usr/local/lib';
# # export LIBRASTERLITE2_LIBS='-L/usr/local/lib';
#
# clone "spatialite_gui";
# cd $DIR/tmp/spatialite_gui;
# ./configure --disable-webp --disable-charls;
# make -j4;
# sudo make install;
# cd -;
