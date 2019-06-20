#!/bin/bash
set -e;
export LC_ALL=en_US.UTF-8;
export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib;
export DEBIAN_FRONTEND=noninteractive;

# location of this file in filesystem
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

# install the latest version of gdal

# remove version provided by package manager
# sudo apt-get -qq remove -y "gdal-bin";

# clean up
rm -rf $DIR/tmp;
mkdir -p $DIR/tmp;

# download and extract source code
SOURCE="http://download.osgeo.org/gdal/2.2.3/gdal-2.2.3.tar.gz";
wget -q $SOURCE -P $DIR/tmp;
cd $DIR/tmp;
tar xvfz $(basename "$SOURCE");

# compile source
cd $(basename "$SOURCE" ".tar.gz");
./configure \
  --with-proj=/usr/local/lib \
  --with-threads=yes \
  --with-libtiff=internal \
  --with-geotiff=internal \
  --with-jpeg=internal \
  --with-gif=internal \
  --with-png=internal \
  --with-sqlite3=yes \
  --with-spatialite=yes \
  --with-geos=yes \
  --with-libz=internal;
make -j8;

# install
sudo make install;
sudo ldconfig;
cd -;

# echo new version
cd -
ogr2ogr --version;
