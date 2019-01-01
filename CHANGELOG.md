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
