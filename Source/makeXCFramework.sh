#!/bin/bash
FRAMEWORK_NAME="ViewControllerPresentationSpy"

CATALYST_ARCHIVE_PATH="./build/archives/mac_catalyst.xcarchive"
IOS_ARCHIVE_PATH="./build/archives/ios.xcarchive"
IOS_SIMULATOR_ARCHIVE_PATH="./build/archives/ios_sim.xcarchive"
TV_ARCHIVE_PATH="./build/archives/tv.xcarchive"
TV_SIMULATOR_ARCHIVE_PATH="./build/archives/tv_sim.xcarchive"

xcodebuild archive -scheme ${FRAMEWORK_NAME} -archivePath ${CATALYST_ARCHIVE_PATH} -destination 'platform=macOS,variant=Mac Catalyst' SKIP_INSTALL=NO
xcodebuild archive -scheme ${FRAMEWORK_NAME} -archivePath ${IOS_ARCHIVE_PATH} -sdk iphoneos SKIP_INSTALL=NO
xcodebuild archive -scheme ${FRAMEWORK_NAME} -archivePath ${IOS_SIMULATOR_ARCHIVE_PATH} -sdk iphonesimulator SKIP_INSTALL=NO
xcodebuild archive -scheme ${FRAMEWORK_NAME}-tvOS -archivePath ${TV_ARCHIVE_PATH} -sdk appletvos SKIP_INSTALL=NO
xcodebuild archive -scheme ${FRAMEWORK_NAME}-tvOS -archivePath ${TV_SIMULATOR_ARCHIVE_PATH} -sdk appletvsimulator SKIP_INSTALL=NO

xcodebuild -create-xcframework \
  -framework ${CATALYST_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
  -framework ${IOS_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
  -framework ${IOS_SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
  -framework ${TV_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
  -framework ${TV_SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
  -output "./build/${FRAMEWORK_NAME}.xcframework"
