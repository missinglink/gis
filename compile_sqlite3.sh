#!/bin/bash
set -e;
export LC_ALL=en_US.UTF-8;
export DEBIAN_FRONTEND=noninteractive;

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
SOURCE="https://www.sqlite.org/2018/sqlite-autoconf-3230100.tar.gz";
wget -q --no-check-certificate $SOURCE -P $DIR/tmp;
cd $DIR/tmp;
tar xvfz $(basename "$SOURCE");

# compile source
cd $(basename "$SOURCE" ".tar.gz");
CFLAGS='-std=gnu99 -DSQLITE_SOUNDEX -DSQLITE_ENABLE_RTREE -DSQLITE_THREADSAFE=1 -DHAVE_USLEEP=1 -DHAVE_PREAD64=1 -DHAVE_PWRITE64=1 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS4_UNICODE61 -DSQLITE_TRACE_SIZE_LIMIT=15 -DSQLITE_DISABLE_INTRINSIC -Wno-deprecated-declarations' \
  ./configure --enable-fts5 --enable-json1;
make -j4;

# install
sudo make install;
sudo ldconfig;
cd -;

# echo new version
cd -
sqlite3 -version;
