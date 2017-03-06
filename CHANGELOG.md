Version 2.0.1
-------------
_06 Mar 2017_

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
