Pod::Spec.new do |s|
  s.name = 'ObjCZMQ'
  s.version = '1.0'
  s.summary = 'Objective-C binding for ZeroMQ'
  s.description  = <<-DESC
    Bundled with ZeroMQ library.
    This is an Objective-C version of the reference ZeroMQ object-oriented C API. It follows the guidelines laid out by the official "Guidelines for ZeroMQ bindings".
    DESC
  s.homepage     = "https://github.com/aklobanov/ObjCZMQ"
  s.license = 'MIT'
  s.author = { 'Alexey Lobanov' => 'aklobanov@gmail.com' }
  s.social_media_url = 'https://www.facebook.com/aklobanov'
  s.source = { :git => 'https://github.com/aklobanov/ObjCZMQ.git', :tag => s.version }
  s.source_files = 'ObjCZMQ/ObjCZMQ/*.{h,m,pch}', 'ObjCZMQ/Dependencies/libzmq/*.h'
  s.public_header_files = 'ObjCZMQ/ObjCZMQ/*.{h,hpp}'
  s.platform     = :ios, '8.0', :osx, '10.9'
  s.requires_arc = true
  s.osx.deployment_target = '10.9'
  s.ios.deployment_target = '8.0'
  s.frameworks = 'Foundation'
  s.libraries = 'libc++'
  s.ios.prepare_command = <<-CMD
DIR="$( cd "ObjCZMQ/Dependencies/libzmq" )" && pwd )"
GLOBAL_OUTDIR=${DIR}/Dependencies
BUILD_DIR=${DIR}/build
LIBZMQ_DIR="${DIR}/libzmq-git"
LIBZMQ_FILE="libzmq.a"
IOS_DEPLOY_TARGET="8.0"
if [[ -f "${DIR}/libzmq-ios.a" ]]; then
exit 0;
#library already built
fi
echo "Initializing build directory..."
if [[ -d ${BUILD_DIR} ]]; then
rm -rf "${BUILD_DIR}"
fi
echo "Initializing dependency directory..."
if [[ -d ${GLOBAL_OUTDIR} ]]; then
rm -rf "${GLOBAL_OUTDIR}"
fi
mkdir -p "${GLOBAL_OUTDIR}/include" "${GLOBAL_OUTDIR}/lib"
rm -rf "${LIBZMQ_DIR}"
echo "Cloning libzmq from source https://github.com/zeromq/libzmq.git"
git clone "https://github.com/zeromq/libzmq.git" "${LIBZMQ_DIR}"
cd "${LIBZMQ_DIR}" || exit
${LIBZMQ_DIR}/autogen.sh
cd "${DIR}" || exit
echo "Compiling libzmq for iphoneos/iphonesimulator"
echo "============================================="
echo "Compiling libzmq for armv7..."
export CFLAGS="-mios-version-min=${IOS_DEPLOY_TARGET}"
export ARCH="armv7"
export SDK="iphoneos"
export HOST="arm-apple-darwin"
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH}"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
mkdir -p "${BUILD_DIR}/${SDK}-${ARCH}"
make distclean
"${LIBZMQ_DIR}/configure" --disable-dependency-tracking \
--enable-static --disable-shared \
--host=${HOST} \
--prefix="${BUILD_DIR}/${SDK}-${ARCH}" --without-libsodium
make
make install
make clean
echo "Compiling libzmq for armv7s..."
export CFLAGS="-mios-version-min=${IOS_DEPLOY_TARGET}"
export ARCH="armv7s"
export SDK="iphoneos"
export HOST="arm-apple-darwin"
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH}"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
mkdir -p "${BUILD_DIR}/${SDK}-${ARCH}"
make distclean
"${LIBZMQ_DIR}/configure" --disable-dependency-tracking \
--enable-static --disable-shared \
--host=${HOST} \
--prefix="${BUILD_DIR}/${SDK}-${ARCH}" --without-libsodium
make
make install
make clean
echo "Compiling libzmq for arm64..."
export CFLAGS="-mios-version-min=${IOS_DEPLOY_TARGET}"
export ARCH="arm64"
export SDK="iphoneos"
export HOST="arm-apple-darwin"
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH}"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
mkdir -p "${BUILD_DIR}/${SDK}-${ARCH}"
make distclean
"${LIBZMQ_DIR}/configure" --disable-dependency-tracking \
--enable-static --disable-shared \
--host=${HOST} \
--prefix="${BUILD_DIR}/${SDK}-${ARCH}" --without-libsodium
make
make install
make clean
echo "Compiling libzmq for i386..."
export CFLAGS="-mios-version-min=${IOS_DEPLOY_TARGET}"
export ARCH="i386"
export SDK="iphonesimulator"
export HOST="i386-apple-darwin"
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH}"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
mkdir -p "${BUILD_DIR}/${SDK}-${ARCH}"
make distclean
"${LIBZMQ_DIR}/configure" --disable-dependency-tracking \
--enable-static --disable-shared \
--host=${HOST} \
--prefix="${BUILD_DIR}/${SDK}-${ARCH}" --without-libsodium
make
make install
make clean
echo "Compiling libzmq for x86_64..."
export CFLAGS="-mios-version-min=${IOS_DEPLOY_TARGET}"
export ARCH="x86_64"
export SDK="iphonesimulator"
export HOST="x86_64-apple-darwin"
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH}"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
mkdir -p "${BUILD_DIR}/${SDK}-${ARCH}"
make distclean
"${LIBZMQ_DIR}/configure" --disable-dependency-tracking \
--enable-static --disable-shared \
--host=${HOST} \
--prefix="${BUILD_DIR}/${SDK}-${ARCH}" --without-libsodium
make
make install
make clean
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
echo "Tidying up..."
rm -rf builds
rm -rf config.*
rm -rf dependencies
rm -rf doc
rm -rf foreign
rm -f libtool
rm -f Makefile
rm -rf perf
rm -rf src
rm -rf tests
rm -rf packaging
rm -rf tools
cp ${DIR}/build/universal/include/zmq.h ${DIR}
cp ${DIR}/build/universal/include/zmq_utils.h ${DIR}
cp ${DIR}/build/universal-ios/libzmq.a ${DIR}/libzmq-ios.a
CMD
  s.osx.prepare_command = <<-CMD
