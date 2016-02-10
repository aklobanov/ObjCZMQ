#!/usr/bin/env bash
DIR="${PROJECT_DIR}/Submodules/libzmq"
LIBZMQ_FILE="libzmq.a"
lipo_input=( )

compile_zmq ()
{
export CFLAGS="-${DEPLOYMENT_TARGET_CLANG_FLAG_NAME}=${MACOSX_DEPLOYMENT_TARGET}"
export ARCH=$1
export SDK=$2
export HOST=$3
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH}"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
mkdir -p "${TARGET_BUILD_DIR}/${SDK}-${ARCH}/include" "${TARGET_BUILD_DIR}/${SDK}-${ARCH}/lib"
make distclean
"./configure" --disable-dependency-tracking --enable-static --disable-shared --host=${HOST} --prefix="${TARGET_BUILD_DIR}/${SDK}-${ARCH}" --without-libsodium --enable-perf --disable-curve-keygen
make
make install
make clean
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

for A in ${VALID_ARCHS}
do
echo "Compiling libzmq for $A..."
compile_zmq "$A" "macosx" "$A-apple-darwin"
done

echo "Creating fat static library..."
lipo -create ${lipo_input[*]} -output "${TARGET_BUILD_DIR}/${FULL_PRODUCT_NAME}"