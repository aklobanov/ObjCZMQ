#!/usr/bin/env bash

# Script adapted from https://github.com/samsoir/libzmq-ios-universal
# tried to keep things to a minimum

DIR="${PROJECT_DIR}/ObjCZMQ"
GLOBAL_OUTDIR="${PROJECT_DIR}/Dependencies/libzmq"
BUILD_DIR="${GLOBAL_OUTDIR}/build"
LIBZMQ_DIR="${GLOBAL_OUTDIR}/libzmq-git"
LIBZMQ_FILE="libzmq.a"
OSX_DEPLOY_TARGET="10.9"

if [[ -f "${DIR}/libzmq-osx.a" ]]; then
exit 0;
fi

compile_zmq ()
{
export CFLAGS="-mmacosx-version-min=${OSX_DEPLOY_TARGET}"
export ARCH=$1
export SDK=$2
export HOST=$3
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH}"
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


echo "Compiling libzmq for macosx"
echo "==========================="

echo "Compiling libzmq for i386..."
compile_zmq "i386" "macosx" "i386-apple-darwin"

echo "Compiling libzmq for x86_64..."
compile_zmq "x86_64" "macosx" "x86_64-apple-darwin"

echo "Creating fat static library for macosx"

lipo_input=( )
lipo_input+=("${BUILD_DIR}/macosx-i386/lib/${LIBZMQ_FILE}")
lipo_input+=("${BUILD_DIR}/macosx-x86_64/lib/${LIBZMQ_FILE}")

mkdir -p "${BUILD_DIR}/universal-osx/"

lipo -create ${lipo_input[*]} -output "${BUILD_DIR}/universal-osx/${LIBZMQ_FILE}"

echo "Copying libzmq headers into universal library..."
mkdir -p "${BUILD_DIR}/universal"
cp -R "${LIBZMQ_DIR}/include" "${BUILD_DIR}/universal"

cp ${BUILD_DIR}/universal/include/zmq.h ${DIR}
cp ${BUILD_DIR}/universal/include/zmq_utils.h ${DIR}
cp ${BUILD_DIR}/universal-osx/libzmq.a ${DIR}/libzmq-osx.a

rm -rf "${BUILD_DIR}"
rm -rf "${LIBZMQ_DIR}"