DIR="$( cd "ObjCZMQ/Dependencies/libzmq" )" && pwd )"
GLOBAL_OUTDIR=${DIR}/Dependencies
BUILD_DIR=${DIR}/build
LIBZMQ_DIR="${DIR}/libzmq-git"
LIBZMQ_FILE="libzmq.a"
OSX_DEPLOY_TARGET="10.9"
if [[ -f "${DIR}/libzmq-osx.a" ]]; then
exit 0;
#library already built
fi
echo "Initializing build directory..."
if [[ -d ${BUILD_DIR} ]]; then
rm -rf "${BUILD_DIR}"
fi
echo "Initializing dependency directory..."
if [[ -d ${GLOBAL_OUTDIR} ]]; then
rm -rf "${GLOBAL_OUTDIR}"
fi
mkdir -p "${GLOBAL_OUTDIR}/include" "${GLOBAL_OUTDIR}/lib"
rm -rf "${LIBZMQ_DIR}"
echo "Cloning libzmq from source https://github.com/zeromq/libzmq.git"
git clone "https://github.com/zeromq/libzmq.git" "${LIBZMQ_DIR}"
cd "${LIBZMQ_DIR}" || exit
${LIBZMQ_DIR}/autogen.sh
cd "${DIR}" || exit
echo "Compiling libzmq for macosx"
echo "==========================="
echo "Compiling libzmq for i386..."
export CFLAGS="-mmacosx-version-min=${OSX_DEPLOY_TARGET}"
export ARCH="i386"
export SDK="macosx"
export HOST="i386-apple-darwin"
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH}"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
mkdir -p "${BUILD_DIR}/${SDK}-${ARCH}"
make distclean
"${LIBZMQ_DIR}/configure" --disable-dependency-tracking \
--enable-static --disable-shared \
--host=${HOST} \
--prefix="${BUILD_DIR}/${SDK}-${ARCH}" --without-libsodium
make
make install
make clean
echo "Compiling libzmq for x86_64..."
export CFLAGS="-mmacosx-version-min=${OSX_DEPLOY_TARGET}"
export ARCH="x86_64"
export SDK="macosx"
export HOST="x86_64-apple-darwin"
export SDKROOT
SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
export CFLAGS="${CFLAGS} -arch ${ARCH}"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"
mkdir -p "${BUILD_DIR}/${SDK}-${ARCH}"
make distclean
"${LIBZMQ_DIR}/configure" --disable-dependency-tracking \
--enable-static --disable-shared \
--host=${HOST} \
--prefix="${BUILD_DIR}/${SDK}-${ARCH}" --without-libsodium
make
make install
make clean
echo "Creating fat static library for macosx"
lipo_input=( )
lipo_input+=("${BUILD_DIR}/macosx-i386/lib/${LIBZMQ_FILE}")
lipo_input+=("${BUILD_DIR}/macosx-x86_64/lib/${LIBZMQ_FILE}")
mkdir -p "${BUILD_DIR}/universal-osx/"
lipo -create ${lipo_input[*]} -output "${BUILD_DIR}/universal-osx/${LIBZMQ_FILE}"
echo "Copying libzmq headers into universal library..."
mkdir -p "${BUILD_DIR}/universal"
cp -R "${LIBZMQ_DIR}/include" "${BUILD_DIR}/universal"
echo "Tidying up..."
rm -rf builds
rm -rf config.*
rm -rf dependencies
rm -rf doc
rm -rf foreign
rm -f libtool
rm -f Makefile
rm -rf perf
rm -rf src
rm -rf tests
rm -rf packaging
rm -rf tools
cp ${DIR}/build/universal/include/zmq.h ${DIR}
cp ${DIR}/build/universal/include/zmq_utils.h ${DIR}
cp ${DIR}/build/universal-osx/libzmq.a ${DIR}/libzmq-osx.a
CMD
  s.ios.vendored_library = 'ObjCZMQ/Dependencies/libzmq/libzmq-ios.a'
  s.osx.vendored_library = 'ObjCZMQ/Dependencies/libzmq/libzmq-osx.a'
end
