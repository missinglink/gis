#!/bin/bash
set -e;
export LC_ALL=en_US.UTF-8;

# location of this file in filesystem
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

# install the latest version of sqlite3

# you can fetch the latest version from http://www.sqlite.org/download.html
# look for the version which says "C source code as an amalgamation. Also includes a "configure" script"

# remove version provided by package manager
# sudo apt-get -q -m -y remove sqlite3 libsqlite3-dev;

# clean up
rm -rf $DIR/tmp;
mkdir -p $DIR/tmp;

# download and extract source code
# note: matched version currently bundled with node-sqlite3
SOURCE="http://www.sqlite.org/2017/sqlite-autoconf-3210000.tar.gz";
wget -q $SOURCE -P $DIR/tmp;
cd $DIR/tmp;
tar xvfz $(basename "$SOURCE");

# compile source
cd $(basename "$SOURCE" ".tar.gz");
CPPFLAGS='-DSQLITE_ENABLE_COLUMN_METADATA -DSQLITE_MAX_WORKER_THREADS=8 -DSQLITE_DEFAULT_WORKER_THREADS=8' CFLAGS='-DSQLITE_SOUNDEX' ./configure --enable-fts5 --enable-json1;
make -j4;

# install
sudo make install;
sudo ldconfig;
cd -;

# echo new version
cd -
sqlite3 -version;
