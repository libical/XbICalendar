#!/bin/bash

set -o xtrace

# Change Working Directory to build
BUILD_DIR=$(dirname "${0}")/../build
pushd $BUILD_DIR > /dev/null
WORKING_DIR=`pwd`
SCRIPTS_DIR=$WORKING_DIR/../scripts
echo "WORKING_DIR : $WORKING_DIR"
echo "SCRIPTS_DIR : $SCRIPTS_DIR"

LIPO="xcrun -sdk iphoneos lipo"

# Download the lastest build Tools
#curl -OL http://ftpmirror.gnu.org/autoconf/autoconf-2.68.tar.gz
#tar xzf autoconf-2.68.tar.gz
#cd  autoconf-2.68
#./configure --prefix=$WORKING_DIR/autotools-bin
#make
#make install
#export PATH=$WORKING_DIR/autotools-bin/bin:$PATH
#cd $WORKING_DIR
#
#curl -OL http://ftpmirror.gnu.org/automake/automake-1.13.4.tar.gz
#tar xzf automake-1.13.4.tar.gz
#cd automake-1.13.4
#./configure --prefix=$WORKING_DIR/autotools-bin
#make
#make install
#cd $WORKING_DIR
#
#curl -OL http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz
#tar xzf libtool-2.4.2.tar.gz
#cd libtool-2.4.2
#./configure --prefix=$WORKING_DIR/autotools-bin
#make
#make install
#cd $WORKING_DIR
#
# Download the latest library
LIBRARY_TARBALL="libical.tar.gz"
if [ ! -e  ./$LIBRARY_TARBALL ]; then
  LIBRARY_DISTRO_URL="http://downloads.sourceforge.net/project/freeassociation/libical/libical-1.0/libical-1.0.tar.gz"


  curl -L  $LIBRARY_DISTRO_URL -o $LIBRARY_TARBALL
  gunzip -c $LIBRARY_TARBALL| tar xopf -
fi

LIBRARY_DIR="libical-1.0"
pushd $LIBRARY_DIR > /dev/null
export OUTPUTDIR="./lib"

./bootstrap

ARCH=armv7 $SCRIPTS_DIR/libical_make.sh
ARCH=armv7s $SCRIPTS_DIR/libical_make.sh
ARCH=arm64 $SCRIPTS_DIR/libical_make.sh
ARCH=i386 $SCRIPTS_DIR/libical_make.sh
ARCH=x86_64 $SCRIPTS_DIR/libical_make.sh

# build up fat library
$LIPO \
    -arch arm64  $OUTPUTDIR/arm64/libical.a \
    -arch armv7  $OUTPUTDIR/armv7/libical.a \
    -arch armv7s $OUTPUTDIR/armv7s/libical.a \
    -arch i386 $OUTPUTDIR/i386/libical.a \
    -create -output $OUTPUTDIR/libical.a

#  x86_64 is failing in the configuration step
#    -arch x86_64 $OUTPUTDIR/x86_64/libical-static.a \

cp  $OUTPUTDIR/libical.a ../../lib
cp  ./src/libical/ical.h ../../src/include

# Return to previous working directory
popd  > /dev/null

exit

