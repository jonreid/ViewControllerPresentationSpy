#!/bin/bash

VERSION=7.0.0
DISTFILE=ViewControllerPresentationSpy-${VERSION}
DISTPATH=build/${DISTFILE}
PROJECTROOT=..

echo Preparing clean build
rm -rf build
mkdir build

echo Building XCFramework
source makeXCFramework.sh
OUT=$?
if [ "${OUT}" -ne "0" ]; then
    echo ViewControllerPresentationSpy build failed
    exit ${OUT}
fi

echo Assembling Distribution
rm -rf "${DISTPATH}"
mkdir "${DISTPATH}"
cp -R "build/ViewControllerPresentationSpy.xcframework" "${DISTPATH}"
cp "${PROJECTROOT}/README.md" "${DISTPATH}"
cp "${PROJECTROOT}/CHANGELOG.md" "${DISTPATH}"
cp "${PROJECTROOT}/LICENSE.txt" "${DISTPATH}"

pushd build
zip --recurse-paths --symlinks ${DISTFILE}.zip ${DISTFILE}
open .
popd
