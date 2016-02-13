#!/usr/bin/env bash
DIR="${PROJECT_DIR}/Submodules/libzmq"
LIBZMQ_FILE="libzmq.a"
lipo_input=( )

compile_zmq ()
{
export MACOSX_DEPLOYMENT_TARGET="10.9"
export CFLAGS="-${DEPLOYMENT_TARGET_CLANG_FLAG_NAME}=${IPHONEOS_DEPLOYMENT_TARGET}"
export ARCH=$1
export SDK=$2
export HOST=$3
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH} -fembed-bitcode"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
if [[ ! -f "${TARGET_BUILD_DIR}/${SDK}-${ARCH}/lib/${LIBZMQ_FILE}" ]]; then
mkdir -p "${TARGET_BUILD_DIR}/${SDK}-${ARCH}/include" "${TARGET_BUILD_DIR}/${SDK}-${ARCH}/lib"
make distclean
#echo "ENVIRONMENT..."
#export
"./configure" --disable-dependency-tracking --enable-static --disable-shared --host=${HOST} --prefix="${TARGET_BUILD_DIR}/${SDK}-${ARCH}" --without-libsodium --enable-perf --disable-curve-keygen
make
make install
make clean
fi
lipo_input+=("${TARGET_BUILD_DIR}/${SDK}-${ARCH}/lib/${LIBZMQ_FILE}")
}

echo "Updating source..."
git submodule init
git submodule update

cd "${DIR}" || exit
if [[ ! -f "./configure" ]]; then
echo "Autogen..."
./autogen.sh
fi
MY_ARCHS="arm64 armv7 armv7s"
#for A in ${VALID_ARCHS}
for A in ${MY_ARCHS}
do
echo "Compiling libzmq for $A..."
compile_zmq "$A" "iphoneos" "arm-apple-darwin"
done
echo "Compiling libzmq for i386..."
compile_zmq "i386" "iphonesimulator" "i386-apple-darwin"
echo "Compiling libzmq for x86_64..."
compile_zmq "x86_64" "iphonesimulator" "x86_64-apple-darwin"

echo "Creating fat static library..."
lipo -create ${lipo_input[*]} -output "${TARGET_BUILD_DIR}/${FULL_PRODUCT_NAME}"