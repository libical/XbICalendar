#!/bin/bash

set -o xtrace

# Change Working Directory to build
BUILD_DIR=$(dirname "${0}")/../build
pushd $BUILD_DIR > /dev/null
WORKING_DIR=`pwd`
export OUTPUT_DIR="$WORKING_DIR/output"
mkdir -p $OUTPUT_DIR

SCRIPTS_DIR=$WORKING_DIR/../scripts
echo "WORKING_DIR : $WORKING_DIR"
echo "SCRIPTS_DIR : $SCRIPTS_DIR"
echo "OUTPUT_DIR  : $OUTPUT_DIR"
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
LIBRARY_TARBALL="libical"
if [ ! -d  ./$LIBRARY_TARBALL ]; then
  LIBRARY_DISTRO_URL="https://github.com/libical/libical"

  git clone $LIBRARY_DISTRO_URL
fi


LIBRARY_DIR="libical"
pushd $LIBRARY_DIR > /dev/null

archList=( armv7 armv7s arm64 i386 x86_64 )
for AA in "${archList[@]}"
do
    ARCH="$AA" $SCRIPTS_DIR/libical_make.sh
done

# build up fat library
$LIPO \
    -arch arm64  $OUTPUT_DIR/arm64/libical.a \
    -arch armv7  $OUTPUT_DIR/armv7/libical.a \
    -arch armv7s $OUTPUT_DIR/armv7s/libical.a \
    -arch x86_64 $OUTPUT_DIR/x86_64/libical.a \
    -arch i386 $OUTPUT_DIR/i386/libical.a \
    -create -output $OUTPUT_DIR/libical.a

# make zoneinfo directory
pushd build/zoneinfo
make install
popd  >/dev/null

# Move things to their final place
mkdir -p ../../lib
cp -f $OUTPUT_DIR/libical.a ../../lib
mkdir -p ../../src/include
cp  -f ./build/src/libical/ical.h ../../src/include
rm -rf ../../zoneinfo
mv  $OUTPUT_DIR/share/libical/zoneinfo ../../zoneinfo

# Return to previous working directory
popd  > /dev/null

exit

