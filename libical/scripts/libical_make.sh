#!/bin/sh

set -o xtrace

# SEE: http://www.smallsharptools.com/downloads/libical/

PATH="`xcode-select -print-path`:/usr/bin:/usr/bin:/bin:/usr/local/bin"


if [ ! -n "$ARCH" ]; then
    export ARCH=armv7
fi


# Select the desired iPhone SDK
export SDKVER="9.1"
export DEVROOT=`xcode-select --print-path`

if [ "i386" = $ARCH ] || [ "x86_64" = $ARCH ]; then
    export SDKROOT=$DEVROOT/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator${SDKVER}.sdk
    export MIOS="-mios-simulator-version-min=7.1"
else
    export SDKROOT=$DEVROOT/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDKVER}.sdk
    export MIOS="-miphoneos-version-min=7.1"
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
export CPPFLAGS="-arch $ARCH -I$SDKROOT/usr/include $MIOS --debug"
export CFLAGS="$CPPFLAGS -pipe -no-cpp-precomp -isysroot $SDKROOT "
export CXXFLAGS="$CFLAGS"

export LDFLAGS="-L$SDKROOT/usr/lib/ -arch $ARCH"

export CLANG=$DEVROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang


export CC=$CLANG
export CXX=$CLANG++
export LD=$DEVROOT/usr/bin/ld
export AR=$DEVROOT/usr/bin/ar
export AS=$DEVROOT/usr/bin/as
export LIBTOOL=$IOSROOT/usr/bin/libtool
export STRIP=$DEVROOT/usr/bin/strip
export RANLIB=$DEVROOT/usr/bin/ranlib
export LIPO="xcrun -sdk iphoneos lipo"
export HOST=arm-apple-darwin10

if [ ! -f $CC ]
then
        echo "C Compiler not found! - $CC"
        exit 1
fi

if [ ! -f $CXX ]
then
        echo "C++ Compiler not found! - $CXX"
        exit 1
fi

if [ ! -f $LD ]
then
        echo "Linker not found! - $LD"
        exit 1
fi

if [ -d $OUTPUT_DIR/$ARCH ]
then 
       rm -rf $OUTPUT_DIR/$ARCH
fi

find ./src -name \*.a -exec rm {} \;


mkdir build
cd build
rm -rf *
cmake -DCMAKE_OSX_ARCHITECTURES=$ARCH -DUSE_BUILTIN_TZDATA=true -DCMAKE_INSTALL_PREFIX="$OUTPUT_DIR" ..

make

# copy the files to the arch folder

mkdir -p $OUTPUT_DIR
mkdir -p $OUTPUT_DIR/$ARCH

cp `find . -name \*.a` $OUTPUT_DIR/$ARCH/

$LIPO -info $OUTPUT_DIR/$ARCH/*.a

echo $ARCH DONE

echo "See $OUTPUT_DIR"
