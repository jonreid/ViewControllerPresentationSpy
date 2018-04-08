#!/bin/bash

VERSION=3.1.0
DISTFILE=MockUIAlertController-${VERSION}
DISTPATH=build/${DISTFILE}
PROJECTROOT=..

echo Preparing clean build

rm -rf build
mkdir build

echo Building MockUIAlertController - Release
xcodebuild -configuration Release -target MockUIAlertController
OUT=$?
if [ "${OUT}" -ne "0" ]; then
    echo MockUIAlertController release build failed
    exit ${OUT}
fi


echo Assembling Distribution
rm -rf "${DISTPATH}"
mkdir "${DISTPATH}"
cp -R "build/Release-iphoneos/MockUIAlertController.framework" "${DISTPATH}"
cp "${PROJECTROOT}/README.md" "${DISTPATH}"
cp "${PROJECTROOT}/CHANGELOG.md" "${DISTPATH}"
cp "${PROJECTROOT}/LICENSE.txt" "${DISTPATH}"

pushd build
zip --recurse-paths --symlinks ${DISTFILE}.zip ${DISTFILE}
open .
popd
