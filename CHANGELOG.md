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
