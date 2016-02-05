#!/usr/bin/env bash

# Script adapted from https://github.com/samsoir/libzmq-ios-universal
# tried to keep things to a minimum

DIR="${PROJECT_DIR}/ObjCZMQ"
GLOBAL_OUTDIR="${PROJECT_DIR}/Dependencies/libzmq"
BUILD_DIR="${GLOBAL_OUTDIR}/build"
LIBZMQ_DIR="${GLOBAL_OUTDIR}/libzmq-git"
LIBZMQ_FILE="libzmq.a"
IOS_DEPLOY_TARGET="8.0"

if [[ -f "${DIR}/libzmq-ios.a" ]]; then
exit 0;
fi

compile_zmq ()
{
export CFLAGS="-mios-version-min=${IOS_DEPLOY_TARGET}"
export ARCH=$1
export SDK=$2
export HOST=$3
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH} -fembed-bitcode"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
mkdir -p "${BUILD_DIR}/${SDK}-${ARCH}/include" "${BUILD_DIR}/${SDK}-${ARCH}/lib"
"${LIBZMQ_DIR}/configure" --disable-dependency-tracking --enable-static --disable-shared --host=${HOST} --prefix="${BUILD_DIR}/${SDK}-${ARCH}" \
                          --without-libsodium --disable-perf --disable-curve-keygen
make
make install
make clean
}

echo "Initializing build directory..."
if [[ -d ${BUILD_DIR} ]]; then
rm -rf "${BUILD_DIR}"
fi

echo "Cloning libzmq from source https://github.com/zeromq/libzmq.git"
if [[ -d ${LIBZMQ_DIR} ]]; then
rm -rf "${LIBZMQ_DIR}"
fi
git clone "https://github.com/zeromq/libzmq.git" "${LIBZMQ_DIR}"

cd "${LIBZMQ_DIR}" || exit
./autogen.sh
cd "${GLOBAL_OUTDIR}" || exit

echo "Compiling libzmq for iphoneos/iphonesimulator"
echo "============================================="

echo "Compiling libzmq for armv7..."
compile_zmq "armv7" "iphoneos" "arm-apple-darwin"

echo "Compiling libzmq for armv7s..."
compile_zmq "armv7s" "iphoneos" "arm-apple-darwin"

echo "Compiling libzmq for arm64..."
compile_zmq "arm64" "iphoneos" "arm-apple-darwin"

echo "Compiling libzmq for i386..."
compile_zmq "i386" "iphonesimulator" "i386-apple-darwin"

echo "Compiling libzmq for x86_64..."
compile_zmq "x86_64" "iphonesimulator" "x86_64-apple-darwin"

echo "Creating fat static library for iphoneos/iphonesimulator"

lipo_input+=("${BUILD_DIR}/iphoneos-armv7/lib/${LIBZMQ_FILE}")
lipo_input+=("${BUILD_DIR}/iphoneos-armv7s/lib/${LIBZMQ_FILE}")
lipo_input+=("${BUILD_DIR}/iphoneos-arm64/lib/${LIBZMQ_FILE}")
lipo_input+=("${BUILD_DIR}/iphonesimulator-i386/lib/${LIBZMQ_FILE}")
lipo_input+=("${BUILD_DIR}/iphonesimulator-x86_64/lib/${LIBZMQ_FILE}")

mkdir -p "${BUILD_DIR}/universal-ios/"

lipo -create ${lipo_input[*]} -output "${BUILD_DIR}/universal-ios/${LIBZMQ_FILE}"

echo "Copying libzmq headers into universal library..."

mkdir -p "${BUILD_DIR}/universal"
cp -R "${LIBZMQ_DIR}/include" "${BUILD_DIR}/universal"

cp ${BUILD_DIR}/universal/include/zmq.h ${DIR}
cp ${BUILD_DIR}/universal/include/zmq_utils.h ${DIR}
cp ${BUILD_DIR}/universal-ios/libzmq.a ${DIR}/libzmq-ios.a

rm -rf "${BUILD_DIR}"
rm -rf "${LIBZMQ_DIR}"