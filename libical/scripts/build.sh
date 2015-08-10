#!/bin/bash

set -o xtrace

# Change Working Directory to build
BUILD_DIR=$(dirname "${0}")/../build
mkdir -p $BUILD_DIR
pushd $BUILD_DIR > /dev/null
WORKING_DIR=`pwd`
export OUTPUT_DIR="$WORKING_DIR/output"
mkdir -p $OUTPUT_DIR

SCRIPTS_DIR=$WORKING_DIR/../scripts
echo "WORKING_DIR : $WORKING_DIR"
echo "SCRIPTS_DIR : $SCRIPTS_DIR"
echo "OUTPUT_DIR  : $OUTPUT_DIR"
LIPO="xcrun -sdk iphoneos lipo"

#
# Verify Tools Are Installed
command -v cmake >/dev/null 2>&1 || { echo >&2 "cmake required but it's not installed.  Aborting."; exit 1; }

#
# Download the latest library
LIBRARY_VISION="v1.0.1"
LIBRARY_TARBALL="libical"
if [ ! -d  ./$LIBRARY_TARBALL ]; then
  LIBRARY_DISTRO_URL="https://github.com/libical/libical"

  git clone $LIBRARY_DISTRO_URL
  git checkout tags/$LIBRARY_VISION > /dev.null

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
cp  -f ./build/src/libical_ical_export.h ../../src/include
rm -rf ../../zoneinfo
mv  $OUTPUT_DIR/share/libical/zoneinfo ../../zoneinfo

# Return to previous working directory
popd  > /dev/null

exit

