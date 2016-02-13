#!/bin/sh

#  build_ios_fw.sh
#  ObjCZMQ
#
#  Created by ALEXEY LOBANOV on 13.02.16.
#  Copyright © 2016 Blue Skies Software. All rights reserved.
set -e
if [ -n "$MULTIPLATFORM_BUILD_IN_PROGRESS" ]; then
exit 0
fi
export MULTIPLATFORM_BUILD_IN_PROGRESS=1

function build_static_library {
# Will rebuild the static library as specified
#     build_static_library sdk
echo "Building project=${PROJECT_FILE_PATH} target=${TARGET_NAME} configuration=${CONFIGURATION} sdk=${1} build_dir=${BUILD_DIR} obj_root=${OBJROOT} build_root=${BUILD_ROOT} sym_root=${SYMROOT} action=${ACTION}"
xcrun xcodebuild -project "${PROJECT_FILE_PATH}" \
-target "${TARGET_NAME}" \
-configuration "${CONFIGURATION}" \
-sdk "${1}" \
ONLY_ACTIVE_ARCH=NO \
BUILD_DIR="${BUILD_DIR}" \
OBJROOT="${OBJROOT}" \
BUILD_ROOT="${BUILD_ROOT}" \
SYMROOT="${SYMROOT}" $ACTION
}
function make_fat_library {
# Will smash 2 static libs together
#     make_fat_library in1 in2 out
xcrun lipo -create "${1}" "${2}" -output "${3}"
}
echo "Extracting the platform (iphoneos/iphonesimulator) from the SDK name ..."
if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]; then
GET_SDK_PLATFORM=${BASH_REMATCH[1]}
else
echo "Could not find platform name from SDK_NAME: $SDK_NAME"
exit 1
fi
echo "SDK name is ${GET_SDK_PLATFORM}"
echo "Extracting the version from the SDK ..."
if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]; then
GET_SDK_VERSION=${BASH_REMATCH[1]}
else
echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
exit 1
fi
echo "SDK VERSION is ${GET_SDK_VERSION}"
echo "Determining the other platform ..."
if [ "$GET_SDK_PLATFORM" == "iphoneos" ]; then
FW_OTHER_PLATFORM=iphonesimulator
else
FW_OTHER_PLATFORM=iphoneos
fi
echo "OTHER PLATFORM is ${FW_OTHER_PLATFORM}"
echo "Finding the build directory ..."
if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$GET_SDK_PLATFORM$ ]]; then
FW_OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${FW_OTHER_PLATFORM}"
else
echo "Could not find other platform build directory."
exit 1
fi
echo "OTHER BUILD DIRECTORY is ${FW_OTHER_BUILT_PRODUCTS_DIR}"
build_static_library "${FW_OTHER_PLATFORM}${GET_SDK_VERSION}"
make_fat_library "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/${PRODUCT_MODULE_NAME}" "${FW_OTHER_BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/${PRODUCT_MODULE_NAME}" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/${PRODUCT_MODULE_NAME}"
