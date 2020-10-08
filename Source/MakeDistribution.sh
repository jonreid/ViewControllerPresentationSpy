#!/bin/bash

VERSION=5.1.0
DISTFILE=ViewControllerPresentationSpy-${VERSION}
DISTPATH=build/${DISTFILE}
PROJECTROOT=..

echo Preparing clean build

rm -rf build
mkdir build

echo Building ViewControllerPresentationSpy - Release
xcodebuild -configuration Release -target ViewControllerPresentationSpy -sdk iphonesimulator
OUT=$?
if [ "${OUT}" -ne "0" ]; then
    echo ViewControllerPresentationSpy release build failed
    exit ${OUT}
fi


echo Assembling Distribution
rm -rf "${DISTPATH}"
mkdir "${DISTPATH}"
cp -R "build/Release-iphonesimulator/ViewControllerPresentationSpy.framework" "${DISTPATH}"
cp "${PROJECTROOT}/README.md" "${DISTPATH}"
cp "${PROJECTROOT}/CHANGELOG.md" "${DISTPATH}"
cp "${PROJECTROOT}/LICENSE.txt" "${DISTPATH}"

pushd build
zip --recurse-paths --symlinks ${DISTFILE}.zip ${DISTFILE}
open .
popd
