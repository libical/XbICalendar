#!/bin/bash

set -o xtrace

# installed home brew
# brew install autoconfig
# brew install automake
# brew intall libtool
# brew install libksba
# brew install libgpg
# brew install pkg-config

# Change Working Directory to build
BUILD_DIR=$(dirname "${0}")/../build
SCRIPT_DIR=../../scripts
pushd $BUILD_DIR > /dev/null
echo "WORKING_DIR : `pwd`"

# Download the latest library
LIBRARY_DISTRO_URL="http://downloads.sourceforge.net/project/freeassociation/libical/libical-1.0/libical-1.0.tar.gz"

LIBRARY_TARBALL="libical.tar.gz"
#curl -L  $LIBRARY_DISTRO_URL -o $LIBRARY_TARBALL 
#gunzip -c $LIBRARY_TARBALL| tar xopf -
LIBRARY_DIR=`echo libical*/`
pushd $LIBRARY_DIR > /dev/null
export OUTPUTDIR="./lib"


#./bootstrap

#ARCH=armv7 $SCRIPT_DIR/libical_make.sh
#ARCH=armv7s $SCRIPT_DIR/libical_make.sh
#ARCH=arm64 $SCRIPT_DIR/libical_make.sh
ARCH=i386 $SCRIPT_DIR/libical_make.sh
#ARCH=x86_64 $SCRIPT_DIR/libical_make.sh

# build x86_64
#./configure
#make
#cp ./src/libical/.libs/libical.a $OUTPUTDIR/x86_64

# build up library
lipo \
    -arch arm64  $OUTPUTDIR/arm64/libical.a \
    -arch armv7  $OUTPUTDIR/armv7/libical.a \
    -arch armv7s $OUTPUTDIR/armv7s/libical.a \
    -arch x86_64 $OUTPUTDIR/x86_64/libical-static.a \
    -arch i386 $OUTPUTDIR/i386/libical-static.a \
    -create -output $OUTPUTDIR/libical.a


# -arch i386 $OUTPUTDIR/i386/libical.a \

cp  $OUTPUTDIR/libical.a ../../lib

cp  ./src/libical/ical.h ../../src/include

# Return to previous working directory
popd  > /dev/null
popd  > /dev/null


