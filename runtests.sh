#!/usr/bin/env bash
set -euo pipefail

echo "Source"
xcodebuild build -project 'Source/ViewControllerPresentationSpy.xcodeproj' -scheme 'ViewControllerPresentationSpy-tvOS' -sdk 'appletvsimulator' -destination 'platform=tvOS Simulator,OS=18.5,name=Apple TV' | xcbeautify

echo "========"
echo "ObjCSample"
xcodebuild test -project 'ObjCSample/ObjCSampleViewControllerPresentationSpy.xcodeproj' -scheme 'ObjCSampleViewControllerPresentationSpy' -sdk 'iphonesimulator' -destination 'platform=iOS Simulator,OS=18.5,name=iPhone 16' | xcbeautify

echo "========"
echo "SwiftSample"
xcodebuild test -project 'SwiftSample/SwiftSampleViewControllerPresentationSpy.xcodeproj' -scheme 'SwiftSampleViewControllerPresentationSpy' -sdk 'iphonesimulator' -destination 'platform=iOS Simulator,OS=18.5,name=iPad Air (4th generation)' | xcbeautify

echo "========"
echo "SwiftSamplePackage"
xcodebuild test -project 'SwiftSamplePackage/SwiftSampleViewControllerPresentationSpy.xcodeproj' -scheme 'SwiftSampleViewControllerPresentationSpy' -sdk 'iphonesimulator' -destination 'platform=iOS Simulator,OS=18.5,name=iPad Air (4th generation)' | xcbeautify
