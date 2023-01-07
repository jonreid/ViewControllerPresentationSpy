Version 7.0.0
-------------
_07 Jan 2023_

Adds @MainActor annotations to spies for Xcode 14 fix. You will need to add @MainActor to any
test suites that use these spies.


Version 6.1.0
-------------
_06 Aug 2022_

Now available from Swift Package Manager!


Version 6.0.0
-------------
_06 Nov 2021_

- Added tvOS support.
- Packaged pre-built binary as single XCFramework containing 5 architectures:
  * Mac Catalyst
  * iOS device
  * iOS simulator
  * tvOS device
  * tvOS simulator
- Fixed Xcode 12.5 build errors. _Thanks to: Felix Yuan_


Version 5.1.0
-------------
_07 Oct 2020_

- Bump project settings to Xcode 12.
- Bump minimum deployment target to iOS 10.0.


Version 5.0.1
-------------
_21 Aug 2020_

Fixed to load on iOS 10.3.3 devices.


Version 5.0.0
-------------
_30 Jan 2020_

This release adds diagnostic test failures if verifiers clash.

- Fail test if code creates multiple instances of any single verifier. This inadvertently undid its
  swizzling, leading to test failures that were tricky to diagnose. Now a failure message provides
  guidance.
- Also fail if an AlertVerifier and a PresentationVerifier exist simultaneously, since they both
  swizzle UIAlertViewController. This has the potential to change test results, so this is marked as
  a major release.


Version 4.2.2
-------------
_13 Sep 2019_

Switch to Legacy Build System to try to improve flaky build errors around importing Swift-generated
headers into Objective-C.


Version 4.2.1
-------------
_05 Sep 2019_

Reduced minimum deployment target to iOS 9.0.


Version 4.2.0
-------------
_30 Aug 2019_

Added `DismissalVerifier` to capture calls to dismiss view controller. The Swift version has a
`verify` method which checks:
  * That the dismissed count is 1.
  * The animated flag.
  * The dismissed view controller, if provided.

Like the other verifiers, it also has a `capturedCompletion` to capture any production code
completion handler, and a `testCompletion` so that test code can supply its own completion handler.


Version 4.1.1
-------------
_24 Aug 2019_

- Fix alert `verify` to pass call site file/line for title and message errors.


Version 4.1.0
-------------
_23 Aug 2019_

Added `verify` methods to the Swift versions of each verifier.

- The `PresentationVerifier` method checks:
  * That the presented count is 1.
  * The animated flag.
  * The presenting view controller, if provided.
  * The type of the presented view controller.
  * Returns the view controller cast to the expected type (or `nil` if it didn't match).
- The `AlertVerifier` method checks:
  * That the presented count is 1.
  * The title.
  * The message.
  * The animated flag.
  * The preferred style (`.alert` or `.actionSheet`).
  * The presenting view controller, if provided.
  * The titles and styles of each action.


Version 4.0.0
-------------
_24 Jul 2019_

MockUIAlertController is dead. Long live ViewControllerPresentationSpy!

- Added `PresentationVerifier` to capture any presented view controller. It's able to capture segues.
- Rewrote alert verifier in Swift. You no longer need a bridging header.
- Simplified name of alert verifier to `AlertVerifier` (Swift) or `QCOAlertVerifier` (Objective-C).
- Use simpler naming for invoking button action, and made it a Swift throwing function. This changes the Objective-C implementation to return an NSError via an "in-out" parameter.
- Renamed test code completion handler to `testCompletion`.
- The production code completion handler passed to `present(_:animated:completion:)` is no longer executed right away. Instead, it's captured in `capturedCompletion`. That way tests can execute it after executing a button action.
- Removed `actionTitles` and `-styleForButtonWithTitle:`, deprecated in Version 3.1.0.


Version 3.2.0
-------------
_10 Feb 2019_

- Added `completion` closure invoked when alert is presented. If you present an alert from `DispatchQueue.main.async`, you can use this to fulfill an XCTestExpectation for async testing.
- Improved README instructions on bridging header for Swift.


Version 3.1.0
-------------
_01 Jan 2019_

- Added `actions` which greatly simplify Swift tests. Instead of `alertVerifier.actionsTitles[0] as? String`, use `alertVerifier.actions[0].title`
- Added `preferredAction`
- Added `textFields`
- Share scheme for Carthage builds. _Thanks to: Kevin Donnelly_

**Deprecated:**

- Deprecated `actionTitles` and `-styleForButtonWithTitle:`. Use `actions` instead.


Version 3.0.0
------------
_02 Feb 2018_

- Changed `animated` from NSNumber to BOOL.
- Added `presentingViewController`


Version 2.0.2
-------------
_30 Jan 2018_

- Fixed crash when presenting UIDocumentMenuViewController while mocking UIAlertController. _Thanks to: Andrei Tulai_


Version 2.0.1
-------------
_06 Mar 2017_

- Fixed nullability mistake: actionTitles are non-null.
- Add shared scheme to satisfy latest version of Carthage.


Version 2.0.0
-------------
_19 Feb 2017_

- Annotate nullability. The QCOMockAlertVerifier initializer is now non-null, which changes Swift use.
- Added Swift sample app.
- Updated example tests to put QCOMockAlertVerifier in test fixture. This is now recommended, to avoid tests which accidentally present real alerts.


Version 1.1.1
-------------
_11 Sep 2016_

- Change UIAlertController's actual `preferredStyle` instead of keeping it in an associated
  property, to avoid UIKit consistency exceptions. _Thanks to: nirgin_
- Allow `executeActionForButtonWithTitle:` even when no handler was set. _Thanks to: John Foulkes_
- Don't record presentation of non-alerts. _Thanks to: Tom Bates_
- Quiet runtime warning about attempting to load view controller while deallocating.
  _Thanks to: Marcelo Fabri_


Version 1.1.0
-------------
_24 Dec 2015_

- Repackage as Cocoa Touch Framework project.
- Support Carthage.
- CocoaPods: Distinguish between public headers and private headers.


Version 1.0.0
-------------
_23 Aug 2015_

- Initial release. Thanks to Victor Ilyukevich for suggestions, testing, and
cleanup.
