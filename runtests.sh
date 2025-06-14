#!/bin/bash

set -e # exit when any command fails

set -o pipefail && xcodebuild build -project 'Source/ViewControllerPresentationSpy.xcodeproj' -scheme 'ViewControllerPresentationSpy-tvOS' -sdk 'appletvsimulator' -destination 'platform=tvOS Simulator,OS=latest,name=Apple TV' | xcbeautify
set -o pipefail && xcodebuild test -project 'ObjCSample/ObjCSampleViewControllerPresentationSpy.xcodeproj' -scheme 'ObjCSampleViewControllerPresentationSpy' -sdk 'iphonesimulator' -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16' | xcbeautify
set -o pipefail && xcodebuild test -project 'SwiftSample/SwiftSampleViewControllerPresentationSpy.xcodeproj' -scheme 'SwiftSampleViewControllerPresentationSpy' -sdk 'iphonesimulator' -destination 'platform=iOS Simulator,OS=latest,name=iPad Air (4th generation)' | xcbeautify
set -o pipefail && xcodebuild test -project 'SwiftSamplePackage/SwiftSampleViewControllerPresentationSpy.xcodeproj' -scheme 'SwiftSampleViewControllerPresentationSpy' -sdk 'iphonesimulator' -destination 'platform=iOS Simulator,OS=latest,name=iPad Air (4th generation)' | xcbeautify
