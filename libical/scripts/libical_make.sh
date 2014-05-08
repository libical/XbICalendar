#!/bin/sh

set -o xtrace

# SEE: http://www.smallsharptools.com/downloads/libical/

PATH="`xcode-select -print-path`/usr/bin:/usr/bin:/bin"

# set the prefix
PREFIX=${HOME}/Library/libical
OUTPUTDIR=./lib

if [ ! -n "$ARCH" ]; then
    export ARCH=armv7
fi


# Select the desired iPhone SDK
export SDKVER="7.1"
export DEVROOT=`xcode-select --print-path`

if [ "i386" = $ARCH ] || [ "x86_64" = $ARCH ]; then
    export SDKROOT=$DEVROOT/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator${SDKVER}.sdk
    export MIOS="-mios-simulator-version-min=7.0"
else
    export SDKROOT=$DEVROOT/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDKVER}.sdk
    export MIOS=""
fi;
export IOSROOT=$DEVROOT/Platforms/iPhoneOS.platform



if [ ! -d $DEVROOT ]
then
        echo "Developer Root not found! - $DEVROOT"
        exit 1
fi

echo "DEVROOT = $DEVROOT"

if [ ! -d $SDKROOT ]
then
        echo "SDK Root not found! - $SDKROOT"
        exit 1
fi

echo "SDKROOT = $SDKROOT"

if [ ! -d $IOSROOT ]
then
        echo "iOS Root not found! - $IOSROOT"
        exit 1
fi

echo "IOSROOT = $IOSROOT"

# Set up relevant environment variables 
export CPPFLAGS="-arch $ARCH -I$SDKROOT/usr/include $MIOS"
export CFLAGS="$CPPFLAGS -pipe -no-cpp-precomp -isysroot $SDKROOT "
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-L$SDKROOT/usr/lib/ -arch $ARCH"

export CLANG=$DEVROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang

export CC=$CLANG
export CXX=$CLANG
export LD=$IOSROOT/Developer/usr/bin/ld
export AR=$IOSROOT/Developer/usr/bin/ar 
export AS=$IOSROOT/Developer/usr/bin/as 
export LIBTOOL=$IOSROOT/usr/bin/libtool 
export STRIP=$IOSROOT/Developer/usr/bin/strip 
export RANLIB=$IOSROOT/Developer/usr/bin/ranlib
export LIPO="xcrun -sdk iphoneos lipo"
export HOST=arm-apple-darwin10


if [ ! -f $CC ]
then
        echo "C Compiler not found! - $CC"
        exit
fi

if [ ! -f $CXX ]
then
        echo "C++ Compiler not found! - $CXX"
        exit
fi

if [ ! -f $LD ]
then
        echo "Linker not found! - $LD"
        exit
fi

if [ -d $OUTPUTDIR/$ARCH ]
then 
       rm -rf $OUTPUTDIR/$ARCH
fi

find ./src -name \*.a -exec rm {} \;
make clean


./configure --prefix=$PREFIX --disable-dependency-tracking --host $HOST CXX=$CXX CC=$CC LD=$LD AR=$AR AS=$AS LIBTOOL=$LIBTOOL STRIP=$STRIP RANLIB=$RANLIB

make -j4

# copy the files to the arch folder

mkdir -p $OUTPUTDIR
mkdir -p $OUTPUTDIR/$ARCH

cp `find . -name \*.a` $OUTPUTDIR/$ARCH/
cp config.log $OUTPUTDIR/$ARCH/config.log

$LIPO -info $OUTPUTDIR/$ARCH/*.a

echo $ARCH DONE

echo "See $OUTPUTDIR"
